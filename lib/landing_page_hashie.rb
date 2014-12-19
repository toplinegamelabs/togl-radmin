class LandingPageHashie < Hashie::Dash
  property :landing_page_template_id
  property :template_variables, default: {}
  property :name, default: ""
  property :id

  def self.build_from_rapi_hash(hash)
    page = self.new

    page.id = hash["id"]
    page.name = hash["name"]
    page.landing_page_template_id = hash["landing_page_template_id"]
    page.template_variables = hash["template_variables"]

    page
  end

end
