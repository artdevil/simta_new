CKEDITOR.editorConfig = function( config )
{
  config.toolbar =
   [
     { name: 'document', items: [ 'Source'] },
     { name: 'links', items: [ 'Link', 'Unlink'] },
     { name: 'basicstyles', items: [ 'Bold', 'Italic', 'Underline' ] },
     { name: 'paragraph', groups: [ 'list', 'align' ], items: [ 'NumberedList', 'BulletedList','JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock'] },
     { name: 'styles', items: [ 'FontSize' ] }
   ];
  
  // config.toolbar = 'Basic';
//   config.extraPlugins = 'Timestamp';
//   config.toolbar_Basic =
//   [
//     ['Bold', 'Italic', '-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink','-','About','Timestamp']
//   ];
};