$(document).ready(function() {

    $('.select-code').click(function(){
      $("#user_code").val($(this).text());
      return false;
    });

    $("input[data-stub]").
      focus(function() { if ($(this).val() == $(this).attr('data-stub')){ $(this).val('');} }).
      blur(function(){ if ($(this).val() == '') { $(this).val($(this).attr('data-stub'));}  });


    $('.jquery-button').each(function() {

        var button_width = $(this).width();
        button_width = button_width - 50;
        $(this).wrapInner('<span class="button_text" />');
        $(this).children('span').css('width', button_width + "px");

        var new_el = $(this).children('span').clone();
        $(this).prepend('<span class="button_left"></span>');
        $(this).append('<span class="button_right"></span>');
        button_width = button_width + 25;
        $(this).children('span.button_right').css('left', button_width + "px");

        if ($.browser.safari && !/Chrome/.test(navigator.appVersion)) {
          button_width += 3;
          $(this).children('span.button_right').css('left', button_width + "px");
          $(this).children('span.button_right').css('top', "1px");
        }

      });

    $("#signup-button").click(function(){
        document.location = "/register/sign_up";        
      }
    );
  });
