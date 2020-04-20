//= require Countable

var CharacterCount = function () {};


CharacterCount.prototype.countCharacters  = function ( textElement ) {

  var context = this;

  $(textElement).bind( 'input propertychange', function( e ) {
    Countable.live( textElement, context.updateCount );
  });
};


CharacterCount.prototype.updateCount  = function ( counter ) {

  var target = this.parentNode.parentNode.querySelector( '.beat-menu__counter' );
  var $count = $( target );

  $count.html( counter.characters );

  if ( counter.characters  < 140 ) {
    $count.addClass( 'error' );
    $count.removeClass( 'success' );
  } else {
    $count.removeClass( 'error' );
    $count.addClass( 'success' );
  }
};


CharacterCount.prototype.attachEvents = function ( parentSelector, textSelector, targetSelector ) {

  var elements    = document.querySelectorAll( parentSelector );

  for ( var i = 0; i < elements.length; i++ ) {
    var el        = elements[i];
    var text      = el.querySelector( textSelector );
    this.target   = el.querySelector( targetSelector );

    var counter   = new CharacterCount( text, this.target );

    counter.countCharacters( text );
  }

};
