$.ajaxSetup({  
	async : false  
});

$(function(){
	var corp_id=getQueryString("corp_id");
	if(corp_id){
		loadPage("vendorEdit.do?corp_id="+corp_id);
		loadData(corp_id);
	}
	var count=0;
	function loadData(corp_id){
		$("#page").val(editUtils.page+1);
		var searchKey=$("#searchKey").val();
		pop_up_box.loadWait();
		$.get("getGysPage.do",{
			"searchKey":searchKey,
			"page":editUtils.page,
			"count":count,
			"corp_id":corp_id
		},function(data){
			$("#listpage tbody").html("");
			pop_up_box.loadWaitClose();
			$.each(data.rows,function(i,n){
				var len=$("#listpage th").length;
				var tr=getTr(len);
				$("#listpage tbody").append(tr);
				for (var i = 0; i < len; i++) {
					var th=$($("#listpage th")[i]);
					var name=$.trim(th.attr("data-name"));
					var show=th.css("display");
					var j=$("#listpage th").index(th);
					if(show=="none"){
						tr.find("td:eq("+j+")").hide();
					}else{
						if(j>=0){
							if(name=="corp_sim_name"){
								tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(n.corp_id)+"'>"+n[name]);
							}else if(name=="weixinStatus"){
								var o2o="";
								if(ifnull(n.weixinStatus)=="1"){
									o2o="已关注";
								}else if (ifnull(n.weixinStatus)=="2") {
									o2o="已冻结";
								}else if($.trim(n.weixinID)!=""){
									o2o="未关注";
								}else{
									o2o="无微信账号";
								}
								tr.find("td:eq("+j+")").html(o2o);
							} 
							else{
								tr.find("td:eq("+j+")").html(n[name]);
							}
						}
					}
				}
				tr.find("td:eq(0)").html(getbtn());
			});
			editUtils.totalPage=data.totalPage;
			count=data.totalRecord;
			selectTr();
			$("#totalPage").html(data.totalPage+1);
			$("#totalRecord").html(data.totalRecord);
			$(".pull-left .form-control").val(data.totalRecord);
		});
	}
	$("#treeAll").click(function(){
		editUtils.page=0;
		count=0;
		loadData();
	}); 
	try { 
//		o2o.editVendor("vendorEdit.do?corp_id=");
		o2o.delVendor("vendor");
	} catch (e) {}
////////////////////////////////
	$("#find").click(function(){
		editUtils.page=0;
		count=0;
		loadData();
	});
	loadData();
////////////////////////////////
	editUtils.paging(function(){
		loadData();
	});
});
function getbtn(){
   var btn=""
   if($("#edit_hi").val()=="true"){
	   btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='editVendor(this);'>修改</button>";
   }
   if($("#del_hi").val()=="true"){
	   btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='delVendor(this);'>删除</button>";
   }
   return btn;
};
function editVendor(t){
	var tr=$(t).parents("tr");
	var corp_id=tr.find("input").val();
//	window.location.href="vendorEdit.do?corp_id="+corp_id;
	loadPage("vendorEdit.do?corp_id="+corp_id);
}
function loadPage(url){
	$.get(url,function(data){
		$("#editpage").html(data);
		$("#listpage").hide();
		vendorEdit.init();
	});
}
function delVendor(t){
	var tr=$(t).parents("tr");
	if (window.confirm("是否要删除该记录?")) {
		var corp_id=tr.find("input").val();
		pop_up_box.postWait();
		$.post("delClient.do",{"treeId":corp_id,"type":"vendor"},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				tr.remove();
//				$(".parent_li input[value='"+corp_id+"']").parents("li").remove();
			}else{
				pop_up_box.showMsg(data.msg);
			}
		});
	}
}