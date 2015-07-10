class PromotionHashie < Hashie::Dash
  property :name
  property :identifier
  property :description
  property :display_type
  property :promotion_group_id
  property :activation_deadline
  property :invitation_hashtag, default: "#"
  property :notification, default: {}
  property :is_pending, default: false

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
        "enabled" => true,
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
        "enabled" => true,
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
        "enabled" => true,
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
        "enabled" => true,
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
      "contest_available" => {
        "enabled" => true,
        "layout" => "",
        "subject" => "",
        "body" => "",
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
    # sometimes it comes in as a date (especially when form is in an error state, and we need a string here
    promo.activation_deadline = hash["activation_deadline"].to_s
    promo.invitation_hashtag = hash["invitation_hashtag"]
    promo.notification = hash["notification"]
    promo.is_pending = hash["is_pending"]
    promo
  end

end
