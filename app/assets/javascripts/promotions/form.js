function updateEmails() {
  custom_layouts = ["cbs", "cbs_small_footer", "configurable"];

  // update based on if emails are enabled
  if($("#enable_contest_available_email").prop("checked")) {
    $("[id^=email_contest_available_]").prop("disabled", false);
    if(custom_layouts.indexOf($("#email_contest_available_layout").val()) >= 0) {
      $("[id^=email_contest_available_header]").prop( "readonly", false);
    } else {
      $("[id^=email_contest_available_header]").prop( "readonly", true);
    }
  } else {
    $("[id^=email_contest_available_]").prop("disabled", true);
  }

  if($("#enable_contest_joined_email").prop("checked")) {
    $("[id^=email_contest_joined_]").prop("disabled", false);
    if(custom_layouts.indexOf($("#email_contest_joined_layout").val()) >= 0) {
      $("[id^=email_contest_joined_header]").prop( "readonly", false);
    } else {
      $("[id^=email_contest_joined_header]").prop( "readonly", true);
    }
  } else {
    $("[id^=email_contest_joined_]").prop("disabled", true);
  }

  if($("#enable_contest_win_email").prop("checked")) {
    $("[id^=email_contest_win_]").prop("disabled", false);
    if(custom_layouts.indexOf($("#email_contest_win_layout").val()) >= 0) {
      $("[id^=email_contest_win_header]").prop( "readonly", false);
    } else {
      $("[id^=email_contest_win_header]").prop( "readonly", true);
    }
  } else {
    $("[id^=email_contest_win_]").prop("disabled", true);
  }

  if($("#enable_contest_loss_email").prop("checked")) {
    $("[id^=email_contest_loss_]").prop("disabled", false);
    if(custom_layouts.indexOf($("#email_contest_loss_layout").val()) >= 0) {
      $("[id^=email_contest_loss_header]").prop( "readonly", false);
    } else {
      $("[id^=email_contest_loss_header]").prop( "readonly", true);
    }
  } else {
    $("[id^=email_contest_loss_]").prop("disabled", true);
  }

  if($("#enable_contest_tie_email").prop("checked")) {
    $("[id^=email_contest_tie_]").prop("disabled", false);
    if(custom_layouts.indexOf($("#email_contest_tie_layout").val()) >= 0) {
      $("[id^=email_contest_tie_header]").prop( "readonly", false);
    } else {
      $("[id^=email_contest_tie_header]").prop( "readonly", true);
    }
  } else {
    $("[id^=email_contest_tie_]").prop("disabled", true);
  }

  // update based on if emails are custom
  updateEmailFields('contest_joined');
  updateEmailFields('contest_win');
  updateEmailFields('contest_loss');
  updateEmailFields('contest_tie');  
}

// *****************************************************************************
// helpers to change html elements based on given data
// *****************************************************************************
function updateSubmit(valid) {
  if(valid) {
    document.getElementById('submitter').removeAttribute("disabled");
  } else {
    document.getElementById('submitter').setAttribute("disabled", "disabled");
  }
}

function updateEmailFields(email_name) {
  if($("#email_" + email_name + "_is_custom:checked").val() == "picked") {
    $("[id^=email_" + email_name + "_]").not("#email_" + email_name + "_is_custom").prop("disabled", false);
  } else {
    $("[id^=email_" + email_name + "_]").not("#email_" + email_name + "_is_custom").prop("disabled", true);
  }
}

function update_push_fields(push_name) {
  if($("#enable_" + push_name + "_push:checked").val() == "picked") {
    document.getElementById("push_" + push_name + "_push_message").removeAttribute("disabled");
    document.getElementById("push_" + push_name + "_link_target_type_home").removeAttribute("disabled");
    document.getElementById("push_" + push_name + "_link_target_type_my_contest").removeAttribute("disabled");
  } else {
    document.getElementById("push_" + push_name + "_push_message").setAttribute("disabled", "disabled");
    document.getElementById("push_" + push_name + "_link_target_type_home").setAttribute("disabled", "disabled");
    document.getElementById("push_" + push_name + "_link_target_type_my_contest").setAttribute("disabled", "disabled");
  }
}

