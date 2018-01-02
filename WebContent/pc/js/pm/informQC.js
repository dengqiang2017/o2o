$(function(){
	//初始化
	$(".hide").each(function(n){
		$(n).hide();
	});
	//按产品生产型企业隐藏查看工艺图纸
	if($("#PlanSource").html()=="0"){
		$("#gytz").hide();
	}
	
	(function(){
		pop_up_box.loadWait();
		$.get("../pm/getInformQC.do", {
			"clerk_id" : $.trim($("#clerk_id").html()),
			"ver" : Math.random()
		},function(data) {
			pop_up_box.loadWaitClose();
			addItem(data);
		});
	})();
	
	//返回
	$(".glyphicon-menu-left").click(function(){
		history.back();
	});
}); 

//增加表行记录
var addItem = function(data){
	//初始化
	props = $("#props");
	prop = $("#prop");
	props.html("");

	if (data && data.length > 0) {
		$.each(data,function(i, n){
			var p = prop.clone();
			p.find("#seeds_id").html(n.seeds_id);
			p.find("#work_id").html(n.work_id);
			p.find("#work_type").html(n.work_type);
			p.find("#No_serial").html(n.No_serial);
			p.find("#item_id").html(n.item_id);
			p.find("#ivt_oper_listing").html(n.ivt_oper_listing);
			p.find("#PH").html(n.PH);
			p.find("#paigong_id").html(n.paigong_id);
			p.find("#clerk_name").html(n.clerk_name);
			p.find("#work_name").html(n.work_name);
			p.find("#PGSL").html(n.PGSL);
			p.find("#WGSJ").html(n.WGSJ_10);
			p.find("#item_name").html(n.item_name);
			p.find("#item_spec").html(n.item_spec);
			p.find("#item_type").html(n.item_type);
			p.find("#vendor_id").html(n.vendor_id);
			p.find("#class_card").html(n.class_card);
			p.find("#item_color").html(n.item_color);
			p.find("#c_memo").html(n.c_memo);
			p.find("#memo_color").html(n.memo_color);
			p.find("#memo_other").html(n.memo_other);
			p.find("#sendInformQC").attr("onclick","sendInformQC(this)");
			if(n.status == "0"){
				p.find("#beginWork").attr("onclick","beginWork(this)");
			}else{
				p.find("#beginWork").html(n.status_trans+"...");
				p.find("#beginWork").attr("disabled",true);
			}
			props.append(p);
		});
	}
};

//通知质检
var sendInformQC = function(data){
	var dom = $(data).parent();
	var seeds_id = dom.find("#seeds_id").html();
	var PH = dom.find("#PH").html();
	var item_id = dom.find("#item_id").html();
	var work_id = dom.find("#work_id").html();
	var work_type = dom.find("#work_type").html();
	var No_serial = dom.find("#No_serial").html();

	pop_up_box.loadWait();
	$.get("../pm/sendInformQC.do", {
		"seeds_id" : seeds_id,
		"PH" : PH,
		"item_id" : item_id,
		"work_id" : work_id,
		"work_type" : work_type,
		"No_serial" : No_serial,
		"ver" : Math.random()
	},function(data) {
		pop_up_box.loadWaitClose();
		if(data.success){
			pop_up_box.showMsg("通知成功!",function(){
				window.location.reload();
			});
		}else{
			pop_up_box.showMsg("通知失败!");
		}
	});
};

//开始生产
var beginWork = function(data){
	var dom = $(data).parent();
	var seeds_id = dom.find("#seeds_id").html();
	pop_up_box.loadWait();
	$.get("../pm/beginWork.do", {
		"seeds_id" : seeds_id,
		"ver" : Math.random()
	},function(data) {
		pop_up_box.loadWaitClose();
		if(data.success){
			pop_up_box.showMsg("提交成功!",function(){
				window.location.reload();
			});
		}else{
			pop_up_box.showMsg("提交失败!");
		}
	});
};

//查看工艺图纸
var seegytz = function(data){
	var prop = $(data).parent().parent();
	var PH = prop.find("#PH").html();
	var JHGR = $("#clerk_id").html();
	//获取工艺图纸名称
	pop_up_box.loadWait();
	$.get("../pm/seegytz.do", {
		"PH" : PH,
		"JHGR" : JHGR,
		"ver" : Math.random()
	},function(data) {
		pop_up_box.loadWaitClose();
		if(data.length>0){
			for(p in data){
				var dom = "<img src='../"+com_id+"/img/SCPG/"+PH+"/"+JHGR+"/"+data[p]+"' " +
						"onclick='javascript:window.open(this.src)' style='cursor:hand'>";
				$(dom).click();
			}
		}else{
			pop_up_box.showMsg("没有上传工艺图纸!");
		}
	});
};