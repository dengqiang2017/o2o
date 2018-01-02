//页面传递参数
var seeds_id = null;

//当前派工
paigongInfo = null;

$(function(){
	seeds_id = $.trim($("#seeds_id").html());
	
	(function(){		
		pop_up_box.loadWait();
		$.get("../pm/getDispatchingWorkBySeedsID.do", {
			"seeds_id" : seeds_id,
			"ver" : Math.random()
		},function(data) {
			pop_up_box.loadWaitClose();
			paigongInfo = data;
			setData(data);
		});
	})();
	
	//返回
	$(".glyphicon-menu-left").click(function(){
		history.back();
	});
	
	//减少
	$("#less").click(function(){
		$("#JJSL").val($("#JJSL").val()-1);
		if($("#JJSL").val()<1){
			$("#JJSL").val(1);
		}
	});
	
	//增加
	$("#more").click(function(){
		var sl = paigongInfo.PGSL - paigongInfo.JJSL
		$("#JJSL").val($("#JJSL").val()-0+1);
		if($("#JJSL").val()>sl){
			$("#JJSL").val(sl);
		}
	});
	
	//质检
	$("#qualityTesting").click(function(){
		qualityTesting();
	});
});

//替换""、null为-
var ifNone = function(prop){
	if(prop){
		return prop;
	}else{
		if(prop === 0){
			return 0;
		}else{
			return "-";
		}
	}
};

//设置前端页面值
var setData = function(data){
	$("#ivt_oper_listing").html(ifNone(data.ivt_oper_listing));
	$("#PH").html(ifNone(data.PH));
	$("#paigong_id").html(ifNone(data.paigong_id));
	$("#work_name_PGSL").html(ifNone(data.work_name)+" | "+ifNone(data.PGSL));
	$("#WGSJ").html(ifNone(data.WGSJ_10));
	$("#item_name").html(ifNone(data.item_name));
	$("#item_spec_type").html(ifNone(data.item_spec)+" | "+ifNone(data.item_type));
	$("#calss_card_item_color").html(ifNone(data.class_card)+" | "+ifNone(data.item_color));
	$("#vendor_id").html(ifNone(data.vendor_id));
	$("#c_memo").html(ifNone(data.c_memo));
	$("#memo_color").html(ifNone(data.memo_color));
	$("#memo_other").html(ifNone(data.memo_other));
	$("#JJSL").val(data.PGSL-data.JJSL);
};

//质检
var qualityTesting = function(){
	var sl = paigongInfo.PGSL - paigongInfo.JJSL;
	if($("#JJSL").val()<1){
		pop_up_box.showMsg("请输入质检通过数量!");
		return;
	}
	if($("#JJSL").val()>sl){
		pop_up_box.showMsg("您输入的质检通过数量大于可通过的数量!");
		$("#JJSL").val(sl);
		return;
	}
	if(seeds_id && $("#JJSL").val()){
		pop_up_box.loadWait();
		$.get("../pm/qualityTest.do", {
			"seeds_id" : seeds_id,
			"JJSL" : $("#JJSL").val(),
			"PH" : paigongInfo.PH,
			"item_id" : paigongInfo.item_id,
			"work_id" : paigongInfo.work_id,
			"work_type" : paigongInfo.work_type,
			"No_serial" : paigongInfo.No_serial,
			"ver" : Math.random()
		},function(data) {
			pop_up_box.loadWaitClose();
			if(data.success){
				pop_up_box.showMsg("质检成功!",function(){
					window.location.reload();
				});
			}else{
				pop_up_box.showMsg("质检失败!");
			}
		});
	}
};