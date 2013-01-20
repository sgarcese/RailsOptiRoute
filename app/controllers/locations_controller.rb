require 'google_api'

class LocationsController < ApplicationController
  def index
    @locations = Location.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locations }
    end
  end

  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @location }
    end
  end

  def new
    @location = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @location }
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def create
    @location = Location.new(params[:location])

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render json: @location, status: :created, location: @location }
      else
        format.html { render action: "new" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  def verify_collection
    @locations = params[:route][:locations_attributes].delete_if{ |index, hash| hash[:address_string].blank? }
    @verified_locations = []

    @locations.each do |index, location|
      location[:index] = index
      location = add_verified_attributes_to_location(location)
      @verified_locations << location
    end

    render json: @verified_locations
  end

  private
    def add_verified_attributes_to_location(location)
      verification_service = AddressVerificationService.new(location[:address_string])
      verified_attributes = verification_service.validated_address_attributes
      location[:verified] = verified_attributes[:address] == location[:address_string]
      location[:verified_address] = verified_attributes[:address]
      location[:latitude] = verified_attributes[:latitude]
      location[:longitude] = verified_attributes[:longitude]
      location
    end
end
