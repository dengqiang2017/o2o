$(function(){
	var customer_id=getQueryString("customer_id");
	if(customer_id){
		editUtils.loadPage("electricianEdit.do?id="+customer_id,function(){
			electrician.init();
		});
		loadData(customer_id);
	}
	$("#electricianEdit").click(function(){
		var param=window.location.href.split("?")[1];
		if(!param){
			param="";
		}
		editUtils.loadPage("electricianEdit.do?"+param,function(){
			electrician.init();
		});
	});
	var count=0;
	function loadData(customer_id){
		var searchKey=$("#searchKey").val();
		pop_up_box.loadWait();
		$.get("../saiyu/getElectricianPage.do",{
			"searchKey":searchKey,
			"isclient":"0",
			"page":editUtils.page,
			"count":count,
			"customer_id":customer_id
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
								tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(n.customer_id)+"'>"+n[name]);
							}else if(name=="weixinStatus"){
								var o2o="";
								if(ifnull(n.weixinStatus)=="1"){
									o2o="已关注";
								}else if (ifnull(n.weixinStatus)=="2") {
									o2o="已冻结";
								}else{
									o2o="无微信账号";
								}
								tr.find("td:eq("+j+")").html(o2o);
							}else if(name=="loginTime"){
								var loginTime="";
								if(n.loginTime!=""&&n.loginTime!=null){
									var now = new Date(n.loginTime);
									loginTime = now.Format("yyyy-MM-dd hh:mm:ss");
								}
								tr.find("td:eq("+j+")").html(loginTime);
							}
							else{
								tr.find("td:eq("+j+")").html(n[name]);
							}
						}
					}
				}
				
				tr.find("td:eq(0)").html(getbtn());
			});
			selectTr();
			editUtils.totalPage=data.totalPage;
			count=data.totalRecord;
			$("#totalPage").html(data.totalPage+1);
			$("#totalRecord").html(data.totalRecord);
		});
	}
////////////////////////////////
	$("#find").click(function(){
		editUtils.page=0;
		count=0;
		loadData();
	});
	loadData();
	editUtils.paging(function(){
		loadData();
	});
	////////////////////////////////
});
function getbtn(){
	var btn="";
	if($("#del_hi").val()=="true"){
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='editVendor(this);'>修改</button>";
	}
	if($("#edit_hi").val()=="true"){
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='delVendor(this);'>删除</button>";
	}
	return btn;
}
function delVendor(t){
	if(confirm("是否删除该电工信息！")){
	var tr=$(t).parents("tr");
	var customer_id=tr.find("input").val();
	$.post("delClient.do",{"treeId":customer_id,"type":"dian"},function(data){
		if (data.success) {
			tr.remove();
		}else{
			pop_up_box.showMsg(data.msg);
		}
	});
	}
}
function editVendor(t){
	var tr=$(t).parents("tr");
	var customer_id=tr.find("input").val();
	editUtils.loadPage("electricianEdit.do?id="+customer_id,function(){
		electrician.init();
	});
}
