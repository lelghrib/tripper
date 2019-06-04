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
      redirect_to trip_path(@trip)
      # scroll/passage au next tab
    else
      render :new
    end
  end

  def show
    @trip = Trip.find(params[:id])
  end

  def edit
  end

  def update
  end

  def details
  end

  private

  def trip_params
    params.require(:trip).permit(:departure_city, :arrival_city, :start_date, :end_date, :trip_trecking, :trip_out, :trip_out, :trip_beach)
  end
end
