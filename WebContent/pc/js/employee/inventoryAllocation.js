$(function(){
	//表格初始化
	function getTr(prop){
		var tr="<tr>";
		
		tr+="<td width='200'>"+ifnull(prop.store_date)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.item_name)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.item_spec)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.item_type)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.plan_price)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.corpstorestruct_id_name)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.store_struct_id_name)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.clerk_name)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.dept_name)+"</td>";
		tr+="<td width='200'>"+ifnull(prop.ivt_oper_listing)+"</td>";
		tr+="</tr>"
		return tr;
	}
	$(".find").click(function(){
		var param = {
				"ver" : Math.random(),
				"beginDate" : $("input[name='beginDate']").val(),
				"endDate" : $("input[name='endDate']").val(),
				"searchKey" : $("input[name='searchKey']").val()
		}
		pop_up_box.loadWait();
		$.get("../employee/inventoryAllocationFind.do",param,
				function(data){
					pop_up_box.loadWaitClose();
					$("tbody").html("");
					$.each(data.rows,function(i,n){
						$("tbody").append(getTr(n));
					});
					
		});
	});
	$(".excel").click(function(){
		pop_up_box.loadWait();
		$.get("../maintenance/inventoryAllocationExport.do",{
			"ver":Math.random(),
			"beginDate":$("input[name='beginDate']").val(),
			"endDate":$("input[name='endDate']").val(),
			"searchKey":$.trim($("input[name='searchKey']").val())
		},function(data){
			pop_up_box.loadWaitClose();
			window.location.href=data.msg;
		});
	});
});