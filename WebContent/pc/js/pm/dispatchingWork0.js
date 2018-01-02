/**
 * 按产品下生产计划
 * */
//排产编号【通过参数传递获取】
PH = null;
//派工单号【通过参数传递获取每次刷新页面时更新,可手工更改】
paigong_id = null;
//系统派工单号【通过参数传递获取每次刷新页面时更新，不可手工更改】
auto_paigong_id = null;
//消息推送方式【0流程型、1离散型】
PlanPush = null;
//生产计划【通过排产编号查询】
productionPlan = null;
//派工信息【通过排产编号查询，派工信息变化时重新获取】
dispatchingWorkArr = null;

$(function(){
	//获取排产编号
	PH = $.trim($(".PH").html());
	//获取派工单号
	paigong_id = $.trim($(".paigong_id").html());
	//获取系统派工单号
	auto_paigong_id = paigong_id;
	//获取派工单号
	PlanPush = $.trim($(".PlanPush").html());
	
	//查找
	(function(){
		var data = {
			"PH" : PH,
			"ver" : Math.random()
		}
		
		//获取生产计划信息
		pop_up_box.loadWait();
		$.ajax({ 
			type : "GET", 
			url  : "../pm/getProductionPlanning.do", 
			cache : false, 
			async : false, 
	        dataType : "json", 
	        data : data,
	        success: function(data){
	        	pop_up_box.loadWaitClose();
	        	productionPlan = data;
	        	$("#ivt_oper_listing").html(data.ivt_oper_listing);
	        	$("#PH").html(data.PH);
	        	$("#item_name").html(data.item_name);
	        	$("#item_spec").html(data.item_spec);
	        	$("#item_color").html(data.item_color);
	        	$("#vendor_id").html(data.vendor_id);
	        	$("#item_type").html(data.item_type);
	        	$("#class_card").html(data.class_card);
	        	$("#JHSL").html(data.JHSL);
	        	$("#work_type").html(data.work_type);
	        	
	        	//初始化输入框的值
	        	$("#work_name").html("");
	        	$("#work_id").val("");
	        	$("#paigong_id").val(paigong_id);
	        	$("#clerk_name").html("");
	        	$("#clerk_id").val("");
	        	$("#PGSL").val(0);
	        	$("input[name='endDate']").val(new Date().Format("yyyy-MM-dd "));
	        	getDispatchingWork();
	        } 
		});
	})();
	
	//返回
	$(".fanhui, .glyphicon-menu-left").click(function(){
		history.back();
	});
	
	//数量减一
	$("#reduce").click(function(){
		$("#PGSL").val($("#PGSL").val()-1);
		if($("#PGSL").val()<0){
			$("#PGSL").val(0);
			pop_up_box.showMsg("派工数量不能小于0!");
		}
	});
	
	//数量加一
	$("#add").click(function(){
		$("#PGSL").val(new Number($("#PGSL").val())+1);
		if($("#PGSL").val()>productionPlan.JHSL){
			$("#PGSL").val(productionPlan.JHSL);
			pop_up_box.showMsg("派工数量不能大于计划数量!");
		}
	});
	
	//派工
	$(".paigong").click(function(){
		dispatchingWork();
	});
	
	//点击浏览
	$(".smg").click(function(){
	   var n = $(".smg").index(this);
	   if (n==0){
		   pop_up_box.loadWait(); 
		   $.get("../pm/getWorkProcessTree.do",{
			   		"work_type":$.trim($("#work_type").html()),
			   		"ver":Math.random()
			   },function(data){
				   pop_up_box.loadWaitClose();
				   $("body").append(data);
		   });
	   }else if(n==1){
		   var work_id = $("#work_id").val();
		   if(work_id){
			   pop_up_box.loadWait(); 
			   $.get("../pm/getWorkerTree.do",{
				   		"work_id" : work_id,
				   		"ver":Math.random()
				   },function(data){
					   pop_up_box.loadWaitClose();
					   $("body").append(data);
			   }); 
		   }else{
			   pop_up_box.showMsg("请先选择工序!");
		   }
	   }
    });
	
	//显示已派工信息
	$('.chakan').click(function(){
	    $('.cl').toggle('slow');
	    //增加已派工记录模块
	    getDispatchingWork();
	    addItem();
	});
	
	//关闭显示已派工信息
	$('#close').click(function(){
        $('.cl').hide();
    });
	$('#close').click();
    
    //微信通知
    $("#sendInfo").click(function(){
    	pop_up_box.loadWait();
    	$.get("../pm/dispatchingWorkSendInfo.do", {
    		"PH" : PH,
    		"ver" : Math.random()
    	},function(data) {
    		pop_up_box.loadWaitClose();
    		if(data.success){
    			pop_up_box.showMsg("通知成功!");
    		}else{
    			pop_up_box.showMsg("通知失败!");
    		}
    	});
    });
});

