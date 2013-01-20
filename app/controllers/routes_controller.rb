class RoutesController < ApplicationController
  
  def index
    @routes = Route.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @routes }
    end
  end

  def show
    @route = Route.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @route }
    end
  end

  def new
    @route = Route.new
    5.times { |i| @route.locations.build }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @route }
    end
  end

  def edit
    @route = Route.find(params[:id])
  end

  def create
    @locations = params[:route][:locations_attributes].delete_if{ |index, hash| hash[:address_string].blank? }
    params[:route][:locations_attributes] = build_location_hashes(@locations)
    @route = current_user.routes.new(params[:route])

    if @route.save
      redirect_to @route, notice: 'Route was successfully created.'
    else
      locations_to_build = 5 - @route.locations.to_a.count
      locations_to_build.times { |i| @route.locations.build }
      render action: "new"
    end
  end

  def update
    @route = Route.find(params[:id])

    respond_to do |format|
      if @route.update_attributes(params[:route])
        format.html { redirect_to @route, notice: 'Route was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @route = Route.find(params[:id])
    @route.destroy
    redirect_to routes_path
  end

  private
    def add_verified_attributes_to_location(location)
      verification_service = AddressVerificationService.new(location[:address_string])
      verified_attributes = verification_service.validated_address_attributes
      location[:latitude] = verified_attributes[:latitude]
      location[:longitude] = verified_attributes[:longitude]
      location
    end

    def build_location_hashes(locations)
      verified_locations = []
      locations.each do |index, location|
        location[:start] = index.to_i == 0
        location[:finish] = index.to_i == locations.length-1
        location[:user_id] = current_user.id

        if location[:latitude].blank? || location[:longitude].blank?
          location = add_verified_attributes_to_location(location) 
        end

        verified_locations << location
      end
      verified_locations
    end
end
