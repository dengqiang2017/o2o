var now = new Date();
var nowStr = now.Format("yyyy-MM-dd"); 
$(".input-sm").val("");
var onedays=nowStr.split("-");
$(".Wdate:eq(0)").val(onedays[0]+"-01-01"); 
$(".Wdate:eq(1)").val(nowStr); 

$(".find").click(function(){
	productViewAndOrder();
	$(".liactive").click();
});
$("#clearClass").click(function(){
	$(this).parent().find("span").html("");
});
$("#selectClass").click(function(){
	   pop_up_box.loadWait();
 	   $.get("../manager/getDeptTree.do",{"type":"cls"},function(data){
 		   pop_up_box.loadWaitClose();
 		   $("body").append(data);
 		   procls.init(function(){
 			   $("#clsId").html(treeSelectId);
 			   $("#clsName").html(treeSelectName);
 		   });
 	   });
});
productViewAndOrder();
function productViewAndOrder(){
pop_up_box.loadWait();
var type_id= $.trim($("#clsId").html());
if(type_id!=null){
	type_id=type_id+"%";
}
$.get("../chartData/productViewAndOrder.do",{
	"searchKey":$.trim($("#searchKey").val()),
	"type_id": type_id,
	"beginDate":$("#d4311").val(),
	"endDate":$("#d4312").val()
},function(data){
	pop_up_box.loadWaitClose();
	var list=[];
	$.each(data,function(i,n){
		var json=[];
		json.push(n.name,n.num);
		list.push(json);
	});
loadChart(list, "column", "jqChart_zhu", "产品浏览与成交", "");
});
}
$(".dropdown-menu a").click(function(){
	var type= $(this).attr("data-type");
	salesCount(parseInt(type));
	$(".dropdown-menu a").removeClass("liactive");
	$(this).addClass("liactive");
});
salesCount(7);
function salesCount(type){
	var typeName="按月";
	switch (type) {
	case 4:
		typeName="按年";
		break;
	case 10:
		typeName="按天";
		break;
	}
	var type_id= $.trim($("#clsId").html());
	if(type_id!=null){
		type_id=type_id+"%";
	}
	pop_up_box.loadWait();
$.get("../chartData/salesCount.do",{
	"searchKey":$.trim($("#searchKey").val()),
	"type":type,
	"type_id":type_id,
	"beginDate":$("#d4311").val(),
	"endDate":$("#d4312").val()
},function(data){
	pop_up_box.loadWaitClose();
	var list=[];
	$.each(data,function(i,n){
		var json=[];
		json.push(n.name,n.num);
		list.push(json);
	});
	loadChart(list, "line", "salesCountLine", "销量"+typeName+"汇总", "销售数");
	loadChart(list, "Pie", "salesCountPie", "销量"+typeName+"汇总", "销售数");
	loadChart(list, "column", "salesCount", "销量"+typeName+"汇总", "销售数");
});
}