class PromotionHashie < Hashie::Dash

  property :name
  property :identifier
  property :description
  property :display_type
  property :promotion_group_id
  property :name_logo, default: 
    {
      "css_class" => "icon-star",
      "unicode" => "e683" 
    }

  property :images, default: 
    {
      "desktop" => {},
      "mobile" => {},
      "tablet" => {}
    }

  property :emails, default:
    {
      "contest_joined" => {
        "layout" => "",
        "subject" => "",
        "body" => ""
      },
      "contest_win" => {
        "layout" => "",
        "subject" => "",
        "body" => {
          "pre" => "",
          "post" => ""
        }
      },
      "contest_loss" => {
        "layout" => "",
        "subject" => "",
        "body" => {
          "pre" => "",
          "post" => ""
        }
      },
      "contest_tie" => {
        "layout" => "",
        "subject" => "",
        "body" => {
          "pre" => "",
          "post" => ""
        }
      }
    }



  def self.build_from_rapi_hash(hash)
    promo = self.new

    promo.name = hash["name"]
    promo.identifier = hash["identifier"]
    promo.description = hash["description"].join("\n")
    promo.display_type = hash["display_type"]
    promo.name_logo = hash["name_logo"]
    promo.images = hash["images"]
    promo.emails = hash["emails"]
    promo.promotion_group_id = hash["promotion_group_id"]
    promo
  end

end
