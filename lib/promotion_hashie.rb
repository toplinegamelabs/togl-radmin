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
        "layout" => nil,
        "subject" => nil,
        "body" => nil,
        "header" => {
          "image_url" => nil,
          "target_url" => nil,
          "color_code" => nil
        }
      },
      "contest_win" => {
        "layout" => nil,
        "subject" => nil,
        "body" => {
          "pre" => nil,
          "post" => nil
        },
        "header" => {
          "image_url" => nil,
          "target_url" => nil,
          "color_code" => nil
        }
      },
      "contest_loss" => {
        "layout" => nil,
        "subject" => nil,
        "body" => {
          "pre" => nil,
          "post" => nil
        },
        "header" => {
          "image_url" => nil,
          "target_url" => nil,
          "color_code" => nil
        }
      },
      "contest_tie" => {
        "layout" => nil,
        "subject" => nil,
        "body" => {
          "pre" => nil,
          "post" => nil
        },
        "header" => {
          "image_url" => nil,
          "target_url" => nil,
          "color_code" => nil
        }
      },
      "contest_available" => {
        "layout" => nil,
        "subject" => nil,
        "body" => {
          "pre" => nil,
          "post" => nil
        },
        "header" => {
          "image_url" => nil,
          "target_url" => nil,
          "color_code" => nil
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
