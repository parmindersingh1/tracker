class StopsController < ApplicationController
  before_action :set_stop, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => [:index, :show,:create_route_stops]
  skip_before_filter :authenticate_user!,  :only => [:create_route_stops]
  # GET /stops
  # GET /stops.json
  def index
    @routes=Route.where(:vehicle_id => school_vehicles_ids).map(&:id)
    @stops = Stop.where(:route_id => @routes)
  end

  # GET /stops/1
  # GET /stops/1.json
  def show
  end

  # GET /stops/new
  def new
    @stop = Stop.new
  end

  # GET /stops/1/edit
  def edit
  end

  # POST /stops
  # POST /stops.json
  def create
    @stop = Stop.new(stop_params)

    respond_to do |format|
      if @stop.save
        format.html { redirect_to stops_path, notice: 'Stop was successfully created.' }
        format.json { render :show, status: :created, location: @stop }
      else
        format.html { render :new }
        format.json { render json: @stop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stops/1
  # PATCH/PUT /stops/1.json
  def update
    respond_to do |format|
      if @stop.update(stop_params)
        format.html { redirect_to stops_path, notice: 'Stop was successfully updated.' }
        format.json { render :show, status: :ok, location: @stop }
      else
        format.html { render :edit }
        format.json { render json: @stop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stops/1
  # DELETE /stops/1.json
  def destroy
    @stop.destroy
    respond_to do |format|
      format.html { redirect_to stops_url, notice: 'Stop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

   def create_route_stops
    puts "((((((((((((((((#{params}))))))))))))))))"
    username = params['username'].present? ? params['username'] : 0
    phoneNumber = params['phonenumber'].present? ? params['phonenumber'] : ''
    @vehicle=Vehicle.find_by_registration_no(username)
    unless @vehicle.nil?
      @latitude = params['latitude'].present? ? params['latitude'].gsub(',', '.').to_f : '0'
      @longitude = params['longitude'].present? ? params['longitude'].gsub(',', '.').to_f : '0'
      @gpsTime = params['date'].present? ?  CGI::unescape(params['date']) :  Time.now
      @name = params['sessionid'].present? ? params['sessionid'] : 0
      @route=Route.find_by_name_and_vehicle_id(@name, @vehicle.id)
      if @route.nil?
        @route=Route.create({:name=> @name, :start_time => @gpsTime, :vehicle_id => @vehicle.id})
      end
    
      time_interval=0
      sequence = 1
      @stop = Stop.new
      @stop.route = @route
      @prev_stop= Stop.where(:route_id => @route.id ).last
       puts "--------------#{@prev_stop.inspect}"
      unless @prev_stop.nil?
        time_interval= ((Time.parse(DateTime.now.to_s) - Time.parse(@prev_stop.created_at.to_s))/60).to_i  #in minutes
        sequence = @prev_stop.sequence.to_i + 1
      end
      @stop.latitude=@latitude
      @stop.longitude= @longitude
      @stop.timeperiod=time_interval
      @stop.sequence=sequence

      if @stop.save
        logger.info "successfully Saved Stop with id #{@stop.id}"
      else
        logger.info "Error Saving Stop with #{@stop.errors}"
      end

    else
      logger.info("No Vehicle Found!")
    end
    render nothing: true
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stop
    @stop = Stop.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def stop_params
    params.require(:stop).permit(:name, :latitude, :longitude, :timeperiod, :sequence, :route_id)
  end
end
