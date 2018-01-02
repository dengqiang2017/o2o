$(function(){
	function importImg(sig){///保存
		var data=$.trim(sig.jSignature('getData'));
		if (data.length>1000) {
			$("#qianming").attr("src",data);
			$("#signature,#clear").remove();
			$("#qianming").show();
			return false;
		}else{
			alert("请签名!");
			return true;
		}
	}
	
	$("#signature").jSignature();
	var height=$('#signature').css("height");
	var width=$('#signature').css("width");
	$('#signature').find("canvas").css("height",height);
	$('#signature').find("canvas").attr("height",height.substring(0,3));
	$('#signature').find("canvas").css("width",document.body.clientWidth+"px");
	$('#signature').find("canvas").attr("width",document.body.clientWidth);
	$('#signature').jSignature('clear');
//	$.removeCookie("orderparams",{path:'/'});
//	$("img").hide();
	$("#qrys").click(function(){
		if(!$("input[type='checkbox']").prop("checked")){
			pop_up_box.showMsg("请阅读客户收货确认须知!");
			return;
		}
		if (importImg($('#signature'))) {
			return;
		}
//		var itemname=$(".itemname:eq(0)").html();
//		for (var i = 0; i < $(".itemname").length; i++) {
//			var ina=$(".itemname:eq(0)").html();
//			if (ina) {
//				itemname=itemname+ina;
//			}
//		}
		pop_up_box.postWait();
		var params=window.location.href.split("?");
		var orders="";
		var orderNo="";
		var item_id="";
		var seeds_id="";
		if(params.length>=3){
			params=params[1].split("&");
			orderNo =params[0].split("=")[1];//orderNo
			item_id =params[1].split("=")[1];//item_id
			seeds_id=params[2].split("=")[1];//seeds_id
		}else{
			orders=$.cookie("orderparams");
		}
		$.post("confimShouhuo.do",{
			"orderNo":orderNo,
			"item_id":item_id,
			"seeds_id":seeds_id,
			"orders":orders,
			"m_flag":5,
//			"description":itemname,
			"img":$("#qianming").attr("src")
			},function(data){
				pop_up_box.loadWaitClose();
			if (data.success) {
//				$('#mymodal2').hide();
//				$("#mymodal").modal("toggle");
				window.location.href="myorder.do";
			} else {
				if (data.msg) {
					pop_up_box.showMsg("提交错误!" + data.msg);
				} else {
					pop_up_box.showMsg("提交错误!");
				}
			}
		});	 
	});
	$("#mymodal").find("a:eq(0)").attr("href","pingjia.do?"+window.location.href.split("?")[1]);
	var show=$("#show").val();
	if(show){
		$("#qianshou,#qs_btn").hide();
		$("#qianming").show();
	}
});