function validate() {
  valid = true;
  valid = valid && validateBasicPromotionDetails();
  valid = valid && validateUser();
  valid = valid && validateEntry();
  valid = valid && validatePromotionTarget();
  valid = valid && validateContestTemplate();
  valid = valid && validateEmails();











  
  // are we valid?
  update_submit(valid);
}












function validateBasicPromotionDetails() {
  valid = true;
  // gotta have promo name
  if($("#promo_name").val() != "") {
    $("[for=promo_name]").css("color", "black");
  } else {
    console.log("bad no promo name");
    valid = false;
    $("[for=promo_name]").css("color", "red");
  }

  // gotta have unique promo identifier
  if (dailymvp.promotion.target.persisted != true) {
    $("#identifier_output").text("");
    if($("#promo_identifier").val() != "") {
      if(unique_identifier) {
        $("[for=promo_identifier]").css("color", "black");
      } else {
        $("#identifier_output").text("not unique!");
        $("[for=promo_identifier]").css("color", "red");
        console.log("promo identifier not unique");
        valid = false;
      } 
    } else {
        console.log("missing promo identifier");
      valid = false;
      $("[for=promo_identifier]").css("color", "red");
    }
  }

  // gotta have promotion group
  if($("#promotion_group_id").val() != "" && $("#promotion_group_id").val() != null) {
    $("[for=promotion_group_id]").css("color", "black");
  } else {
    console.log("need a promotion group");
    valid = false
    $("[for=promotion_group_id]").css("color", "red");
  }
  return valid;
}

function validateContestTemplate() {
  valid = true;

  // *****************************************************************************
  // BUYIN
  // *****************************************************************************
    
  if (dailymvp.promotion.target.persisted == true) {
    initial_max = dailymvp.promotion.target.max || 0;
  } else {
    initial_max = 0;
  }
  if($("input[name=c_or_c]:checked").val() == "challenge" || user_found) {
    var working_buy_in;
    if(buy_in != null && buy_in != "") {
      working_buy_in = buy_in;
    } else {
      working_buy_in = $("#buy_in").val();
    }
    if(($("#max").val() - initial_max) * (working_buy_in * 100) > balance) { 
      $("[for=buy_in]").css("color", "red");
      $("#buy_in_output").css("color", "red");
      console.log("not enough balance");
      valid = false;
      $("#buy_in_output").text("Total Buy In: $" + ($("#max").val() * working_buy_in).toFixed(2) + " - this is over budget");

    } else {
      $("[for=buy_in]").css("color", "black");
      $("#buy_in_output").css("color", "black");
      if(working_buy_in != null && working_buy_in != "") {
        $("#buy_in_output").text("Total Buy In: $" + ($("#max").val() * working_buy_in).toFixed(2));
      }
    }
  }


  if($("#size").val() < 2) {

    valid = false;
    $("#size_output").text("Size must be greater than 2");
    console.log("invalid contest size");
  } else {
    $("#size_output").text("");
  }

  // *****************************************************************************
  // PRIZES
  // *****************************************************************************
    
  $(".prize_option_output").text("");
  // mark if anything overlaps
  $("#prize_rows").children().each(function(index_upper) {

    my_row = $(this);
    my_start = my_row.children(".prize_range").children("#prize_table__start_place").val();
    my_end = my_row.children(".prize_range").children("#prize_table__end_place").val();
    // loop through every other row and check that our ranges don't overlap
    $("#prize_rows").children().each(function(index_lower) {
      if(index_upper != index_lower) {
        some_row = $(this);
        some_start = some_row.children(".prize_range").children("#prize_table__start_place").val();
        some_end = some_row.children(".prize_range").children("#prize_table__start_place").val();
        if((my_start >= some_start && my_start <= some_end) ||
            (my_end >= some_start && my_end <= some_end)) {

          console.log("prize ranges overlap");
          valid = false;
          my_row.children(".prize_option_output").text("range overlaps");

        }
      }
    });
  });

  // *****************************************************************************
  // GAME
  // *****************************************************************************
    
  if (dailymvp.promotion.target.persisted != true) {
    // game it
    if($("#game_id").val() != "") {
      $("[for=game_id]").css("color", "black");
      $("#cc_config").show();
    } else {

        console.log("missing game");
      valid = false;
      $("[for=game_id]").css("color", "red");
      $("#cc_config").hide();
    }

    // EVENT SET
    if($("#event_set_id").val() != "") {
      $("[for=event_set_id]").css("color", "black");
    } else {
      valid = false;
        console.log("missing event set");
      $("[for=event_set_id]").css("color", "red");
    }
  }

  return valid;
}

