
function fileUpload(t){
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=imgFile&fileNameNo=no&type=sp",
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":500
	},t,function(imgUrl){
		fileloadHandler(imgUrl);
	});
}
function fileloadHandler(imgUrl){
	var fileGroup=$(".file-icon-group");
	var item=fileGroup.clone();
	$("#filelaoddiv").append(item);
	item.show();
	var names=imgUrl.split("/");
	item.find(".file-name").html(names[names.length-1]);
	item.find("input").val(imgUrl);
	item.find(".glyphicon-trash").click(function(){
		var t=$(this);
		$.get("../upload/removeTemp.do",{"imgUrl":imgUrl},function(data){
			if (data.success) {
				 t.parent().remove();
			}else{
				pop_up_box.showMsg("删除失败!"+data.msg);
			}
		});
	});
	item.find(".glyphicon-search").click(function(){
//		window.open("../"+imgUrl);
		pop_up_box.showImg("../"+imgUrl);
	});
}
modalFile={
		init:function(approvaler){
			$.get("getFileList.do",{
				"type":"sp", 
				"OA_who":approvaler, 
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
 
function spjil(n){
	var div= "<div class='alert alert-success'>"+
	"<div class='ctn'>"+
	"<div class='col-sm-2 m-t-b' style='font-weight:700;'>"+n.clerk_name+"</div>"+	
	"<div class='col-sm-1 m-t-b' style='font-weight:700;'>"+n.approval_YesOrNo+"</div>"+	
	"<div class='col-sm-5 m-t-b'>"+n.approval_suggestion+"</div>"+	
	"<div class='col-sm-2 m-t-b' style='fong-size:12px; color:#858585;'>"+new Date(n.approval_time).Format("yyyy-MM-dd hh:mm:ss")+"</div>";	
	if (n.isfile) {
		div+="<div class='col-sm-2 m-t-b'><input type='hidden' value='"+n.OA_whom+"'>"+	
		"<button type='button'  class='btn btn-primary'>附件</button>"+		
		"</div>";
	}
	
	div+="</div></div>";
	return div;
}