$(function(){
	var guding=$("#guding").html().split(",");
	function getTr(warehouse){
		var tr="<tr>";
		var b=false;
		for (var i = 0; i < guding.length; i++) {
			if(ifnull(warehouse.sort_id)==guding[i]){
				b=true;
			}
		}
		if (b) {
			tr+="<td>系统默认项</td>";
		}else{
			tr+="<tr><td><button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='editSettlement(this);'>修改</button>"
				+"<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='delSettlement(this);'>删除</button></td>";
		}
		tr+="<td><input type='hidden' value='"+ifnull(warehouse.sort_id)
		+"'>"+ifnull(warehouse.settlement_sim_name)+"</td>";
		tr+="<td>"+ifnull(warehouse.settlement_type_id)+"</td>";
		tr+="<td>"+ifnull(warehouse.cheque_flag)+"</td>";
		tr+="<td>"+ifnull(warehouse.i_Amount)+"</td>";
		tr+="<td>"+ifnull(warehouse.dept_name)+"</td>";
		tr+="<td>"+ifnull(warehouse.c_fullname)+"</td>";
		return tr;
	}
	try {
		o2o.treeAll("settlement",function(n){
			return getTr(n);
		});
		o2o.next_tree("settlement",function(n){
			return treeli(n.settlement_sim_name,n.sort_id);
		},function(n){
			return  getTr(n);
		});
//		o2o.editClient("settlementEdit.do?sort_id=");
//		o2o.delClient("settlement");
	} catch (e) {}
	
	$("#find").click(function(){
		var settlement_sim_name=$("#settlement_sim_name").val();
		var easy_id=$("#easy_id").val();
		pop_up_box.loadWait();
		$.get("getSettlement.do",{
			"settlement_sim_name":settlement_sim_name,
			"find":1, 
			"easy_id":easy_id
		},function(data){
			pop_up_box.loadWaitClose(); 
			$("tbody").html("");
			$.each(data,function(i,n){
				$("tbody").append(getTr(n));
			});
//			$("#page").val("1");
//			$("#totalPage").val(data.totalPage);
			treeSelectId="";
			selectTr();
		});
	});
});

function editSettlement(t){
	var tr=$(t).parents("tr");
	var sort_id=tr.find("input").val();
	window.location.href="settlementEdit.do?sort_id="+sort_id; 
}
function delSettlement(t){
	var tr=$(t).parents("tr");
	if (window.confirm("是否要删除该记录?")) {
		var sort_id=tr.find("input").val();
		pop_up_box.postWait();
		$.post("delClient.do",{"treeId":sort_id,"type":"settlement"},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				tr.remove();
				$(".parent_li input[value='"+sort_id+"']").parent().parent().remove();
			}else{
				pop_up_box.showMsg(data.msg);
			}
		});
	}
}