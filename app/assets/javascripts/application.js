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
    $('.ct-custom-login-form').hide();
    $('.ct-signup').hide();
    $('.ct-login').show();
    clearLoginNotices();
  });
  $('#signinfb').click(function() {
    FB.login(function() {
      checkLoginState();
    });
  });

  function destroySession(callback) {
    $.ajax({
      type: 'DELETE',
      url: '/logout',
      success: callback
    });
  }

  $("#logout").click(function() {
    if ($.cookie('custom') == "1") {
      // In case of custom login, we don't need to do FB logout.
      destroySession(loadHomePage);
    } else {
      // Do FB logout and then clear the rest cookies.
      FB.logout(function() {
        destroySession(loadHomePage);
      });
    }
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

  // Modal dialog handling and LOGIN JS Begins
  $('.custom-signup-button').click(function() {
    showCustomSignup();
  });
  $('.custom-login-button').click(function() {
    showCustomLogin();
  });

  function showCustomLogin() {
    $('.ct-login').hide();
    $('.ct-signup').hide();
    $('.ct-custom-login-form').show();
  }

  function showCustomSignup() {
    $('.ct-login').hide();
    $('.ct-signup').show();
    $('.ct-custom-login-form').hide();
  }

  function showLoginNotice(isError) {
    clearLoginNotices();
    if (isError) {
      $('.login-notices > .alert-danger').show();
      $('.login-notices > .alert-danger').text('Login Failed');
    } else {
      $('.login-notices > .alert-success').show();
      $('.login-notices > .alert-success').text('Login Success! Reloading...');
      setTimeout(function() {
        location.reload();
      }, 2000);
    }
  }

  function showSignupNotice(isError) {
    clearLoginNotices();
    if (isError) {
      $('.login-notices > .alert-danger').show();
      $('.login-notices > .alert-danger').text('Signup failed');
    } else {
      $('.login-notices > .alert-success').show();
      $('.login-notices > .alert-success').text('Signup success! Please login!');
    }
  }

  function clearLoginNotices() {
    $('.login-notices > .alert-success').hide();
    $('.login-notices > .alert-danger').hide();
  }

  $('.ct-signup').submit(function(e) {
    e.preventDefault();
    var email = $('#signup-inputEmail').val();
    var password = $('#signup-inputPassword').val();
    var name = $('#signup-inputName').val();
    $.ajax({
      'type': 'POST',
      'url': '/signup',
      'data': {
        'user': {
          'name': name,
          'email': email,
          'password': password
        }
      },
      'success': function() {
        showSignupNotice();
        showCustomLogin();
      },
      'error': function() {
        showSignupNotice(true /* isError */); 
      }
    });
  });
  $('.ct-custom-login-form').submit(function(e) {
    e.preventDefault();
    var email = $('#login-inputEmail').val();
    var password = $('#login-inputPassword').val();
    $.ajax({
      'type': 'POST',
      'url': '/login',
      'data': {
        'session': {
          'email': email,
          'password': password
        }
      },
      'success': function() {
        showLoginNotice(); 
      },
      'error': function() {
        showLoginNotice(true /* isError */); 
      }
    });
  });
  // LOGIN JS END.
});
