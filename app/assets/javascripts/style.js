$(document).ready(function(){
  $('#id-input-file-1 , #id-input-file-2').ace_file_input({
  	no_file:'No File ...',
  	btn_choose:'Choose',
  	btn_change:'Change',
  	droppable:false,
  	onchange:null,
  	thumbnail:false //| true | large
  	//whitelist:'gif|png|jpg|jpeg'
  	//blacklist:'exe|php'
  	//onchange:''
  	//
  });
  
  $(document).on('click','.add_nested_fields',function(){
    $('.upload_file').ace_file_input({
    	no_file:'No File',
    	btn_choose:'Choose',
    	btn_change:'Change',
    	droppable:false,
    	onchange:null,
    	thumbnail:false, //| true | large
    	whitelist: 'png|jpg|jpeg|pdf|txt'
    	//blacklist:'exe|php'
    	//onchange:''
    	//
    });
  });
  
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
});

function updateComments() {
  if($('#notification_tab').hasClass('open') == false){
    $.getScript('/notifications');
  }
  setTimeout(updateComments, 10000); 
}