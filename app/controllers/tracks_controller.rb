class TracksController < ApplicationController
  require 'cgi'
  skip_before_filter :authenticate_user!
  # before_action :set_track, only: [:show, :edit, :update, :destroy]

  # GET /tracks
  # GET /tracks.json
  # def index
    # @tracks = Track.all
  # end
# 
  # # GET /tracks/1
  # # GET /tracks/1.json
  # def show
  # end
# 
  # # GET /tracks/new
  # def new
    # @track = Track.new
  # end
# 
  # # GET /tracks/1/edit
  # def edit
  # end
# 
  # # POST /tracks
  # # POST /tracks.json
  # def create
    # @track = Track.new(track_params)
# 
    # respond_to do |format|
      # if @track.save
        # format.html { redirect_to @track, notice: 'Track was successfully created.' }
        # format.json { render :show, status: :created, location: @track }
      # else
        # format.html { render :new }
        # format.json { render json: @track.errors, status: :unprocessable_entity }
      # end
    # end
  # end
# 
  # # PATCH/PUT /tracks/1
  # # PATCH/PUT /tracks/1.json
  # def update
    # respond_to do |format|
      # if @track.update(track_params)
        # format.html { redirect_to @track, notice: 'Track was successfully updated.' }
        # format.json { render :show, status: :ok, location: @track }
      # else
        # format.html { render :edit }
        # format.json { render json: @track.errors, status: :unprocessable_entity }
      # end
    # end
  # end
# 
  # # DELETE /tracks/1
  # # DELETE /tracks/1.json
  # def destroy
    # @track.destroy
    # respond_to do |format|
      # format.html { redirect_to tracks_url, notice: 'Track was successfully destroyed.' }
      # format.json { head :no_content }
    # end
  # end
  
  def display_map
    
  end 
  
 
  def getallroutesformap
#     
    # BEGIN
  # SELECT DISTINCT(sessionId), MAX(gpsTime) gpsTime, 
  # CONCAT('{ "latitude":"', CAST(latitude AS CHAR),'", "longitude":"', CAST(longitude AS CHAR), '", "speed":"', CAST(speed AS CHAR), '", "direction":"', CAST(direction AS CHAR), '", "distance":"', CAST(distance AS CHAR), '", "locationMethod":"', locationMethod, '", "gpsTime":"', DATE_FORMAT(gpsTime, '%b %e %Y %h:%i%p'), '", "userName":"', userName, '", "phoneNumber":"', phoneNumber, '", "sessionID":"', CAST(sessionID AS CHAR), '", "accuracy":"', CAST(accuracy AS CHAR), '", "extraInfo":"', extraInfo, '" }') json
  # FROM gpslocations
  # WHERE sessionID != '0' && CHAR_LENGTH(sessionID) != 0 && gpstime != '0000-00-00 00:00:00'
  # GROUP BY sessionID;
# END ;;
    @locations=[] 
    @locations=Track.where("sessionID != '0' AND CHAR_LENGTH(sessionID) != 0 AND gpstime != '0000-00-00 00:00:00' AND DATE(gpstime) = '#{params[:selecteddate]}'").group(:sessionID)
    # @locations= Gpslocation.getallroutesformap
    puts "=================#{@locations.count}"
    render :json =>  {:locations=> @locations}
  end
  
  def getrouteformap
    
    
    # BEGIN
  # SELECT CONCAT('{ "latitude":"', CAST(latitude AS CHAR),'", "longitude":"', CAST(longitude AS CHAR), '", "speed":"', CAST(speed AS CHAR), '", "direction":"', CAST(direction AS CHAR), '", "distance":"', CAST(distance AS CHAR), '", "locationMethod":"', locationMethod, '", "gpsTime":"', DATE_FORMAT(gpsTime, '%b %e %Y %h:%i%p'), '", "userName":"', userName, '", "phoneNumber":"', phoneNumber, '", "sessionID":"', CAST(sessionID AS CHAR), '", "accuracy":"', CAST(accuracy AS CHAR), '", "extraInfo":"', extraInfo, '" }') json
  # FROM gpslocations
  # WHERE sessionID = _sessionID
  # ORDER BY lastupdate;
# END

    @locations=[] 
    @locations=Track.where("sessionID = '#{params[:sessionid]}'").order("updated_at DESC")
   
    render :json =>  {:locations=> @locations}
  end
  
  def getroutes
    
    # BEGIN
    # CREATE TEMPORARY TABLE tempRoutes (
    # sessionID VARCHAR(50),
    # userName VARCHAR(50),
    # startTime DATETIME,
    # endTime DATETIME)
  # ENGINE = MEMORY;
# 
  # INSERT INTO tempRoutes (sessionID, userName)
  # SELECT DISTINCT sessionID, userName
  # FROM gpslocations;
# 
  # UPDATE tempRoutes tr
  # SET startTime = (SELECT MIN(gpsTime) FROM gpslocations gl
  # WHERE gl.sessionID = tr.sessionID
  # AND gl.userName = tr.userName);
