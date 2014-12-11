class ContestTemplatesController < ApplicationController
  before_filter :require_user

  def index

    # note: limited to h2h only for challenges


    config = YAML.load(File.open("#{Rails.root}/config/rapi.yml"))
    environment = config[Rails.env]["environment"]

    oauth_token = OauthManager.execute(environment: environment, client_app: "dailymvp" || params[:client_app])
    rapi_response = RapiManager.new(environment: environment, oauth_token: oauth_token).contest_templates(params[:game_id])

    @contest_templates = []
    rapi_response["event_sets"].each do |event_set|
      event_set["contest_templates"].each do |contest_template|
        if contest_template["size"]["value"] == 2
          @contest_templates << ["#{event_set["description"]} - #{contest_template["buy_in"]["label"]} - #{contest_template["size"]["label"]}", contest_template["id"]]
        end
      end
    end

    render json: @contest_templates.to_json
  end

end
