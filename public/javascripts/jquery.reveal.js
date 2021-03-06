/*
 * jQuery Reveal Plugin 1.0
 * www.ZURB.com
 * Copyright 2010, ZURB
 * Free to use under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 */

(function($) {

  $('a[data-reveal-id]').live('click', function(e) {
    e.preventDefault();
    var modalLocation = $(this).attr('data-reveal-id');
    $('#'+modalLocation).reveal($(this).data());
  });

  $.fn.reveal = function(options) {

    var defaults = {
      animation: 'fadeAndPop', //fade, fadeAndPop, none
      animationspeed: 300, //how fast animtions are
      closeonbackgroundclick: true, //if you click background will modal close?
      dismissmodalclass: 'close-reveal-modal' //the class of a button or element that will close an open modal
    };

    //Extend dem' options
    var options = $.extend({}, defaults, options);

    return this.each(function() {

      var modal = $(this),
          topMeasure  = parseInt(modal.css('top')),
          topOffset = modal.height() + topMeasure,
          locked = false,
          modalBG = $('.reveal-modal-bg');

      if(modalBG.length == 0) {
        modalBG = $('<div class="reveal-modal-bg" />').insertAfter(modal);
      }

      //Open Modal Immediately
      openModal();

      //Close Modal Listeners
      var closeButton = $('.' + options.dismissmodalclass).live('click.modalEvent',closeModal);
      modal.bind('reveal:close', closeModal);
      if(options.closeonbackgroundclick) {
        modalBG.css({"cursor":"pointer"})
        modalBG.bind('click.modalEvent',closeModal)
      }
      $('body').keyup(function(e) {
        if(e.which===27){ closeModal(); } // 27 is the keycode for the Escape key
      });

      //Entrance Animations
      function openModal() {
        modalBG.unbind('click.modalEvent');
        $('.' + options.dismissmodalclass).unbind('click.modalEvent');
        if(!locked) {
          lockModal();
          if(options.animation == "fadeAndPop") {
            modal.css({'top': $(document).scrollTop()-topOffset, 'opacity' : 0, 'visibility' : 'visible'});
            modalBG.fadeIn(options.animationspeed/2);
            modal.delay(options.animationspeed/2).animate({
              "top": $(document).scrollTop()+topMeasure,
              "opacity" : 1
            }, options.animationspeed,unlockModal());
          }
          if(options.animation == "fade") {
            modal.css({'opacity' : 0, 'visibility' : 'visible', 'top': $(document).scrollTop()+topMeasure});
            modalBG.fadeIn(options.animationspeed/2);
            modal.delay(options.animationspeed/2).animate({
              "opacity" : 1
            }, options.animationspeed,unlockModal());
          }
          if(options.animation == "none") {
            modal.css({'visibility' : 'visible', 'top':$(document).scrollTop()+topMeasure});
            modalBG.css({"display":"block"});
            unlockModal()
          }
        }
      }

      //Closing Animation
      function closeModal() {
        if(!locked) {
          lockModal();
          if(options.animation == "fadeAndPop") {
            modalBG.delay(options.animationspeed).fadeOut(options.animationspeed);
            modal.animate({
              "top":  $(document).scrollTop()-topOffset,
              "opacity" : 0
            }, options.animationspeed/2, function() {
              modal.css({'top':topMeasure, 'opacity' : 1, 'visibility' : 'hidden'});
              unlockModal();
            });
          }
          if(options.animation == "fade") {
            modalBG.delay(options.animationspeed).fadeOut(options.animationspeed);
            modal.animate({
              "opacity" : 0
            }, options.animationspeed, function() {
              modal.css({'opacity' : 1, 'visibility' : 'hidden', 'top' : topMeasure});
              unlockModal();
            });
          }
          if(options.animation == "none") {
            modal.css({'visibility' : 'hidden', 'top' : topMeasure});
            modalBG.css({'display' : 'none'});
          }
        }
      }

      function unlockModal() {
        locked = false;
      }
      function lockModal() {
        locked = true;
      }

    });//each call
  }//orbit plugin call
})(jQuery);
