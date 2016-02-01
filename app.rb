require 'sinatra'
require 'sinatra/activerecord'
require 'omniauth-twitter'
require './config/environments'
require 'haml'
Dir["./models/*.rb"].each {|file| require file }

configure do
  enable :sessions
  set :session_secret, 'timeline-sinatra'
  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "views") }

  use OmniAuth::Builder do
    provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
  end
end

helpers do
  def logged_in?
    current_user != false
  end

  def current_user
    return User.find(1) if Sinatra::Base.development?
    session[:current_user_id].blank? ? false : User.find(session[:current_user_id])
  end

  def set_current_user(user_id)
    session[:current_user_id] = user_id
  end

  def is_admin?
    logged_in? and current_user.admin?
  end

  def is_owner?(timeline_id)
    return true if Sinatra::Base.development?
    logged_in? and current_user.owner?(timeline_id)
  end
end

get '/auth/twitter/callback' do
  twitter_uid = env['omniauth.auth']['uid']
  twitter_info = env['omniauth.auth']['info']
  twitter_nickname = twitter_info['nickname']
  twitter_access_token = env['omniauth.auth']['credentials']['token']
  twitter_access_token_secret = env['omniauth.auth']['credentials']['secret']
  user = User.create_with(twitter_nickname: twitter_nickname).find_or_create_by(twitter_uid: twitter_uid, twitter_access_token: twitter_access_token, twitter_access_token_secret: twitter_access_token_secret)
  set_current_user(user.id)
  current_user.timelines.create(title: "#{current_user.twitter_nickname}'s timeline", description: "Description of my new timeline") if current_user.timelines.blank?
  redirect to('/')
end

get '/auth/failure' do
  params[:message]
end

get '/todays_shares' do
  User.todays_shares
  status 200
end

get '/logout' do
  set_current_user(nil)
  redirect to('/')
end

get '/' do
  haml :index
end

get '/me/timelines' do
  @timelines = current_user.timelines
  haml :"timelines/index"
end

get '/timelines' do
  @timelines = Timeline.all
  haml :"timelines/index"
end

get '/timelines/:id' do
  @timeline = Timeline.find(params[:id])
  haml :"timelines/show"
end

get '/timelines/:id/edit' do
  @timeline = current_user.timelines.where(id: params[:id]).try(:first)
  return status 401 unless @timeline
  @action = "/timelines/#{@timeline.id}"
  @method = "put"
  haml :"timelines/form"
end

put '/timelines/:id' do
  @timeline = current_user.timelines.where(id: params[:id]).try(:first)
  return status 401 unless @timeline
  @timeline.update(params[:timeline])
  redirect to("/timelines/#{@timeline.id}")
end

get '/timelines/:id/events/new' do
  @timeline = current_user.timelines.where(id: params[:id]).try(:first)
  return status 401 unless @timeline
  @event = Event.new
  @action = "/timelines/#{@timeline.id}/events"
  @method = "post"
  haml :"events/form"
end

post '/timelines/:id/events' do
  @timeline = current_user.timelines.where(id: params[:id]).try(:first)
  return status 401 unless @timeline
  @timeline.events.create(params[:event])
  redirect to("/timelines/#{@timeline.id}")
end

get '/timelines/:timeline_id/events/:event_id/edit' do
  @timeline = current_user.timelines.where(id: params[:timeline_id]).try(:first)
  return status 401 unless @timeline
  @event = @timeline.events.find(params[:event_id])
  @action = "/timelines/#{@timeline.id}/events/#{@event.id}"
  @method = "put"
  haml :"events/form"
end

put '/timelines/:timeline_id/events/:event_id' do
  @timeline = current_user.timelines.where(id: params[:timeline_id]).try(:first)
  return status 401 unless @timeline
  params[:event][:share] = params[:event][:share].present? ? true : false
  @event = @timeline.events.find(params[:event_id])
  @event.update(params[:event])
  redirect to("/timelines/#{@timeline.id}")
end