$.fn.serializeObject = function() {
  var values = {}
  $("form input, form select, form textarea").each( function(){
        values[this.name] = $(this).val();
        });
  
  return values;
}  

var goto_simple_form = function() {
  hide_errors();
  $('#social-signup').hide();
  $('#simple-signup').show();
  $('#success-signup').hide();
  $('#no-activation-signup').hide();
}
var show_simple_form = function(){
  goto_simple_form();
  $.ajax({
    type: "POST",
    url: "omniauth_callbacks/clear_omniauth",
    success: function(){
      alert("kar ditta pai jan");
      }
    });

}
var show_social_form= function() {
  hide_errors();
  $('#simple-signup').hide();
  $('#social-signup').show();
}

var show_confirm_div= function() {
  hide_errors();
  $('#simple-signup').hide();
  $('#social-signup').hide();
  $('#no-activation-signup').show();
}

var show_success_div = function() {
  hide_errors();
  $('#simple-signup').hide();
  $('#social-signup').hide();
  $('#success-signup').show();
}

var hide_errors = function() {
    $('.er_span').remove();
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
  $('#s_user_e').val(data['email']);
  $('.social_name').html(data['name']);
  $('.social_image').attr("src",data["image"]);
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
      $('.loader').show();
      registration(this);
  });

  $('#social-register-btn').click(function () {
      $('#social-signup .loader').show();
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

var registration = function(ele){
  form = $(ele).parents(".theform");
  url = form.attr("action");
  $.ajax({
    type: "POST",
    url: url,
    data: form.serialize(),
    dataType: "json",
    error:signup_error,
    complete: function(){
      $(".loader").hide();
    },
    failure: function(data){
      },
    success: signup_success
    });

}
  var show_form_errors = function(er, type){
    var a = 10;
    var b = 20;
    var c = $(this).reg
    
    $('.er_span').remove();
    $.each(er, function(k, v){
        el_name = "user["+k+"]";
        console.log(el_name);
        $('#'+type+' input[name*="'+el_name+'"]').after('<span class="er_span" style=\'display:block;color:red;\'>'+k+' '+v+'</span>');
       }); 
  }
  var signup_error = function(response){
    var er = JSON.parse(response.responseText);
    show_form_errors(er, 'simple-signup');
  }
  var signup_success = function(response){
    if(response.errors){
      show_form_errors(response.errors, 'social-signup'); 
      return false;
    }
    if(response.user) {
      tb_remove();
      $("#user_e").val("");
      $("#user_n").val("");
      $("#user_p").val("");
      show_success_div();
    }
  }
