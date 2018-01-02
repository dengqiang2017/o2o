$.ajaxSetup({  
	async : false  
});
function defineApproval(t,tijian){
	var customer_id=$(t).parents("tr").find("input[type='hidden']").val();
	var customer_name=$(t).parents("tr").find("td:eq(1)").text();
	var tel_no=$(t).parents("tr").find("td:eq(2)").html();
	if (tijian) {
		window.location.href="clientTijian.do?"+customer_id+"|"+customer_name+"|"+tel_no;
	}else{
		window.location.href="clientDefineApproval.do?"+customer_id+"|"+customer_name+"|"+tel_no;
	}
}
$(function(){
	var customer_id=getQueryString("customer_id");
	if(customer_id){
		editUtils.loadPage("clientEdit.do?customer_id="+customer_id,function(){
			clientEdit.init();
		});
		loadData(customer_id);
	}
	$("#sms").bind("input propertychange blur",function(){
		$("#smslen").html($("#sms").val().length);
	});
	$(".smsyue").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getBalance.do",function(data){
			pop_up_box.loadWaitClose();
			pop_up_box.showMsg("短信剩余数量:"+data);
		});
	});
	var count=0;
	$("#rows").change(function(){
		editUtils.page=0;
		count=0;
		loadData();
	});
	function loadData(customer_id){
		if(!customer_id){
		   customer_id=$(".tree .activeT").find("input[type='hidden']").val();;
		}
		$("#page").val(editUtils.page+1);
		var searchKey=$("#searchKey").val();
		$("th input[type='checkbox']").prop("checked",false);
		pop_up_box.loadWait();
		$.get("getCustomer.do",{
			"searchKey":searchKey,
			"page":editUtils.page,
			"rows":$("#rows").val(),
			"count":count,
			"customer_id":customer_id
		},function(data){
			$("#listpage tbody").html("");
			pop_up_box.loadWaitClose();
			$.each(data.rows,function(i,n){
				if($.trim(n.customer_id)=="CS1"){
					return;
				}else if($.trim(n.customer_id)=="CS1_ERROR"){
					return;
				}else if($.trim(n.customer_id)=="CS1_ZEROM"){
					return;
				}else{
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
								}else if(name=="driveId"){
									var driveNum=0;
									if(n.driveId){
										driveNum=n.driveId.split(",").length-1;
									}
									if($("#edit_hi").val()=="true"){
										tr.find("td:eq("+j+")").html("<span>司机("+driveNum+"位)</span><a class='btn btn-danger btn-xs' onclick='o2od.showDrive(this,\""+ifnull(n.driveId)+"\",\"list\")'>查看</a>");
									}
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
								}else if(name=="loginTime"){
									var loginTime="";
									if(n.loginTime!=""&&n.loginTime!=null){
										var now = new Date(n.loginTime);
										loginTime = now.Format("yyyy-MM-dd hh:mm:ss");
									}
									tr.find("td:eq("+j+")").html(loginTime);
								}else{
									tr.find("td:eq("+j+")").html(n[name]);
								}
							}
						}
					}
					if($.trim(n.customer_id)!="CS1C001"&&$.trim(n.customer_id)!="CS1C002"){
						tr.find("td:eq(0)").html(getbtn(n));
					}
				}
			});
			selectTr();
			$("#totalPage").html(data.totalPage+1);
			$("#totalRecord").html(data.totalRecord);
			editUtils.totalPage=data.totalPage;
			count=data.totalRecord;
			$("tbody .check").click(function(){
				setSelectClient(this);
			});
			$(".selectShow").click(function(){
				$(".tc").show();
			});
		});
	}
	function setSelectClient(t){
		var b=$(t).prop("checked");
		if(b){
//			for (var i = 0; i < len; i++) {
//				  var th=$($("#listpage th")[i]);          
//				  var dataname=$.trim(th.attr("data-name"));
//				  var j=$("#listpage th").index(th);
//				  if(name=="user_id"){
//				  }else if(name=="corp_sim_name"){
//				  }
//			}
			var phone=$.trim($(t).parents("tr").find("td").eq(1).text()); 
			var name=$.trim($(t).parents("tr").find("td").eq(2).text());
			var b1=true;
			for (var i = 0; i < $(".tc li").length; i++) {
				var li=$($(".tc li")[i]);
				if(phone==$.trim(li.find(".phone").html())){
					b1=false;
					break;
				}
			}
			if(b1){
				if(phone.length==11){
					var li=$('<li><span class="name"></span>-<span class="phone"></span><span class="glyphicon glyphicon-remove"></span></li>');
					$(".tc ul").append(li);
					li.find(".name").html(name);
					li.find(".phone").html(phone);
					li.find(".glyphicon-remove").click(function(){
						$(this).parent().remove();
						$("#selectCount").html("("+$(".tc li").length+"位)");
					});
				}
			}
			$("#selectCount").html("("+$(".tc li").length+"位)");
		}else{
			for (var j = 0; j < $("td input[type='checkbox']:not(:checked)").length; j++) {
				var phone=$.trim($($("td input[type='checkbox']")[j]).parents("tr").find("td").eq(1).text());
				for (var i = 0; i < $(".tc li").length; i++) {
					var li=$($(".tc li")[i]);
					if(phone==$.trim(li.find(".phone").html())){
						li.remove();
					}
				}
			}
			$("#selectCount").html("("+$(".tc li").length+"位)");
		}
	}
	$("th input[type='checkbox']").click(function(){
		$("td input[type='checkbox']").prop("checked",$(this).prop("checked"));
		for (var i = 0; i < $("td input[type='checkbox']").length; i++) {
			setSelectClient($($("td input[type='checkbox']")[i]));
		}
	});
	$(".tableShow").click(function(){
		for (var i = 0; i < $(".tc li").length; i++) {
			var li=$($(".tc li")[i]);
			for (var j = 0; j < $("td input[type='checkbox']").length; j++) {
				var phone=$.trim($($("td input[type='checkbox']")[j]).parents("tr").find("td").eq(1).text());
				if(phone==$.trim(li.find(".phone").html())){
					$($("td input[type='checkbox']")[j]).prop("checked",true);
				}
			}
		}
	});
	//群发短信
	$(".sendsms").click(function(){
		var txt=$.trim($(".tc textarea").val());
		var lis=$(".tc li");
		var selectType=$("input[name='selectType']:checked").val();
		if(txt==""){
			pop_up_box.showMsg("请输入短信内容!");
		}else if(lis.length<=0&&selectType!="0"){
			pop_up_box.showMsg("请选择短信接收人!");
		}else{
			var list=[];
			for (var i = 0; i < lis.length; i++) {
				var li=$(lis[i]);
				var name=li.find(".name").html();
				var phone=li.find(".phone").html();
				list.push(JSON.stringify({"name":name,"phone":phone}));
			}
			pop_up_box.postWait();
			$.post("../manager/sendsms.do",{
				"selectType":selectType,
				"mobile":$("#mobile").prop("checked"),
				"telecom":$("#telecom").prop("checked"),
				"unicom":$("#unicom").prop("checked"),
				"txt":txt,
				"list":"["+list.join(",")+"]"
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.toast("发送成功!",2000);
				} else {
					if (data.msg) {
						pop_up_box.showMsg("保存错误!" + data.msg);
					} else {
						pop_up_box.showMsg("保存错误!");
					}
				}
			});
		}
	});
	$("#treeAll").click(function(){
		editUtils.page=0;
		count=0;
		loadData();
	}); 
	try {
		o2o.next_tree("client",function(n){
			if($.trim(n.customer_id)=="CS1_ERROR"){
				return "";
			}else if($.trim(n.customer_id)=="CS1_ZEROM"){
				return "";
			}else{
				return treeli(n.corp_name,n.customer_id);
			}
		},undefined,function(treeId){
			editUtils.page=0;
			count=0;
			loadData(treeId);
		});
		$(".tree").find("span:contains('我公司')").click();
//		o2o.editClient("clientEdit.do?customer_id=");
		o2o.delClient("client"); 
	} catch (e) {}
