var page = 1;			//当前页数
var currentRecord = 0;	//当前记录数
var totalRecord = 0;	//总记录数
var pageRecord = 10000; //每页记录数
var dataArr = null;		//获取查询到的记录

$(function(){
	//初始化
	$("tbody").html("");
	$("input[name='send_date']").val(new Date().Format("yyyy-MM-dd"));
	$("input[name='plan_end_date']").val(new Date().Format("yyyy-MM-dd"));
	
	//查找
	$(".find:eq(0)").click(function(){
		pop_up_box.loadWait();
		$.get("../pm/getProductionPlanInfo.do", {
			"searchKey" : $.trim($("#searchKey").val()),
			"send_date" : $.trim($("input[name='send_date']").val()),
			"plan_end_date" : $.trim($("input[name='plan_end_date']").val()),
			"page" : page,
			"pageRecord" : pageRecord,
			"ver" : Math.random()
		},function(data) {
			pop_up_box.loadWaitClose();
			addItem(data);
			currentRecord = page*data.pageRecord;
			totalRecord = data.totalRecord;
		});
	});
	$(".find:eq(0)").click();
	
	//返回
	$(".glyphicon-menu-left").click(function(){
		history.back();
	});

	//关闭详细
    $('.zz').click(function(){
        $('.zz').hide()
    });
});

//增加表行记录
var addItem = function(data){
	dataArr = data.rows;
	$("tbody").html("");
	if (data && data.rows.length > 0) {
		$.each(data.rows,function(i, n){
			var str = "";
			str+= "<tr onclick=detail('"+n.PH+"')>";
			str+= "<td style='width:35%;'>"+ifNone(n.PH)+"</td>";
			str+= "<td style='width:35%;'>"+ifNone(n.item_name)+"</td>";
			str+= "<td style='width:15%;'>"+ifNone(n.JHSL)+"</td>";
			if(n.status == '2'){
				str+= "<td style='width:15%;'>已完工</td>";
			}else if(n.status == '3'){
				str+= "<td style='width:15%;'>已作废</td>";
			}else{
				str+= "<td style='width:15%;'>生产中</td>";
			}
			str+= "</tr>";
			$("tbody").append(str);
		});
	}
}

//显示详细
var detail = function(PH){
	var SCJH = null;	//生产计划
	var GX = null;		//工序数组
	var GX_JJSL = null;	//各工序完工数量
	
	//公共部分数据赋值
	for(p in dataArr){
		if(PH == dataArr[p].PH){
			SCJH = dataArr[p];
			$("#ivt_oper_listing").html(dataArr[p].ivt_oper_listing);
			$("#PH").html(dataArr[p].PH);
			$("#item_name_JHSL").html(ifNone(dataArr[p].item_name)+"|"+ifNone(dataArr[p].JHSL));
			$("#send_date").html(dataArr[p].send_date);
			$("#plan_end_date").html(dataArr[p].plan_end_date);
			$("#item_spec_type").html(ifNone(dataArr[p].item_spec)+"|"+ifNone(dataArr[p].item_type));
			$("#vendor_id_class_card_color").html(ifNone(dataArr[p].vendor_id)+"|"+ifNone(dataArr[p].class_card)+"|"+ifNone(dataArr[p].item_color));
			$("#c_memo").html(dataArr[p].c_memo);
			$("#memo_color").html(dataArr[p].memo_color);
			$("#memo_other").html(dataArr[p].memo_other);
			$('.zz').toggle('slow');
			break;
		}
	}
	
	//查询所有工序
	pop_up_box.loadWait();
	$.get("../pm/getProductionProcessInfo.do", {
		"work_type" : SCJH.work_type,
		"ver" : Math.random()
	},function(data) {
		pop_up_box.loadWaitClose();
		GX = data;
		
		//查询各工序完工数量
		pop_up_box.loadWait();
		$.get("../pm/getEachProcessJJSLALL.do", {
			"PH" : SCJH.PH,
			"work_type" : SCJH.work_type,
			"ver" : Math.random()
		},function(data) {
			pop_up_box.loadWaitClose();
			GX_JJSL = data;

			//所有工序完工数量赋值
			for(p in GX){
				for(q in GX_JJSL){
					if(GX[p].work_id == GX_JJSL[q].work_id){
						GX[p].JJSL = GX_JJSL[q].JJSL_All;
					}
				}
			}
			
			//各工序完工数量展示到页面
			var props = $("#props");
			var prop = $("#prop");
			props.html("");
			for(p in GX){
				var n = prop.clone();
				n.find("#work_name").html(GX[p].work_name);
				n.find("#JJSL").html(GX[p].JJSL);
				props.append(n);
			}
		});
	});
}
               