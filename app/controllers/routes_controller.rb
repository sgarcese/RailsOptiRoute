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
    @verified_locations = []

    @locations.each do |index, location|
      next if location[:latitude].present? && location[:longitude].present?
      location = add_verified_attributes_to_location(location) 
      location[:user_id] = current_user.id
      location[:start] = index == 0
      location[:end] = index == @locations.length-1
      @verified_locations << location
    end

    params[:route][:locations_attributes] = @verified_locations
    @route = Route.new(params[:route])

    respond_to do |format|
      if @route.save
        format.html { redirect_to @route, notice: 'Route was successfully created.' }
        format.json { render json: @route, status: :created, location: @route }
      else
        locations_to_build = 5 - @route.locations.to_a.count
        locations_to_build.times { |i| @route.locations.build }
        format.html { render action: "new" }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /routes/1
  # PUT /routes/1.json
  def update
    @route = Route.find(params[:id])

    respond_to do |format|
      if @route.update_attributes(params[:route])
        format.html { redirect_to @route, notice: 'Route was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /routes/1
  # DELETE /routes/1.json
  def destroy
    @route = Route.find(params[:id])
    @route.destroy

    respond_to do |format|
      format.html { redirect_to routes_url }
      format.json { head :no_content }
    end
  end

  private
  def add_verified_attributes_to_location(location)
    verification_service = AddressVerificationService.new(location[:address_string])
    verified_attributes = verification_service.validated_address_attributes
    location[:latitude] = verified_attributes[:latitude]
    location[:longitude] = verified_attributes[:longitude]
    location
  end
end