////////////////////////////////
	$("#find").click(function(){
		editUtils.page=0;
		count=0;
		loadData();
	});
////////////////////////////////
	editUtils.paging(function(){
		loadData();
	});
	////////////
	$("#addclient").click(function(){
//		window.location.href="clientEdit.do";
		editUtils.loadPage("clientEdit.do",function(){
			clientEdit.init();
		});
	});
	$("#sendSpreadMsg").click(function(){
		pop_up_box.postWait();
		$.post("sendSpreadMsg.do",{
			"type":"client",
			"datatype":2,
			"searchKey":$("#searchKey").val(),
			"blessing":$("#blessing").val()
		},function(data){
			pop_up_box.loadWaitClose();
		});
	});
	
});
function getbtn(n){
   var btn="";
	var dysp="";
	if($("#edit_approval").val()=="true"&&$.trim(n.working_status)=="是"&&$.trim(n.user_id).length!=11){
		dysp="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='defineApproval(this);'>定义审批</button>";
	}
	if($("#edit_hi").val()=="true"){
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='editClient(this);'>修改</button>";
	}
	if($("#del_hi").val()=="true"){
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='delClient(this);'>删除</button>";
	}
	var b=$("th input[type='checkbox']").length;
	var pro="";
	if(b>0){
		pro="<input type='checkbox' class='check'>";
	}
   return pro+btn+dysp;
}
function editClient(t){
	var tr=$(t).parents("tr");
	var customer_id=tr.find("input[type='hidden']").val();
	editUtils.loadPage("clientEdit.do?customer_id="+customer_id,function(){
		clientEdit.init();
	});
}

function delClient(t){
	var tr=$(t).parents("tr");
	var td1=$.trim(tr.find("td:eq(1)").html());
	if ("我公司(虚拟)"==td1) {
		pop_up_box.showMsg("该记录属于系统级不能删除");
	}else if (window.confirm("是否要删除该记录?")) {
		var customer_id=tr.find("input[type='hidden']").val();
		pop_up_box.postWait();
		$.post("delClient.do",{"treeId":customer_id,"type":"client"},function(data){
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