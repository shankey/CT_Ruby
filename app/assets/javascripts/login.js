// This is called with the results from from FB.getLoginStatus().
function statusChangeCallback(response) {
  // The response object is returned with a status field that lets the
  // app know the current login status of the person.
  // Full docs on the response object can be found in the documentation
  // for FB.getLoginStatus().
  if (response.status === 'connected') {
    // Logged into your app and Facebook.
    // Make an XHR to the backend to store that the user has logged in.
    handleLoginSuccess(response);
    // Make this cookie live for 1 year.
    // Ideally we should make a login client API and use that
    // in client everywhere.
    $.cookie("login", "1", {expires: 365, path: '/' });
  } else if (response.status === 'not_authorized') {
    // The person is logged into Facebook, but not your app.
  } else {
    // The person is not logged into Facebook, so we're not sure if
    // they are logged into this app or not.
  }
}

// This function is called when someone finishes with the Login
// Button.  See the onlogin handler attached to it in the sample
// code below.
function checkLoginState() {
  FB.getLoginStatus(function(response) {
    statusChangeCallback(response);
  });
};

function handleLoginSuccess() {
  FB.api('/me?fields=id,name,picture,email', function(response) {
    $('#myModal').modal('hide');
    $("#signouttext").text(response.name.split(" ")[0]);
    $("#signinli").hide();
    $(".dropdown").show();
    $("#profileimage").attr('src', response.picture.data.url);
    $("#profileimage").show();
    $.ajax({
      type: "POST",
      url: "/login_request",
      data: {
        user: {
          external_id: response.id,
          access_token: FB.getAccessToken(),
          email: response.email,
          name: response.name,
          profile_pictures: response.picture.data.url
        }
      }
    }).done(function(data){
      // Anything that needs to be done?
    });
  });
};

// This should be merged with application.js by making login.js a library.
$(function() {
  $( "#signin" ).click(function() {
    FB.login(function(response){
      checkLoginState();
    });
  });
});

window.fbAsyncInit = function() {
  // Add an app id to support the URL corresponding to your test app.
  var appIdMap = {
    'localhost:3000': '532369196931759',
    'testwsrubyct-stauntonknight.c9users.io': '1145563762138091',
    'coupletrips.in': '1138815052812962'
  };
  // Default to the PROD app.
  var appId = '1138815052812962';
  for (var i in appIdMap) {
    if (window.location.href.indexOf(i) != -1) {
      appId = appIdMap[i];
      break;
    }
  }
  FB.init({
    appId      : appId,
    cookie     : true,  // enable cookies to allow the server to access 
                        // the session
    xfbml      : true,  // parse social plugins on this page
    version    : 'v2.5' // use version 2.2
  });

  // Now that we've initialized the JavaScript SDK, we call 
  // FB.getLoginStatus().  This function gets the state of the
  // person visiting this page and can return one of three states to
  // the callback you provide.  They can be:
  //
  // 1. Logged into your app ('connected')
  // 2. Logged into Facebook, but not your app ('not_authorized')
  // 3. Not logged into Facebook and can't tell if they are logged into
  //    your app or not.
  //
  // These three cases are handled in the callback function.

  FB.getLoginStatus(function(response) {
    statusChangeCallback(response);
  });

};

// Load the SDK asynchronously
(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
