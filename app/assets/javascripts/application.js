// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//


//= require_tree .
$(document).ready(function() {
  $( "#signinpop" ).click(function() {
    $('#myModal').modal('show');
  });

  $("#logout" ).click(function() {
    FB.logout(function(response) {
      $.cookie("login", "0");
      location.reload();
    });
  });

  $(".navbar-brand").hover(
    function() { 
      $("img.logo-ct").attr("src", '/images/CT-Logo-green.png');
      $(".navbar-brand").css("background-color","white");
    },
    function() {
      $("img.logo-ct").attr("src", '/images/CT-Logo-2heart.png');
      $(".navbar-brand").css("background-color", "#0EA474" );
    });
})

