class TracksController < ApplicationController
  require 'cgi'
  skip_before_filter :verify_authenticity_token,  :only => [:updatelocation]
  # before_action :set_track, only: [:show, :edit, :update, :destroy]

  def display_map
 puts "--------------#{current_user.inspect}"
  end

  def getallroutesformap
    #
    # BEGIN
    # SELECT DISTINCT(sessionId), MAX(gpstime) gpstime,
    # CONCAT('{ "latitude":"', CAST(latitude AS CHAR),'", "longitude":"', CAST(longitude AS CHAR), '", "speed":"', CAST(speed AS CHAR), '", "direction":"', CAST(direction AS CHAR), '", "distance":"', CAST(distance AS CHAR), '", "locationmethod":"', locationmethod, '", "gpstime":"', DATE_FORMAT(gpstime, '%b %e %Y %h:%i%p'), '", "userName":"', userName, '", "phoneNumber":"', phoneNumber, '", "sessionid":"', CAST(sessionid AS CHAR), '", "accuracy":"', CAST(accuracy AS CHAR), '", "extrainfo":"', extrainfo, '" }') json
    # FROM gpslocations
    # WHERE sessionid != '0' && CHAR_LENGTH(sessionid) != 0 && gpstime != '0000-00-00 00:00:00'
    # GROUP BY sessionid;
    # END ;;
    @locations=[]
    @tracks=[]
    # @locations=Track.joins(:vehicle).select("tracks.*, vehicles.registration_no as userName").where("tracks.sessionid != '0' AND CHAR_LENGTH(tracks.sessionid) != 0 AND tracks.gpstime != '0000-00-00 00:00:00' AND DATE(tracks.gpstime) = '#{params[:selecteddate]}'").group("tracks.sessionid")
    # @locations=Track.where("sessionid != '0' AND CHAR_LENGTH(sessionid) != 0 AND gpstime != '0000-00-00 00:00:00' AND DATE(gpstime) = '#{params[:selecteddate]}'").group(:sessionid).order("id DESC")
    selected_vehicles=school_vehicles_ids.join(",")
    unless selected_vehicles.empty?
    location_ids = Track.select("MAX(id) AS id").where("vehicle_id in (#{selected_vehicles})").group(:sessionid).collect(&:id)
    else
    location_ids = Track.select("MAX(id) AS id").group(:sessionid).collect(&:id)  
    end
    unless location_ids.empty?
    @locations = Track.order("created_at DESC").where("id in (#{location_ids.join(',')}) AND sessionid != '0' AND CHAR_LENGTH(sessionid) != 0 AND DATE(gpstime) = '#{params[:selecteddate]}'").as_json
    @locations.each do |loc|
      vehicle = Vehicle.find_by_id(loc["vehicle_id"])
      loc["userName"] = vehicle.registration_no
      loc["route_name"]  = Route.find_by_id(loc["route_id"]).name
      @tracks << loc
    end
    end
    render :json =>  {:locations=> @tracks}
  end

  def getrouteformap

    # BEGIN
    # SELECT CONCAT('{ "latitude":"', CAST(latitude AS CHAR),'", "longitude":"', CAST(longitude AS CHAR), '", "speed":"', CAST(speed AS CHAR), '", "direction":"', CAST(direction AS CHAR), '", "distance":"', CAST(distance AS CHAR), '", "locationmethod":"', locationmethod, '", "gpstime":"', DATE_FORMAT(gpstime, '%b %e %Y %h:%i%p'), '", "userName":"', userName, '", "phoneNumber":"', phoneNumber, '", "sessionid":"', CAST(sessionid AS CHAR), '", "accuracy":"', CAST(accuracy AS CHAR), '", "extrainfo":"', extrainfo, '" }') json
    # FROM gpslocations
    # WHERE sessionid = _sessionid
    # ORDER BY lastupdate;
    # END
    
    @locations=[]
    @tracks=[]
    selected_vehicles=school_vehicles_ids.join(",")
    @locations=Track.where("sessionid = '#{params[:sessionid]}'").order("updated_at DESC").as_json
    @locations.each do |loc|
      vehicle = Vehicle.find_by_id(loc["vehicle_id"])
      loc["userName"] = vehicle.registration_no
      loc["route_name"]  = Route.find_by_id(loc["route_id"]).name
      @tracks << loc
    end
    render :json =>  {:locations=> @tracks}
  end

  def getroutes

    # BEGIN
    # CREATE TEMPORARY TABLE tempRoutes (
    # sessionid VARCHAR(50),
    # userName VARCHAR(50),
    # startTime DATETIME,
    # endTime DATETIME)
    # ENGINE = MEMORY;
    #
    # INSERT INTO tempRoutes (sessionid, userName)
    # SELECT DISTINCT sessionid, userName
    # FROM gpslocations;
    #
    # UPDATE tempRoutes tr
    # SET startTime = (SELECT MIN(gpstime) FROM gpslocations gl
    # WHERE gl.sessionid = tr.sessionid
    # AND gl.userName = tr.userName);
    #
    # UPDATE tempRoutes tr
    # SET endTime = (SELECT MAX(gpstime) FROM gpslocations gl
    # WHERE gl.sessionid = tr.sessionid
    # AND gl.userName = tr.userName);
    #
    # SELECT
    #
    # CONCAT('{ "sessionid": "', CAST(sessionid AS CHAR),  '", "userName": "', userName, '", "times": "(', DATE_FORMAT(startTime, '%b %e %Y %h:%i%p'), ' - ', DATE_FORMAT(endTime, '%b %e %Y %h:%i%p'), ')" }') json
    # FROM tempRoutes
    # ORDER BY startTime DESC;
    #
    # DROP TABLE tempRoutes;
    # END
    @routes=[];
    route=Hash.new
    selected_vehicles=school_vehicles_ids.join(",")
    unless selected_vehicles.empty?
    @distinct_sessions=Track.select(:sessionid).where("DATE(gpstime) = '#{params[:selecteddate]}' AND vehicle_id in (#{selected_vehicles})").distinct
    else
    @distinct_sessions=Track.select(:sessionid).where("DATE(gpstime) = '#{params[:selecteddate]}'").distinct  
    end 
    @distinct_sessions.each do |session|
      route={}
      route["sessionid"]=session.sessionid

      startTime=Track.where("sessionid = '#{session.sessionid}'  AND DATE(gpstime) = '#{params[:selecteddate]}'").minimum('gpstime')
      endTime=Track.where("sessionid = '#{session.sessionid}'   AND DATE(gpstime) = '#{params[:selecteddate]}'").maximum('gpstime')
      first_track = Track.where("sessionid = '#{session.sessionid}'   AND DATE(gpstime) = '#{params[:selecteddate]}'").first
      route["userName"]=first_track.vehicle.registration_no
      route["route_name"]=first_track.route.name
      # if startTime.nil?
        # startTime = CGI::unescape('0000-00-00')
      # end
      # if endTime.nil?
        # endTime = CGI::unescape('0000-00-00')
      # end

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
    # _locationmethod VARCHAR(50),
    # _userName VARCHAR(50),
    # _phoneNumber VARCHAR(50),
    # _sessionid VARCHAR(50),
    # _accuracy INT(10),
    # _extrainfo VARCHAR(255),
    # _eventtype VARCHAR(50)
    # )
    # BEGIN
    # INSERT INTO gpslocations (latitude, longitude, speed, direction, distance, gpstime, locationmethod, userName, phoneNumber,  sessionid, accuracy, extrainfo, eventtype)
    # VALUES (_latitude, _longitude, _speed, _direction, _distance, _date, _locationmethod, _userName, _phoneNumber, _sessionid, _accuracy, _extrainfo, _eventtype);
    # SELECT NOW();
    # END ;;

    logger.info "--------------------#{track_params}"
    # username = params['username'].present? ? params['username'] : 0
    # phoneNumber = params['phonenumber'].present? ? params['phonenumber'] : ''
    @device = Device.find_by_imei_no(track_params[:device])
    unless @device.nil? && !@device.is_enabled
    @vehicle=@device.vehicle
    @route= Route.find_by_id(track_params[:route_id])
    unless @vehicle.nil?
      # location={}
      # location["latitude"] = params['latitude'].present? ? params['latitude'].gsub(',', '.').to_f : '0'
      # location["longitude"] = params['longitude'].present? ? params['longitude'].gsub(',', '.').to_f : '0'
      # location["speed"] = params['speed'].present? ? params['speed'] : 0
      # location["direction"] = params['direction'].present? ? params['direction'] : 0
      # location["distance"] = params['distance'].present?  ? params['distance'].gsub(',', '.').to_f : '0'
      # location["gpstime"] = params['date'].present? ?  CGI::unescape(params['date']) :  Time.now
      # location["locationmethod"] = params['locationmethod'].present? ?  CGI::unescape(params['locationmethod']) : ''
      # location["sessionid"] = params['sessionid'].present? ? params['sessionid'] : 0
      # location["accuracy"] = params['accuracy'].present? ? params['accuracy'] : 0
      # location["extrainfo"] = params['extrainfo'].present? ? params['extrainfo'] : ''
      # location["eventtype"] = params['eventtype'].present? ? params['eventtype'] : ''
