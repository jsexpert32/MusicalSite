Paloma.controller 'Artists', track_list: ->
  $('#tab-two-1').attr 'checked', 'checked'

  $('#tracks_order').on 'change', ->
    $.ajax
      url: window.location.pathname
      type: 'GET'
      dataType: 'script'
      data: { order: $('#tracks_order option:selected').val(); }

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
