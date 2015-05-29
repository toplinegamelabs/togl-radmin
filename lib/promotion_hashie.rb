class PromotionHashie < Hashie::Dash
  property :name
  property :identifier
  property :description
  property :display_type
  property :promotion_group_id
  property :activation_deadline
  property :invitation_hashtag, default: "#"
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
        "body" => "",
        "header" => {
          "image_url" => "",
          "target_url" => "",
          "color_code" => ""
        }
      },
      "contest_win" => {
        "layout" => "",
        "subject" => "",
        "body" => {
          "pre" => "",
          "post" => ""
        },
        "header" => {
          "image_url" => "",
          "target_url" => "",
          "color_code" => ""
        }
      },
      "contest_loss" => {
        "layout" => "",
        "subject" => "",
        "body" => {
          "pre" => "",
          "post" => ""
        },
        "header" => {
          "image_url" => "",
          "target_url" => "",
          "color_code" => ""
        }
      },
      "contest_tie" => {
        "layout" => "",
        "subject" => "",
        "body" => {
          "pre" => "",
          "post" => ""
        },
        "header" => {
          "image_url" => "",
          "target_url" => "",
          "color_code" => ""
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
    promo.activation_deadline = hash["activation_deadline"]
    promo.invitation_hashtag = hash["invitation_hashtag"]
    promo
  end

end
