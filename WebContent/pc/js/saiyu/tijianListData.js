$(function(){
	var tdnames=$("tr>td[data-name]");
	var json={};
	for (var i = 0; i < tdnames.length; i++) {
		var td=$(tdnames[i]);
		var tr=$(tdnames[i]).parent();
		var key=td.attr("data-name");
		var val=td.html();
		if(key.indexOf("corp_sim_name")>=0){
		
		}else{
			json[key]=val;
		}
		var imgkey=td.parent().find("td[data-imge]").attr("data-imge");
		tr.find("td[data-imge]").html("<img src='sl.png'>"+fileimghtml(imgkey));
		tr.find("td[data-name-num]").html("<input>");
		tr.find("td[data-select]").html('<span></span><button type="button" class="btn btn-primary" onclick="selectproduct(this);" style="position:absolute;bottom:0;left:7px">推荐产品</button>');
		if(imgkey){
			var imgpath=td.parent().find("td[data-imge]>img").attr("src");
			json[imgkey]=imgpath;
		}
		//////客户使用时/////
//		if(key.indexOf("_id")>=0){
//			td.remove();
//		}
//		if(key.indexOf("corp_sim_name")>=0){
//			td.remove();
//		}
//		if(key.indexOf("use_oq")>=0){
//			td.remove();
//		}
	}
	
	function fileimghtml(imgkey){
		 var hm="<button type='button' class='btn btn-primary' style='position: relative;width: 50%'>"+
           "<input type='file'  id='"+imgkey+"' name='"+imgkey+"' onchange='imgUpload(this,\""+imgkey+"\",\""+imgkey+"\")' style='opacity:0;left: 0;top: 0;width: 100%;height: 100%;position: absolute;'>"+
         "选择文件</button>";
		 return hm;
	}
	tdinit();
	function tdinit(){
		$("tr>td[data-name]").unbind("dblclick");
		$("tr>td[data-name]").dblclick(function(){
			$(this).html("<input value='"+$(this).html()+"'>");
			var t=$(this);
			$(this).find("input").blur(function(){
				t.html($(this).val());
			});
			$(this).find("input").focus().select();
		});
		////
		$("tr>td:eq(0)>button:eq(1)").unbind("click");
		$("tr>td:eq(0)>button:eq(1)").click(function(){
			if (confirm("是否删除当前记录!")) {
				var ivt_oper_listing=$.trim($(this).parent().next().html());
				var t=$(this);
				if (ivt_oper_listing) {
					$.get("deltijian.do",{
						"ivt_oper_listing":ivt_oper_listing
					},function(data){
						if (data.success) {
							pop_up_box.showMsg("删除成功!",function(){
								t.parents("tr").remove();
							});
						} else {
							if (data.msg) {
								pop_up_box.showMsg("删除错误!" + data.msg);
							} else {
								pop_up_box.showMsg("删除错误!");
							}
						}
					});
				}else{
					if(confirm("该记录没有保存过是否删除!")){
						$(this).parents("tr").remove();
					}
				}
			}
		});
		///行基本数据保存于推荐数据保存
		$("tr>td:eq(0)>button:eq(0)").unbind("click");
		$("tr>td:eq(0)>button:eq(0)").click(function(){
			var tr=$(this).parents("tr");
			var position_big=$.trim(tr.find("td[data-name='position_big']").html());
			var position=$.trim(tr.find("td[data-name='position']").html());
			var item_name=$.trim(tr.find("td[data-name='item_name']").html());
			if (position_big=="") {
				pop_up_box.showMsg("请输入位置大类!");
			} else if (position=="") {
				pop_up_box.showMsg("请输入位置小类!");
			}else if(item_name==""){
				pop_up_box.showMsg("请输入灯具名称!");
			}else{
				var tdnames=tr.find("td[data-name]");
				var json={};
				var td=tdnames;
				var key=td.attr("data-name");
				var val=td.html();
				if(key.indexOf("corp_sim_name")>=0){
					
				}else{
					if (val) {
						json[key]=val;
					}
				}
				var imgkey=tr.find("td[data-imge]").attr("data-imge");
				if(imgkey){
					var imgpath=tr.find("td[data-imge]>img").attr("src");
					if (imgpath) {
						json[imgkey]=imgpath;
					}
				}
				var numkey=tr.find("td[data-name-num]").attr("data-name-num");
				if(numkey){
					var numval=tr.find("td[data-name-num]>input").val();
					if (numval) {
						json[numkey]=numval;
					}
				}
				var idkey=tr.find("td[data-id]").attr("data-id");
				if(idkey){
					var idval=tr.find("td[data-id]").html();
					if (idval) {
						json[idkey]=idval;
					}
				}
				var usekey=tr.find("td[data-use]").attr("data-use");
				if(usekey){
					var useval=tr.find("td[data-use]").html();
					if (useval) {
						json[usekey]=useval;
					}
				}
				console.debug(json);
				console.debug(json);
			}
		});
	}
	////客户使用时
//	$("th[data-bm='bm']").remove();
//	$("th[colspan='5']").attr("colspan","3");
	function addTdHtml(){
		var tr=$("<tr>"+$("tbody>tr:eq(0)").html()+"</tr>");
		$("tbody>tr:eq(0)").before(tr);
		tr.find("td").html("");
		tr.find("td:eq(0)").html('<button type="button" class="btn btn-primary">保存</button><button type="button" class="btn btn-primary">删除</button>');
		tr.find("td[data-client]").html('<span></span><button type="button" class="btn btn-primary" onclick="selectclient(this);" style="position:absolute;bottom:0;left:7px">选择客户</button>');
		tr.find("td[data-select]").html('<span></span><button type="button" class="btn btn-primary" onclick="selectproduct(this);" style="position:absolute;bottom:0;left:7px">推荐产品</button>');
		tr.find("td[data-name-num]").html('<input data-num="num">');
		for (var i = 0; i < tr.find("td[data-imge]").length; i++) {
			var item=$(tr.find("td[data-imge]")[i]);
			var imgkey=item.attr("data-imge");
			item.html(fileimghtml(imgkey));
		}
		tdinit();
	}
	$("#addtd").click(function(){
		addTdHtml();
	});
	
	$("#saveData").click(function(){
		var tdnames=$("tr>td[data-name]");
		var list=[];
		for (var i = 0; i < tdnames.length; i++) {
			var json={};
			var td=$(tdnames[i]);
			var key=td.attr("data-name");
			var val=td.html();
			if(key.indexOf("corp_sim_name")>=0){
			
			}else{
				json[key]=val;
			}
			var imgkey=td.parent().find("td[data-imge]").attr("data-imge");
			if(imgkey){
				var imgpath=td.parent().find("td[data-imge]>img").attr("src");
				json[imgkey]=imgpath;
			}
			var numkey=td.parent().find("td[data-name-num]").attr("data-name-num");
			if(numkey){
				var numval=td.parent().find("td[data-name-num]>input").val();
				json[numkey]=numval;
			}
			list.push(json);
		}
		console.debug(list.length);
		console.debug(list);
	});

});
function imgUpload(t,key,img){
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName="+key+"&type=tijian&imgName="+img,
		"msgId":"msg",
		"fileId":key,
		"msg":"图片",
		"fid":"",
		"uploadFileSize":50
	},t,function(imgurl){
		if ($("#"+key).parent().find("img").length>0) {
			$("#"+key).parent().find("img").attr("src",".."+imgurl+"?ver="+Math.random());
		}else{
			$("#"+key).before("<img src='.."+imgurl+"'>");
		}
	});
}
function selectclient(t){
	pop_up_box.loadWait(); 
	   $.get("../manager/getClientTree.do",{"ver":Math.random()},function(data){
		   pop_up_box.loadWaitClose();
		   $("body").append(data);
		   client.init(function(id,name){
			   $(t).parent().prev().html(id);
			   $(t).prev().html(name);
		   });
	   });
}
function selectproduct(t){
	 $.get("../tree/productSelect.do",function(data){
		   pop_up_box.loadWaitClose();
		   $("body").append(data);
		   product.init(function(){
			   $(t).parent().prev().html($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
			   $(t).prev().html($(".modal").find("tr.activeTable").find("td:eq(1)").text());
			   $(t).parent().next().html($(".modal").find("tr.activeTable").find("td:eq(6)").text());
			   $(t).parent().next().next().html($(".modal").find("tr.activeTable").find("td:eq(5)").text());
			   $(t).parent().next().next().next().html($(".modal").find("tr.activeTable").find("td:eq(5)").text());
		   });
	   });
}