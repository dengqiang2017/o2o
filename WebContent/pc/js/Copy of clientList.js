$.ajaxSetup({  
	async : false  
});
function defineApproval(t,tijian){
	var customer_id=$(t).parents("tr").find("input").val();
	var customer_name=$(t).parents("tr").find("a").html();
	var tel_no=$(t).parents("tr").find("td:eq(2)").html();
	if (tijian) {
		window.location.href="clientTijian.do?"+customer_id+"|"+customer_name+"|"+tel_no;
	}else{
		window.location.href="clientDefineApproval.do?"+customer_id+"|"+customer_name+"|"+tel_no;
	}
}
$(function(){	
	$("#treeAll").click(function(){
		pop_up_box.loadWait();
		$.get("getCustomer.do",{"ver":Math.random()},function(data){
			pop_up_box.loadWaitClose(); 
			$("tbody").html("");
			$.each(data.rows,function(i,n){
				$("tbody").append(getTr(n));
			});
			selectTr();
			$("#page").val("0");
			$("#totalPage").html(data.totalPage);$(".pull-left .form-control").html(data.totalRecord);
			treeSelectId="";
		});
	}); 
	function getTr(client){
//		 href='clientEdit.do?customer_id="+ifnull(client.customer_id)
//				+"&info=info' title='点击查看详细'
		var tr="<tr><td><button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='editClient(this);'>修改</button>"
			 +"<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='delClient(this);'>删除</button>";
		tr+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='defineApproval(this);'>定义审批</button></td>";
		tr+="<td><input type='hidden' value='"+ifnull(client.customer_id)+"'><a>"+ifnull(client.corp_name)+"</a></td>";
		tr+="<td>"+ifnull(client.tel_no)+"</td>";
		tr+="<td>"+ifnull(client.ditch_type)+"</td>";
		tr+="<td>"+ifnull(client.weixinID)+"</td>";
		if(ifnull(client.weixinStatus)=="1"){
			tr+="<td>已关注</td>";
		}else if (ifnull(client.weixinStatus)=="2") {
			tr+="<td>已冻结</td>";
		}else if(ifnull(client.weixinID)!=""){
			tr+="<td><button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;'"
				+"onclick='weixininviteone(this);'>邀请关注</button></td>";
		}else{
			tr+="<td>无微信账号</td>";
		}
		tr+="<td>"+ifnull(client.regionalism_name_cn)+"</td>";
		tr+="<td>"+ifnull(client.corp_name)+"</td><td>"+ifnull(client.clerk_nameAccountApprover)+"</td>";
		tr+="<td>"+ifnull(client.customer_third_type)+"</td><td>"+ifnull(client.ifUseCredit)+"</td>";
		tr+="<td>"+ifnull(client.ifUseDeposit)+"</td><td>"+ifnull(client.price_type)+"</td>";
		tr+="<td>"+ifnull(client.customer_type)+"</td></tr>";
		return tr;
	}
	try {
		o2o.next_tree("client",function(n){
			return treeli(n.corp_name,n.customer_id);
		},undefined,function(treeId){
			o2o.clickGetTable("getCustomer.do?customer_id="+treeId,treeId,function(data){
				return getTr(data);
			});
		});
		$(".tree").find("span:contains('我公司')").click();
		o2o.editClient("clientEdit.do?customer_id=");
		o2o.delClient("client"); 
//		$("#editClient").click(function(){
//			var select_treeId=$("#select_treeId").val();
//			$.get("clientEdit.do",{"customer_id":select_treeId},function(data){
//				$("#list").hide();
//				$("#editpage").html(data);
//			});
//		});
	} catch (e) {}
////////////////////////////////
	$("#find").click(function(){
		var searchKey=$("#searchKey").val();
		pop_up_box.loadWait(); 
		$.get("getCustomer.do",{
			"searchKey":searchKey
		},function(data){
			pop_up_box.loadWaitClose();
			$("tbody").html("");
			$.each(data.rows,function(i,n){
				$("tbody").append(getTr(n));
			});
			$("#page").val("0");
			$("#totalPage").html(data.totalPage);$(".pull-left .form-control").val(data.totalRecord);
			treeSelectId="";
			selectTr();
		});
	});
//	$("#find").click();
	function loadData(page){
		var searchKey=$("#searchKey").val();
		pop_up_box.loadWait();
		$.get("getCustomer.do",{
			"searchKey":searchKey,
			"page":page,
			"customer_id":treeSelectId
		},function(data){
			$("tbody").html("");
			pop_up_box.loadWaitClose();
			$.each(data.rows,function(i,n){
				$("tbody").append(getTr(n));
			});
			selectTr();
			$("#totalPage").html(data.totalPage);$(".pull-left .form-control").val(data.totalRecord);
		});
	}
	//1.首页
	$("#beginpage").click(function(){
		$("#page").val("0");
		loadData($("#page").val());
	});
	//2.尾页
	$("#endpage").click(function(){
		$("#page").val($("#totalPage").html());
		loadData($("#totalPage").html());
	});
	$("#uppage").click(function(){
		var page=$("#page").val();
		page=parseInt(page)-1;
		if (page>=0) {
			$("#page").val(page);
			loadData(page);
		}else{
			pop_up_box.showMsg("已到第一页!");
		}
	});
	$("#nextpage").click(function(){
		var  totalpage=$("#totalPage").html();
		var  page=$("#page").val();
		  page=parseInt(page)+1;
		if (page<=totalpage) {
			$("#page").val(page);
			loadData(page);
		}else{
			pop_up_box.showMsg("已到最后一页!");
		}
	});
	////////////////////////////////
	$("#addclient").click(function(){
		$.cookie("backshowfind",JSON.stringify(getParamsBack()));
		window.location.href="clientEdit.do";
	});
	var backparams=$.cookie("backshowfind");
	if (backparams&&backparams!="null") {
		backparams=$.parseJSON(backparams);
		$("#page").val(backparams.page);
			if (backparams.user_id!="") {
				 $("#searchKey").val(backparams.user_id);
				pop_up_box.loadWait();
				$.get("getCustomer.do",{
					"searchKey":backparams.user_id,
					"customer_id":backparams.treeId,
					"page":backparams.page,
					"ver":Math.random()
				},function(data){
					pop_up_box.loadWaitClose();
					$("tbody").html("");
					$.each(data.rows,function(i,n){
						$("tbody").append(getTr(n));
					});
					$("#totalPage").val(data.totalPage);
					$(".pull-left .form-control").val(data.totalRecord);
					selectTr();
					treeSelectId="";
				});
			}else if (backparams.treeId!="") {
					o2o.clickGetTable("getCustomer.do?page="+backparams.page+"&customer_id="+backparams.treeId,backparams.treeId, function(n){
						return getTr(n);
					});
			}else{
				pop_up_box.loadWait();
				$.get("getCustomer.do",{
					"page":backparams.page,
					"ver":Math.random()
				},function(data){
					pop_up_box.loadWaitClose();
					$("tbody").html("");
					$.each(data.rows,function(i,n){
						$("tbody").append(getTr(n));
					});
					$("#totalPage").val(data.totalPage);$(".pull-left .form-control").val(data.totalRecord);
					selectTr();
					treeSelectId="";
				});
			}
		 
	}
	$.cookie("backshowfind",null); 
});
function getParamsBack(){
	var backshowfind={
			page:$("#page").val(),
			user_id:$("#user_id").val(),
			corp_name:$("#corp_name").val(),
			easy_id:$("#easy_id").val(),
			treeId:treeSelectId
	}
	return backshowfind;
}
function editClient(t){
	var tr=$(t).parents("tr");
	var customer_id=tr.find("input").val();
	window.location.href="clientEdit.do?customer_id="+customer_id;
//	$.get("clientEdit.do",{
//		"customer_id":customer_id
//	},function(data){
//		$("#list").hide();
//		$("#editpage").html(data);
//	});
}
function delClient(t){
	var tr=$(t).parents("tr");
	var td1=$.trim(tr.find("td:eq(1)").html());
	if ("我公司(虚拟)"==td1) {
		pop_up_box.showMsg("该记录属于系统级不能删除");
	}else if (window.confirm("是否要删除该记录?")) {
		var customer_id=tr.find("input").val();
		$.post("delClient.do",{"treeId":customer_id,"type":"client"},function(data){
			if (data.success) {
				tr.remove();
			}else{
				pop_up_box.showMsg(data.msg);
			}
		});
	}
}