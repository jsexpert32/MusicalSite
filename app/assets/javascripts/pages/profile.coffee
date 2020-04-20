$ ->
  $('[data-attr]').on 'DOMSubtreeModified', (e) ->
    $("[name='user[#{$(@).data('attr')}]']").val($(@).text())

  $('#user_country').on 'change', (e) ->
    $('[data-select]').text($(@).val())
