class EventSetsController < ApplicationController
  before_filter :require_user

  def index
    # note: limited to h2h only for challenges
    rapi_response = RapiManager.new.list_event_sets(params[:game_id])

    @event_sets = []
    rapi_response["event_sets"].each do |event_set_wrapper|
      event_set = event_set_wrapper["event_set"]
      if event_set
        @event_sets << [
          event_set["id"],
          event_set["name"]
        ]
      end
    end

    render json: @event_sets.to_json
  end

end
