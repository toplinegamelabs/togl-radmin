class MetricsController < ApplicationController
  before_filter :require_user

  def index
    @date_range = {}
  end

  def create
    from = "#{params[:from_year].to_i}-#{params[:from_month].to_i}-#{params[:from_day].to_i}"
    to = "#{params[:to_year].to_i}-#{params[:to_month].to_i}-#{params[:to_day].to_i}"
    rapi_manager = RapiManager.new
    @response = rapi_manager.get_date_range_metrics(from, to)
  end
end
