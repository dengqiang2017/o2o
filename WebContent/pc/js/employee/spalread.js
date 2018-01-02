$(function(){
	var seeds_id=window.location.href.split("?")[1].split("=")[1];
	var file_icon_group=$(".file-icon-group");
	pop_up_box.loadWait();
	$.get("getOAInfo.do",{"seeds_id":seeds_id},function(data){
		pop_up_box.loadWaitClose();
		if (data.info.OA_who) {
			$("#OA_who").append(data.info.OA_who);
		}else{
			$("#OA_who").append(data.info.clerk_name);
		}
		$("#accountStatement").attr("href","../employee/accountStatement.do?clientId="+data.customer_id+"&name="+data.info.OA_who);
		
		$("#OA_what").append(data.info.OA_what);
		$("#content").append(data.info.content);
		$("#ivt_oper_listing").val(data.info.ivt_oper_listing);
		$("#store_date").append(new Date(data.info.store_date).Format("yyyy-MM-dd hh:mm:ss"));
		if (data.info.isfile) {
//			$("#sqfujian .glyphicon-save").click({"OA_who":$.trim(data.info.approvaler)},function(event){
//				window.open(data.info.url);
//			});
//			$("#sqfujian .glyphicon-search").click({"OA_who":$.trim(data.info.approvaler)},function(event){
//				window.open(data.info.url);
//			});
			$("#sqfujian .glyphicon-search").click({"OA_who":$.trim(data.info.approvaler)},function(event){
				 var t=$(this);
				 $.get("../pc/modalFile.html",function(data){
					 $("body").append(data);
					 modalFile.init(event.data.OA_who);
				 });
			});
		}else{
			$("#sqfujian").remove();
		}
		 $(".box-body").html("<h5>审批记录</h5>");
		 $.each(data.list,function(i,n){
			 var item=$(spjil(n));
			 $(".box-body").append(item);
			 item.find(".btn-primary").click({"url":$.trim(n.url)},function(event){
				 window.open(event.data.url);
//					 var t=$(this);
//					 $.get("../pc/modalFile.html",function(data){
//						 $("body").append(data); 
////						 var approvaler=t.parent().find("input").val();
//						 modalFile.init(event.data.OA_whom);
//					 });
			 }); 
		 });
		 if (data.ioupath) {
			$("#iou").show();
			$("#ioupath").attr("href",data.ioupath);
		}else{
			$("#iou").hide();
		}
	});
	
});