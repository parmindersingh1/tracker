class StopsController < ApplicationController
  before_action :set_stop, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => [:index, :show,:create_route_stops]
  skip_before_filter :verify_authenticity_token,  :only => [:create_route_stops]
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
    @routes=Route.where(:vehicle_id => school_vehicles_ids).map(&:id)
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
      @stop_record = Hash.new
      @route=Route.find_by_id(stop_params[:route_id])    
      time_interval=0
      sequence = 1
      @prev_stop= Stop.where(:route_id => @route.id ).last
      unless @prev_stop.nil?
        start_time = Time.parse(@prev_stop.created_at.to_s).localtime
        end_time = Time.now
       
        time_interval = TimeDifference.between(start_time, end_time).in_minutes.to_i
        # time_interval= ((Time.parse(stop_params[:gpstime]) - Time.parse(@prev_stop.created_at.to_s))/60).to_i  #in minutes
        # time_interval=@prev_stop.timeperiod.to_i + time_interval
        sequence = @prev_stop.sequence.to_i + 1
      end      
    
      @stop_record["latitude"]=stop_params[:latitude]
      @stop_record["longitude"]=stop_params[:longitude]
      @stop_record["timeperiod"]=time_interval
      @stop_record["sequence"]=sequence
      @stop_record["route_id"]=stop_params[:route_id]   
      
      @stop=Stop.new(@stop_record)
      if @stop.save
        logger.info "successfully Saved Stop with id #{@stop.id}"
        render :json => {:message=> "Stop Successfuly Saved",:success=> true} 
      else
        logger.info "Error Saving Stop with #{@stop.errors}"
        render :json => {:message=> @stop.errors,:success=> false} 
      end        
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stop
    @stop = Stop.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def stop_params
    params.require(:stop).permit(:name, :latitude, :longitude, :timeperiod, :sequence, :route_id, :gpstime)
  end
end
