class DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => [:index, :show]
  skip_before_filter :verify_authenticity_token, :only => [:create]
  # GET /devices
  # GET /devices.json
  def index
    @devices = Device.where(:vehicle_id => school_vehicles_ids)
  end

  # GET /devices/1
  # GET /devices/1.json
  def show
    # redirect_to "index"
  end

  # GET /devices/new
  def new
    @device = Device.new
    @vehicles = Vehicle.where(:id => school_vehicles_ids)
  end

  # GET /devices/1/edit
  def edit
      @vehicles = Vehicle.where(:id => school_vehicles_ids)
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to devices_path, notice: 'Device was successfully created.' }
        format.json { render :json=>{:message=> "Device Successfully Saved", :success=> true}}
      else
        format.html { render :new }
        format.json { render :json=>{ :message=>@device.errors, :success=> false}}
      end
    end
  end

  # PATCH/PUT /devices/1
  # PATCH/PUT /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to devices_path, notice: 'Device was successfully updated.' }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.json
  def destroy
    @device.destroy
    respond_to do |format|
      format.html { redirect_to devices_url, notice: 'Device was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:mobile_no, :imei_no, :vehicle_id, :is_enabled)
    end
end
