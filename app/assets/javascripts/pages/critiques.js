Paloma.controller('Critiques', {
	show: function() {
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