# 
      @location = Track.new(track_params)
      @location.vehicle=@vehicle

      if @location.save
        logger.info("location saved #{@location.id}")
        within_distance=false
        
         @route.stops.each do |stop|
           logger.info("&&&&&&&&&&&&#{stop.class.instance_methods.include?("distance")}$$$$$$$$$$$$$")
            distance = stop.check_distance([@location.latitude, @location.longitude])
            if distance <= ENV["DISTANCE"].to_f
              within_distance = true              
              break
            end
          end
   
        
        if within_distance == false
          logger.info("**********Send SMS*************");
           @response = SmsManager.new("#{@vehicle.registration_no} is out of track",@device.school.phone_no)
             if @response == "something went worng"
                logger.info("Error Sending Message to #{@track.id}")                  
             end       
        end
        
        render :json => {:message=> "Location Saved Successfully", :success => true}
      else
        logger.info("Error while Saving location #{@location.errors}")
        render :json => {:message=> @location.errors,:success => false}
      end
    else
      logger.info("No Vehicle Found!")
      render :json => {:message=> "No Vehicle Found!",:success => false}
    end
    else
      logger.info("No Active Device Found!")
      render :json => {:message=> "No Active Device Found!",:success => false}
    end

    # render nothing: true
  end

  def deleteroute
    # CREATE DEFINER=`root`@`localhost` PROCEDURE `prcDeleteRoute`(
    # _sessionid VARCHAR(50))
    # BEGIN
    # DELETE FROM gpslocations
    # WHERE sessionid = _sessionid;
    # END ;;
    session = params["sessionid"].present? ? params["sessionid"] : '0'
    @gpslocation = Track.find_by_sessionid(session)
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
    params.require(:track).permit(:latitude, :longitude, :sessionid, :speed, :direction, :distance, :gpstime, :locationmethod, :accuracy, :extrainfo, :eventtype, :vehicle_id, :route_id, :device, :route_name)
  end
end
