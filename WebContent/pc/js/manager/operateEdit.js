var math;
$(function(){
	math=Math.random();
	$("#math").val(math);
    var corp_name=$("#corp_sim_name");
  corp_name.change(function(){
  	if ($("#corp_name").val()=="") {
  		$("#corp_name").val(corp_name.val());
	}
  	$("#easy_id").val(makePy(corp_name.val()));
  });
  if($("#info").val()=="info"){
  	$("input").attr("disabled","disabled");
  	$("select").attr("disabled","disabled");
  	$(".btn-success ").attr("disabled","disabled");
  	$("#saveoperate").hide();
  }
  //////////////////////////
  $("#userId").change(function(){
  	if ($.trim($("#userId").val())=="") {
			return;
		}
  	pop_up_box.loadWait();   
	   $.get("checkPhone.do",{"phone":$("#userId").val(),"type":"operate"},function(data){
		   pop_up_box.loadWaitClose();
		   if (!data.success) {
			   pop_up_box.showMsg("手机号已经存在!",function(){
				   $("#userId").val("");
			   });
			   
		   }
	   });
   });
  
  $(".btn-success").click(function(){
	  var n = $(".btn-success").index(this);
	  pop_up_box.loadWait(); 
	   $.get("getDeptTree.do",{"type":"operate","ver":Math.random()},function(data){
		   pop_up_box.loadWaitClose();
		   $("body").append(data);
		   operate.init(function(treeId,treeName){
				var treeId=$(".modal").find(".activeT").find("input").val();
				if($.trim(treeId)==$.trim($("#comId").val())){
					pop_up_box.showMsg("不能选择与当前一样的运营商,请重新选择!");
				}else{
					var treeName=$(".modal").find(".activeT").text();
					$("#upper_com_name").html(treeName);
					$("#upper_com_id").val(treeId);
				}
			});
	   });
  });
  $("#saveOperate").click(function(){
	    if($.trim($("#com_name").val())==""){
		   pop_up_box.showMsg("请输入运营商名称!");
	   }else if($.trim($("#com_sim_name").val())==""){
		   pop_up_box.showMsg("请输入运营商简称!");
	   }else if($.trim($("#tel_no").val())==""){
		   pop_up_box.showMsg("请输入手机号!");
	   }else{
		   pop_up_box.postWait();  
		   $.post("saveOperate.do",$("#operateForm").serialize(),function(data){
			   pop_up_box.loadWaitClose();
			   if (data.success) {
				   pop_up_box.showMsg("保存成功返回列表页面!",function(){
					   $("form>input").val("");
					   window.location.href="operate.do";
				   });
			}else{
				pop_up_box.showMsg("保存失败,错误:"+data.msg);
			}
		   });
	   }
  });
///////////////回显图片////////////
//  var customerId=$.trim($("#comId").val());
//  if (customerId!="") {
//	   var com_id=$.trim($("#com_id").val());
//	$("#IDcard").attr("src","../"+com_id+"/userpic/"+customerId+"/IDcard.png");
//	$("#You").attr("src","../"+com_id+"/userpic/"+customerId+"/You.png");
//	$("#Inc").attr("src","../"+com_id+"/userpic/"+customerId+"/Inc.png");
//	$("#BusinessLicense").attr("src","../"+com_id+"/userpic/"+customerId+"/BusinessLicense.png");
//	$("#OrganizationCode").attr("src","../"+com_id+"/userpic/"+customerId+"/OrganizationCode.png");
//	$("#TaxRegistration").attr("src","../"+com_id+"/userpic/"+customerId+"/TaxRegistration.png");
////	$("#qianmingImg").attr("src","../"+com_id+"/userpic/"+customerId+"/qianmingImg.png");
//  }
  $.get("../saiyu/getevalimg.do",{
	  "type":"userpic",
	  "customer_id":$.trim($("#comId").val())
  },function(data){
	 if(data&&data.length>0){
		 $.each(data,function(i,n){
			 var customerId=$.trim($("#comId").val());
			 if (customerId!="") {
				 var com_id=$.trim($("#com_id").val());
					 $("#"+n.split(".")[0]).attr("src","../"+com_id+"/userpic/"+customerId+"/"+n+"?"+Math.random());
 			 }
		 });
		 }
  	});
});
function imgCLientUpload(t,key,img){
	pop_up_box.postWait(); 
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName="+key+"&type=userpic"+math+"&imgName="+img,
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