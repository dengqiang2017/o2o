var customer_id="";
$(function(){
	if(browser.versions.iPhone){
		$("#iphone").show();
	}
	selectClient.init(function(customerId) {
		customer_id=customerId;
		$(".find:eq(0)").click();
	});
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-01"); 
	$(".Wdate:eq(0)").val(nowStr);
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".Wdate:eq(1)").val(nowStr);
	$(".find").click(function(){
		$("#list").html("");
		loadData();
	});
	$("#add").click(function(){
		window.location.href="add.do?customer_id="+customer_id;
	});
	function loadData(){
		pop_up_box.loadWait();
		$.get("../employee/getAddFileList.do",{
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val(),
			"customer_id":customer_id
		},function(data){
			pop_up_box.loadWaitClose();
			$.each(data,function(i,n){
				var item=$($("#item").html());
				$("#list").append(item);
				item.find("#time").html(n.time);
				item.find("#customerName").html($(".sim-msg>.col-xs-6").html());
				item.find("a").attr("href",n.url);
			});
		});
	}
});
function delAddFile(t){
	if(confirm("是否删除客户订单附件,删除后将不能恢复!")){
		pop_up_box.postWait();
		var url=$(t).parent().find("a").attr("href");
		$.post("../employee/delAddFile.do",{
			"url":url,
			"customerName":$(".sim-msg>.col-xs-6").html(),
			"customer_id":customer_id
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.toast("删除成功!",1500);
				$(t).parents(".col-xs-12").remove();
			} else {
				if (data.msg) {
					pop_up_box.showMsg("删除错误!" + data.msg);
				} else {
					pop_up_box.showMsg("删除错误!");
				}
			}
		});
	}
}
function fileLoad(t){
	if(!customer_id){
		$("#seekh").click();
	}
	var date=new Date();
	var nowStr = date.Format("yyyy-MM-dd hh:mm:ss"); 
	var imgPath="/@com_id/addFile/"+customer_id+"/"+date.getTime()+".jpg";
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImageZs.do?fileName=imgFile&imgPath="+imgPath,
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":5
	},t,function(imgurl){
		pop_up_box.loadWaitClose();
		var item=$($("#item").html());
		if($("#list").html()==""){
			$("#list").append(item);
		}else{
			$(".col-xs-12:eq(0)").before(item);
		}
		item.find("#time").html(nowStr);
		item.find("#customerName").html($(".sim-msg>.col-xs-6").html());
		item.find("a").attr("href",imgurl);
		$.get("../employee/writeOperatingLog.do",{
			"content":"为客户上传客户订单附件,客户名称:"+$(".sim-msg>.col-xs-6").html()
		},function(data){
			if (data.success) {
				pop_up_box.toast("保存成功!",1000);
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
	});
}