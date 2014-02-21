$(document).on('click','.examiner_status',function(){
  if($(this).val() == "lulus dengan revisi"){
    $('.date-picker').show();
  }
  else{
    $('.date-picker').hide();
  }
});

$(document).ready(function(){
  $("#browser").treeview();
  $(document).on('change','.ace-file-input label span',function(){
    $("form[data-validate]").resetClientSideValidations();
  });
  
  $(document).on('click','.user_find_ajax',function(){
    $('.user_find_ajax').autocomplete({
      minLength: 3,
      source: $(this).data('autocomplete-source'),
      select: function( event, ui ) {
        var parent = $(this).parent().parent().parent();
        parent.find('#'+$(this).data('input')).val(ui.item.id);
        $("form[data-validate]").resetClientSideValidations();
      }
    });
  });
  var currentDate = new Date();
  
  $('.date-picker').datepicker({
    format: "dd-mm-yyyy",
    startDate: currentDate.getDate()+"-"+currentDate.getMonth()+"-"+currentDate.getFullYear()
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
  
	$('table th input:checkbox').on('click' , function(){
		var that = this;
		$(this).closest('table').find('tr > td:first-child input:checkbox')
		.each(function(){
			this.checked = that.checked;
			$(this).closest('tr').toggleClass('selected');
		});
			
	});
  
  $('.data_tables').dataTable({
	  "aoColumns": [null, null,null, null, { "bSortable": false }] 
  });
  
  $('.data_advisor_tables').dataTable({
    "aoColumns": [null, null,null, { "bSortable": false }]
  });
  $('.data_student_tables').dataTable({
    "sDom": "<'row-fluid'<'span1 selected'><'span7'l><'span4'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
    "aoColumns": [{ "bSortable": false },null, null,null, { "bSortable": false }, { "bSortable": false }]
  });
  $('.data_proposal_tables').dataTable({
    "sDom": "<'row-fluid'<'span1 selected'><'span7'l><'span4'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
    "aoColumns": [{ "bSortable": false },null,null, null, null, { "bSortable": false }, { "bSortable": false }]
  });
  $('.data_final_project_tables').dataTable({
    "sDom": "<'row-fluid'<'span1 selected'><'span7'l><'span4'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
    "aoColumns": [{ "bSortable": false },null,null, null, null,null, { "bSortable": false }, { "bSortable": false }]
  });
  $('.data_examiner_tables').dataTable({
    "sDom": "<'row-fluid'<'span1 selected'><'span7'l><'span4'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
    "aoColumns": [{ "bSortable": false },null,null, null, null,null, { "bSortable": false }, { "bSortable": false }]
  });
  $('.data_advisor_schedule_tables').dataTable({
    "aoColumns": [null, null,{ "bSortable": false }, { "bSortable": false }, { "bSortable": false },{ "bSortable": false },{ "bSortable": false }]
  });
  
  $(".span1.selected").html('<input type="submit" value="send sms" id="send_sms">');
  
  $(document).on('click','#send_sms', function(){
    $('#send_sms_table').submit();
  });
  
  if($(document).length > 0) {
    setTimeout(updateComments, 10000);
  }
  
  $('.timeago').timeago();
  
  $('#tag_show').click(function(){
    $('#tag_init_show').show();
    $(this).hide();
    $('html, body').animate({
            scrollTop: $('#tag_init_show').offset().top
    }, 'slow');
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
  
  $(document).on('click','.datetimepicker', function(){
    $('.datetimepicker').datetimepicker({
      minDate:'-1970/01/01',
      allowTimes:[
        '08:30', '10:30', '12:30', '14:30', '16.30'
      ]
    });
  });
});

function updateComments() {
  if($('#notification_tab').hasClass('open') == false){
    $.getScript('/notifications');
  }
  setTimeout(updateComments, 10000); 
}