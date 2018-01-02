$(function(){
	function getTr(client){
		var if_statistic="是";
		if (ifnull(client.if_statistic)=="0") {
			if_statistic="否";
		}
		var tr="<tr><td><input type='hidden' value='"+ifnull(client.sort_id)
		+"'><a href='../product/regionalismEdit.do?sort_id="+ifnull(client.sort_id)
		+"&info=info' >"+ifnull(client.regionalism_name_cn)+"</a></td>";
		tr+="<td>"+ifnull(client.regionalism_id)+"</td>";
		tr+="<td>"+ifnull(client.dept_name)+"</td>";
		tr+="<td>"+ifnull(client.easy_id)+"</td>";
		tr+="<td>"+ifnull(client.market_type)+"</td>";
		tr+="<td>"+if_statistic+"</td>";
		return tr;
	}
	try {
		o2o.treeAll("regionalism",function(n){
			return getTr(n);
		});
		$.get("getRegionalism.do",function(data){
			o2o.initTree(data,function(n){
				return treeliinit(n.regionalism_name_cn,n.sort_id);
			});
			o2o.next_tree("regionalism",function(n){
				return treeli(n.regionalism_name_cn,n.sort_id);
			},function(n){
				return getTr(n);
			});
		});
		o2o.editClient("regionalismEdit.do?sort_id=");
		o2o.delClient("regionalism"); 
	} catch (e) {}
	$("#treeAll").click();
	
	$("#find").click(function(){
		var regionalism_name_cn=$("#regionalism_name_cn").val();
		var easy_id=$("#easy_id").val();
		var dept_manager=$("#dept_manager").val();
		$.get("getRegionalism.do",{
			"regionalism_name_cn":regionalism_name_cn,
			"find":1,"ver":Math.random(),
			"easy_id":easy_id
		},function(data){
			$("tbody").html("");
			$.each(data,function(i,n){
				$("tbody").append(getTr(n));
			});
			$("#page").val("1");
			$("#totalPage").val(data.totalPage);
			treeSelectId="";
			selectTr();
		});
	});
});