//增加表行记录
var addItem = function(){
	data = dispatchingWorkArr;
	var props = $("#props");
	var prop = props.find("#prop");
	props.html("");
	if (data && data.length > 0) {
		$.each(data,function(i, n){
			var p = prop.clone();
			p.find("#m_seeds_id").html(n.seeds_id);
			p.find("#m_work_id").html(n.JCGXID);
			p.find("#m_work_name").html(n.JCGXNAME);
			p.find("#m_clerk_id").html(n.JHGR);
			p.find("#m_clerk_name").html(n.JHGRNAME);
			p.find("#m_paigong_id").html(n.paigong_id);
			p.find("#m_batch_mark").html(n.batch_mark);
			p.find("#m_ivt_oper_listing").html(n.ivt_oper_listing);
			p.find("#m_WGSJ_10").html(n.WGSJ_10);
			p.find("#m_PH").html(n.PH);
			p.find("#m_item_name").html(n.item_name);
			p.find("#m_item_spec").html(n.item_spec);
			p.find("#m_item_type").html(n.item_type);
			p.find("#m_item_color").html(n.item_color);
			p.find("#m_vendor_id").html(n.vendor_id);
			p.find("#m_class_card").html(n.class_card);
			p.find("#m_PGSL").html(n.PGSL);
			p.find("#m_status").html(n.status);
			p.find("#m_status_trans").html(n.status_trans);
			p.find("#edit").attr("onclick","editDispatchingWork(this)");
			p.find("#del").attr("onclick","delDispatchingWork(this)");
			p.find("#unuse").attr("onclick","unusedDispatchingWork(this)");
			p.find(".hide").each(function(n){
				$(n).hide();
			});
			props.append(p)
		});
	}
};

//派工
var dispatchingWork = function(){
	var seeds_id = $.trim($("#seeds_id").val());
	var work_id = $.trim($("#work_id").val());
	var No_serial = $.trim($("#No_serial").val());
	var paigong_id = $.trim($("#paigong_id").val());
	var JHGR = $.trim($("#clerk_id").val());
	var PGSL = $.trim($("#PGSL").val());
	var WGSJ = $.trim($("input[name='endDate']").val());
	if(!work_id){
		pop_up_box.showMsg("请选择工序!");
		return false;
	}
	if(!paigong_id){
		pop_up_box.showMsg("请输入派工单号!");
		return false;
	}
	if(!JHGR){
		pop_up_box.showMsg("请选择工人!");
		return false;
	}
	if(PGSL<1){
		pop_up_box.showMsg("请输入派工数量!");
		return false;
	}
	if(!WGSJ){
		pop_up_box.showMsg("请选择完工时间!");
		return false;
	}
	if(!seeds_id){
		//计算可派工数量
		var PGSL_MORE = getPGSLALL(work_id,No_serial,productionPlan.JHSL);
		if(PGSL>PGSL_MORE){
			pop_up_box.showMsg("可派工数量"+PGSL_MORE+"!");
			$("#PGSL").val(PGSL_MORE);
			return false;
		}
	}
	pop_up_box.loadWait();
	$.get("../pm/dispatchingWork.do", {
		"seeds_id" : seeds_id,
		"PH" : PH,
		"work_id" : work_id,
		"paigong_id" : paigong_id,
		"auto_paigong_id" : auto_paigong_id,
		"JHGR" : JHGR,
		"PGSL" : PGSL,
		"WGSJ" : WGSJ,
		"ver" : Math.random()
	},function(data) {
		pop_up_box.loadWaitClose();
		if(data.success){
			pop_up_box.showMsg("派工成功!",function(){
				$("#clerk_id").val("");
				$("#clerk_name").html("");
				$("#PGSL").val(0);
				$("#work_id").parent().find(".smg").attr("disabled",false);
				$("#paigong_id").attr("disabled",false);
				//重新查看已派工记录
				getDispatchingWork();
				$("#PGSL").val(getPGSLALL($("#work_id").val(),$("#No_serial").val(),productionPlan.JHSL));
			});
		}else{
			pop_up_box.showMsg("派工失败!");
		}
	});
};

