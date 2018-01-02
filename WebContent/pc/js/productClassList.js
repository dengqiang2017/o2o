$(function(){
	try {
		$.get("../tree/getTree.do",{"type":"productClass"},function(data){
			pop_up_box.loadWaitClose();
			o2o.initTree(data,function(n){
				return treeliinit(n.sort_name,n.sort_id);
			});
			o2o.next_tree("productClass",function(n){
				return treeli(n.sort_name,n.sort_id);
			},undefined,function(treeId){
				loadData(treeId);
			});
		});
	} catch (e) {}
	$("#treeAll").click(function(){
		loadData();
	});
	$("#find").click(function(){
		loadData();
	});
	$("#find").click();
	////////////////////////////////
	$("#addClass").click(function(){
		editUtils.loadPage("../product/productClassEdit.do",function(){
			productClassEdit.init();
		});
	});
	//////////////////////
function loadData(sort_id){
	if (!sort_id) {
		sort_id="";
	}
//	$("#page").val(page);
	var searchKey=$("#searchKey").val();
	pop_up_box.loadWait();
	$.get("../manager/getProductClass.do",{
		"searchKey":searchKey,
//		"page":page,
//		"count":count,
		"sort_id":sort_id
	},function(data){
		$("#listpage tbody").html("");
		pop_up_box.loadWaitClose();
		$.each(data,function(i,n){
			var len=$("#listpage th").length;
			var tr=getTr(len);
			$("#listpage tbody").append(tr);
			for (var i = 0; i < len; i++) {
				var th=$($("#listpage th")[i]);
				var name=$.trim(th.attr("data-name"));
				var show=th.css("display");
				var j=$("#listpage th").index(th);
				var val=$.trim(n[name]);
				if(show=="none"){
					tr.find("td:eq("+j+")").hide();
				}else{
					if(j>=0){
						if(name=="sort_name"){
							tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(n.sort_id)+"'>"+val);
						}else{
							tr.find("td:eq("+j+")").html(val);
						}
					}
				}
			}
			tr.find("td:eq(0)").html(getbtn());
		});
		selectTr();
//		$("#totalPage").html(data.totalPage);
//		$(".pull-left .form-control").val(data.totalRecord);
//		totalPage=data.totalPage;
//		count=data.totalRecord;
	});
}

});
/////////////////
function editProduct(t){
	var tr=$(t).parents("tr");
	var sort_id=tr.find("input").val();
	editUtils.loadPage("../product/productClassEdit.do?sort_id="+sort_id,function(){
		productClassEdit.init();
	});
}
function delProduct(t){
	var tr=$(t).parents("tr");
	if (window.confirm("是否要删除该记录?")) {
		var customer_id=tr.find("input").val();
		pop_up_box.postWait();
		$.post("delClient.do",{"treeId":customer_id,"type":"productClass"},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				tr.remove();
				$(".parent_li input[value='"+customer_id+"']").parent().parent().remove();
			}else{
				pop_up_box.showMsg(data.msg);
			}
		});
	}
}
function getbtn(){
	var btn="";
	if($("#edit_hi").val()=="true"){
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='editProduct(this);'>修改</button>";
	}
	if($("#del_hi").val()=="true"){
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='delProduct(this);'>删除</button>";
	}
	return btn;
}