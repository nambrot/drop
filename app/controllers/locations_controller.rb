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
    @location.lonlat = "POINT( #{params[:location][:lng]} #{params[:location][:lat]})"
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
    # binding.pry
    current_user.locations.create kml_matches.map {|line| { created_at: DateTime.parse(line[0]), lonlat: "POINT(#{line[1]} #{line[2]})" } }

    redirect_to locations_path

  end

  private
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:user_id)
    end
end
