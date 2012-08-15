(function($) {
  $.fn.zoom = function(opt) {
    var width = opt.width, height = opt.height, node = $(this);
    if (width || height) {
    $(window).bind('resize', function() {
      var vertical, horizontal, zoom;

      if (width) {
      vertical = $(window).width() / width * 100;
      }
      if (height) {
      horizontal = $(window).height() / height * 100;
      }
      if (width && height) {
      zoom = Math.min(vertical, horizontal);
      } else {
      zoom = width ? vertical : horizontal;
      }

      node.css('zoom', Math.round(zoom) + '%');
      }).resize();
    }
    return this;
  };
}(jQuery));
