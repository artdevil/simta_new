$(document).ready(function(){
  
  $(document).on('change','.ace-file-input label span',function(){
    $("form[data-validate]").resetClientSideValidations();
  });
  
  $(document).on('click','.user_find_ajax',function(){
    $('.user_find_ajax').autocomplete({
      minLength: 3,
      source: $('.user_find_ajax').data('autocomplete-source'),
      select: function( event, ui ) {
        var parent = $(this).parent().parent().parent();
        parent.find('.recipient_id').val(ui.item.id);
        $("form[data-validate]").resetClientSideValidations();
      }
    });
  });
  
  $(document).on('click','.add_nested_fields',function(){
    $('.upload_file').ace_file_input({
    	no_file:'No File',
    	btn_choose:'Choose',
    	btn_change:'Change',
    	droppable:false,
    	onchange:null,
    	thumbnail:true, //| true | large
    	whitelist: 'png|jpg|jpeg|pdf|JPG'
    	//blacklist:'exe|php'
    	//onchange:''
    	//
    });
  });
  
  $('.upload_file').ace_file_input({
  	no_file:'No File',
  	btn_choose:'Choose',
  	btn_change:'Change',
  	droppable:false,
  	onchange:null,
  	thumbnail:true, //| true | large
  	whitelist: 'png|jpg|jpeg|pdf|JPG'
  	//blacklist:'exe|php'
  	//onchange:''
  	//
  });
  
  $(document).on('click','.client_side_validation', function(){
    $("form[data-validate]").validate();
  });
  $('.data_tables').dataTable({
	  "aoColumns": [null, null,null, null, { "bSortable": false }] 
  });
  
  if($(document).length > 0) {
    setTimeout(updateComments, 10000);
  }
  
  $('.timeago').timeago();
  
  $('#tag_topic_button').click(function(){
    $('#form_topic_tag').show();
    $(this).hide();
  });
  
  $(document).on('hover','.btn-tooltip',function(){
    $('.btn-tooltip').tooltip();
  });
  
	$('.easy-pie-chart.percentage').each(function(){
		var $box = $(this).closest('.infobox');
		var barColor = $(this).data('color') || (!$box.hasClass('infobox-dark') ? $box.css('color') : 'rgba(255,255,255,0.95)');
		var trackColor = barColor == 'rgba(255,255,255,0.95)' ? 'rgba(255,255,255,0.25)' : '#E2E2E2';
		var size = parseInt($(this).data('size')) || 50;
		$(this).easyPieChart({
			barColor: barColor,
			trackColor: trackColor,
			scaleColor: false,
			lineCap: 'butt',
			lineWidth: parseInt(size/10),
			size: size
		});
	});
});

function updateComments() {
  if($('#notification_tab').hasClass('open') == false){
    $.getScript('/notifications');
  }
  setTimeout(updateComments, 10000); 
}