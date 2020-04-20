$ ->
  $(document).on 'keyup', '[data-live]', (e) ->
    count = $(@).val().length
    $("[data-count='#{$(@).data('live')}']").text(count)
    if count >= 140 then $('[data-count]').addClass('beat-menu__counter--green') else $('[data-count]').removeClass('beat-menu__counter--green')
