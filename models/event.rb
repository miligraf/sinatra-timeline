class Event < ActiveRecord::Base
	belongs_to :timeline
	delegate :user, to: :timeline
	default_scope { order("EXTRACT(month FROM date), EXTRACT(day FROM date), EXTRACT(year FROM date)") }
end