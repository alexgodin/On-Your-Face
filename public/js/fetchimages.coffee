$(document).ready ->
  $('.left .btn').click =>
    $.ajax({ url :"/search/#{$('.left input')[0].value}", async : true, crossDomain : true, success : (results) =>
      for picture in JSON.parse(results)
        $(".left #images").append("<img id='results' src='#{picture.thumb_url}' data-url='#{picture.url}' data-id='#{picture.image_id}'>")
      for element in $(".left #images img")
        $(element).bind 'click', (event) =>
          $(event.target).toggleClass("selected")
    })
  $('.right .btn').click =>
    $.ajax({ url :"/search/#{$('.right input')[0].value}", async : true, crossDomain : true, success : (results) =>
      for picture in JSON.parse(results)
        $(".right #images").append("<img id='results' src='#{picture.thumb_url}' data-url='#{picture.url}' data-id='#{picture.image_id}'>")
      for element in $(".right #images img")
        $(element).bind 'click', (event) =>
          $(event.target).toggleClass("selected")
    })
  $('.btn-danger').click =>
    $('#myModal').modal()
    messages = ["Please wait... 640K ought to be enough for anybody", "Please wait... the architects are still drafting", "Please wait... the bits are breeding", "Please wait... we're building the buildings as fast as we can", "Please wait... would you prefer chicken, steak, or tofu?", "Please wait... pay no attention to the man behind the curtain", "Please wait... and enjoy the elevator music", "Please wait... while the little elves draw your map", "Please wait... a few bits tried to escape, but we caught them", "Please wait... and dream of faster computers", "Please wait... would you like fries with that?", "Please wait... checking the gravitational constant in your locale", "Please wait... go ahead -- hold your breath", "Please wait... at least you're not on hold", "Please wait... hum something loud while others stare", "Please wait... you're not in Kansas any more", "Please wait... the server is powered by a lemon and two electrodes", "Please wait... we love you just the way you are", "Please wait... while a larger software vendor in Seattle takes over the world", "Please wait... we're testing your patience", "Please wait... as if you had any other choice", "Please wait... take a moment to sign up for our lovely prizes", "Please wait... don't think of purple hippos", "Please wait... follow the white rabbit", "Please wait... why don't you order a sandwich?", "Please wait... while the satellite moves into position", "Please wait... the bits are flowing slowly today", "Please wait... dig on the 'X' for buried treasure... ARRR!", "Please wait... it's still faster than you could draw it", "Locating the required gigapixels to render...", "Spinning up the hamster...", "Shovelling coal into the server...", "Please wait... 640K ought to be enough for anybody", "Please wait... the architects are still drafting", "Please wait... the bits are breeding", "Please wait... we're building the buildings as fast as we can", "Please wait... would you prefer chicken, steak, or tofu?", "Please wait... pay no attention to the man behind the curtain", "Please wait... and enjoy the elevator music", "Please wait... while the little elves draw your map", "Please wait... a few bits tried to escape, but we caught them", "Please wait... and dream of faster computers", "Please wait... would you like fries with that?", "Please wait... checking the gravitational constant in your locale", "Please wait... go ahead -- hold your breath", "Please wait... at least you're not on hold", "Please wait... hum something loud while others stare", "Please wait... you're not in Kansas any more", "Please wait... the server is powered by a lemon and two electrodes", "Please wait... we love you just the way you are", "Please wait... while a larger software vendor in Seattle takes over the world", "Please wait... we're testing your patience", "Please wait... as if you had any other choice", "Please wait... take a moment to sign up for our lovely prizes", "Please wait... don't think of purple hippos", "Please wait... follow the white rabbit", "Please wait... why don't you order a sandwich?", "Please wait... while the satellite moves into position", "Please wait... the bits are flowing slowly today", "Please wait... dig on the 'X' for buried treasure... ARRR!", "Please wait... it's still faster than you could draw it", "Locating the required gigapixels to render...", "Spinning up the hamster...", "Shovelling coal into the server..."]
    displayMessage = (index=0) ->
      if msg = messages[index]
        $('#myModal #garbagetext').html("<h2><em>#{msg}</em></h2>")
      if messages[index+1]?
        deferredMessage = -> displayMessage(index+1)
        setTimeout(deferredMessage, 2000)
    displayMessage(0)
    $.ajax({ url :"/foo/#{$('.right .selected').data('id')}", async : true, crossDomain : true, success : (results) =>
      @bodyPhotoId = JSON.parse(results)['photo_id']
      $.ajax({ url :"/foo/#{$('.left .selected').data('id')}", async : true, crossDomain : true, success : (results) =>
        @facePhotoId = JSON.parse(results)['photo_id']
        $.ajax({ url :"/bar/#{@bodyPhotoId}/#{@facePhotoId}", async : true, crossDomain : true, success : (results) =>
          urls = JSON.parse(results)['urls']
          $('#garbagetext').hide()
          for url,i in urls
            if i != 0
              $('#myModal #resultimage').append("<img src='#{url}' class'notfirst'>")
            else
              $('#myModal #resultimage').append("<img src='#{url}'>")

          setInterval( () ->
            for image,index in $("#resultimage img")
              if $(image).is(":visible")
                $(image).toggle()
                if index != 4
                  $($("#resultimage img")[index+1]).toggle()
                else
                  $($("#resultimage img")[0]).toggle()
                return false
            return arguments.callee
          , 300)
        })
      })
    })
