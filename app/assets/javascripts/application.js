//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery_ufujs
//= require jquery.atwho
//= require application_vendor
//= require paloma
//= require lazybox
//= require parsley
//= require parsley.remote
//= require clipboard
//= require_tree ./pages
//= require_tree ./components
//= require messenger
//= require logs
//= require image_preview
//= require welcome
//= require charts
//= require mobile-slider
//= require_tree ./partials
//= require progress-bar
//= require tracks
//= require uikit


function send_critique_comment(id) {
  var form_data = $('#form_show_'+id).serialize();
  src = '/assets/arrow.gif';
  $('#send_comment').html('<img src=' + src + '>');
  $.ajax({
    url: '/comments',
    method: 'POST',
    data: form_data,
    data: form_data,
    dataType: 'script'
  });
  return false;
}



$(document).ready(function(){
  $('#main_id li').click(function(){
    var my_id = (this.id);
    $('.beat-navlist').hide();
    $('.beat-nav-content_'+my_id).show();
  });
  $('.send-button').click(function(){
     var my_id = (this.id);
    $('#pop_'+my_id).toggle();
  });
  $('.play-btn').click(function(){
     var my_id = (this.id);
    $('#beat_'+my_id).toggle();
  });

  //card_hover_js();
  $(function() {

    $( '#slider-vertical' ).slider({
      orientation: 'vertical',
      range: 'min',
      min: 0,
      max: 100,
      value: 60,
      slide: function( event, ui ) {
        $( '#amount' ).val( ui.value );
      }
    });
    $( '#amount' ).val( $( '#slider-vertical' ).slider( 'value' ) );
  });
});

function likeTrack() {
  $('.on_rating').click(function(){
    var id = this.id;
    var href = this.href;
    $.ajax({
      url: href,
      method: 'GET',
      success: function(data) {
        change_emojis(data, id);
        total_likes(data, id);
      }
    });
    return false;
  });
}
// js for ratings on shared/beat as well as critiques/show
function change_emojis(data, id) {
  $('.image_'+id).each(function( index ) {
    var imageUrl = $($($('.image_'+id)[index]).html()).attr('src').replace('-active','');

    if (index === 0 && data.star == 'like'){
      imageUrl = '/assets/fire-active.png';
    }
    else if(index == 1 && data.star == 'indifferent'){
      imageUrl = '/assets/sad-active.png';
    }
    else if (index == 2 && data.star == 'dislike') {
      imageUrl = '/assets/unlike-active.png';
    }
    $($('.image_'+id)[index]).html('<img src=' + imageUrl + '>');
  });
}

function total_likes(data, id) {
  $('#like_'+id).html(data.likes);
  $('#indifferent_'+id).html(data.indifference);
  $('#dislike_'+id).html(data.dislikes);
}

$(document).ready(function() {
  likeTrack();
});

$('.editable').click(function(){
  var href = this.href;
  $.ajax({
    url: href ,
    method: 'GET'
  });
  return false;
});



$(':file').change(function () {
    if (this.files && this.files[0]) {
        var reader = new FileReader();
        $('#spinner_2').show();
        reader.onload = function(e){
            $('#excistedImage').attr('src',e.target.result);
            $('#spinner_2').hide();
        };
        reader.readAsDataURL(this.files[0]);
    }
});

$('#excistedImage').click(function(){
    $('#profilePicture').trigger('click');
});


var wait_and_run = (function () {
  var timer = 0;
  return function (callback, ms) {
    clearTimeout(timer);
    timer = setTimeout(callback, ms);
  }
})();

window.BEAT           = {};
window.BEAT.waveforms = {};


