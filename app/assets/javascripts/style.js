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
});