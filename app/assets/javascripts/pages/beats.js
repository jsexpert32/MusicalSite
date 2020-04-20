Paloma.controller('Beats', {
  index: function() {
    // Beat Index page showing the Sidebar,Loader and Content
    $("[data-beat-main-left], #after-slider").hide();
    setTimeout(function(){
       $("[data-beat-main-left]").show();
    }, 500);

    setTimeout(function(){
       $("#spinner").removeClass('hide').show();
    }, 1000);

   setTimeout(function(){
      $("#spinner").addClass('hide');
      $("#filterrific_results").removeClass('hide');
      $("#after-slider").show();
    }, 1500);

   // moved from _desktop_index.slim
    $(document).ready(function(){
      $('#beats').addClass('active');
      $( "#slider" ).slider();
      $(".volume-button").click(function(){
        var my_id = (this.id);
        $("#vol_"+my_id).toggle();
      });

    });


//////////////////////////////////////
// beats/index  AND charts/index /////
//////////////////////////////////////
// set height of left and right div

    $(function () {
      wait_and_run(height_change_beat_main(), 500);
    });

    $(window).resize(function () {
      wait_and_run(height_change_beat_main(), 200);
    });

    var height_change_beat_main = function () {
      var left            = $(document).find('[data-beat-main-left]');
      var right           = $(document).find('[data-beat-main-right]');
      var chartsBeats     = $(document).find('#chartsBeats');
      if(left.length > 0 && right.length > 0){
        var top_header_nav  = $('.navbar').height();
        var bottom_play_bar = $('[data-player]').height();
        $(document).find('html').css('overflow', 'hidden');
        left.css('height', ($(window).height() - (top_header_nav+bottom_play_bar))+'px');
        right.css('height', ($(window).height() - (top_header_nav+bottom_play_bar))+'px');
      }else if(chartsBeats.length > 0){
        var top_header_nav  = $('.navbar').height() * 2;
        $(document).find('html').css('overflow', 'hidden');
        chartsBeats.css('height', ($(window).height() - (top_header_nav))+'px');
      }
    };

  }
});
