$(function(){
	$("#searchKey").bind("input propertychange blur",function(){
		$("input[name='searchKey']").val($(this).val());
	});
	$("input[name='searchKey']").bind("input propertychange blur",function(){
		$("#searchKey").val($(this).val());
	}); 
});