$(function(){
	var page=0;
	var totalPage=0;
	var count=0;
	$("#expand").click(function(){
		var form=$("#gzform");
		if(form.is(":hidden")){
			form.show();
			$(this).text("隐藏搜索");
		}else{
			$(this).text("展开搜索");
			form.hide();
		}
	});
	//表格初始化
	function getTr(prop){
		var bzs=0;  //包装数
		var lts=0;  //零头数
		var kcje=0; //库存金额
		if (prop.pack_unit&&prop.pack_unit!=""&&prop.pack_unit!="0") {
			bzs=parseFloat(prop.accn_ivt)/parseFloat(prop.pack_unit);
			bzs = numformat(bzs,2);
		}
		if (prop.pack_unit&&prop.pack_unit!=""&&prop.pack_unit!="0") {
			lts=parseFloat(prop.accn_ivt)%parseFloat(prop.pack_unit);
			lts = numformat(lts,2);
		}
		if (prop.oh&&prop.i_price&&prop.i_price!="0") {
			kcje=(parseFloat(prop.accn_ivt)*parseFloat(prop.i_price));
			kcje = numformat(kcje,2);
		}
		var tr="<tr>";
		tr+="<td width='200'>"+ifnull(prop.store_struct_name)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.type_name)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.PH)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.item_id)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.item_name)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.item_spec)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.item_type)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.item_color)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.class_card)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.item_unit)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.accn_ivt)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.i_price)+"</td>";
		tr+="<td width='200'>"+kcje+"</td>";
		tr+="<td width='200'>"+ifnull("")+"</td>";
		tr+="<td width='200'>"+ifnull(prop.store_struct_id)+"</td>";
		tr+="</tr>"
		return tr;
	}
	function loadData(){
		pop_up_box.postWait();
		$.get("initialMaintenancePage.do",{//期末库存查询:../maintenance/getWarePage.do
//			"searchKey":$.trim($("#searchKey").val()),
			"store_struct_id":$.trim($("#store_struct_id").val()),
//			"type_id":$.trim($("#type_id").val()),
			"item_id":$.trim($("#item_id").val())
//			"item_spec":$.trim($("#item_spec").val()),
//			"item_type":$.trim($("#item_type").val())
		},function(data){
			pop_up_box.loadWaitClose();
			$("tbody").html("");
			$.each(data.rows,function(i,n){
				var ul=getTr(n);
				$("tbody").append(ul);
				totalPage=data.totalPage;
				count=data.totalRecord;
				$("#page").html("当前页:"+page);
			});
		});
	}
	$(".find").click(function(){
		loadData();
	});
	////////////从外部直接进入处理
	var params=window.location.href.split("?");
	if (params&&params.length>1) {
		
	}else{
		loadData();
	}
	$("#onePage").click(function(){
		page=0;
		loadData();
	});
	$("#uppage").click(function(){
		page=parseInt(page)-1;
		if (page>=0) {
			loadData();
		}else{
			pop_up_box.showMsg("已到第一页!");
		}
	});
	$("#nextPage").click(function(){
		  page=parseInt(page)+1;
			if (page<=totalPage) {
				loadData();
			}else{
				pop_up_box.showMsg("已到最后一页!");
			}
	});
	$("#endPage").click(function(){
		page=totalPage;
		loadData();
	});
	$(".excel").click(function(){
		$.get("initialMaintenanceExcel.do",{
//			"searchKey":$.trim($("#searchKey").val()),
			"store_struct_id":$.trim($("#store_struct_id").val()),
//			"type_id":$.trim($("#type_id").val()),
			"item_id":$.trim($("#item_id").val())
//			"item_spec":$.trim($("#item_spec").val()),
//			"item_type":$.trim($("#item_type").val())
		},function(data){
			pop_up_box.loadWaitClose();
			window.location.href=data.msg;
		});
	});
	$(".btn-success").click(function() {
		var n = $(".btn-success").index(this);
		if (n==0) {
			$.get("../manager/getDeptTree.do", {
				"type" : "warehouse"
			}, function(data) {
				pop_up_box.loadWaitClose();
				$("body").append(data);
				warehouse.init(function(){
					selectInfo("store_struct_id", "store_struct_name", "库房");
				});
			});
		}
		if (n==1) {
			$.get("../tree/productSelect.do",
				function(data) {
				pop_up_box.loadWaitClose();
				$("body").append(data);
				product.init(function(){
					var item_id=$(".modal").find("tr.activeTable").find("td:eq(0)>input").val();
					var item_name=$(".modal").find("tr.activeTable").find("td:eq(1)").text();
					$("#item_id").val(item_id);
					$("#item_name").html(item_name); 
				});
			});
		}
	});
	//单选信息
	function selectInfo(id,name,msg){
		var id_Info=$("#"+id).val("");
		var id_InfoName=$("#"+name).html("");
		
		$("#"+id).val(treeSelectId);
		$("#"+name).html(treeSelectName);
	}
});