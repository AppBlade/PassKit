$(function() {
  // Set the negative margin on the top menu for slide-menu pages
  var $selector1 = $('#topMenu'),
    events = 'click.fndtn touchstart.fndtn';
  if ($selector1.length > 0) {
    $selector1.css("margin-top", ($selector1.height() + 20) * -1);
    $selector1.css("z-index", 3);
  }

  // Watch for clicks to show the menu for slide-menu pages
  var $selector3 = $('#menuButton');
  if ($selector3.length > 0)  {
    $('#menuButton').on(events, function(e) {
      e.preventDefault();
      $('body').toggleClass('active-menu');
    });
  }

  // Adjust sidebars and sizes when resized
  $(window).resize(function() {
    $('body').removeClass('active');
    var $selector4 = $('#topMenu');
    if ($selector4.length > 0) {
      $selector4.css("margin-top", ($selector1.height() + 20) * -1);
    }
  });

  // $('#nav li a').on(events, function(e) {
  //   e.preventDefault();
  //   var href = $(this).attr('href'),
  //     $target = $(href);
  //   $('html, body').animate({scrollTop : $target.offset().top}, 300);
  // });
});