# 
  # UPDATE tempRoutes tr
  # SET endTime = (SELECT MAX(gpsTime) FROM gpslocations gl
  # WHERE gl.sessionID = tr.sessionID
  # AND gl.userName = tr.userName);
# 
  # SELECT
# 
  # CONCAT('{ "sessionID": "', CAST(sessionID AS CHAR),  '", "userName": "', userName, '", "times": "(', DATE_FORMAT(startTime, '%b %e %Y %h:%i%p'), ' - ', DATE_FORMAT(endTime, '%b %e %Y %h:%i%p'), ')" }') json
  # FROM tempRoutes
  # ORDER BY startTime DESC;
# 
  # DROP TABLE tempRoutes;
    # END
    @routes=[];
    route=Hash.new
    
    @distinct_sessions=Track.select(:sessionID).where("DATE(gpstime) = '#{params[:selecteddate]}'").distinct
    @distinct_sessions.each do |session|
      route={}
      route["sessionID"]=session.sessionID
      # route["userName"]=session.userName
      startTime=Track.where("sessionID = '#{session.sessionID}'  AND DATE(gpstime) = '#{params[:selecteddate]}'").minimum('gpsTime')
      endTime=Track.where("sessionID = '#{session.sessionID}'   AND DATE(gpstime) = '#{params[:selecteddate]}'").maximum('gpsTime')
      
      if startTime.nil?
        startTime = CGI::unescape('0000-00-00')
      end 
      if endTime.nil?
        endTime = CGI::unescape('0000-00-00')
      end
      
      route["times"]="#{startTime.strftime('%b %e %Y %I:%M%p')} - #{endTime.strftime('%b %e %Y %I:%M%p')}"
      
      @routes << route
    end   
    render :json =>  {:routes=> @routes}
  end
  
  def updatelocation
    
    # CREATE DEFINER=`root`@`localhost` PROCEDURE `prcSaveGPSLocation`(
# _latitude DECIMAL(10,7),
# _longitude DECIMAL(10,7),
# _speed INT(10),
# _direction INT(10),
# _distance DECIMAL(10,1),
# _date TIMESTAMP,
# _locationMethod VARCHAR(50),
# _userName VARCHAR(50),
# _phoneNumber VARCHAR(50),
# _sessionID VARCHAR(50),
# _accuracy INT(10),
# _extraInfo VARCHAR(255),
# _eventType VARCHAR(50)
# )
# BEGIN
   # INSERT INTO gpslocations (latitude, longitude, speed, direction, distance, gpsTime, locationMethod, userName, phoneNumber,  sessionID, accuracy, extraInfo, eventType)
   # VALUES (_latitude, _longitude, _speed, _direction, _distance, _date, _locationMethod, _userName, _phoneNumber, _sessionID, _accuracy, _extraInfo, _eventType);
   # SELECT NOW();
# END ;;


    puts "--------------------#{params}"
     username = params['username'].present? ? params['username'] : 0
     phoneNumber = params['phonenumber'].present? ? params['phonenumber'] : ''
     @vehicle=Vehicle.find_by_registration_no(username)
    location={}
    location["latitude"] = params['latitude'].present? ? params['latitude'].gsub(',', '.').to_f : '0'
    location["longitude"] = params['longitude'].present? ? params['longitude'].gsub(',', '.').to_f : '0'
    location["speed"] = params['speed'].present? ? params['speed'] : 0
    location["direction"] = params['direction'].present? ? params['direction'] : 0
    location["distance"] = params['distance'].present?  ? params['distance'].gsub(',', '.').to_f : '0'
    location["gpsTime"] = params['date'].present? ?  CGI::unescape(params['date']) :  Time.now
    location["locationMethod"] = params['locationmethod'].present? ?  CGI::unescape(params['locationmethod']) : ''
    location["sessionID"] = params['sessionid'].present? ? params['sessionid'] : 0
    location["accuracy"] = params['accuracy'].present? ? params['accuracy'] : 0
    location["extraInfo"] = params['extrainfo'].present? ? params['extrainfo'] : ''
    location["eventType"] = params['eventtype'].present? ? params['eventtype'] : ''
    
   @location = Track.new(location)
   @location.vehicle=@vehicle
   
   if @location.save
     logger.info("location saved #{@location.id}")
     else 
     logger.info("Error while Saving location #{@location.errors}")
   end
       
   render nothing: true   
  end
  
  def deleteroute
    # CREATE DEFINER=`root`@`localhost` PROCEDURE `prcDeleteRoute`(
# _sessionID VARCHAR(50))
# BEGIN
  # DELETE FROM gpslocations
  # WHERE sessionID = _sessionID;
# END ;;
  session = params["sessionid"].present? ? params["sessionid"] : '0'
  @gpslocation = Track.find_by_sessionID(session)
  if @gpslocation.destroy 
      logger.info("location deleted ")
     else 
     logger.info("Error while deleting location #{@gpslocation.errors}")
  end
  render :json=>{:success => true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_track
      @track = Track.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def track_params
      params.require(:track).permit(:latitude, :longitude, :sessionID, :speed, :direction, :distance, :gpsTime, :locationMethod, :accuracy, :extraInfo, :eventType, :vehicle_id, :route_id)
    end
end