//查询已派工记录
var getDispatchingWork = function(){
	pop_up_box.loadWait();
	$.get("../pm/getDispatchingWork.do", {
		"PH" : PH,
		"ver" : Math.random()
	},function(data) {
		pop_up_box.loadWaitClose();
		dispatchingWorkArr = data;
	});
}

//获取可派工数量
var getPGSLALL = function(work_id,No_serial,JHSL){
	var PGSL = 0;						//可用派工数量
	var pre_No_serial = No_serial - 1;	//上一工序序号
	var pre_PGSLALL = 0;				//上一工序完工数量
	var now_No_serial = No_serial - 0;	//当前工序序号
	var now_PGSLALL = 0;				//当前工序完工数量
	var flag = PlanPush;				//消息推送方式
	
	//离散型
	if(flag=="0"){	
		if(work_id){
			for(p in dispatchingWorkArr){
				if(dispatchingWorkArr[p].JCGXID == work_id && dispatchingWorkArr[p].status != 3){
					PGSL = new Number(PGSL) + new Number(dispatchingWorkArr[p].PGSL);
				}
			}
			PGSL = JHSL - PGSL;
		}
	}
	//流程型
	if(flag=="1"){				
		if(work_id){
			//计算当前工序已派工未作废数量
			for(p in dispatchingWorkArr){
				if(dispatchingWorkArr[p].No_serial == now_No_serial && dispatchingWorkArr[p].status!=3){
					now_PGSLALL = new Number(now_PGSLALL) + new Number(dispatchingWorkArr[p].PGSL) ;
				}
			}
			//计算上一工序完工数量
			for(p in dispatchingWorkArr){
				if(dispatchingWorkArr[p].No_serial == pre_No_serial && dispatchingWorkArr[p].status==2){
					pre_PGSLALL = new Number(pre_PGSLALL) + new Number(dispatchingWorkArr[p].PGSL) ;
				}
			}
		}
		//非第一道工序可用派工数量计算
		if(pre_PGSLALL>0){
			PGSL = pre_PGSLALL - now_PGSLALL;
		}
		//第一道工序可用派工数量计算
		if(parseInt(now_No_serial) == 1){
			PGSL = JHSL - now_PGSLALL;
		}
	}
	return PGSL;
};

//编辑派工
var editDispatchingWork = function(data){
	var prop = $(data).parent().parent().parent().parent();
	var status = prop.find("#m_status").html();
	if(status=="0"){
		$("#seeds_id").val($.trim(prop.find("#m_seeds_id").html()));
		$("#work_id").val($.trim(prop.find("#m_work_id").html()));
		$("#work_name").html($.trim(prop.find("#m_work_name").html()));
		$("#paigong_id").val($.trim(prop.find("#m_paigong_id").html()));
		$("#clerk_id").val($.trim(prop.find("#m_clerk_id").html()));
		$("#clerk_name").html($.trim(prop.find("#m_clerk_name").html()));
		$("#PGSL").val($.trim(prop.find("#m_PGSL").html()));
		$("input[name='endDate']").val($.trim(prop.find("#m_WGSJ_10").html()));
		$("#work_id").parent().find(".smg").attr("disabled",true);
		$("#paigong_id").attr("disabled",true);
		$('#close').click();
	}else{
		pop_up_box.showMsg("不可修改!");
	}
};

//删除派工
var delDispatchingWork = function(data){
	var prop = $(data).parent().parent().parent().parent();
	var status = prop.find("#m_status").html();
	var seeds_id = prop.find("#m_seeds_id").html();
	if(status=="0"||status=="3"){
		pop_up_box.loadWait();
		$.get("../pm/delDispatchingWork.do", {
			"seeds_id" : seeds_id,
			"ver" : Math.random()
		},function(data) {
			if(data.success){
				pop_up_box.showMsg("删除成功!",function(){
					getDispatchingWork();
					$('#close').click();
				});
			}else{
				pop_up_box.showMsg("删除失败!");
			}
		});
	}else{
		pop_up_box.showMsg("不可删除!");
	}
};

//作废派工
var unusedDispatchingWork = function(data){
	var prop = $(data).parent().parent().parent().parent();
	var status = prop.find("#m_status").html();
	var seeds_id = prop.find("#m_seeds_id").html();
	pop_up_box.loadWait();
	$.get("../pm/unusedDispatchingWork.do", {
		"seeds_id" : seeds_id,
		"ver" : Math.random()
	},function(data) {
		if(data.success){
			pop_up_box.showMsg("作废成功!",function(){
				getDispatchingWork();
				$('#close').click();
			});
		}else{
			pop_up_box.showMsg("作废失败!");
		}
	});
};