function validateEmails() {
  valid = true;
  if($("#skip_entry").prop("checked")) {
    if($("#email_contest_available_subject").val() != "") {
      $("#email_contest_available_subject_output").text("");
    } else {
      $("#email_contest_available_subject_output").text("* required");
      valid = false;
      console.log("pending promotion details missing");
    }

    if($("#email_contest_available_body").val() != "") {
      $("#email_contest_available_body_output").text("");
    } else {
      $("#email_contest_available_body_output").text("* required");
      valid = false;
      console.log("pending promotion details missing");
    }

    if($("#notification_name").val() != "") {
      $("#notification_name_output").text("");
    } else {
      $("#notification_name_output").text("* required");
      valid = false;
      console.log("pending promotion details missing");
    }

    if($("#notification_description").val() != "") {
      $("#notification_description_output").text("");
    } else {
      $("#notification_description_output").text("* required");
      valid = false;
      console.log("pending promotion details missing");
    }

    if($("#notification_push_text").val() != "") {
      $("#notification_push_text_output").text("");
    } else {
      $("#notification_push_text_output").text("* required");
      valid = false;
      console.log("pending promotion details missing");
    }
  }
  return valid;
}

function validateEntry() {
  valid = true;
  $("#entries_output").empty();
  $("[id^=entry_item_label_]").css("color", "black");
  if($("#skip_entry").prop("checked")) {
    if($("#activation_deadline_date").val() != null && $("#activation_deadline_date").val() != ""
      && $("#activation_deadline_time").val() != null && $("#activation_deadline_time").val() != "") {
      $("#activation_deadline").css("color", "black");
    } else {
      $("#activation_deadline").css("color", "red");
      console.log("missing activation deadline");
      valid = false;
    }
  } else if ($("input[name=c_or_c]:checked").val() == "challenge" || user_found) {
    // entriesss
    entry_count = $("[id^=entry_item_drop]").length;
    unique_entry_count = $.unique($.map($("[id^=entry_item_drop_]"), function( i ) { return $(i).val(); })).length;
    valid_entries = (entry_count > 0 && entry_count == unique_entry_count);

    if(valid_entries) {
      $("#entries_output").empty();
      $("[id^=entry_item_label_]").css("color", "black");
    } else {
      console.log("missing entry");
      valid = false;
      if(entry_count != unique_entry_count) {
        $("#entries_output").css("color", "red");
        $("#entries_output").text("Duplicate entry item selection detected!");
        $("#entries_output").append("<br/><br/>");
      }
      $("[id^=entry_item_label_]").css("color", "red");
    }
  }
  return valid;
}

function validatePromotionTarget() {
  valid = true;
  // max it out
  if($("#max").val() < 1) {
    if (dailymvp.promotion.target.persisted != true) {
      valid = false;
      console.log("max must be >= 1");
      $("[for=max]").css("color", "red");
    }
  }
  return valid;
}

function validateUser() {
  valid = true;
  if (dailymvp.promotion.target.persisted != true) {
    // User validating
    if($("input[name=c_or_c]:checked").val() == "challenge") {
      if($("#user_id").val() != "") {
        $("[for=username]").css("color", "black");
      } else {
        console.log("challenge without a creator");
        valid = false;
        $("[for=username]").css("color", "red");
      }
    } else {
      $("[for=username]").css("color", "black");
    }
  }
  return valid;
}
