function run_tabs(){
  $(".beats-menu a").click(function(event) {
        event.preventDefault();
        $(this).parent().addClass("current");
        $(this).parent().siblings().removeClass("current");
    });
}

$(document).ready(run_tabs);

$(document).ready(function(){
	$(".contact-tabs").hide();
	$(".info-tabs").hide();
	$(".share-tabs").hide();
	$(".critique_tab_click").click(function(){
	  track_id = this.id.split("_")[1]
	  $("#contact_"+track_id).removeClass('active');
	  $("#info_"+track_id).removeClass('active');
	  $("#share_"+track_id).removeClass('active');
	  $("#critique_"+track_id).addClass('active');
	  $("#contact_tab_show_"+track_id).hide();
	  $("#info_tab_show_"+track_id).hide();
	  $("#share_tab_show_"+track_id).hide();
	  $("#critique_tab_show_"+track_id).show();
	});
	$(".contact_tab_click").click(function(){
	  track_id = this.id.split("_")[1]
	  $("#critique_"+track_id).removeClass('active');
	  $("#info_"+track_id).removeClass('active');
	  $("#share_"+track_id).removeClass('active');
	  $("#contact_"+track_id).addClass('active');
	  $("#critique_tab_show_"+track_id).hide();
	  $("#info_tab_show_"+track_id).hide();
	  $("#share_tab_show_"+track_id).hide();
	  $("#contact_tab_show_"+track_id).show();
	});
	$(".info_tab_click").click(function(){
	  track_id = this.id.split("_")[1]
	  $("#critique_"+track_id).removeClass('active');
	  $("#contact_"+track_id).removeClass('active');
	  $("#share_"+track_id).removeClass('active');
	  $("#info_"+track_id).addClass('active');
	  $("#critique_tab_show_"+track_id).hide();
	  $("#contact_tab_show_"+track_id).hide();
	  $("#share_tab_show_"+track_id).hide();
	  $("#info_tab_show_"+track_id).show();
	});
	$(".share_tab_click").click(function(){
	  track_id = this.id.split("_")[1]
	  $("#critique_"+track_id).removeClass('active');
	  $("#contact_"+track_id).removeClass('active');
	  $("#info_"+track_id).removeClass('active');
	  $("#share_"+track_id).addClass('active');
	  $("#critique_tab_show_"+track_id).hide();
	  $("#contact_tab_show_"+track_id).hide();
	  $("#info_tab_show_"+track_id).hide();
	  $("#share_tab_show_"+track_id).show();
	});
});
