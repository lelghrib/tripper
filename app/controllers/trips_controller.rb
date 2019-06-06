class TripsController < ApplicationController
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
    @activities = activities_in_zone(@trip)
    @ratio_type_activities = ratio_duration(@trip)
    @list_acti_beach = filter_activities_by_time("beach")
    @total_beach = total_duration(@list_acti_beach)
    @list_acti_culture = filter_activities_by_time("culture")
    @total_culture = total_duration(@list_acti_culture)
    @list_acti_sport = filter_activities_by_time("sport")
    @total_sport = total_duration(@list_acti_sport)
    @list_acti_visit = filter_activities_by_time("visit")
    @total_visit = total_duration(@list_acti_visit)
    @total_activities = @total_beach + @total_sport + @total_visit + @total_culture
    #@order_culture = order_by_ranking(@activities, 'culture')
    #@total_culture = total_duration(@order_culture)
    #@order_sport = order_by_ranking(@activities, 'sport')
    #@total_sport = total_duration(@order_sport)
    #@order_visit = order_by_ranking(@activities, 'visit')
    #@total_visit = total_duration(@order_visit)
    @list_all_acti = @list_acti_beach + @list_acti_culture + @list_acti_visit
    # + @list_acti_culture + @list_acti_sport + @list_acti_visit
    # @list_all_acti.flatten!
    @list_acti_map = []
    @trip.steps.each do |step|
        @list_acti_map << step.activities
    end
    @list_acti_map.flatten!
    activities_to_map(@list_acti_map)
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
  end



  def save
    @trip = Trip.find(params[:id])
    raise
    @trip.user = current_user if current_user.present?
    redirect_to details_trip_path(@trip) if @trip.save!
  end

  private

  def trip_params
    params.require(:trip).permit(:departure_city_id, :arrival_city_id, :start_date, :end_date, criteria: {})
  end
end
