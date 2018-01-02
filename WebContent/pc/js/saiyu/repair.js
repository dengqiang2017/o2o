$("a[data-head]").unbind("click");
$("a[data-head]").click(function(){
	window.location.href="../pc/index.html";
});
var repair={
		init:function(){
			$(".add").unbind("click");
			$(".add").click(function(){
				var num=parseFloat($(this).parent().find("#pronum").val());
				if (!num) {
					num=0;
				}
				$(this).parent().find("#pronum").val(num+1);
				$(this).parent().find("#pronum").blur();
			});
			$(".sub").unbind("click");
			$(".sub").click(function(){
				var num=parseFloat($(this).parent().find("#pronum").val());
				if (!num) {
					$(this).parent().find("#pronum").val(1);
				}else{
					$(this).parent().find("#pronum").val(num-1);
				}
				$(this).parent().find("#pronum").blur();
			});
			
			$(".item").find(".btn-sm").unbind("click");
			$(".item").find(".btn-sm").click(function(){
				liulan=$(this).parent().prev();
				var val=liulan.val();
				var n=$(this).parents(".item").find(".btn-sm").index(this);
				if(n==0){
					var itemhtml=$.trim($(".zz3").find("#positem").html());
					if(itemhtml==""){
						$.get("getPosition.do",function(data){
							$.each(data,function(i,n){
								if(ifnull(n.position_big)!=""){
								$(".zz3").find("#positem").append(getulli(n.position_big));
								}
							});
							$(".zz3").find("#positem").find("li").click(function(){
								liulan.val($(this).html());
								$(".zz3,.cover").hide();
							});
							$(".zz3,.cover").show();
						});
					}else{
						$(".zz3,.cover").show();
					}
				}else{
					var itemhtml=$.trim($(".zz5").find("#itemnameitem").html());
					if(itemhtml==""){
					$.get("getItemBrand.do",{
						"position_big":liulan.parents(".row").find("input[name='position_big']").val()
					},function(data){
						$.each(data,function(i,n){
							if(ifnull(n.item_name)!=""){
								$(".zz5").find("#itemnameitem").append(getulli(n.item_name));
							}
						});
						$(".zz5").find("#itemnameitem").find("li").click(function(){
							liulan.val($(this).html());
							$(".zz5,.cover").hide();
						});
					});
					    $(".zz5,.cover").show();
					}else{
						$(".zz5,.cover").show();
				    }
				}
			});
			$(".additem").unbind("click");
			$(".additem").click(function(){
				var item=$($("#item").html());
				$("form").append(item);
				item.find("img0").attr("src","../pc/repair-images/camero.png");
				item.find("input").val("");
				repair.init();
				window.location.href=window.location.href+"#cop";
			});
			initNumInput(); 
		}
}
var liulan;
function getulli(name){
	return '<ul class="hide-msg"><li class="col-xs-12">'+name+'</li></ul>';
}
$(function(){
	repair.init();
	///////////////
    $('.cover').click(function(){
        $('.cover').hide();
        $('.zz5').hide();
        $('.zz3').hide();
    });
	/////////////////////////
    
    ///////////////
	$("#save").click(function(){
		if ($("#item").length<=0) {
			postRepair();
			return;
		}
		var params=[];
		var items=$(".item");
		for (var i = 0; i < items.length; i++) {
			var item=$(items[i]);
			var item_name=item.find("input[name='item_name']").val();
			var positionImg=item.find("input[name='positionImg']").val();
			var position_big=item.find("input[name='position_big']").val();
			var position=item.find("input[name='position']").val();
			var typeImg=item.find("input[name='typeImg']").val();
			var num=item.find("input[name='num']").val();
			var date=item.find("input[name='date']").val();
			var param={};
			if (position_big!=""&&position!="") {
				param.position_big=position_big;
				param.position=position;
				if (item_name) {
					param.item_name=item_name;
				}
				if (num) {
					param.num=num;
				}
				if (positionImg) {
					param.positionImg=positionImg;
				}
				if (typeImg) {
					param.typeImg=typeImg;
				}
				if (date) {
					param.date=date;
				}
				params.push(JSON.stringify(param));
			}
		}
		if(params.length>0){
			pop_up_box.postWait();
			$.post("saveRepair.do",{
				"approval_step":$("#approval_step").val(),
				"items":params
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.showMsg("数据提交成功!",function(){
						getContainerHtml("repair.do");
					});
				}else{
					if(data.msg){
						pop_up_box.showMsg(data.msg);
					}else{
						pop_up_box.showMsg("数据提交失败!");
					}
				}
			});
		}else{
			pop_up_box.showMsg("请输入损坏位置和楼层!");
		}
	});
	///提交报修信息
	function postRepair(){
		var item=$(".item");
		var item_name=item.find("input[name='item_name']").val();
		var positionImg=item.find("input[name='positionImg']").val();
		var position_big=item.find("input[name='position_big']").val();
		var position=item.find("input[name='position']").val();
		var typeImg=item.find("input[name='typeImg']").val();
		var num=item.find("input[name='num']").val();
		if (position_big!=""&&position!="") {
			var param={};
			param.position_big=position_big;
			param.position=position;
			if (item_name) {
				param.item_name=item_name;
			}
			if (num) {
				param.num=num;
			}
			if (positionImg) {
				param.positionImg=positionImg;
			}
			if (typeImg) {
				param.typeImg=typeImg;
			}
			pop_up_box.postWait();
			$.post("saveRepair.do",param,function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.showMsg("数据提交成功!",function(){
						getContainerHtml("repair.do");
					});
				}else{
					if(data.msg){
						pop_up_box.showMsg(data.msg);
					}else{
						pop_up_box.showMsg("数据提交失败!");
					}
				}
			});
		}else{
			pop_up_box.showMsg("请输入损坏位置和楼层!");
		}
	}
});
function imgUpload(t,key) {
	ajaxUploadFile({
		"uploadUrl" : "../upload/uploadImage.do?fileName="+key,
		"msgId" : "msg",
		"fileId" : key,
		"msg" : "图片",
		"fid" : "",
		"uploadFileSize" : 5
	}, t, function(imgurl) {
		$("#"+key).parents(".section-img").find("#filePath").val(imgurl);
		$("#"+key).parents(".section-img").find("img").attr("src",
				"../" + imgurl + "?ver=" + Math.random());
		pop_up_box.dataHandling("图片回显中!");
		$("#"+key).parents(".section-img").find("img").load(function(){
			pop_up_box.loadWaitClose();
		});
	});
}