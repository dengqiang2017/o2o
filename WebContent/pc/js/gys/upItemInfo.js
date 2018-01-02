$(function(){
	var ivt_no=window.location.href.split("?")[1];
	if(!ivt_no){
		pop_up_box.showMsg("参数错误!",function(){
			history.go(-1);
		});
		return;
	}
	$.get("getGysUpItemInfoList.do",{
		"ivt_no":ivt_no
	},function(data){
		if(data){
			var data=data[0];
			$("#item_name").html(data.item_name);
			$("#num").html(data.num);
			$("#price").html(data.price);
			$(".item_unit").html(data.item_unit);
			$(".date_box").html(data.at_time);
			if(data.imgs&&data.imgs.length>0){
				$(".img-responsive").attr("src",data.imgs[0]);
			}
			$(".btn_box button:eq(0)").click({
				"ivt_no":ivt_no,
				"corp_name":data.corp_name,
				"weixinID":data.weixinID,
				"movtel":data.movtel
				},function(event){//通过
				pop_up_box.postWait();
				$.post("../employee/updateGysProFlag.do",{
					"weixinID":event.data.weixinID,
					"movtel":event.data.movtel,
					"flag":1,
					"ivt_no":event.data.ivt_no,
					"title":"上报产品信息-确认通过通知",
					"description":"@comName-"+event.data.corp_name+":您上报的产品信息,@comName采购已经确认通过"
					},function(data){
						pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("提交成功!",function(){
//							window.location.href="../employee.do";
							$(".btn_box button:eq(1)").hide();
							$(".btn_box button:eq(0)").hide();
						});
					} else {
						if (data.msg) {
							pop_up_box.showMsg("保存错误!" + data.msg);
						} else {
							pop_up_box.showMsg("保存错误!");
						}
					}
				});
			});
			$(".btn_box button:eq(1)").click({
				"ivt_no":ivt_no,
				"corp_name":data.corp_name,
				"weixinID":data.weixinID,
				"movtel":data.movtel
				},function(event){//不通过
				pop_up_box.postWait();
				$.post("../employee/updateGysProFlag.do",{
					"weixinID":event.data.weixinID,
					"movtel":event.data.movtel,
					"flag":2,
					"ivt_no":event.data.ivt_no,
					"title":"上报产品信息-确认不通过通知",
					"description":"@comName-"+event.data.corp_name+":您上报的产品信息,@comName采购确认不通过"
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("提交成功!",function(){
//							window.location.href="../employee.do";
							$(".btn_box button:eq(1)").hide();
							$(".btn_box button:eq(0)").hide();
						});
					} else {
						if (data.msg) {
							pop_up_box.showMsg("保存错误!" + data.msg);
						} else {
							pop_up_box.showMsg("保存错误!");
						}
					}
				});
			});
			$(".btn_box button:eq(2)").click({"item_id":data.item_id,"price":data.price},function(event){//修改单价
				pop_up_box.postWait();
				$.post("../manager/updateProPrice.do",{
					"item_id":event.data.item_id,
					"price":event.data.price
				},function(){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("提交成功!",function(){
//							window.location.href="../employee.do";
							$(".btn_box button:eq(2)").hide();
						});
					} else {
						if (data.msg) {
							pop_up_box.showMsg("保存错误!" + data.msg);
						} else {
							pop_up_box.showMsg("保存错误!");
						}
					}
				});
			});
		}else{
			pop_up_box.showMsg("获取数据失败");
		}
	});
	
    $('.box02>.pull-left,#mymodal>img').click(function(){
        $("#mymodal").modal("toggle");
    });
    $('.box02>.pull-left>img').click(function(){
        var s=$(this).attr("src");
        $('#mymodal img').attr('src',s);
    });
});