//= require active_admin/base
//= require jquery_nested_form
//= require jquery.datetimepicker
//= require rails-timeago-all
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
  $('.datetimepicker').datetimepicker();
});
