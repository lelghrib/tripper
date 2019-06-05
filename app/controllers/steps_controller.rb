class StepsController < ApplicationController
  def index
    @steps = Step.all
  end

  def new
    @trip = Trip.find(params[:trip_id])
    @step = Step.new

    @activities = activities_in_zone(@trip)

    @activities_culture = @activities.select do |activity|
      activity.activity_types == "culture"
    end


    @ratio_type_activities_double = ratio_duration_double(@trip)
    @ratio_type_activities = ratio_duration(@trip)
    @list_acti_beach = filter_activities_by_time(@activities, @ratio_type_activities_double, "beach")
    #@total_beach = total_duration(@list_acti_beach)
    @list_acti_sport = filter_activities_by_time(@activities, @ratio_type_activities_double, "sport")
    #@total_sport = total_duration(@list_acti_sport)
    @list_acti_visit = filter_activities_by_time(@activities, @ratio_type_activities_double, "visit")
    #@total_visit = total_duration(@list_acti_visit)
    @list_acti_culture_double = filter_activities_by_time(@activities, @ratio_type_activities_double, "culture")
    @list_acti_culture_real = filter_activities_by_time(@activities, @ratio_type_activities, "culture")
    #@total_culture_double = total_duration(@list_acti_culture_double)
    #@total_culture = total_duration(@list_acti_culture)
    # this@total_activities = @total_beach + @total_sport + @total_visit + @total_culture
    #@order_culture = order_by_ranking(@activities, 'culture')
    #@total_culture = total_duration(@order_culture)
    #@order_sport = order_by_ranking(@activities, 'sport')
    #@total_sport = total_duration(@order_sport)
    #@order_visit = order_by_ranking(@activities, 'visit')
    #@total_visit = total_duration(@order_visit)
    # this@list_all_acti = @list_acti_beach + @list_acti_culture + @list_acti_visit
    # + @list_acti_culture + @list_acti_sport + @list_acti_visit
    # @list_all_acti.flatten!
    #activities_to_map(@list_acti_culture)

    # activities to choose when 1 activity
    if @list_acti_culture_real.size == 1
      # activities with same duration that real and plus minus 30 min
      list_to_replace = @list_acti_culture_double.select do |activity|
        activity.duration == @list_acti_culture_real.first.duration + 30 || activity.duration == @list_acti_culture_real.first.duration - 30 || activity.duration == @list_acti_culture_real.first.duration
      end
      @list_acti_culture_choose = list_to_replace.first(4)
    elsif @list_acti_culture_real.size == 2
      # activities to choose when 2 activities
      @list_acti_culture_choose = @list_acti_culture_double[@list_acti_culture_real.size - 2..@list_acti_culture_real.size + 1]
    else
      # activities to choose when plus 2 activities
      @list_acti_culture_fixed = @list_acti_culture_real[0..@list_acti_culture_real.size - 3].map do |activity|
        activity.id
      end
      @list_acti_culture_choose = @list_acti_culture_double[@list_acti_culture_real.size - 2..@list_acti_culture_real.size + 1]
    end
  end

  def filter_activities_by_time(activities, ratio_type_activities, criteria)
    order_list = order_by_ranking(activities, criteria)
    total_list = total_duration(order_list)
    list_acti = []
    if total_list < ratio_type_activities[criteria]
      list_acti << order_list
      list_acti.flatten!
      return list_acti
    else
      order_list.each do |acti|
        return list_acti if (total_duration(list_acti) + acti.duration) > ratio_type_activities[criteria]

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
    total_trip_duration = ((trip.end_date - trip.start_date) / 86400) * 2 * 60 # -> nb days * 8h * 60min
    beach_ratio = (total_trip_duration * trip.criteria["beach"].to_i) / 100
    visit_ratio = (total_trip_duration * trip.criteria["visit"].to_i) / 100
    culture_ratio = (total_trip_duration * trip.criteria["culture"].to_i) / 100
    sport_ratio = (total_trip_duration * trip.criteria["sport"].to_i) / 100
    ratio_duration = { "beach" => beach_ratio, "visit" => visit_ratio, "culture" => culture_ratio, "sport" => sport_ratio}
    @total_trip_duration = total_trip_duration
    return ratio_duration
  end

  def ratio_duration_double(trip)
    # calculates double ratio of duration of each criteria vs total duration of trip activity
    total_trip_duration_double = ((trip.end_date - trip.start_date) / 86400) * 2 * 60 * 2 # -> nb days * 8h * 60min * 2(double time)
    beach_ratio = (total_trip_duration_double * trip.criteria["beach"].to_i) / 100
    visit_ratio = (total_trip_duration_double * trip.criteria["visit"].to_i) / 100
    culture_ratio = (total_trip_duration_double * trip.criteria["culture"].to_i) / 100
    sport_ratio = (total_trip_duration_double * trip.criteria["sport"].to_i) / 100
    ratio_duration_double = { "beach" => beach_ratio, "visit" => visit_ratio, "culture" => culture_ratio, "sport" => sport_ratio}
    # @total_trip_duration = total_trip_duration
    return ratio_duration_double
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

  def create
    # find trip
    @trip = Trip.find(params[:trip_id])
    # clean params activities ids from ''
    activities_choosen = params[:activities_ids].reject do |activity_id|
      activity_id == ''
    end
    # array of fixed activities in string
    unless params[:activities_fixed_ids] == [""]
      activities_fixed = params[:activities_fixed_ids].join.gsub("[", "").gsub("]", "").split(", ")
      # pushing fixed activities to choosen
      activities_fixed.each do |activity_id|
        activities_choosen << activity_id
      end
    end

    # creating hash key: city_id value: array of activities
    step_hash = {}
    activities_choosen.each do |activity_id|
      activity = Activity.find(activity_id)
      if step_hash.key?(activity.city.id)
        step_hash[activity.city.id] << activity.id
      else
        step_hash[activity.city.id] = [activity.id]
      end
    end

    step_hash.each do |key, value|
      # creating steps for each key=city_id
      step = Step.new
      step.city = City.find(key)
      step.trip = @trip
      step.duration = 5
      step.order = 5
      step.time_next_step = 5
      step.distance_next_step = 5
      step.save
      # creating step_activities for each value=array of activities
      value.each do |activity_id|
        step_activity = StepActivity.new
        step_activity.step = step
        step_activity.activity = Activity.find(activity_id)
        step_activity.save
      end
    end
    redirect_to trip_path(@trip)
  end
end
