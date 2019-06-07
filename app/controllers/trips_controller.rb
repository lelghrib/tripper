class TripsController < ApplicationController
require 'json'
require 'open-uri'


  def index
    @trips = Trip.where(user: current_user)

  end

  def new
    @trip = Trip.new
    @step = Step.new
  end

  def create
    @trip = Trip.new(trip_params)
    redirect_to new_trip_step_path(@trip) if @trip.save!
  end

  def show
    @trip = Trip.find(params[:id])
    @list_acti_map = []
    @trip.steps.each do |step|
        @list_acti_map << step.activities
    end
    @list_acti_map.flatten!
    steps_coord = ""
    @trip.steps.each do |step|
      steps_coord += step.city.longitude.to_s + ',' + step.city.latitude.to_s + ';'
    end
    steps_call = steps_coord.delete_suffix(";")
    url = "https://api.mapbox.com/optimized-trips/v1/mapbox/driving/#{steps_call}?source=first&destination=last&steps=true&access_token=#{ENV['MAPBOX_API_KEY']}"
    response_serialized = open(url).read
    response = JSON.parse(response_serialized)
    steps_ordered = []
    response['waypoints'].sort_by! { |waypoint| waypoint['waypoint_index'] }
    steps_to_map(response['waypoints'])
    # activities_to_map(@list_acti_map)
  end
  def steps_to_map(steps)
    # .select {|item| !(item[:lat].nil? || item[:long].nil?)}.

      @markers = steps.map do |step|
       {
        lat: step['location'][1],
        lng: step['location'][0]
        }
    end
  end

  def activities_to_map(activities)
    # .select {|item| !(item[:lat].nil? || item[:long].nil?)}.
    @markers = activities.map do |activity|
      {
        lat: activity.latitude,
        lng: activity.longitude
      }
    end
  end

  def filter_activities_by_time(criteria)
    order_list = order_by_ranking(@activities, criteria)
    total_list = total_duration(order_list)
    list_acti = []
    if total_list < @ratio_type_activities[criteria]
      list_acti << order_list
      list_acti.flatten!
      return list_acti
    else
      order_list.each do |acti|
        return list_acti if (total_duration(list_acti) + acti.duration) > @ratio_type_activities[criteria]
        list_acti << acti
      end
    end
  end

  def activities_in_zone(trip)
    long_max = [trip.arrival_city.longitude, trip.departure_city.longitude].max
    long_min = [trip.arrival_city.longitude, trip.departure_city.longitude].min
    lat_max = [trip.arrival_city.latitude, trip.departure_city.latitude].max
    lat_min = [trip.arrival_city.latitude, trip.departure_city.latitude].min
    activities = Activity.where('longitude BETWEEN ? AND ?', long_min - 0.5, long_max + 0.5).where('latitude BETWEEN ? AND ?', lat_min - 0.5, lat_max + 0.5)
    return activities
  end

  def ratio_duration(trip)
    # calculates ratio of duration of each criteria vs total duration of trip activity
    total_trip_duration = ((trip.end_date - trip.start_date) / 86_400) * 8 * 60 # -> nb days * 8h * 60min
    criteria_sum = trip.criteria["beach"].to_f + trip.criteria["visit"].to_f + trip.criteria["culture"].to_f + trip.criteria["sport"].to_f
    beach_ratio = (total_trip_duration * trip.criteria["beach"].to_f) / criteria_sum
    visit_ratio = (total_trip_duration * trip.criteria["visit"].to_f) / criteria_sum
    culture_ratio = (total_trip_duration * trip.criteria["culture"].to_f) / criteria_sum
    sport_ratio = (total_trip_duration * trip.criteria["sport"].to_f) / criteria_sum

    ratio_duration = { "beach" => beach_ratio, "visit" => visit_ratio, "culture" => culture_ratio, "sport" => sport_ratio }
    @total_trip_duration = total_trip_duration
    return ratio_duration
  end

  def order_by_ranking(array, type)
    result = array.select do |array_act|
      array_act.activity_types == type
    end
    result.sort_by!{|act| act.ranking_interest }
    return result
  end

  def total_duration(array)
    sum = 0
    array.each do |act|
      sum += act.duration
    end
    return sum
  end

  def edit
    @trip = Trip.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update(trip_params)
      redirect_to new_trip_step_path(@trip)
    else
      render :edit
    end
  end

  def details
    @trip = Trip.find(params[:id])
    list = activities(@trip)
    activities_to_map(list)
  end

  def activities(trip)
    trip_activities = []
    trip.steps.each do |step|
      trip_activities << step.activities
    end
    trip_activities.flatten!
    return trip_activities
  end

  def save
    @trip = Trip.find(params[:id])
    @trip.user = current_user if current_user.present?
    redirect_to trips_path if @trip.save!
  end

  private

  def trip_params
    params.require(:trip).permit(:departure_city_id, :arrival_city_id, :start_date, :end_date, criteria: {})
  end


end
