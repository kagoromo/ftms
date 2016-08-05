class Admin::LocationsController < ApplicationController
  load_and_authorize_resource

  def index
    @location = Location.new
  end

  def new
    add_breadcrumb_path "locations"
    add_breadcrumb_new "locations"
    @managers = User.trainers
  end

  def create
    if @location.save
      flash[:success] = flash_message "created"
      redirect_to admin_locations_path
    else
      flash[:failed] = flash_message "not_created"
      render :new
    end
  end

  def edit
    add_breadcrumb_path "locations"
    add_breadcrumb_edit "locations"
    @managers = User.trainers
  end

  def update
    if @location.update_attributes location_params
      flash[:success] = flash_message "created"
      redirect_to admin_locations_path
    else
      flash[:failed] = flash_message "not_created"
      render :edit
    end
  end

  private
  def location_params
    params.require(:location).permit :name, :user_id
  end
end
