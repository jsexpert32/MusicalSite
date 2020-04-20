hideOptions = ->
  $('.subgenre-select option').show()
  $('.subgenre-select').each (index, select) ->
    if select.value
      $('.subgenre-select option[value=\'' + select.value + '\']').hide()

window.initSlider = ->
  $('[data-edit-share] [data-edit-slider]').slider
    min: 0
    max: 1
    animate: 'slow'
    create: (event, ui) ->
      value = event.target.parentElement.getAttribute('data-slider')
      event.target.firstChild.style.left = '100%' if value == '1'
    slide: (event, ui) ->
      return if $(ui.handle).hasClass('ui-state-hover')
      streamable = if ui.value > 0
        true
      else
        false
      id = event.target.parentElement.getAttribute('data-id')
      $.ajax
        url: "/tracks/#{id}"
        dataType: 'json'
        type: 'PUT'
        data: {track: {streamable: streamable}}

$(document).ready ->
  $('#genre-select').on 'change', ->
    $.ajax
      url: '/tracks/new'
      dataType: 'json'
      type: 'GET'
      data: genre_id: @value
      success: (data) ->
        $('.subgenre-select option').remove()
        $('.subgenre-select').append new Option('Choose Subgenre', '')
        if data
          data.forEach (item) ->
            option = new Option(item.name, item.id)
            $('.subgenre-select').append option


  $('.subgenre-select').on 'change', ->
    hideOptions()

  hideOptions()
  initSlider()

  $('#file_browse_wrapper').on 'click', ->
    $('input#track_audio_data').click()

  $('.form-track [data-edit-slider]').slider
    min: 0
    max: 1
    animate: 'slow'
    create: (event, ui) ->
      streamable = $('input[id=\'track_streamable\']').prop('checked')
      event.target.lastChild.style.left = '100%' if streamable
    slide: (event, ui) ->
      if ui.value > 0
        $('input[id=\'track_streamable\']').prop 'checked', true
      else
        $('input[id=\'track_streamable\']').prop 'checked', false


  $('[data-edit-slider]').on 'slidechange', (e, ui) ->
    if ui.value == 0
      $('[data-edit-left]').addClass 'chosen'
      $('[data-edit-right]').removeClass 'chosen'
    else
      $('[data-edit-left]').removeClass 'chosen'
      $('[data-edit-right]').addClass 'chosen'

  $('#upload-audio').on 'change', ->
    if this.value
      $('[data-upload-content]').hide()
      $('.beat-uploading-content').show()
      $('span.select#genre').hide()
      $('span.select#subgenres').hide()

  $('#close-form').on 'click', ->
    $('.beat-uploading-content').hide()
    $('#new_track')[0].reset()
    $('#image_upload_preview').removeAttr 'src'
    $('[data-upload-content]').show()

  $('#genre-select').on 'change', ->
    $('span.select#subgenres').show()

  $('.form-track').parsley({successClass: "has-success", errorClass: "has-error"})

  $('.description textarea, .description ul.parsley-errors-list').on 'click', ->
    $('.description li.parsley-required').hide()

  $('.form-track').on 'submit', ->
    moveBar()
