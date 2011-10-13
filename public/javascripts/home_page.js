$.fn.serializeObject = function() {
  var values = {}
  $("form input, form select, form textarea").each( function(){
        values[this.name] = $(this).val();
        });
  
  return values;
}  
var form_type = function(param) {
  $('#dd').val(param);
}
var oauth_data = function(type) {
  $.ajax({
    type: "GET",
    url: "omniauth_callbacks/oauth_data",
    data: 'type='+type,
    success: function(data){
      populate_form(data);
      }
    });
}
var populate_form = function(data){
  $('#user_e').val(data['email']);
  $('#user_n').val(data['name']);
}
var title = "Success!";
var icon = "success";

$(document).ready(function() {

  $('#confirm_submit').click(function () {
    $('#user_confirmation_token').val($('#confirmation_token').val());
    $.ajax({
      type: "PUT",
      url: "/confirm_user",
      data: $("#aaa").serialize(), 
      success: function(data){
          var response = data;
          if(response.result == "success") {
            var text = response.message;
            $("#notif_container").notify("create", {
                title: title,
                text: text,
                icon: icon
               },
               {
                click: function(e,instance){
                instance.close();
               }
             });
            window.location.href = "/user_home";
          }
          else {
            $("#error-confirm").html("");
            var errors = $("#error-confirm");
            errors.append("<h2>"+response.message+"</h2><ul>");
            $.each(response.error, function(key, value) { 
              errors.append("<li>"+value+"</li>");
            });
            errors.append("</ul>");
            $("#TB_title").hide();
          }
        }
      });
    });

  
  $('#register-btn').click(function () {
      registration(this);
  });

  $('#register-btn1').click(function () {
      registration(this);
  });
});

function signIn(){
  var email = $('#signin-e').val();
  var password = $('#signin-n').val();
  var data = {remote: true, commit: "Sign in", utf8: "✓",
            user: {password: password, email: email}};

  $.ajax({
    type: "POST",
    url: "/users/sign_in.json",
    data: data,
    error: function(xhr,ajaxOptions,thrownError){
        $("#error-explanation").html("");
        var errors = $("#error-explanation");
        errors.append("<h2>There were errors while submitting the form:</h2><ul>");
        var er = JSON.parse(xhr.responseText);
        if(er.error)
        {
          errors.append("<li>Email: " + er.error + "</li>");
        }
        errors.append("</ul>");
    },
    success: function(data){
        var response = data;
        if(response.user.id) {
          window.location.href = "/user_home";
        }
        else {
          $("#error-explanation").html("There was some error while signing you in!");
//          var errors = $("#error-explanation");
//          errors.append("<h2>"+response.message+"</h2><ul>");
//          $.each(response.error, function(key, value) { 
//            errors.append("<li>"+value+"</li>");
//          });
//          errors.append("</ul>");
        }
      }
    });
}
function social_connect(id) {
  $('#oauth_provider_'+id).attr('checked','checked');
  $('#oauth_form').submit();
}
var registration = function(ele){
  if($('#dd').val() == "update_user")
  {
    var ty = "/users/update_user_for_password";
  }
  else
  {
    var ty = "/users";
  }
  $.ajax({
    type: "POST",
    url: ty,
    data: $(ele).parent().serialize(),
    dataType: "json",
    error:signup_error,
    failure: function(data){
      },
    success: signup_success
    });

}
  var signup_error = function(response){
    var er = JSON.parse(response.responseText);
    title = "Error";
    text = "There are errors with the following fields:\n\n<ul>";
    if(er.email)
      text = text + "<li>Email: "  + er.email + "</li>";
    if(er.name)
      text = text + "<li>Name: "  + er.name + "</li>";
    if(er.password)
      text = text + "<li>Password: "  + er.password + "</li></ul>";
    icon = "error";
      $("#notif_container").notify("create", {
          title: title,
          text: text,
          icon: icon
         },
         {
          click: function(e,instance){
          instance.close();
         }
       });
//    $("#signup-btn").trigger('click');
//    $("#get-share-code").width("320px");
//    $("#get-share-code label").width("80px");
//    $("#error-signup").html("");
//    var errors = $("#error-signup");
//    errors.append("<h2>There were errors while submitting the form:</h2><ul>");
//    var er = JSON.parse(response.responseText);
//  if(er.email)
//  {
//    errors.append("<li>Email: " + er.email  + "</li>");
//  }
//  if(er.name)
//  {
//    errors.append("<li>Name: " + er.name  + "</li>");
//  }
//  errors.append("</ul>");
//  $("#TB_title").hide();
//  if($("#user_email").val().length==0)
//      $("#user_email").val($("#user_e").val());
//  if($("#user_name").val().length==0)
//      $("#user_name").val($("#user_n").val());
  }
  var signup_success = function(response){
    if(response.user) {
      tb_remove();
      $("#user_e").val("");
      $("#user_n").val("");
      $("#user_p").val("");
      var text = "Congratulations! The way you communicate just got upgraded.<br /> A simple 4 digit ShareMe is all you will ever need, check your email now.";
      $("#notif_container").notify("create", {
          title: title,
          text: text,
          icon: icon
         },
         {
          click: function(e,instance){
          instance.close();
         }
       });
    }
  }
