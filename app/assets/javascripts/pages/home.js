Paloma.controller('Home', {
  index: function() {
    $(document).ready(function() {

      // changes rating counts
      $('.unreg_user_on_rating').click(function(){
        var id = this.nextSibling.id;
        var el = document.getElementById(id);
        var count = Number(el.innerHTML);
        el.innerHTML = count + 1;


        // activates/deactivates emojis
        if(this.id == 'fire') {
          this.src = '/assets/fire-active.png';
          document.getElementById('sad').src = '/assets/sad.png';
          document.getElementById('unlike').src = '/assets/unlike.png';
        }

        else if(this.id == 'sad') {
         this.src = '/assets/sad-active.png';
         document.getElementById('fire').src = '/assets/fire.png';
          document.getElementById('unlike').src = '/assets/unlike.png';
        }

        else if(this.id == 'unlike'){
          this.src = '/assets/unlike-active.png';
          document.getElementById('fire').src = '/assets/fire.png';
          document.getElementById('sad').src = '/assets/sad.png';
        };
      });
  });

  var waveform_proc = function(){
    $.each($(document).find('div#beat[data-done="false"]'), function(i, k){
      try {
        var self = this;
        setTimeout(function () {
          if ($(self).is(':visible')) {
            $(self).attr('data-done', true);
            var waveform_proc = $(self).find('div#waveform-proc');
            window.BEAT.waveforms[waveform_proc.data('id')] = new window.Waveform('#'+waveform_proc.data('id'), waveform_proc.data('url'), waveform_proc.data('waveform'));
          }
        }, (i*500));
      }catch (e){
        console.log(e);
      }
    });
  };

    wait_and_run(waveform_proc(), 500);
  }
});
