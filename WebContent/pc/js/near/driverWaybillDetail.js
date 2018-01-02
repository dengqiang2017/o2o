$(function(){
	var seeds_id=common.getQueryString("seeds_id");
	if($(".secition-two-2 ul").length==0){
		$(".secition-two-2").html("订单已发货!");
	}
	$(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
		var b=$(this).hasClass("pro-checked");
		if (b) {
			$(this).removeClass("pro-checked");
		}else{
			$(this).addClass("pro-checked");
		}
	});
	var se=$.trim($(".secition-two-2").html());
	if(se==""){
		$(".footer2").html("该订单已出库!");
	}
	if(window.location.href.indexOf("huashenmuye")>=0){
		$(".dui").html("堆垛:");
		$(".zhes").show();
	}
	$("#beihuo").click(function(){
		var didian=$.trim($("#didian").val());
		if(didian==""){
			pop_up_box.showMsg("请输入司机提货仓门号");
			return;
		}
		pop_up_box.postWait();
		$.get("../orderTrack/noticeDrive.do",{
			"seeds_id":seeds_id,
			"didian":didian,
			"description":"拉货仓门:"+didian
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("提交成功!",function(){
					window.location.href="../employee/orderTracking.do";
				});
			} else {
				if (data.msg) {
					pop_up_box.showMsg("提交错误!" + data.msg);
				} else {
					pop_up_box.showMsg("提交错误!");
				}
			}
		});
	});
	$("#tzdrive").click(function(){
		if (confirm("是否确认装车完成,并通知司机过磅!")) {
			pop_up_box.postWait();
			$.get("../employee/noticeDriveGuard.do",{
				"seeds_id":seeds_id
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("提交成功!",function(){
						window.location.href="../employee.do";
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("提交错误!" + data.msg);
					} else {
						pop_up_box.showMsg("提交错误!");
					}
				}
			});
		}
	});
	$("#tzfhgly").click(function(){
		var phs=$(".pro-checked");
		if(phs&&phs.length>0){
			var seeds_id="";
			var customer_names="";
			for (var i = 0; i < phs.length; i++) {
				var ph=$(phs[i]).parents("ul").find("#seeds_id").html();
				var corp_sim_name=$(phs[i]).parents("ul").find("#corp_sim_name").html();
				if(seeds_id==""){
					seeds_id=ph;
				}else{
					seeds_id=ph+","+seeds_id;
				}
				if(customer_names==""){
					customer_names=corp_sim_name;
				}else{
					if(customer_names.indexOf(corp_sim_name)<0){
						customer_names=customer_names+","+corp_sim_name;
					}
				}
			}
			if (confirm("是否确认装车完成并通知客户收货!")) {
				pop_up_box.postWait();
				$.get("../employee/saveHandle.do",{
					"seeds_id":seeds_id,
					"new":"new",
					"customer_names":customer_names,
					"name":$("#Status_OutStore").html(),
					"type":"已发货",
					"msg":"货物已装车出库，请注意收货并验收",
					"addName":"description",
					"description":"您有订单产品装车出库，请注意收货并验收，届时将有司机联系您。点开消息查看清单并验收（此条信息重要，务请保留，直至收货验收完毕）",
					"shipped":"已发货"
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("提交成功!",function(){
							window.location.href="../employee.do";
						});
					} else {
						if (data.msg) {
							pop_up_box.showMsg("提交错误!" + data.msg);
						} else {
							pop_up_box.showMsg("提交错误!");
						}
					}
				});
			}
		}else{
			pop_up_box.showMsg("请选择出库产品!");
		}
	});
////////////////////
	$(".showimg").click(function(){
		var list=$(this).next();
		var t=$(this);
		var item_id=$.trim($(this).parents("ul").find("#item_id").html());
		var com_id=$.trim($(this).parents("ul").find("#com_id").html());
		pop_up_box.loadWait();
		$.get("../product/getImgUrl.do",{
			"item_id":item_id,
			"com_id":com_id
		},function(data){
			t.hide();
			pop_up_box.loadWaitClose();
			if (data.cps) {
				list.append("<li data-src='"+data.cps[0]+"'><a class='btn btn-info btn-sm'>看实物图</a><img src='"+data.cps[0]+"' /></li>");
				for (var i = 1; i < data.cps.length; i++) {
					var name=data.cps[i];
					var li=$("<li data-src='"+name+"'><img src='"+name+"' /></li>");
					list.append(li);
					li.hide();
				}
				list.lightGallery({
					loop:true,
					auto:false
				});
				list.find("li:eq(0)").click();
			}
		}); 
	});
});