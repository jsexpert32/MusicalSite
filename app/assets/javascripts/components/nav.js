$(document).on('click', '.button.email', function() {
  $('.form-create-account').removeClass( 'hide' );
  $('div.logins').addClass( 'hide' );
});

$(document).on('click', 'a.tw-next', function() {
  currentForm = $(this).parent('.profile-form');
  nextForm = currentForm.next('.profile-form');
  currentForm.addClass( 'hide' );
  nextForm.removeClass( 'hide' );
});

$(document).on('click', '#sign-up-form a.next-form', function() {
  $('.form-user.show input').each(function( index ) {
    $(this).parsley().validate();
  });
  errors = $('.form-user.show .parsley-errors-list li');
  if(!errors.length) {
    currentForm = $(this).parent('.form-user');
    nextForm = currentForm.next('.form-user');
    currentForm.addClass( 'hide' ).removeClass( 'show' );
    nextForm.removeClass( 'hide' ).addClass( 'show' );
    $('#sign-up-form').parsley().reset();
  }
});

$(document).on('click', '#sign-up-form .next-form', function() {
  $('.form-user.show span.error').remove();
});

