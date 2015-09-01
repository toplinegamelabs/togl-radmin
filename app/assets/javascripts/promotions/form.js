function updateEmails() {
  custom_layouts = ["cbs", "cbs_small_footer", "configurable"];


  if($("#email_contest_available_layout_configurable").prop("checked")) {
    $("#email_contest_available_layout").val("configurable");
    $("#email_contest_available_layout").prop("readonly", true);
  } else {
    $("#email_contest_available_layout").prop("readonly", false);
  }
  if(custom_layouts.indexOf($("#email_contest_available_layout").val()) >= 0) {
    $("[id^=email_contest_available_header]").prop( "readonly", false);
  } else {
    $("[id^=email_contest_available_header]").prop( "readonly", true);
  }

  if($("#email_contest_joined_layout_configurable").prop("checked")) {
    $("#email_contest_joined_layout").val("configurable");
    $("#email_contest_joined_layout").prop("readonly", true);
  } else {
    $("#email_contest_joined_layout").prop("readonly", false);
  }
  if(custom_layouts.indexOf($("#email_contest_joined_layout").val()) >= 0) {
    $("[id^=email_contest_joined_header]").prop( "readonly", false);
  } else {
    $("[id^=email_contest_joined_header]").prop( "readonly", true);
  }

  if($("#email_contest_win_layout_configurable").prop("checked")) {
    $("#email_contest_win_layout").val("configurable");
    $("#email_contest_win_layout").prop("readonly", true);
  } else {
    $("#email_contest_win_layout").prop("readonly", false);
  }
  if(custom_layouts.indexOf($("#email_contest_win_layout").val()) >= 0) {
    $("[id^=email_contest_win_header]").prop( "readonly", false);
  } else {
    $("[id^=email_contest_win_header]").prop( "readonly", true);
  }

  if($("#email_contest_loss_layout_configurable").prop("checked")) {
    $("#email_contest_loss_layout").val("configurable");
    $("#email_contest_loss_layout").prop("readonly", true);
  } else {
    $("#email_contest_loss_layout").prop("readonly", false);
  }
  if(custom_layouts.indexOf($("#email_contest_loss_layout").val()) >= 0) {
    $("[id^=email_contest_loss_header]").prop( "readonly", false);
  } else {
    $("[id^=email_contest_loss_header]").prop( "readonly", true);
  }

  if($("#email_contest_tie_layout_configurable").prop("checked")) {
    $("#email_contest_tie_layout").val("configurable");
    $("#email_contest_tie_layout").prop("readonly", true);
  } else {
    $("#email_contest_tie_layout").prop("readonly", false);
  }
  if(custom_layouts.indexOf($("#email_contest_tie_layout").val()) >= 0) {
    $("[id^=email_contest_tie_header]").prop( "readonly", false);
  } else {
    $("[id^=email_contest_tie_header]").prop( "readonly", true);
  }
}



// *****************************************************************************
// helpers to change html elements based on given data
// *****************************************************************************
function update_submit(valid) {
  if(valid) {
    document.getElementById('submitter').removeAttribute("disabled");
  } else {
    document.getElementById('submitter').setAttribute("disabled", "disabled");
  }
}

function update_email_fields(email_name) {
  if($("#enable_" + email_name + "_email:checked").val() == "picked") {
    document.getElementById("email_" + email_name + "_layout_configurable").removeAttribute("disabled");
    document.getElementById("email_" + email_name + "_layout").removeAttribute("disabled");
    document.getElementById("email_" + email_name + "_subject").removeAttribute("disabled");
    document.getElementById("email_" + email_name + "_header_image_url").removeAttribute("disabled");
    document.getElementById("email_" + email_name + "_header_color_code").removeAttribute("disabled");
    document.getElementById("email_" + email_name + "_header_target_url").removeAttribute("disabled");
    body = document.getElementById("email_" + email_name + "_body")
    if(body != null) {
      body.removeAttribute("disabled");
    }
    body = document.getElementById("email_" + email_name + "_body_pre")
    if(body != null) {
      body.removeAttribute("disabled");
    }
    body = document.getElementById("email_" + email_name + "_body_post")
    if(body != null) {
      body.removeAttribute("disabled");
    }
  } else {
    document.getElementById("email_" + email_name + "_layout_configurable").setAttribute("disabled", "disabled");
    document.getElementById("email_" + email_name + "_layout").setAttribute("disabled", "disabled");
    document.getElementById("email_" + email_name + "_subject").setAttribute("disabled", "disabled");
    document.getElementById("email_" + email_name + "_header_image_url").setAttribute("disabled", "disabled");
    document.getElementById("email_" + email_name + "_header_color_code").setAttribute("disabled", "disabled");
    document.getElementById("email_" + email_name + "_header_target_url").setAttribute("disabled", "disabled");
    body = document.getElementById("email_" + email_name + "_body")
    if(body != null) {
      body.setAttribute("disabled", "disabled");
    }
    body = document.getElementById("email_" + email_name + "_body_pre")
    if(body != null) {
      body.setAttribute("disabled", "disabled");
    }
    body = document.getElementById("email_" + email_name + "_body_post")
    if(body != null) {
      body.setAttribute("disabled", "disabled");
    }
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

