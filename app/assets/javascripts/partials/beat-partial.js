

// for critiques to send
function send_comment(id) {
  $('#err_'+id).html(''); // .hide()?
  $('#send_'+id).html('Sending');
  var data = $('#form_'+id).serialize();
  $.ajax({
    url: '/comments' ,
    method: 'POST',
    data: data,
    dataType: 'JSON',
    success: function(data) {
      critique_success(data,id);
    },
    error: function(data) {
      critique_error(data,id);
    }
  });
}


function critique_success(data, id) {
  $('#form_'+id).addClass('hide');
  $('#send_'+id).remove();
  $('#detail_'+id).removeClass('hide').prepend('Critique Sent!');
  return false;
}

function critique_error(data, id) {
  $('#send_'+id).html('Send');
  var error = JSON.parse(data.responseText).errors.body;
  $('#err_'+id).prepend(error);
  return false;
}
// for critiques to send
