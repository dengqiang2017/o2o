//存放查询数据
var dataArr = null;

$(function(){
	//初始化
	$("input[name='send_date']").val(new Date().Format("yyyy-MM-dd"));
	$("input[name='plan_end_date']").val(new Date().Format("yyyy-MM-dd"));
	
	$(".find:eq(0)").click(function(){
		pop_up_box.loadWait();
		$.get("../pm/getQualityTesting.do", {
			"searchKey" : $.trim($("#searchKey").val()),
			"send_date" : $.trim($("input[name='send_date']").val()),
			"plan_end_date" : $.trim($("input[name='plan_end_date']").val()),
			"ver" : Math.random()
		},function(data) {
			pop_up_box.loadWaitClose();
			addItem(data);
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
	dataArr = data;
	$("tbody").html("");
	if (data && data.length > 0) {
		$.each(data,function(i, n){
			var str = "";
			str+= "<tr onclick=detail('"+n.seeds_id+"')>";
			str+= "<td>"+ifNone(n.item_name)+"</td>";
			str+= "<td>"+ifNone(n.work_name)+"</td>";
			str+= "<td>"+ifNone(n.clerk_name)+"</td>";
			str+= "<td>"+ifNone(n.PGSL)+"</td>";
			str+= "<td><button type='button' class='btn btn-xs btn-info' onclick='qualityTesting("+n.seeds_id+")'>质检</button></td>";
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
		if(prop == 0){
			return 0;
		}else{
			return "-";
		}
	}
};

//质检
var qualityTesting = function(seeds_id){
	window.location.href = "../pm/qualityTesting.do?seeds_id="
		+seeds_id;
};

//显示详细
var detail = function(seeds_id){
	for(p in dataArr){
		if(seeds_id == dataArr[p].seeds_id){
			$("#ivt_oper_listing").html(dataArr[p].ivt_oper_listing);
			$("#PH").html(dataArr[p].PH);
			$("#clerk_name").html(dataArr[p].clerk_name);
			$("#send_date").html(dataArr[p].send_date);
			$("#plan_end_date").html(dataArr[p].plan_end_date);
			$("#item_name").html(dataArr[p].item_name);
			$("#item_spec").html(dataArr[p].item_spec);
			$("#item_type").html(dataArr[p].item_type);
			$("#item_color").html(dataArr[p].item_color);
			$("#vendor_id").html(dataArr[p].vendor_id);
			$("#class_card").html(dataArr[p].class_card);
			$("#PGSL").html(dataArr[p].PGSL);
			$("#c_memo").html(dataArr[p].c_memo);
			$("#memo_color").html(dataArr[p].memo_color);
			$("#memo_other").html(dataArr[p].memo_other);
			$('.zz').toggle('slow');
		}
	}
}
               