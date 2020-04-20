try{
  var wavesurfer = WaveSurfer.create({
    container: document.getElementsByClassName('.separator-box'),
    waveColor: '#c9c9c9',
    progressColor: '#2bb673',
    barWidth: 1,
    height: 126,
    // scrollParent:true
  });

  wavesurfer.load('http://ia902606.us.archive.org/35/items/shortpoetry_047_librivox/song_cjrg_teasdale_64kb.mp3');
}catch (e){
  console.log(e);
}