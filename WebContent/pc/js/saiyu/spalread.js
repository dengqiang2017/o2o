$(function(){
	var file_icon_group=$(".file-icon-group");
	pop_up_box.loadWait();
	$.get("getOAInfo.do",{"ivt_oper_listing":$("#spNo").val(),"type":"yiban"},function(data){
		pop_up_box.loadWaitClose();
		var infos=data.info.content.split("|");
		$("#info").html(infos[0].replace( /&/gm,"<br>"));
		$("#bxNo").html(infos[1].split(":")[1]);
		$("#itempage").find("#spNo").val(data.info.ivt_oper_listing);
		$("#itempage").find("#store_date").html(new Date(data.info.store_date).Format("yyyy-MM-dd hh:mm:ss"));
		if (data.info.isfile) {
			$("#sqfujian .glyphicon-save").click(function(){
				window.open("/phone/"+data.info.url);
			});
			$("#sqfujian .glyphicon-search").click(function(){
				window.open("/phone/"+data.info.url);
			});
		}else{
			$("#sqfujian").remove();
		}
		 $(".box-body").html("<h5>审批记录</h5>");
		 $.each(data.list,function(i,n){
			 var item=$($("#spjlitem").html());
			 $(".box-body").append(item);
			 item.find("#OA_who_item").html(n.corp_sim_name);
				if (!n.corp_sim_name) {
					item.find("#OA_who_item").html(n.clerk_name);
				}
				item.find("#OA_what").html(n.OA_what);
				item.find("#approval_YesOrNo").html(n.approval_YesOrNo);
				item.find("#store_date_item").html(new Date(n.store_date).Format("yyyy-MM-dd hh:mm:ss"));
				
				 $(".btn-primary").click(function(){
					 var t=$(this);
//					 $.get("../pc/modalFile.html",function(data){
//						 $("body").append(data); 
//						 var approvaler=t.parent().find("input").val();
//						 modalFile.init(approvaler);
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
modalFile={
		init:function(approvaler){
			$.get("getFileList.do",{
				"type":"sp", 
				"approvaler":approvaler, 
				"ivt_oper_listing":$("#ivt_oper_listing").val()
			},function(data){
				var file_group=$(".modal-body").find(".file-icon-group");
				$(".modal-body").find(".form-group").html("");
				$.each(data,function(i,n){
					var names=n.split("/");
					var item=loadModal(names[names.length-1],n);
					$(".modal-body").find(".form-group").append(item);
				});
			});
			$(".closeModal").click(function(){
				$(".modal,.modal-cover").remove();
			});
		}
}
function loadModal(name,url){
	return "<div class='file-icon-group'>"+
	"<span class='glyphicon glyphicon-file file-icon'></span>"+
	"<span class='file-name'>"+name+"</span>"+
	"<a href='"+url+"'  target='_blank' class='glyphicon glyphicon-search file-operate'></a></div>";
}
