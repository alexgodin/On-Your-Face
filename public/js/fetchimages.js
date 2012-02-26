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
      var displayMessage, messages;
      $('#myModal').modal();
      messages = ["Please wait... 640K ought to be enough for anybody", "Please wait... the architects are still drafting", "Please wait... the bits are breeding", "Please wait... we're building the buildings as fast as we can", "Please wait... would you prefer chicken, steak, or tofu?", "Please wait... pay no attention to the man behind the curtain", "Please wait... and enjoy the elevator music", "Please wait... while the little elves draw your map", "Please wait... a few bits tried to escape, but we caught them", "Please wait... and dream of faster computers", "Please wait... would you like fries with that?", "Please wait... checking the gravitational constant in your locale", "Please wait... go ahead -- hold your breath", "Please wait... at least you're not on hold", "Please wait... hum something loud while others stare", "Please wait... you're not in Kansas any more", "Please wait... the server is powered by a lemon and two electrodes", "Please wait... we love you just the way you are", "Please wait... while a larger software vendor in Seattle takes over the world", "Please wait... we're testing your patience", "Please wait... as if you had any other choice", "Please wait... take a moment to sign up for our lovely prizes", "Please wait... don't think of purple hippos", "Please wait... follow the white rabbit", "Please wait... why don't you order a sandwich?", "Please wait... while the satellite moves into position", "Please wait... the bits are flowing slowly today", "Please wait... dig on the 'X' for buried treasure... ARRR!", "Please wait... it's still faster than you could draw it", "Locating the required gigapixels to render...", "Spinning up the hamster...", "Shovelling coal into the server..."];
      displayMessage = function(index) {
        var deferredMessage, msg;
        if (index == null) index = 0;
        if (msg = messages[index]) {
          $('#myModal #garbagetext').html("<h2><em>" + msg + "</em></h2>");
        }
        if (messages[index + 1] != null) {
          deferredMessage = function() {
            return displayMessage(index + 1);
          };
          return setTimeout(deferredMessage, 2000);
        }
      };
      displayMessage(0);
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
                  $('#garbagetext').hide();
                  return $('#myModal #resultimage').html("<img src='" + url + "'>");
                }
              });
            }
          });
        }
      });
    });
  });

}).call(this);
