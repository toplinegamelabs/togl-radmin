class ContestTemplatesController < ApplicationController
  before_filter :require_user

  def index

    # note: limited to h2h only for challenges
    oauth_token = OauthManager.execute(client_app: @current_client_app)
    rapi_response = RapiManager.new(oauth_token: oauth_token).list_contest_templates(params[:game_id])

    @contest_templates = []
    rapi_response["event_sets"].each do |event_set|
      event_set["contest_templates"].each do |contest_template|
        if contest_template["size"]["value"] == 2
          @contest_templates << [
              contest_template["id"],
              event_set["description"],
              contest_template["buy_in"]["label"],
              contest_template["buy_in"]["value"],
              contest_template["size"]["label"],
              contest_template["is_publicly_joinable"] ? "Public" : "Private"
            ]
        end
      end
    end

    render json: @contest_templates.to_json
  end

end
