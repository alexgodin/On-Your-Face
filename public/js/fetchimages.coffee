$(document).ready ->
  $('.left .btn').click =>
    $.ajax({ url :"http://192.168.2.2:4567/search/#{$('.left input')[0].value}", async : true, crossDomain : true, success : (results) =>
      for picture in JSON.parse(results)
        $(".left #images").append("<img id='results' src='#{picture.thumb_url}' data-url='#{picture.url}'>")
      for element in $(".left #images img")
        $(element).bind 'click', (event) =>
          $(event.target).toggleClass("selected")
    })
  $('.right .btn').click =>
    $.ajax({ url :"http://192.168.2.2:4567/search/#{$('.right input')[0].value}", async : true, crossDomain : true, success : (results) =>
      for picture in JSON.parse(results)
        $(".right #images").append("<img id='results' src='#{picture.thumb_url}'>")
    })

