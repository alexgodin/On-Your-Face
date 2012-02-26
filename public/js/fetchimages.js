(function() {

  $(document).ready(function() {
    var _this = this;
    $('.left .btn').click(function() {
      return $.ajax({
        url: "/search/" + ($('.left input')[0].value),
        async: true,
        crossDomain: true,
        success: function(results) {
          var element, picture, _i, _j, _len, _len2, _ref, _ref2, _results;
          _ref = JSON.parse(results);
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            picture = _ref[_i];
            $(".left #images").append("<img id='results' src='" + picture.thumb_url + "' data-url='" + picture.url + "' data-id='" + picture.image_id + "'>");
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
    $('.right .btn').click(function() {
      return $.ajax({
        url: "/search/" + ($('.right input')[0].value),
        async: true,
        crossDomain: true,
        success: function(results) {
          var element, picture, _i, _j, _len, _len2, _ref, _ref2, _results;
          _ref = JSON.parse(results);
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            picture = _ref[_i];
            $(".right #images").append("<img id='results' src='" + picture.thumb_url + "' data-url='" + picture.url + "' data-id='" + picture.image_id + "'>");
          }
          _ref2 = $(".right #images img");
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
    return $('.btn-danger').click(function() {
      return $.ajax({
        url: "/foo/" + ($('.right .selected').data('id')),
        async: true,
        crossDomain: true,
        success: function(results) {
          _this.bodyPhotoId = JSON.parse(results)['photo_id'];
          return $.ajax({
            url: "/foo/" + ($('.left .selected').data('id')),
            async: true,
            crossDomain: true,
            success: function(results) {
              _this.facePhotoId = JSON.parse(results)['photo_id'];
              return $.ajax({
                url: "/bar/" + _this.bodyPhotoId + "/" + _this.facePhotoId,
                async: true,
                crossDomain: true,
                success: function(results) {
                  var url;
                  url = JSON.parse(results)['url'];
                  return console.log(url);
                }
              });
            }
          });
        }
      });
    });
  });

}).call(this);
