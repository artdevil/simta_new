//= require active_admin/base
//= require jquery.datetimepicker
//= require rails-timeago-all
//= require jquery.timeago
//= require raphael
//= require morris
//= require ckeditor/init
//= require ckeditor/config

$(document).on('click','.user_find_ajax',function(){
  $('.user_find_ajax').autocomplete({
    minLength: 3,
    source: $(this).data('autocomplete-source'),
    select: function( event, ui ) {
      var parent = $(this).parent().parent().parent();
      parent.find('#'+$(this).data('input')).val(ui.item.id);
    }
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

$(document).ready(function(){
  $('.timeago').timeago();
});