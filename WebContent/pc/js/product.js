﻿var productEdit={
		init:function(){
			$("#editpage").show();
			var item_id=$("#editpage").find("input[name='item_id']");
			editUtils.editinit("getProductInfo",item_id.val(),function(data){
				if(item_id.val()){
					$("#detail").unbind("click");
					$("#detail").click(function(){
						var item_name=$("#editpage").find("input[name='item_name']");
						var j=$("th").index($("th[data-name='detail_num']"));
						var t=$("td:input[value='"+item_id.val()+"']").parents("tr").find("td:eq("+j+")>span");
						var detail_num=t.html();
						edithtml.init($("#com_id").html(),item_id.val(),item_name.val(),detail_num,t,true);
						$("#editpage").hide();
						$("#listpage").hide();
					});
				}else{
					$("#detail").click(function(){
						pop_up_box.showMsg("请先保存后在列表中直接编辑产品详情图文编辑操作!");
					});
				}
			});
			$("#cp").sortable();
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
					 var imgs=$(".upload-img:eq(0) img");
					 var mainImgs=[];
					 for (var i = 0; i < imgs.length; i++) {
						var img=$(imgs[i]);
						var path=img.attr("src").split("?")[0];
						if(path){
							mainImgs.push(path);
						}
					}
					 if(mainImgs.length>0){
						 json.mainImg=mainImgs.join(",");
						 json.main_img=mainImgs.length;
					 }else{
						 json.main_img=0;
					 }
					 var coverImg=$(".upload-img:eq(1) img").attr("src");
					 if(coverImg.indexOf("pcxy")>=0){
						 coverImg="";
						 json.cover_img=0;
					 }else{
						 json.coverImg=coverImg.split("?")[0];
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
									}else if(name=="main_img"){
										tr.find("td:eq("+j+")").html(json.main_img);
									}else if(name=="cover_img"){
										tr.find("td:eq("+j+")").html(json.cover_img);
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
			cp.html("");
			if(item_id.val()){
				pop_up_box.loadWait();
				var imgPath="/"+$("#com_id").html()+"/img/"+item_id.val()+"/";
				$.get(imgPath+"cp.txt?ver="+Math.random(),function(data){
					pop_up_box.loadWaitClose();
					if (data) {
						data=data.split(",");
						for (var i = 0; i < data.length; i++) {
							if(data[i]!=""){
								cp.append("<div class='whimg'><img src='"+data[i]
								+"?ver="+Math.random()+"'></div>");
							}
						}
						imgclick();
					}
				});
				$("#editpage").find("#cpslimg").attr("src",imgPath+"sl.jpg");//缩略图
			}
			initNumInput();
		}
}
function imgLoadDiv(){
	var popdiv="<div class='whimg-box'>"
		+"<a href='#' class='btn btn-xs btn-default'>查看</a>"
		+"<button type='button' class='btn btn-xs btn-default' id='delimg'>删除</button>"
		+"<button type='button' class='whimg-close btn btn-xs btn-danger' id='closeimgdiv'>关闭</button>"
		+"</div>";
	return popdiv;
}
function imdivclick(img,type){
	$("#editpage").find(".whimg-box").remove();
	var imgdiv=imgLoadDiv();
	img.after(imgdiv);
	$("#editpage").find(".whimg-box>a").attr("href","../pc/image-view.html?type=product&item_id="+$("#editpage").find("input[name='item_id']").val()+"&imgtype="+type);
	$("#editpage").find(".whimg-box>#delimg").click(function(){
		if (window.confirm("是否要删除该图片,删除后将不能恢复?")) {
			var whimg=$(this).parents(".whimg");
			var imgUrl=whimg.find("img").attr("src").split("?")[0];
			imgUrl=imgUrl.replace("..", "");
			$.get("../upload/removeTemp.do",{
				"imgUrl":imgUrl
			},function(data){
				whimg.remove();
			});
		}
	});
	$("#editpage").find(".whimg-box>#closeimgdiv").click(function(){
		$("#editpage").find(".whimg-box").remove();
	});
}
function imgclick(){
	$("#editpage").find("#cp").find("img").bind("click",function(){
		imdivclick($(this), "cp"); 
	});
}
function imgUpload(t){
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=imgFile&type=cp",
		"msgId":"msg",
		"fileId":"imgFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":500
	},t,function(imgurl){
		$("#editpage").find("#cp").append("<div class='whimg'><img src='"+imgurl
				+"?ver="+Math.random()+"'></div>");
		imgclick();
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