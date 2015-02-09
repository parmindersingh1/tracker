class RoutesController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource :except => [:index, :show]
  skip_before_filter :verify_authenticity_token, :only => [:create]
  # GET /routes
  # GET /routes.json
  def index
    @routes = Route.where(:vehicle_id => school_vehicles_ids)
  end

  # GET /routes/1
  # GET /routes/1.json
  def show
  end

  # GET /routes/new
  def new
    @route = Route.new
    @vehicles = Vehicle.where(:id => school_vehicles_ids)
  end

  # GET /routes/1/edit
  def edit
     @vehicles = Vehicle.where(:id => school_vehicles_ids)
  end

  # POST /routes
  # POST /routes.json
  def create
    @route = Route.new(route_params)

    respond_to do |format|
      if @route.save
        format.html { redirect_to routes_path, notice: 'Route was successfully created.' }
        format.json { render :json=>{:route=>@route,:message=> "Route Successfully Saved", :success=> true} }
      else
        format.html { render :new }
        format.json { render :json=>{ :message=>@route.errors, :success=> false} }
      end
    end
  end

  # PATCH/PUT /routes/1
  # PATCH/PUT /routes/1.json
  def update
    respond_to do |format|
      if @route.update(route_params)
        format.html { redirect_to @route, notice: 'Route was successfully updated.' }
        format.json { render :show, status: :ok, location: @route }
      else
        format.html { render :edit }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /routes/1
  # DELETE /routes/1.json
  def destroy
    @route.destroy
    respond_to do |format|
      format.html { redirect_to routes_url, notice: 'Route was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def user_routes
    myUser = User.find_by_id(params["user"])
     if myUser.role == "superuser"
        @routes =  Route.all
    else
     user_vehicles = myUser.school.vehicles.map(&:id)
    @routes = Route.where(:vehicle_id => user_vehicles)    
    end
    render json: {:routes=>@routes,:message=>"Routes Loded Successfully",:success=>"true",:total => @routes.count}
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_route
    @route = Route.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def route_params
    unless params["action"] == "user_routes"
    params.require(:route).permit(:name, :start_time, :end_time, :vehicle_id, :user)
    end
  end
end
