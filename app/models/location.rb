class Location < ActiveRecord::Base
  validates :lat, presence: true
  validates :lng, presence: true
  validates :user_id, presence: true
end
