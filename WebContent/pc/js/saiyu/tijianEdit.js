//$(function(){
//	tijianEdit.init();
//});
function showlistpage(){
	$("#listpage").show();
	$("#editpage").html("");
}
var tijianEdit={
		init:function(){
			$("#save").click(function(){
				var position_big=$.trim($("#position_big").val());
				var position=$.trim($("input[data-num]").eq(0).val());
				var item_name=$.trim($("#item_name").val());
				var num=$.trim($("input[data-num]").eq(1).val());
				if (position_big=="") {
					pop_up_box.showMsg("请输入位置大类!",function(){
						$("#position_big").focus().select();
					});
				}else if (position=="") {
					pop_up_box.showMsg("请输入位置小类!",function(){
						$("input[data-num]").eq(0).focus().select();
					});
				}else if (item_name=="") {
					pop_up_box.showMsg("请输入名称!",function(){
						$("#item_name").focus().select();
					});
				}else if (num==""||num=="0") {
					pop_up_box.showMsg("请输入使用数量!",function(){
						$("input[data-num]").eq(1).focus().select();
					});
				} else {
					pop_up_box.postWait();
					$.post("saveTijian.do", $("#tijianForm").serialize(),function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							pop_up_box.showMsg("保存成功!",function(){
								tijian.loadData($("#page").val(),function(){
									showlistpage();
									$("tbody").find("input[value='"+data.msg+"']").parents("tr").addClass("activeTable");
								});
							});
						} else {
							if (data.msg) {
								pop_up_box.showMsg("保存错误!" + data.msg);
							} else {
								pop_up_box.showMsg("保存错误!");
							}
						}
					});
				}
			});
			function getulli(name){
				return '<ul class="hide-msg"><li class="col-xs-12">'+name+'</li></ul>';
			}
			$(".cover").click(function(){
				$(".zz3,.cover").hide();
			});
			$(".btn-success").click(function(){
				var n = $(".btn-success").index(this);
				pop_up_box.loadWait(); 
			   if (n==2) {
				   var liulan=$(this).parent().prev();
					var val=liulan.val();
				   var itemhtml=$.trim($(".zz3").find("#positem").html());
					if(itemhtml==""){
						$.get("../saiyu/getPosition.do",{"customer_id":$("#customerId").val()},function(data){
							 pop_up_box.loadWaitClose();
							$.each(data,function(i,n){
								if(ifnull(n.position_big)!=""){
								$(".zz3").find("#positem").append(getulli(n.position_big));
								}
							});
							$(".zz3").find("#positem").find("li").click(function(){
								liulan.val($(this).html());
								$(".zz3,.cover").hide();
							});
							$(".zz3,.cover").show();
						});
					}else{
						$(".zz3,.cover").show();
					}
			   }else{
				   $.get("../tree/productSelect.do",function(data){
					   pop_up_box.loadWaitClose();
					   $("body").append(data);
					   product.init(function(){
						   $("#item_id").val($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
						   $("#item_id_name").html($(".modal").find("tr.activeTable").find("td:eq(0)").text());
					   });
				   });
			   }
			});		   
		}
}
function tijianImgUpload(t,key,img){
	pop_up_box.postWait(); 
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName="+key+"&type=tijian&imgName="+img,
		"msgId":"msg",
		"fileId":key,
		"msg":"图片",
		"fid":"",
		"uploadFileSize":0.5
	},t,function(imgurl){
		pop_up_box.loadWaitClose(); 
		$("#"+key).parents(".m-t-b").find("img").attr("src","../"+imgurl+"?ver="+Math.random());
		$("#"+img).val(imgurl);
	});
}
