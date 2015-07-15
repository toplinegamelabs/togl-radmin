// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs

// gonna disable this 
// require_tree .




  function update_client_app() {
    $.ajax({
      url: '/client_apps',
      type: 'PUT',
      data: "client_app=" + $("#client_app").val(),
      success: function(data) {
        location.reload();
      }
    });
  }

  function update_ui_for_client_app() {
    if($("#client_app").val() == "dailymvp") {
      $("#heading").css("background-color","#00CCFF");
    } else if($("#client_app").val() == "fannation") {
      $("#heading").css("background-color","#FFCCCC");
    } else {
      $("#heading").css("background-color","#FFFFFF");
    }
  }