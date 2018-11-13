class User < ActiveRecord::Base
	require 'twitter'
	has_many :timelines
	has_many :events, through: :timelines 
	ADMIN_IDS = [1]

	def admin?
		User::ADMIN_IDS.include?(self.id)
	end

	def owner?(timeline_id)
		self.timelines.where(id: timeline_id).try(:first)
	end

	def self.todays_shares
		User.includes(:events).where("EXTRACT(day FROM events.date)=EXTRACT(day FROM CURRENT_DATE) and EXTRACT(month FROM events.date)=EXTRACT(month FROM CURRENT_DATE) and events.share=true").references(:events).each do |user|
			user.share_on_twitter(user.events)
			user.share_on_facebook(user.events)
		end
	end

	def share_on_twitter(events)
		client = Twitter::REST::Client.new do |config|
		  config.consumer_key        = ENV['CONSUMER_KEY']
		  config.consumer_secret     = ENV['CONSUMER_SECRET']
		  config.access_token        = self.twitter_access_token
		  config.access_token_secret = self.twitter_access_token_secret
		end
		events.each {|event| client.update(event.description)}
	end

	def share_on_facebook(events)
		page_graph = Koala::Facebook::API.new(ENV['FB_PAGE_TOKEN'])
		events.each {|event| page_graph.put_wall_post(event.description)}
	end

end
