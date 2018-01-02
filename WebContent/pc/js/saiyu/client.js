$(function(){
   //////////////////
	initNumInput();
   $(".btn-success").click(function(){
	   var n = $(".btn-success").index(this);
	   if (n==0) {
		   pop_up_box.loadWait(); 
		   $.get("../manager/getClientTree.do",{"ver":Math.random()},function(data){
			   pop_up_box.loadWaitClose();
			   $("body").append(data);
			   client.init();
		   });
	   }else{
		   pop_up_box.loadWait(); 
		   $.get("../manager/getDeptTree.do",{"type":"regionalism","ver":Math.random()},function(data){
			   pop_up_box.loadWaitClose();
			   $("body").append(data);
			   regionalism.init(function(treeId,treeName){
					var treeId=$(".modal").find(".activeT").find("input").val();
					var treeName=$(".modal").find(".activeT").text();
					$("#regionalism_name_cn").html(treeName);
					$("#regionalismId").val(treeId);
				});
		   });
	   }
   });
   //////////
   $("#saveClient").click(function(){
	    if($.trim($("#corp_name").val())==""){
		   pop_up_box.showMsg("请输入客户名称!");
	   }else if($.trim($("#corp_sim_name").val())==""){
		   pop_up_box.showMsg("请输入客户简称!");
	   }else if($.trim($("#movtel").val())==""){
		   pop_up_box.showMsg("请输入手机号!");
	   }else{
		   pop_up_box.postWait();  
		   $.post("saveClient.do",$("#clientForm").serialize(),function(data){
			   pop_up_box.loadWaitClose();
			   if (data.success) {
				   pop_up_box.showMsg("保存成功返回列表页面!",function(){
					   $("form>input").val("");
					   window.location.href="client.do";
				   });
			}else{
				pop_up_box.showMsg("保存失败,错误:"+data.msg);
			}
		   });
	   }
   });
   ///////////////回显图片////////////
   var customerId=$.trim($("#customerId").val());
   if (customerId!="") {
	   var com_id=$.trim($("#com_id").val());
	$("#IDcard").attr("src","../"+com_id+"/userpic/"+customerId+"/IDcard.png");
	$("#You").attr("src","../"+com_id+"/userpic/"+customerId+"/You.png");
	$("#Inc").attr("src","../"+com_id+"/userpic/"+customerId+"/Inc.png");
	$("#BusinessLicense").attr("src","../"+com_id+"/userpic/"+customerId+"/BusinessLicense.png");
	$("#OrganizationCode").attr("src","../"+com_id+"/userpic/"+customerId+"/OrganizationCode.png");
	$("#TaxRegistration").attr("src","../"+com_id+"/userpic/"+customerId+"/TaxRegistration.png");
	$("#qianmingImg").attr("src","../"+com_id+"/userpic/"+customerId+"/qianmingImg.png");
//	imgclick();
   }
   ///////////////////////////////////////////////
   
});
/////////////////////////////////////////////////////////
function imgLoadDiv(){
	var popdiv="<div class='whimg-box'><div class='btn-whimg'>"
		+"<button type='button' class='btn btn-xs btn-default btn-whimg'>编辑</button>"	
		+"<input type='file' name='imgEditFile' id='imgEditFile' onchange='imgEditUpload(this);'>"		
		+"</div>"
		+"<a href='#' class='btn btn-xs btn-default' target='_blank'>查看</a>"
		+"<button type='button' class='btn btn-xs btn-default' id='delimg'>删除</button>"
		+"<button type='button' class='whimg-close btn btn-xs btn-danger' id='closeimgdiv'>关闭</button>"
		+"<button type='button' style='display: none;' id='confirm'>确定</button>"
		+"<div class='link-group'><label for=''>超链接</label>"
		+"<input type='text'></div></div>";
	return popdiv;
}
function imdivclick(img,type){
	imgselecturl="";
	delimgurl="";
	imgupdate=false;
	$(".whimg-box").remove();
	var imgdiv=imgLoadDiv();
	imgselect=img;
	img.after(imgdiv);
	imgselecturl=img.attr("src").split("?")[0];
	$(".whimg-box>a").attr("href","../pc/image-view.html?type=user&item_id="+$("#customerId").val());
	$(".whimg-box>#delimg").click(function(){
		if (imgselect.attr("src").indexOf("temp")>0) {
			pop_up_box.showMsg("正在编辑中不能删除!");
			return;
		}
		if (window.confirm("是否要删除该图片")) {
			delimgurl=img.attr("src").split("?")[0];
			$(".whimg-box>#confirm").click();
		}
		 
	});
	$(".whimg-box>#closeimgdiv").click(function(){
		imgselecturl="";
		delimgurl="";
		imgupdate=false;
		$(".whimg-box").remove();
	});
	$(".whimg-box>#confirm").click(function(){
		var url={};
		if (delimgurl!="") {
			url.delimg=delimgurl;
			imgselect.parent().remove();
		}else if (imgupdate) {
			if (imgselecturl.indexOf("temp")<0) {
				url.oldimg=imgselecturl;
				url.newimg=img.attr("src");
			}
		}
		imgedit.push(url);
		imgselecturl="";
		delimgurl="";
		imgupdate=false;
		$(".whimg-box").remove();
	});
}
function imgclick(){
	$("#cp").find("img").bind("click",function(){
		imgType="cp";
		imdivclick($(this), "cp"); 
	}); 
}
var imgselecturl="";//当前选择的url
var delimgurl="";//当前选择的url
var imgselect;
var imgupdate=false;
var imgedit=[];//编辑数组
var imgType="cp";
function imgEditUpload(t){
	if (imgselecturl.indexOf("temp")>0) {
		pop_up_box.showMsg("请保存后再修改!");
		return;
	}
	if (imgselect.attr("src").indexOf("temp")>0) {
		pop_up_box.showMsg("请保存后再修改!");
		return;
	}
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=imgEditFile&type="+imgType,
		"msgId":"msg",
		"fileId":"imgEditFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":500
	},t,function(imgurl){
		imgselect.attr("src","../"+imgurl+"?ver="+Math.random());
		$(".whimg-box>a").attr("href","../"+imgurl);
		imgupdate=true;
		$(".whimg-box>#confirm").click();
	});
}
///////////////////////////////////////////////
function imgCLientUpload(t,key,img){
	pop_up_box.postWait(); 
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName="+key+"&type=userpic&imgName="+img,
		"msgId":"msg",
		"fileId":key,
		"msg":"图片",
		"fid":"",
		"uploadFileSize":0.5
	},t,function(imgurl){
		pop_up_box.loadWaitClose(); 
		$("#"+img).attr("src","../"+imgurl+"?ver="+Math.random());
	});
}