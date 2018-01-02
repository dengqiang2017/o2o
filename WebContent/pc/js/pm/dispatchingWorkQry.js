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
			str+= "<td>"+ifNone(n.PH)+"</td>";
			str+= "<td>"+ifNone(n.item_sim_name)+"</td>";
			if(n.status == '2'){
				str+= "<td>已完工</td>";
			}else if(n.status == '3'){
				str+= "<td>已作废</td>";
			}else{
				str+= "<td><button type='button' class='btn btn-xs btn-info' onclick='toDispatchingWork(this)'>派工</button></td>";
			}
			str+= "</tr>";
			$("tbody").append(str);
		});
	}
}

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

//派工
var toDispatchingWork = function(data){
	$('.zz').click();
	var dom = $(data).parent().parent();
	var PH = dom.find("td")[0].innerText;
	window.location.href = "../pm/toDispatchingWork.do?PH="+PH;
};

//显示详细
var detail = function(PH){
	for(p in dataArr){
		if(PH == dataArr[p].PH){
			$("#ivt_oper_listing").html(dataArr[p].ivt_oper_listing);
			$("#PH").html(dataArr[p].PH);
			$("#CusName").html(dataArr[p].CusName);
			$("#send_date").html(dataArr[p].send_date);
			$("#plan_end_date").html(dataArr[p].plan_end_date);
			$("#item_name").html(dataArr[p].item_name);
			$("#item_spec").html(dataArr[p].item_spec);
			$("#item_type").html(dataArr[p].item_type);
			$("#item_color").html(dataArr[p].item_color);
			$("#vendor_id").html(dataArr[p].vendor_id);
			$("#class_card").html(dataArr[p].class_card);
			$("#JHSL").html(dataArr[p].JHSL);
			$("#c_memo").html(dataArr[p].c_memo);
			$("#memo_color").html(dataArr[p].memo_color);
			$("#memo_other").html(dataArr[p].memo_other);
			$('.zz').toggle('slow');
		}
	}
}               