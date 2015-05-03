class LocationsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    user.add_location(params[:lat], params[:lng])
    render json: {}
  end

end
