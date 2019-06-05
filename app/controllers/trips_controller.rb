class TripsController < ApplicationController
  def index
    @trips = Trip.all
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    # Ajout manuel de criteria
    # new_criteria = { beach: 30,
    #             trecking: 30,
    #             culture: 20,
    #             out: 20
    #             }
    # @trip.criteria = new_criteria

    if @trip.save
      redirect_to edit_trip_path(@trip)
      # scroll/passage au next tab
    else
      render :new
    end
  end

  def show
    @trip = Trip.find(params[:id])
    long_max = [@trip.arrival_city.longitude, @trip.departure_city.longitude].max
    long_min = [@trip.arrival_city.longitude, @trip.departure_city.longitude].min
    lat_max = [@trip.arrival_city.latitude, @trip.departure_city.latitude].max
    lat_min = [@trip.arrival_city.latitude, @trip.departure_city.latitude].min

    @activities = Activity.where('longitude BETWEEN ? AND ?', long_min-0.5, long_max+0.5).where('latitude BETWEEN ? AND ?', lat_min-0.5, lat_max+0.5)
    # Comment.where('created_at BETWEEN ? AND ?', @selected_date.beginning_of_day, @selected_date.end_of_day)
    # and (:latitude.between?(lat_ar, lat_dep))))
    @order_beach = ranking(@activities, 'beach')
    @order_culture = ranking(@activities, 'culture')
    @order_sport = ranking(@activities, 'sport')
    @order_visit = ranking(@activities, 'visit')
  end
  def ranking(array, type)
      result = array.select do |array_act|
      array_act.activity_types == type
    end
    result.sort_by!{|act| act.ranking_interest }
    return result
  end

  def edit
    @trip = Trip.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update(trip_params)
      redirect_to trip_path(@trip)
    else
      render :edit
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:departure_city_id, :arrival_city_id, :start_date, :end_date, criteria: {})
  end
end
