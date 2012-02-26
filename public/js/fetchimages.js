(function() {

  $(document).ready(function() {
    var _this = this;
    $('.left .btn').click(function() {
      return $.ajax({
        url: "http://192.168.2.2:4567/search/" + ($('.left input')[0].value),
        async: true,
        crossDomain: true,
        success: function(results) {
          var element, picture, _i, _j, _len, _len2, _ref, _ref2, _results;
          _ref = JSON.parse(results);
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            picture = _ref[_i];
            $(".left #images").append("<img id='results' src='" + picture.thumb_url + "' data-url='" + picture.url + "'>");
          }
          _ref2 = $(".left #images img");
          _results = [];
          for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
            element = _ref2[_j];
            _results.push($(element).bind('click', function(event) {
              return $(event.target).toggleClass("selected");
            }));
          }
          return _results;
        }
      });
    });
    return $('.right .btn').click(function() {
      return $.ajax({
        url: "http://192.168.2.2:4567/search/" + ($('.right input')[0].value),
        async: true,
        crossDomain: true,
        success: function(results) {
          var picture, _i, _len, _ref, _results;
          _ref = JSON.parse(results);
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            picture = _ref[_i];
            _results.push($(".right #images").append("<img id='results' src='" + picture.thumb_url + "'>"));
          }
          return _results;
        }
      });
    });
  });

}).call(this);
