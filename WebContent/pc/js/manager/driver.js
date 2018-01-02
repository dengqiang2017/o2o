$.ajaxSetup({  
	async : false  
});
var driveId="";
var clientdrive="";
$(function(){
	function clientDriveShow(){///参数类型 driveId|listpage(edit)&客户名称|电话|客户编码
		var param=window.location.href.split("?")[1];
		if(param){
			var params=param.split("&");
			if(params.length>1){
				var info=params[0];
				var clientInfos=params[1].split("_");
				var infos=info.split("_");
				driveId=infos[0];
				info=infos[1];//标识是从客户列表或者客户详细进入
				//设置手机端的时候返回链接
				var url;
				if(info!="edit"){
					$(".breadcrumb:eq(1)>li:eq(2)").hide();
					url=$(".breadcrumb:eq(1)>li:eq(1)").find("a").attr("href");
				}else{
					$(".breadcrumb:eq(1)>li:eq(2)").show();
					url=$(".breadcrumb:eq(1)>li:eq(2)").find("a").attr("href");
				}
				clientdrive=clientInfos[2];
				$(".header-title:eq(1)>a").attr("href",url);
				$(".header").hide();
				$(".header:eq(1)").show();
				$(".box-head").show();
				$("#addDrive").show();
				$(".box-head:eq(0)").find("h4:eq(0)").html("客户名称:"+decodeURI(clientInfos[0]));
				$(".box-head:eq(0)").find("h4:eq(1)>a").attr("href","tel:"+clientInfos[1]);
				$(".box-head:eq(0)").find("h4:eq(1)>a").html(clientInfos[1]);
				$("#upload-btn,.excel").hide();
				$("#addDrive").click({
					"customer_id":clientInfos[2]
				},function(event){
					pop_up_box.loadWait();
					$.get("../tree/getDeptTree.do",{"type":"driver"},function(data){
						pop_up_box.loadWaitClose();
						$("body").append(data);
						driver.init("select",function(){
							var chks=$('input[type="checkbox"]:checked');
							if(chks&&chks.length>0){
								var drid="";
								for (var i = 0; i < chks.length; i++) {
									var dId=$(chks[i]).parents("tr").find("input[type='hidden']").val();
									if(driveId.indexOf(dId)<0){
										driveId=dId+","+driveId;
										drid=dId+","+drid;
									}
								}
								$.post("../user/postCientDriveId.do",{
									"customer_id":event.data.customer_id,
									"type":"add",
									"driveId":drid
								},function(datap){
									if(datap){
										$("#find").click();
									}else{
										pop_up_box.showMsg("提交错误");
									}
								});
							}
						});
					});
				});
			}
		}
	}
	clientDriveShow();
	$("#addDriveInfo").click(function(){
		var param=window.location.href.split("?")[1];
		if(!param){
			param="";
		}
		editUtils.loadPage("driverEdit.do?"+param,function(){
			driver.init();
		});
	});
	var customer_id=getQueryString("customer_id");
	if(customer_id){
		editUtils.loadPage("driverEdit.do?id="+customer_id,function(){
			driver.init();
		});
		loadData(customer_id);
	}
	var count=0;
	function loadData(customer_id){
		$("#page").val(editUtils.page+1);
		var searchKey=$("#searchKey").val();
		pop_up_box.loadWait();
		$.get("../saiyu/getElectricianPage.do",{
			"searchKey":searchKey,
			"isclient":"1",
			"page":editUtils.page,
			"count":count,
			"clientdrive":clientdrive,
			"showAll":$("#showAll").prop("checked"),
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
							}else if(name=="driveId"){
								var driveNum=0;
								if(n.driveId){
									driveNum=n.driveId.split(",").length-1;
								}
								if($("#edit_hi").val()=="true"){
									tr.find("td:eq("+j+")").html("<span>司机("+driveNum+"位)</span><a class='btn btn-danger btn-xs' onclick='o2od.showDrive(this,\""+ifnull(n.driveId)+"\",\"listpage\")'>查看</a>");
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
	if($("#edit_hi").val()=="true"){
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='editVendor(this);'>修改</button>";
	}
	if($("#del_hi").val()=="true"){
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='delVendor(this);'>删除</button>";
	}
	   return btn;
	}
function editVendor(t){
	var tr=$(t).parents("tr");
	var customer_id=tr.find("input").val();
	if(clientdrive){
		var url="driverEdit.do?"+window.location.href.split("?")[1]+"&id="+customer_id;
		editUtils.loadPage(url,function(){
			driver.init();
		});
	}else{
		editUtils.loadPage("driverEdit.do?id="+customer_id,function(){
			driver.init();
		});
	}
}
function delVendor(t){
	if(confirm("是否删除该司机信息！")){
		var tr=$(t).parents("tr");
		var customer_id=tr.find("input").val();
		if(clientdrive){
			driveId=driveId.replace(customer_id+",", "");
			pop_up_box.postWait();
			 $.post("../user/postCientDriveId.do",{
				 "customer_id":clientdrive,
				 "type":"del",
				 "driveId":customer_id
			 },function(datap){
				 pop_up_box.loadWaitClose();
				 if(datap){
					 $("#find").click();
				 }else{
					 pop_up_box.showMsg("提交错误");
				 }
			 });
		}else{
			$.post("delClient.do",{"treeId":customer_id,"type":"drive"},function(data){
				if (data.success) {
					tr.remove();
				}else{
					pop_up_box.showMsg(data.msg);
				}
			});
		}
	}
}