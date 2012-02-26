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
    $.ajax({ url :"/foo/#{$('.right .selected').data('id')}", async : true, crossDomain : true, success : (results) =>
      @bodyPhotoId = JSON.parse(results)['photo_id']
      $.ajax({ url :"/foo/#{$('.left .selected').data('id')}", async : true, crossDomain : true, success : (results) =>
        @facePhotoId = JSON.parse(results)['photo_id']
        $.ajax({ url :"/bar/#{@bodyPhotoId}/#{@facePhotoId}", async : true, crossDomain : true, success : (results) =>
          url = JSON.parse(results)['url']
          console.log(url)
        })
      })
    })
