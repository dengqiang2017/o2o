$(function(){
	function getWareHouseTr(warehouse){
		var tr="<tr><td><input type='hidden' value='"+ifnull(warehouse.sort_id)
		+"'>"+ifnull(warehouse.store_struct_name)+"</td>";
		tr+="<td>"+ifnull(warehouse.store_struct_id)+"</td>";
		tr+="<td>"+ifnull(warehouse.store_struct_type)+"</td>";
		tr+="<td>"+ifnull(warehouse.clerk_name)+"</td>";
		tr+="<td>"+ifnull(warehouse.dept_name)+"</td>";
		tr+="<td>"+ifnull(warehouse.regionalism_id)+"</td>";
		return tr;
	}
	$("#treeAll").click(function(){
		pop_up_box.loadWait();
		$.get("getWarehouse.do",{"ver":Math.random()},function(data){
			pop_up_box.loadWaitClose();
			$("tbody").html("");
			$.each(data.rows,function(i,n){
				$("tbody").append(getWareHouseTr(n));
			});
		});
	}); 
	try {
		o2o.next_tree("warehouse",function(n){
			return treeli(n.store_struct_name,n.sort_id);
		},function(n){
			return getWareHouseTr(n);
		});
		o2o.editClient("warehouseEdit.do?sort_id=");
		o2o.delClient("warehouse"); 
	} catch (e) {}
	$("#find").click(function(){
		var store_struct_name=$.trim($("#store_struct_name").val());
		var store_struct_type=$.trim($("#store_struct_type").val());
		var easy_id=$.trim($("#easy_id").val());
		var dept_name=$.trim($("#dept_name").val());
		pop_up_box.loadWait();
		$.get("getWarehouse.do",{
			"store_struct_name":store_struct_name,
			"store_struct_type":store_struct_type,
			"dept_name":dept_name,
			"find":1,
			"easy_id":easy_id
		},function(data){
			pop_up_box.loadWaitClose();
			$("tbody").html("");
			$.each(data.rows,function(i,n){
				$("tbody").append(getWareHouseTr(n));
			});
//			$("#page").val("1");
//			$("#totalPage").val(data.totalPage);
			treeSelectId="";
			selectTr();
		});
	});
});