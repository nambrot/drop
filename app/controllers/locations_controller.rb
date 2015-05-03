class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only: [:import_locations, :import_kml]
  respond_to :html, :json

  def index
    @locations = Location.all
    respond_with(@locations)
  end

  def show
    respond_with(@location)
  end

  def new
    @location = Location.new
    respond_with(@location)
  end

  def edit
  end

  def create
    @location = Location.new(location_params)
    @location.save
    respond_with(@location)
  end

  def update
    @location.update(location_params)
    respond_with(@location)
  end

  def destroy
    @location.destroy
    respond_with(@location)
  end

  def import_locations
  end

  def import_kml
    kml_matches = params[:kml][:file].tempfile.read.scan /<when>([\d+-T]+)<\/when>\s<gx:coord>([-\d.]+) ([-\d.]+)/
    current_user.locations.create kml_matches.map {|line| { created_at: DateTime.parse(line[0]), lat: line[2].to_f, lng: line[1].to_f } }

    redirect_to locations_path

  end

  def foursquare
    client = Foursquare2::Client.new(:client_id => Rails.application.secrets.foursquare_id, 
        :client_secret => Rails.application.secrets.foursquare_secret,
        :api_version => 20150501)

    #client.search_venues(:ll => event.lat + ',' + event.long, :intent => match)

    venues = client.search_venues(:ll => '40.719009,-73.996995', :intent => 'checkin')
    event.venue_id = venues.venues[0].id
    event.category = venues.venues[0].categories[0].name
    byebug
  end

  private
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:lat, :lng, :user_id)
    end
end
