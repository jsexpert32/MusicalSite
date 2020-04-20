Paloma.controller 'Charts', index: ->
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
  $('.scroll-right').scroll ->
    nextPage = $('nav.pagination a[rel=next]')[0]
    if nextPage && $('.scroll-right').scrollTop() > $('#shared_results').height() - $('.scroll-right').height() + 50
      nextPage.click()
      $('.pagination').text("Fetching more tracks...")
  $('.scroll-right').scroll()

  $('select#charted-order-by').on 'change', ->
    url = $(".beats-menu li.current a").attr('href')
    $.ajax
      url: url
      method: 'GET'
      dataType: 'script'
      data: {direction: this.value}
