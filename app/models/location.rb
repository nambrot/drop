class Location < ActiveRecord::Base
  validates :user_id, presence: true
  validates :lonlat, presence: true
  set_rgeo_factory_for_column(:lonlat, RGeo::Geographic.spherical_factory(:srid => 4326))
end
