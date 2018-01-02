$(function(){
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".Wdate").val(nowStr);
	$(".Wdate").prop("disabled",true);
	
	
});