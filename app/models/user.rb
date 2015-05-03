class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :events
  serialize :state

  def add_location(lat, lng, time = Time.now)
    self.state = { last_location: {}, occurence: 0, time_of_first_occurence: nil, time_of_last_occurence: nil } unless self.state

    address, resp_lat, resp_lng = self.class.reverse_geocode(lat, lng)

    if state[:last_location]
      if state[:last_location][:address] == address
        state[:occurence] += 1
        state[:time_of_last_occurence] = time
      else

        if state[:occurence] > 5
          # we have a location that we have been in enough to create an event
          create_event

        end

        state[:last_location] = {address: address, lat: resp_lat, lng: resp_lng }
        state[:time_of_first_occurence] = time
        state[:time_of_last_occurence] = time
        state[:occurence] = 1

      end
    else
      state[:last_location] = {address: address, lat: resp_lat, lng: resp_lng }
      state[:time_of_first_occurence] = time
      state[:time_of_last_occurence] = time
      state[:occurence] = 1
    end

    self.save
  end

  def self.reverse_geocode(lat, lng)
    response = JSON.parse(HTTParty.get("http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/reverseGeocode?location=#{lng},#{lat}&distance=50?token=1Ukoeka9lU2yjIYVlZls1kHCubE03ovaVAqBk5EIMyzf8ayXaiaqR0nQ3g9hyWx9N5Y7fxkO2-cPfqSFYxBJWY87uvtcl5Z8-5vqp2SDW6BbTFYLEERSbX9A404vfH52cQmvxN8dLNT40IGtbu2m-A..&outSR=&f=pjson"))

    return response['address']['Address'], response['location']['y'], response['location']['x']
  end

  def create_event
    events.create lat: state[:last_location][:lat], lng: state[:last_location][:lng], entered_at: state[:time_of_first_occurence], time_spent: ((state[:time_of_last_occurence] - state[:time_of_first_occurence]) / 1.minute).round
  end

end
