class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => [:index, :show]
  # GET /vehicles
  # GET /vehicles.json
  def index
    @vehicles = Vehicle.where(:id => school_vehicles_ids)
  end

  # GET /vehicles/1
  # GET /vehicles/1.json
  def show
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
    @school = current_user.school
  end

  # GET /vehicles/1/edit
  def edit
    @school = current_user.school
  end

  # POST /vehicles
  # POST /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to vehicles_path, notice: 'Vehicle was successfully created.' }
        format.json { render :show, status: :created, location: @vehicle }
      else
        format.html { render :new }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1
  # PATCH/PUT /vehicles/1.json
  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.html { redirect_to vehicles_path, notice: 'Vehicle was successfully updated.' }
        format.json { render :show, status: :ok, location: @vehicle }
      else
        format.html { render :edit }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1
  # DELETE /vehicles/1.json
  def destroy
    @vehicle.destroy
    respond_to do |format|
      format.html { redirect_to vehicles_url, notice: 'Vehicle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

def user_vehicles
      myUser = User.find_by_id(params["user"])
      if myUser.role == "superuser"
        @vehicles =  Vehicle.all
      else
        @vehicles = myUser.school.vehicles
      end
      render json: {:vehicles=>@vehicles,:message=>"Vehicles Loded Successfully",:success=>"true",:total => @vehicles.count}
  end 
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vehicle_params
      unless params["action"]=="user_vehicles"
      params.require(:vehicle).permit(:registration_no, :capacity, :vehicle_type, :school_id)
      end
    end
end
