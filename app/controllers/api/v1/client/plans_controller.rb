class Api::V1::Client::PlansController < ApplicationController

  # list all available plans to the user
  def index
    render json: Plan.all.order(price: :asc)
  end
end
