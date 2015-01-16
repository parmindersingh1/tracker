require 'test_helper'

class TracksControllerTest < ActionController::TestCase
  setup do
    @track = tracks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tracks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create track" do
    assert_difference('Track.count') do
      post :create, track: { accuracy: @track.accuracy, direction: @track.direction, distance: @track.distance, eventType: @track.eventType, extraInfo: @track.extraInfo, gpsTime: @track.gpsTime, latitude: @track.latitude, locationMethod: @track.locationMethod, longitude: @track.longitude, route_id: @track.route_id, sessionID: @track.sessionID, speed: @track.speed, vehicle_id: @track.vehicle_id }
    end

    assert_redirected_to track_path(assigns(:track))
  end

  test "should show track" do
    get :show, id: @track
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @track
    assert_response :success
  end

  test "should update track" do
    patch :update, id: @track, track: { accuracy: @track.accuracy, direction: @track.direction, distance: @track.distance, eventType: @track.eventType, extraInfo: @track.extraInfo, gpsTime: @track.gpsTime, latitude: @track.latitude, locationMethod: @track.locationMethod, longitude: @track.longitude, route_id: @track.route_id, sessionID: @track.sessionID, speed: @track.speed, vehicle_id: @track.vehicle_id }
    assert_redirected_to track_path(assigns(:track))
  end

  test "should destroy track" do
    assert_difference('Track.count', -1) do
      delete :destroy, id: @track
    end

    assert_redirected_to tracks_path
  end
end
