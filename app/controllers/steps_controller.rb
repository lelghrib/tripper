class StepsController < ApplicationController
  # def show
  #   @step = Step.find(params[:id])
  # end

  def index
    @steps = Step.all
  end
end
