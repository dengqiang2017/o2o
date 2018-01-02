function backOrder(){
	$("#itempage").html("");
	$("#listorder").show();
	getContainerHtml("gysOrder.do");
}
$(function(){
	var itemhtml=$("#item").html();
	function addItem(data){
		if (data&&data.rows.length>0) {
			$.each(data.rows,function(i,n){
				if(n.item_name){
				var item=$(itemhtml);
				$("#itemlist").append(item);
				item.find("#no>span").append(n.st_auto_no);
				item.find("#item_name").append(n.item_name);
				if(n.item_type){
					item.find("#item_name").append(","+n.item_type);
				}
				if(n.c_memo){
					item.find("#c_memo").append(n.c_memo);
//					item.find("#c_memo").append(n.c_memo+"地点:"+n.wuliudx);
				}
				item.find("#seeds_id").val(n.seeds_id);
				item.find("#item_id").val(n.item_id);
				item.find("#customer_name").html(n.customer_name);
				if(n.casing_unit){
					item.find("#hav_rcv").append(n.hav_rcv+n.casing_unit);
				}else{
					item.find("#hav_rcv").append(n.hav_rcv);
				}
				item.find("#zsum").append(numformat(n.hav_rcv/n.pack_unit,0)+n.item_unit);
				
				if(item.find("#plandate").length>0){
					item.find("#plandate").append(new Date(n.finacial_d).Format("yyyy-MM-dd"));
				}else{
					item.find("#date").append(new Date(n.finacial_d).Format("yyyy-MM-dd hh:mm:ss"));
				}
				item.find("button").hide();
				if(n.m_flag==0){//0不作废,为1作废,2-已处理,3-无货
					item.find("#flag").append("未处理");
					item.find("button:eq(0)").show();
					item.find("button:eq(1)").show();
				}else if(n.m_flag==1){
					item.find("#flag").append("已作废");
//					item.find(".pro-check").hide();
					item.find(".check").remove();
				}else if(n.m_flag==2){
					item.find("#flag").append("已处理有货");
//					item.find("button:eq(2)").show();
				}else if(n.m_flag==9){
					item.find("#flag").append("已通知安排物流");
					item.find("button:eq(2)").show();
				}else if(n.m_flag==8){
					item.find("#flag").append("已提交物流信息");
					item.find("button:eq(2)").show();
				}else if(n.m_flag==3){
					item.find("#flag").append("已处理无货");
					item.find(".check").remove();
				}else if(n.m_flag==4){
					item.find("#flag").append("已发货");
//					item.find(".pro-check").hide();
					item.find(".check").remove();
				}else{
					item.find("#flag").append("已收货");
					item.find(".check").remove();
				}
				item.find("button:eq(0)").click({"item_id":n.item_id,"seeds_id":n.seeds_id,"st_auto_no":n.st_auto_no},function(event){
					var item_id=event.data.item_id;
					var seeds_id=event.data.seeds_id;
					var st_auto_no=event.data.st_auto_no; 
					setFlag(this,item_id,st_auto_no,2);
				});
				item.find("button:eq(1)").click({"item_id":n.item_id,"seeds_id":n.seeds_id,"st_auto_no":n.st_auto_no},function(event){
					var item_id=event.data.item_id;
					var seeds_id=event.data.seeds_id;
					var st_auto_no=event.data.st_auto_no; 
					setFlag(this,item_id,st_auto_no,3);
				});
				item.find("button:eq(2)").click({"item_id":n.item_id,"seeds_id":n.seeds_id,"st_auto_no":n.st_auto_no},function(event){
					var item_id=event.data.item_id;
					var seeds_id=event.data.seeds_id;
					var st_auto_no=event.data.st_auto_no; 
					setFlag(this,item_id,st_auto_no,4);
				});
				function setFlag(t,item_id,seeds_id,st_auto_no,index){
					var orderInfo="";
					for (var i = 0; i < 4; i++) {
						var item=$(t).parent().find("div:eq("+i+")").html();
						if(item){
							orderInfo=orderInfo+item+",";
						}
					}
					orderReceipt(item_id,seeds_id,st_auto_no,index,t,orderInfo);
				}
//				item.find(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
//					var b=$(this).hasClass("pro-checked");
//					if (b) {
//						$(this).removeClass("pro-checked");
//					}else{
//						$(this).addClass("pro-checked");
//					}
//				});
				}
			});
			if(data.totalPage==1){
				$(".btn-add").hide();
			}
		}else{
			$(".btn-add").hide();
		}
	}
	$(".xfooter button").hide();
	$("#type").change(function(){
		var val=$(this).val();
		$(".xfooter button").hide();
		if (val=="0") {
			$(".xfooter button:eq(0)").show();
			$(".xfooter button:eq(1)").show();
		}else if(val=="2"||val=="9"){
			$(".xfooter button:eq(2)").show();
		}else{
			$(".xfooter button").hide();
		}
		$(".find:eq(0)").click();
	});
	var page=0;
	var count=0;
	var totalPage=0;
	$(".btn-add").click(function(){
		page+=1;
		if (page==totalPage) {}else{
			loadData(page,count);
		}
	});
	$("#allcheck").bind("click",function(){
//		var b=$(this).hasClass("pro-checked");
//        if (b) {
//        $(".pro-check").removeClass("pro-checked");
//        }else{
//        $(".pro-check").addClass("pro-checked");
//        }
		var b=$(this).prop("checked");
		$("#itemlist .check").prop("checked",b);
	});
	$(".xfooter").find(".btn-primary:eq(0)").click(function(){//有货
		var chks=$("#itemlist").find(".check");
		if(chks&&chks.length>0){
			var list=[];
			for (var i = 0; i < chks.length; i++) {
				var pr=$(chks[i]).parent();
				var flag=pr.find("#flag").html();
				if(flag.indexOf("未处理")>=0){
					var json={};
					json.st_auto_no=$.trim(pr.find("#no>span").html());
					json.item_id=$.trim(pr.find("#item_id").val());
					json.seeds_id=$.trim(pr.find("#seeds_id").val());
					json.type=2;
					list.push(JSON.stringify(json));
				}
			}
			if(list.length>0){
				pop_up_box.postWait();
				$.get("orderReceipt.do",{
					"list":list,
					"title":"供应商有货，请安排并确认物流信息",
					"description":"@comName采购员@clerkName：@gys，已为您确认采购订单“有货”，请安排并确认车牌号及司机等物流信息，以便司机前往提货",
					"type":2
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("提交成功!",function(){
							$("#itemlist").html("");
							loadData(0,0);
						});
					} else {
						if (data.msg) {
							pop_up_box.showMsg("提交错误!" + data.msg);
						} else {
							pop_up_box.showMsg("提交错误!");
						}
					}
				});
			}else{
				pop_up_box.showMsg("没有要处理的信息!");
			}
		}
	});
	$(".xfooter").find(".btn-primary:eq(1)").click(function(){//无货
		var chks=$("#itemlist").find(".check");
		if(chks&&chks.length>0){
			var list=[];
			var st_auto_no="";
			for (var i = 0; i < chks.length; i++) {
				var pr=$(chks[i]).parent();
				var flag=pr.find("#flag").html();
				if(flag.indexOf("未处理")>=0){
					var json={};
					json.st_auto_no=$.trim(pr.find("#no>span").html());
					json.item_id=$.trim(pr.find("#item_id").val());
					json.seeds_id=$.trim(pr.find("#seeds_id").val());
					json.type=3;
					st_auto_no=json.st_auto_no;
					list.push(JSON.stringify(json));
				}
			}
			if(list.length>0){
				pop_up_box.postWait();
				$.get("orderReceipt.do",{
					"list":list,
					"title":"供应商无货，需换供应商",
					"description":"@comName采购员@clerkName：@gys，为您授理采购订单，结果“无货”，请及时更换供应商办理采购。采购订单编号："+st_auto_no,
					"type":3
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("提交成功!",function(){
							$("#itemlist").html("");
							loadData(0,0);
						});
					} else {
						if (data.msg) {
							pop_up_box.showMsg("提交错误!" + data.msg);
						} else {
							pop_up_box.showMsg("提交错误!");
						}
					}
				});
			}else{
				pop_up_box.showMsg("没有要处理的信息!");
			}
		}
	});
	$(".xfooter").find(".btn-primary:eq(2)").click(function(){//已发货
		var chks=$("#itemlist").find(".check");
		if(chks&&chks.length>0){
			var list=[];
			for (var i = 0; i < chks.length; i++) {
				var pr=$(chks[i]).parent();
				var flag=pr.find("#flag").html();
				var c_memo=$.trim(pr.find("#c_memo").html());
				var json={};
				json.st_auto_no=$.trim(pr.find("#no>span").html());
				json.item_id=$.trim(pr.find("#item_id").val());
				json.seeds_id=$.trim(pr.find("#seeds_id").val());
				json.type=4;
				list.push(JSON.stringify(json));
			}
			if(list.length>0){
				pop_up_box.postWait();
				$.get("orderReceipt.do",{
					"list":list,
					"title":"您的货物已装车出库，请注意收货并验收 ",
					"description":"@comName库管@clerkName：您的采购订单，已装车出库，请注意收货并验收，届时将有司机联系您。点开消息查看清单并验收（此条信息重要，务请保留，直至收货验收完毕）",
					"type":4
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("提交成功!",function(){
							$("#itemlist").html("");
							loadData(0,0);
						});
					} else {
						if (data.msg) {
							pop_up_box.showMsg("提交错误!" + data.msg);
						} else {
							pop_up_box.showMsg("提交错误!");
						}
					}
				});
			}else{
				pop_up_box.showMsg("没有要处理的信息!");
			}
		}
	});
	$(".find").click(function(){
		$("#itemlist").html("");
		loadData(0,0);
	});
	var url=window.location.href.split("?");
	if(url&&url.length>1){
		var ps=url[1].split("|");
		if(ps.length>1){
			var sear=ps[0].split("=")[1];
			$("#searchKey").val(sear);
			$("#type").val(ps[1]);$("#type").change();
		}else{
			var sear=url[1].split("=")[1];
			$("#searchKey").val(sear);
			var params=window.location.href.split("?");
			var st_auto_no="";
			if(params&&params.length>1){
				params=params[1].split("&");
				if(params&&params.length>1){
					for (var i = 0; i < params.length; i++) {
						var urls=params[i].split("=");
						$("#searchKey").val(urls[1]);
						if("st_auto_no"==urls[0]){
							st_auto_no=urls[1];
						}
					}
				}else{
					st_auto_no=params[0].split("=")[1];
				}
			}
		}
		var type=getQueryString("type");
		var st_auto_no=getQueryString("st_auto_no");
		if(st_auto_no!=null&&st_auto_no!=undefined){
			$("#searchKey").val(st_auto_no);
		}
		if(type!=null&&type!=undefined){
			$("#type").val(type);$("#type").change();
		}
	}else{
		var now = new Date();
		var nowStr = now.Format("yyyy-MM-dd"); 
//		now=addDate(nowStr,1);
//		nowStr = now.Format("yyyy-MM-dd"); 
		$(".Wdate:eq(0)").val(nowStr);
		$(".Wdate:eq(1)").val(nowStr);
		loadData(0,0);
	}
