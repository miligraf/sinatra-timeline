require "clockwork"
require "./app"
require "sinatra/activerecord/rake"

include Clockwork

every(1.day, 'Scheduled Tweets', :at => '18:00', :tz => 'UTC') { Event.todays_tweets }