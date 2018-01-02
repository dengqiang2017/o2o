var productEdit={
		init:function(){
			var item_id=$("#editpage").find("input[name='item_id']");
			editUtils.editinit("getProductInfo",item_id.val());
		    var item_sim_name=$("#editpage").find("input[name='item_sim_name']");
		    item_sim_name.unbind("change");
		    item_sim_name.change(function(){
		    	$("#editpage").find("input[name='easy_id']").val(makePy(item_sim_name.val()));
		    	if ($.trim($("#editpage").find("input[name='item_name']").val())=="") {
		    		$("#editpage").find("input[name='item_name']").val(item_sim_name.val());
		    	}
		    });
		    var price_display=$("#editpage").find("input[name='price_display']");
		    var price_prefer=$("#editpage").find("input[name='price_prefer']");
		    var price_otherDiscount=$("#editpage").find("input[name='price_otherDiscount']");
		    price_display.change(function(){
		    	sum_item_Sellprice();
		    });
		    price_prefer.unbind("change");
		    price_prefer.change(function(){
		    	sum_item_Sellprice();
		    });
		    price_otherDiscount.unbind("change");
		    price_otherDiscount.change(function(){
		    	sum_item_Sellprice();
		    });
		    $("#editpage").find("input[name='pack_unit']").bind("input propertychange blur",function(){
		    	var val=parseFloat($.trim($(this).val()));
		    	if(val<1){
		    		pop_up_box.toast("输入的数据至少要大于等于1!",1000);
		    		$(this).val("1");
		    	}
		    });
		    function sum_item_Sellprice(){
		    	if (price_otherDiscount.val()=="") {
		    		price_otherDiscount.val("0");
		    	}
		    	if (price_prefer.val()=="") {
		    		price_prefer.val("0");
		    	}
		    	if (price_display.val()=="") {
		    		price_display.val("0");
				}
		    	if (price_display.val()!="0") {
		    		var sell=parseFloat(price_display.val())-parseFloat(price_prefer.val())-parseFloat(price_otherDiscount.val());
		    		$("#editpage").find("input[name='item_Sellprice']").val(sell);
				}
		    }
		    $("#editpage").find(".btn-success").unbind("click");
		    $("#editpage").find(".btn-success").click(function(){
		 	   var n = $("#editpage").find(".btn-success").index(this);
		 	   var txt=$(this).parents(".form-group").find("label").html();
		 	   var type="";
		 	   if(txt.indexOf("仓")>=0){
		 		  type="warehouse";
		 	   }else if(txt.indexOf("供应商")>=0){
		 		  type="vendor";
		 	   }else if(txt.indexOf("设计师")>=0){
		 		   type="employee";
		 	   }else{
		 		   type="cls";
		 	   }
		 	   pop_up_box.loadWait();
		 	   $.get("getDeptTree.do",{"type":type},function(data){
		 		   pop_up_box.loadWaitClose();
		 		   $("body").append(data);
		 		   if (type=="cls") {
		 			  procls.init();
		 		   }else if(type=="vendor"){
		 			  vendor.init(function(){
		 				 $("#editpage").find("#vendor_id").val($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
						   $("#editpage").find("#vendor_name").html($(".modal").find("tr.activeTable").find("td:eq(0)").text());
		 			  });
		 		   }else if(type=="employee"){
		 			  employee.init(function(){
		 	 				  $("#editpage").find("#clerk_id").val($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
		 	 				  $("#editpage").find("#clerkName").html($(".modal").find("tr.activeTable").find("td:eq(0)").text());
		 	 		   });
		 		   }else if(type=="warehouse"){
		 			  warehouse.init(function(){
		 				  $("#editpage").find("#store_struct_id").val(treeSelectId);
		 				  $("#editpage").find("#store_struct_name").html(treeSelectName);
		 			  });
		 		   }
		 	   });
		    });
		    $("#editpage").find(".btn-info").unbind("click");
			$("#editpage").find(".btn-info").click(function(){
				 var inputs=$("#editpage").find("input[type='text']");
				 var msg=$("#editpage").find("#msg");
				 var run=true;
				 if($.trim(item_sim_name.val())==""){
					 pop_up_box.showMsg("请输入产品名称!");
				 }else{
					 pop_up_box.postWait();
					 var json={};
					 var list=[];
					 for (var i = 0; i < $("#editForm").serializeArray().length; i++) {
						 var sa=$("#editForm").serializeArray()[i];
						 var name=sa.name;
						 var value=sa.value;
						 json[name]=value;
					 }
//					 var url="";
//					for (var i = 0; i < imgedit.length; i++) {
//						url=url+JSON.stringify(imgedit[i])+"_";
//					}
//					if(url){
//						json.imgurl=url;
//					}
//					 $("#editpage").find("#editForm").append("<input name='imgurl' value='"+url+"'>");
					 var imgs=$(".upload-img:eq(0) img");
					 var mainImgs=[];
					 for (var i = 0; i < imgs.length; i++) {
						var img=$(imgs[i]);
						var path=img.attr("src").split("?")[0];
						if(!path){
							mainImgs.push(path);
						}
					}
					 if(mainImgs.length>0){
						 json.mainImg=mainImgs.join(",");
						 json.main_img=mainImgs.length;
					 }
					 var coverImg=$(".upload-img:eq(2) img").attr("src").split("?")[0];
					 if(coverImg.indexOf("pcxy")>=0){
						 coverImg="";
						 json.cover_img=0;
					 }else{
						 json.coverImg=coverImg;
						 json.cover_img=1;
					 }//$("#editpage").find("#editForm").serialize()
					 $.post("../product/save.do",json,function(data){
						 pop_up_box.loadWaitClose();
						 if (data.success) {
							 pop_up_box.toast("数据保存成功!", 1000);
							 var type = 1;
								var cid = $.trim(item_id.val());
								if (cid == "") {
									cid = data.msg;
									type = 0;
								}
								item_id.val(cid);
								editUtils.tableShowSyn(type,getbtn(),function(tr,j,name) {
								   if(name=="item_sim_name"){
										var val=$("#editForm *[name='"+name+"']").val(); 
										tr.find("td:eq("+j+")").html("<input type='hidden' value='"+cid+"'>"+val);
									}else if(name=="clerkName"){
										var val=$("#editForm #clerkName").html(); 
										tr.find("td:eq("+j+")").html(val);
									}else if(name=="sort_name"){
										var val=$("#editForm #sort_name").html(); 
										tr.find("td:eq("+j+")").html(val);
									}else if(name=="vendor_name"){
										var val=$("#editForm #vendor_name").html(); 
										tr.find("td:eq("+j+")").html(val);
									}else if(name=="store_struct_name"){
										var val=$("#editForm #store_struct_name").html(); 
										tr.find("td:eq("+j+")").html(val);
									}
								});
						 }else{
							 if(data.msg){
								 pop_up_box.showMsg("数据存储异常");
							 }else{
								 pop_up_box.showMsg("数据存储异常,错误代码:"+data.msg);
							 }
						 }
					 });
				 }
			});
			var cp=$("#editpage").find("#cp");
			var xj=$("#editpage").find("#xj");
			cp.html("");
			xj.html("");
			pop_up_box.loadWait();
			$.get("../product/getImgUrl.do",{"item_id":item_id.val()},function(data){
				pop_up_box.loadWaitClose();
				if (data.cps) {
					for (var i = 0; i < data.cps.length; i++) {
					var name=data.cps[i];
					if (/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(name)) {
						cp.append("<div class='whimg'><img src='"+name
								+"?ver="+Math.random()+"'></div>");
					}else if (/\.(mp4|swf|ogg|WebM)$/.test(name)) {
						cp.append("<div class='whimg'><video autobuffer='' controls='' src='"+name
								+"?ver="+Math.random()+"'></video></div>");
					}
					if (i==(data.cps.length-1)) {
						$("#editpage").find("#cpimg").val(name.split(".")[0]);
					}
					var aj={};
					aj.alink=name;
					aj.type="cp";
					alinklist.push(aj);
					}
				}
				if (data.xjs) {
					for (var i = 0; i < data.xjs.length; i++) {
						var name=data.xjs[i];
						if (/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(name)) {
						xj.append("<div class='whimg'><img src='"+name
								+"?ver="+Math.random()+"'></div>");
						}else if (/\.(mp4|swf|ogg|WebM)$/.test(name)) {
							xj.append("<div class='whimg'><video autobuffer='' controls='' src='"+name
									+"?ver="+Math.random()+"'></video></div>");
						}
						if (i==(data.xjs.length-1)) {
							$("#editpage").find("#xjimg").val(name.split(".")[0]);
						}
						var aj={};
						aj.alink=name;
						aj.type="xj";
						alinklist.push(aj);
					}
				}
				$("#editpage").find("#cpslimg").attr("src",data.sl);
//				imgclick();
			});	
			initNumInput();
		}
}
var imgselecturl="";//当前选择的url
var delimgurl="";//当前选择的url
var imgselect;
var imgupdate=false;
//var imgedit=[];//编辑数组
var alinklist=[];
var imgType="cp";
function imgLoadDiv(){
	var popdiv="<div class='whimg-box'>"
//		+"<div class='btn-whimg'><button type='button' class='btn btn-xs btn-default btn-whimg'>编辑</button>"	
//		+"<input type='file' name='imgEditFile' id='imgEditFile' onchange='imgEditUpload(this);'></div>"		
		+"<a href='#' class='btn btn-xs btn-default'>查看</a>"
		+"<button type='button' class='btn btn-xs btn-default' id='delimg'>删除</button>"
		+"<button type='button' class='whimg-close btn btn-xs btn-danger' id='closeimgdiv'>关闭</button>"
//		+"<button type='button' id='confirm'>确定</button>"
//		+"<div class='link-group'><label for=''>超链接</label><input type='text' id='alink'></div>"
		+"</div>";
	return popdiv;
}
function imdivclick(img,type){
//	imgselecturl="";
//	delimgurl="";
//	imgupdate=false;
	$("#editpage").find(".whimg-box").remove();
	var imgdiv=imgLoadDiv();
//	imgselect=img;
	img.after(imgdiv);
//	imgselecturl=img.attr("src").split("?")[0];
	$("#editpage").find(".whimg-box>a").attr("href","../pc/image-view.html?type=product&item_id="+$("#editpage").find("input[name='item_id']").val()+"&imgtype="+type);
	/////回显超链接/////
//	$.each(imgedit,function(i,n){
//		if (n.alink) {
//			if (n.type==type) {
//				if (n.aindex==imgselecturl) {
//					$("#editpage").find("#alink").val(n.alink);
//				}
//			}
//		}
//	});
//	if (imgedit.length<=0) {
//		if (alinklist.length>0) {
//			$.each(alinklist,function(i,n){
//				if (n.alink) {
//					if (n.type==type) {
//						if (imgselecturl.indexOf(n.alink)>0) {
//							$.get(imgselecturl.split(n.alink)[0]+n.alink.split(".")[0]+".json",function(data){
//								$("#editpage").find("#alink").val(data.url);
//							});
//						}
//					}
//				}
//			});
//		}
//	}
	$("#editpage").find(".whimg-box>#delimg").click(function(){
//		if (imgselect.attr("src").indexOf("temp")>0) {
//			pop_up_box.showMsg("正在编辑中不能删除!");
//			return;
//		}
		if (window.confirm("是否要删除该图片")) {
//			delimgurl=img.attr("src").split("?")[0];
//			$("#editpage").find(".whimg-box>#confirm").click();
		}
		 
	});
	$("#editpage").find(".whimg-box>#closeimgdiv").click(function(){
//		imgselecturl="";
//		delimgurl="";
//		imgupdate=false;
		$("#editpage").find(".whimg-box").remove();
	});
//	$("#editpage").find(".whimg-box>#confirm").click(function(){
//		var url={};
//		if (delimgurl!="") {
//			url.delimg=delimgurl;
//			imgselect.parent().remove();
//		}else if (imgupdate) {
//			if (imgselecturl.indexOf("temp")<0) {
//				url.oldimg=imgselecturl;
//				url.newimg=img.attr("src");
//			}
//		}
//		if ($("#editpage").find("#alink").val()!="") {
//			url.alink=$("#editpage").find("#alink").val();
//			url.aindex=imgselecturl;
//			url.type=type;
//		}
//		imgedit.push(url);
//		imgselecturl="";
//		delimgurl="";
//		imgupdate=false;
//		$("#editpage").find(".whimg-box").remove();
//	});
}
function imgclick(){
	$("#editpage").find("#cp").find("img").bind("click",function(){
		imgType="cp";
		imdivclick($(this), "cp"); 
	});
//	$("#editpage").find("#xj").find("img").bind("click",function(){
//		imgType="xj";
//		imdivclick($(this), "xj"); 
//	});
}
function imgEditUpload(t){
//	if (imgselecturl.indexOf("temp")>0) {
//		pop_up_box.showMsg("请保存后再修改!");
//		return;
//	}
//	if (imgselect.attr("src").indexOf("temp")>0) {
//		pop_up_box.showMsg("请保存后再修改!");
//		return;
//	}
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=imgEditFile&type="+imgType,
		"msgId":"msg",
		"fileId":"imgEditFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":500
	},t,function(imgurl){
		imgselect.attr("src","../"+imgurl+"?ver="+Math.random());
		$("#editpage").find(".whimg-box>a").attr("href","../"+imgurl);
		imgupdate=true;
		var url={"newimg":imgurl};
//		imgedit.push(url);
		$("#editpage").find(".whimg-box>#confirm").click();
	});
}
function imgUpload(t){
//	var cpimg=parseInt($("#editpage").find("#cpimg").val());
//	if (cpimg==5) {alert("已达到最大数请选择上传细节图");
//		return;
//	}
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=imgFile&type=cp",
		"msgId":"msg",
		"fileId":"imgFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":500
	},t,function(imgurl){
		if (/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(name)) {
			$("#editpage").find("#cp").append("<div class='whimg'><img src='"+imgurl
				+"?ver="+Math.random()+"'></div>");
		}else if (/\.(mp4|swf|ogg|WebM)$/.test(name)) {
			$("#editpage").find("#cp").append("<div class='whimg'><video autobuffer='' controls='' src='"+imgurl+"?ver="+Math.random()+"'></video></div>");
		}else{
			$("#editpage").find("#cp").append("<div class='whimg'><img src='"+imgurl+"?ver="+Math.random()+"'></div>");
		}
		var url={"newimg":imgurl};
//		imgedit.push(url);
//		$("#editpage").find("#cpimg").val(cpimg+1);
		imgclick();
	});
}
function imgUpxjload(t){
	var cpimg=parseInt($("#editpage").find("#xjimg").val());
	if (cpimg==100) {
		return;
	}
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=imgxjFile&type=xj",
		"msgId":"msg",
		"fileId":"imgxjFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":500
	},t,function(imgurl){
		if (/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(imgurl)) {
			$("#editpage").find("#xj").append("<div class='whimg'><img src='"+imgurl
				+"?ver="+Math.random()+"'></div>");
		}else if (/\.(mp4|swf|ogg|WebM)$/.test(imgurl)) {
			$("#editpage").find("#xj").append("<div class='whimg'><video autobuffer='' controls='' src='"+imgurl+"?ver="+Math.random()+"'></video></div>");
		}else{
			$("#editpage").find("#xj").append("<div class='whimg'><img src='"+imgurl+"?ver="+Math.random()+"'></div>");
		}
		var url={"newimg":imgurl};
//		imgedit.push(url);
		$("#editpage").find("#xjimg").val(cpimg+1);
//		imgclick();
	});
}

function imgSlUpload(t,key){
	pop_up_box.postWait(); 
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=cpsl",
		"msgId":"msg",
		"fileId":key,
		"msg":"图片",
		"fid":"",
		"uploadFileSize":50
	},t,function(imgurl){
		pop_up_box.loadWaitClose(); 
		$("#editpage").find("#cpslimg").attr("src",""+imgurl+"?ver="+Math.random());
		$("#editpage").find("input[name='cpslpath']").val(imgurl);
	});
}