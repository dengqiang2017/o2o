common.URLFiltering();
var customer_id=$.trim($("#customer_id").html());
$(function(){
	if(browser.versions.iPhone){
		$("#iphone").show();
	}
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-01"); 
	$(".Wdate:eq(0)").val(nowStr);
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".Wdate:eq(1)").val(nowStr);
	$(".find").click(function(){
		$("#list").html("");
		loadData();
	});
	loadData();
	function loadData(){
		pop_up_box.loadWait();
		$.get("../customer/getAddFileList.do",{
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			pop_up_box.loadWaitClose();
			$.each(data,function(i,n){
				var item=$($("#item").html());
				$("#list").append(item);
				item.find("#time").html(n.time);
				item.find("a").attr("href",n.url);
			});
		});
	}
});
function fileLoad(t){
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
		item.find("a").attr("href",imgPath);
		$.get("../customer/noticeSales.do",{
			"headship":"内勤",
			"title":"客户上传订单附件通知",
			"description":"#comName-@Eheadship-@clerkName:客户【@customerName】提交了订单附件,请尽快核实并初步报价."
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