////////////////////
	function loadData(page,count){
		pop_up_box.loadWait();
		var rows="10";
		if($("#rows").length>0){
			rows=$("#rows").html();
		}
		$.get("getGysOrderList.do",{
			"searchKey":$.trim($("#searchKey").val()),
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val(),
			"type":$("#type").val(),
			"st_auto_no":st_auto_no,
			"rows":rows,
			"page":page,
			"count":count
		},function(data){
			pop_up_box.loadWaitClose();
			addItem(data); 
			totalPage = data.totalPage;
			count = data.totalRecord;
		});
	}
	///
	function orderReceipt(item_id,seeds_id,st_auto_no,type,t,orderInfo){
		pop_up_box.postWait();
		$.get("orderReceipt.do",{
			"item_id":item_id,
			"seeds_id":seeds_id,
			"st_auto_no":st_auto_no,
			"type":type, 
			"orderInfo":$.trim(orderInfo)
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("提交成功!");
				if(type==2){
					$(t).parent().find("#flag").html("订单状态:已处理有货");
					$(t).next().remove();
				}else{
					$(t).parent().find("#flag").html("订单状态:已处理无货");
					$(t).prev().remove();
				}
				$(t).remove();
			} else {
				if (data.msg) {
					pop_up_box.showMsg("提交错误!" + data.msg);
				} else {
					pop_up_box.showMsg("提交错误!");
				}
			}
		});
	}
});