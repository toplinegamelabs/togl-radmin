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
  property :sort_ranking, default: 0

  property :name_logo, default: 
    {
      "css_class" => "icon-star",
      "unicode" => "e683" 
    }

  property :prize_source, default:
    {
      "label" => "",
      "image_url" => ""
    }

  property :images, default: 
    {
      "desktop" => {},
      "mobile" => {},
      "tablet" => {}
    }

  property :pushes, default:
    {
      "contest_win" => {
        "enabled" => true,
        "message" => "",
        "target_type" => ""
      },
      "contest_loss" => {
        "enabled" => true,
        "message" => "",
        "target_type" => ""
      },
      "contest_tie" => {
        "enabled" => true,
        "message" => "",
        "target_type" => ""
      }
    }

  property :emails, default:
    {
      "contest_joined" => {
        "enabled" => false,
        "custom" => true,
        "content" => {
          "layout" => "",
          "subject" => "",
          "body" => "",
          "header" => {
            "image_url" => "",
            "target_url" => "",
            "color_code" => ""
          },
          "action_buton" => {
            "target_type" => "",
            "label" => ""
          }
        }
      },
      "contest_win" => {
        "enabled" => true,
        "custom" => false,
        "content" => {
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
          },
          "action_buton" => {
            "target_type" => "",
            "label" => ""
          }
        }
      },
      "contest_loss" => {
        "enabled" => true,
        "custom" => false,
          "content" => {
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
          },
          "action_buton" => {
            "target_type" => "",
            "label" => ""
          }
        }
      },
      "contest_tie" => {
        "enabled" => true,
        "custom" => false,
        "content" => {
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
          },
          "action_buton" => {
            "target_type" => "",
            "label" => ""
          }
        }
      },
      "contest_available" => {
        "enabled" => true,
        "custom" => true,
        "content" => {
          "layout" => "",
          "subject" => "",
          "body" => "",
          "header" => {
            "image_url" => "",
            "target_url" => "",
            "color_code" => ""
          },
          "action_buton" => {
            "target_type" => "",
            "label" => ""
          }
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
    promo.prize_source = hash["prize_source"] if hash["prize_source"]
    promo.emails = hash["emails"]
    promo.pushes = hash["pushes"]
    promo.promotion_group_id = hash["promotion_group_id"]
    # sometimes it comes in as a date (especially when form is in an error state, and we need a string here
    promo.activation_deadline = hash["activation_deadline"].to_s
    promo.invitation_hashtag = hash["invitation_hashtag"]
    promo.notification = hash["notification"]
    promo.is_pending = hash["is_pending"]
    promo
  end

end
