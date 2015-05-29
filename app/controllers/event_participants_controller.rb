class EventParticipantsController < ApplicationController
  before_filter :require_user

  def index
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    rapi_manager = RapiManager.new(oauth_token: oauth_token)
    if params[:contest_template_id]
      ep_response = rapi_manager.list_event_participants_by_contest_template(params[:game_id], params[:contest_template_id])
    elsif params[:event_set_id]
      ep_response = rapi_manager.list_event_participants_by_event_set(params[:game_id], params[:event_set_id])
    end
    game_response = rapi_manager.list_games

    game = game_response["games"].select { |game| game["id"] == params[:game_id].to_i }.first

    @event_participants_by_slot = []

    game["game_details"]["slots"].each do |slot|
      @event_participants_by_slot << {
        slot_id: slot["slot_id"],
        display_name: slot["display_name"],
        event_participants: (ep_response["event_participants"] || []).select do |ep|
          ([slot["group"]] & ep["slot_groups"]).present?
        end.sort do |a, b|
          [a["player"]["biography"]["position"], a["player"]["last_name"], a["player"]["first_name"]] <=> [b["player"]["biography"]["position"], b["player"]["last_name"], b["player"]["first_name"]]
        end.collect do |ep|
          ["#{ep["player"]["team"]["abrv_name"]} - #{ep["player"]["full_name"]} (Projected: #{ep["projected_points"]}pts)", ep["id"].to_s]
        end
      }
    end

    render json: @event_participants_by_slot.to_json
  end

end
