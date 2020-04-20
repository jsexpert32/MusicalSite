$ ->
  $(document).on 'click', '.filter-in', (e)->
    e.stopImmediatePropagation()
    filter("&filters[sorted_by]=#{$('select#filters_sorted_by option:selected').val()}")

  $(document).on 'change', 'select#filters_sorted_by', (e)->
    e.stopImmediatePropagation()
    filter("&filters[sorted_by]=#{$(this, 'option:selected').val()}")

  filter = (moreParams)->
    $.ajax
      url: '/beats'
      method: 'GET'
      data: $('.beats-filter').serialize()+moreParams
      dataType: 'script'
      beforeSend: ->
        $("#spinner").removeClass('hide').show()
        $('[data-beat-main-right]').addClass('loading-state')

      success: ->
        $("#spinner").addClass('hide')
        $('[data-beat-main-right]').removeClass('loading-state')

      error: ->
        console.log('error')
        $("#spinner").addClass('hide')
        $('[data-beat-main-right]').removeClass('loading-state')

      # unchecks every other filter if 'all-beats' is checked
  $('#all-beats').on 'click', ->
    $('.not-all-beats').prop('checked', false)

    # unchecks 'all-beats' if any other filter is checked
  $('.not-all-beats').on 'click', ->
    $('#all-beats').prop('checked', false)

    # checks 'all-beats' filter if no other filters are checked (return to default)
  $(document).on 'change', ->
    count = 0
    $.each $('.not-all-beats'), (index, value) ->
      if this.checked is false
        count += 1
        if count is $('.not-all-beats').length
          $('#all-beats').prop('checked', true)

  $('[data-beat-main-right]').on 'scroll', ->
    at_last = false
    at_last = true if $(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight
    if at_last && ($('div.beats').attr('fetching') == '0' || $('div.beats').attr('fetching') == undefined)
      $('div.beats').append('<div class="columns is-gapless pagination-spinner"><span>Loading...</span></div>')
      $('body').animate({ scrollTop: $(document).height() }, 1000);
      $('div.beats').attr('fetching', 1)
      wait_and_run ->
        offset = $.trim($('div.offset').text())
        filterParams = $('div.filter-params').text()
        $.ajax
          url: window.location.href
          dataType: 'text'
          data: {offset: offset, filterParams: filterParams}
          method: 'GET'
          beforeSend: ->
            # TODO
          success: (data)->
            if data == 'norecord'
              $("div.pagination-spinner").remove()
              $('div.beats').append('<div class="empty-block-beat"></div>')
            else
              $('div.beats').attr('fetching', 0)
            try
              eval(data)
            catch e
              console.log e
      , 1000

Paloma.controller 'Beats', index: ->
  waveform_proc = ->
    $.each $(document).find('div#beat[data-done="false"]'), (i, k) ->
      try
        self = this
        setTimeout (->
          waveform_proc
          if $(self).is(':visible')
            $(self).attr 'data-done', true
            waveform_proc = $(self).find('div#waveform-proc')
            window.BEAT.waveforms[waveform_proc.data('id')] = new (window.Waveform)('#' + waveform_proc.data('id'), waveform_proc.data('url'), waveform_proc.data('waveform'))
          return
        ), i * 500
      catch e
        console.log e
      return
    return

  wait_and_run(waveform_proc(), 500)

  $ ->
    wait_and_run height_change_beat_main(), 500
    return
  $(window).resize ->
    wait_and_run height_change_beat_main(), 200
    return

  height_change_beat_main = ->
    top_header_nav

    left  = $(document).find('[data-beat-main-left]')
    right = $(document).find('[data-beat-main-right]')
    chartsBeats = $(document).find('#chartsBeats')
    if left.length > 0 and right.length > 0
      top_header_nav = $('.navbar').height()
      bottom_play_bar = $('[data-player]').height()
      $(document).find('html').css 'overflow', 'hidden'
      left.css 'height', $(window).height() - (top_header_nav + bottom_play_bar) + 'px'
      right.css 'height', $(window).height() - (top_header_nav + bottom_play_bar) + 'px'
    else if chartsBeats.length > 0
      top_header_nav = $('.navbar').height() * 2
      $(document).find('html').css 'overflow', 'hidden'
      chartsBeats.css 'height', $(window).height() - top_header_nav + 'px'
    return

    #endless pagination
  $('.beat-col-right').scroll ->
    nextPage = $('nav.pagination a[rel=next]')[0]
    if nextPage && $('.beat-col-right').scrollTop() > $('.all-beats-section').height() - $('.beat-col-right').height() - 50
      nextPage.click()
      $('.pagination').text("Fetching more tracks...")
  $('.beat-col-right').scroll()
