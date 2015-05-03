class Event < ActiveRecord::Base
  validates :lat, presence: true
  validates :lng, presence: true
  validates :user_id, presence: true

  #venue
  #category
  #time start
  #time spent
end
