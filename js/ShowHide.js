/*
 * ShowHide.js
 *
 * Jonathan Callahan
 * http://mazamascience.com
 *
 * Unobtrusive toggling of elements in a web page inpired by  http://onlinetools.org/tools/domcollapse/
 *
 */

// Event handler to toggle the visibility of the DOM element immediately following  a 'trigger'.
function toggleTarget(event) {
  // NOTE:  Within an event handler, 'this' always refers to the element they are registered on.
  $(this).next().toggle();
  if ( $(this).next().is(':visible') ) {
    $(this).addClass('expanded');
    $(this).children('img').replaceWith('<img src="./style/images/minus.gif" alt="hide section" class="showhide" />');
  } else {
    $(this).removeClass('expanded');
    $(this).children('img').replaceWith('<img src="./style/images/plus.gif" alt="show section" class="showhide" />');
  }
}

// Bind event handlers immediately after the DOM is loaded.
$(function() {
  $('.trigger').each( function() {
    $(this).prepend('<img src="./style/images/plus.gif" alt="show section" class="showhide" />');
    $(this).next().hide();
    $(this).bind('click',toggleTarget);
  });
  $('.expanded').each( function() {
    $(this).prepend('<img src="./style/images/minus.gif" alt="hide section" class="showhide" />');
    $(this).addClass('trigger');
    $(this).bind('click',toggleTarget);
  });
});
