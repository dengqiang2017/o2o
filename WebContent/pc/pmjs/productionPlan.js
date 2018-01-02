var productionPlan={
		init:function(){
			//查询条件赋值
			var com_id=$.trim($("#com_id").html());
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd");
			var onedays=nowStr.split("-");
			$("input[name='send_date']").val(onedays[0]+"-"+onedays[1]+"-01"); 
			nowStr = now.Format("yyyy-MM-dd hh:mm");
			$("input[name='plan_end_date']").val(nowStr); 
			loadSelect();
			//初始化
			$("#save").removeAttr("disabled");
			$(".tabs-content").hide();
			$(".tabs-content:eq(0)").show();
			$('body,html').animate({scrollTop:0},500);
			$("#allcheck").prop("checked",false);
			$(".nav li").removeClass("active");
			$(".nav li:eq(0)").addClass("active");
			var orderPage={page:0,count:0};
			var productPage={page:0,count:0};
			var planPage={page:0,count:0};
			productpage.initBtnClick(function(lia){
				if (lia==0) {
					orderPage.page=0;
				}else if(lia==1){
					productPage.page=0;
				}else{
					planPage.page=0;
				}
				loadData(0,0);
			});
			//切换li标签时模拟搜索框点击事件自动获取数据
			productpage.navLiClick(function(n){
				if (n == 2) {
					$("#save").hide();
					$(".btn-add:eq(" + n + ")").parent().show();
				}else if (n == 1) {
					$(".btn-add:eq(" + n + ")").parent().show();
					$("#save").show();
				}else{
					$("#save").show();
				}
			});
			//加载更多数据 
			productpage.btnAddClick(function(page,count,totalPage){
				if (lia==0) {
					orderPage.page+=1;
					page=orderPage.page;
					count=orderPage.count;
					totalPage=orderPage.totalPage;
				}else if(lia==1){
					productPage.page+=1;
					page=productPage.page;
					count=productPage.count;
					totalPage=productPage.totalPage;
				}else{
					planPage.page+=1;
					page=planPage.page;
					count=planPage.count;
					totalPage=planPage.totalPage;
				}
				if (page<=totalPage) {
					loadData(page, count);
				}
			});
			//增加产品
			function addItem(data) {
				if (data && data.rows.length > 0) {
					var lia = $(".nav li").index($(".nav .active"));
					$.each(data.rows,function(i, n) {
						var item =$($("#item").html());
						$(".tabs-content").eq(lia).find("#list").append(item);
						loadProInfo(item,n);
						//填充产品信息
						item.find("#customer_id").html(n.customer_id);
						if(n.item_id&&n.item_id.indexOf("NO.")>=0){
							item.find("#item_name").html("定制产品");
						}else{
							item.find("#item_name").html(n.item_name);
						}
						item.find("#item_id").html(n.item_id);
						if(n.info){
							if(n.info.demandInfo){
								item.find("#item_name").html(n.info.demandInfo);
							}
							item.find("img").attr("src",".."+n.imgs[0]);
							item.find("img").click(function(){
								pop_up_box.showImg(".."+n.imgs[0]);
							});
							item.find("#item_id").parent().show();
						}
						
						if(n.corp_sim_name){
							item.find("#corp_sim_name").html(n.corp_sim_name);
							item.find("#movtel").html(n.movtel);
						}else{
							item.find("#corp_sim_name").parent().remove();
							item.find("#movtel").parent().remove();
						}
						//根据下计划、已下计划、按产品生产、按计划生产填充数据
						if(lia!=2){
							item.find("#plan_end_date").parent().remove();
							if(lia==0){
								item.find(".num").val(isnull0(n.sd_oq));
								item.find("#sd_oq").html(isnull0(n.sd_oq));
								item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
							}else if(lia == 1){
								item.find("#ivt_oper_listing,#sd_oq").parent().remove();
							}
							//增加点击事件
							item.find("#moreMemo").attr("onclick","moreMemo(this)");
							item.find("#detailc_memo").parent().remove();
						} else{
							item.find("#use_oq").parent().remove();
							item.find("#sd_oq").parent().remove();
							if(n.plan_end_date){
								var now=new Date(n.plan_end_date);
								item.find("#plan_end_date").html(now.Format("yyyy-MM-dd hh:mm:ss"));
							} 
							if(n.detailauto_mps_id){
								item.find("#ivt_oper_listing").html(n.detailauto_mps_id);
							}
							if(n.orderNo){
								item.find("#ivt_oper_listing").html(n.orderNo);
							}
							item.find(".add").hide();
							item.find(".sub").hide();
							item.find(".num").val(n.JHSL);
							item.find(".num").attr("disabled","true");
							if(n.status==0){
								item.find("#moreMemo").attr("onclick","unuse(this)");
								item.find("#moreMemo").html("作废");
							}else{
								item.find("#moreMemo").hide();
							}
							item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
							item.find("#PH").html(n.PH);
							item.find("#c_memo").html(n.c_memo);
							item.find("#detailc_memo").html(n.detailc_memo);
							item.find("#memo_color").html(n.memo_color);
							item.find("#memo_other").html(n.memo_other);
							if(n.status==0){
								item.find("#status_trans").html("未生产");
								item.find("input[type='checkbox']").show();
							}else if(n.status=1){
								item.find("#status_trans").html("生产中");
								item.find("input[type='checkbox']").hide();
							}else{
								item.find("input[type='checkbox']").hide();
								item.find("#status_trans").html("已完成");
							}
							item.find("#seeds_id").html(n.seeds_id);
						}
					});
					$(".num").bind("input propertychange blur",function(){
						var chk=$(this).parents(".dataitem").find("input[type='checkbox']");
						if($.trim($(this).val())==""||$(this).val()=="0"){
							chk.prop("checked",false);
						}else{
							chk.prop("checked",true);
						}
					});
					productpage.detailClick(true,function(t){
						t.parents(".dataitem").find(".num").focus().select();
					});
				}
			}
 			function loadData(page,count){
				var lia = $(".nav li").index($(".nav .active"));
				var url;
				if(lia==0){
					url="../orderTrack/getWaitingHandleOrderPage.do?type=生产";
				}else if(lia==1){
					url="../product/getProductWarePage.do?type=生产";
				}else{
					url="../pPlan/getProductionPlanInfo.do";
				}
				var searchKey=$.trim($(".tabs-content").eq(lia).find("#searchKey").val());
				var json={};
				json.searchKey=searchKey;
				json.page=page;
				json.count=count;
				if(lia==2){
					json.beginDate= $.trim($(".tabs-content:eq(2)").find("#store_date").val());
					json.endDate=$.trim($(".tabs-content:eq(2)").find("#planned_delivery_date").val());
					json.c_memoMain=$.trim($("#c_memoMain").val());
				}else if(lia==1){
					json.type_id=common.getVal(".tabs-content:eq(1) #sort_name");
					json.quality_class=common.getVal(".tabs-content:eq(1) #quality_class");
					json.item_style=common.getVal(".tabs-content:eq(1) #item_style");
					json.class_card=common.getVal(".tabs-content:eq(1) #class_card");
					json.item_spec=common.getVal(".tabs-content:eq(1) #item_spec");
				}
				pop_up_box.loadWait();
				$.get(url,json, function(data) {
					pop_up_box.loadWaitClose();
					addItem(data);
					productpage.setPageParam(data);
				});
			}
			$(".find:eq(0)").click();
			//提交
			$("#save").click(function(){
				var dataArr = [];
				//生产计划
				var lia = $(".nav li").index($(".nav .active"));
				var plan_end_date=$.trim($(".tabs-content").eq(lia).find("input[name='plan_end_date']").val());
				if(plan_end_date==""){
					pop_up_box.showMsg("请输入预计完成时间");
					return;
				}
					var chks=$(".tabs-content").eq(lia).find("#list input[type='checkbox']:checked");
					if(chks&&chks.length>0){
						for (var i = 0; i < chks.length; i++) {
							var item=$(chks[i]).parents(".dataitem");
							dataArr.push(JSON.stringify({
								"item_id" : $.trim(item.find("#item_id").html()),
								"item_name" : $.trim(item.find("#item_name").html()),
								"corp_name" : $.trim(item.find("#corp_sim_name").html()),
								"JHSL" : $.trim(item.find(".num").val()),
								"PH" : $.trim(item.find("#PH").html()),
								"c_memo" : $.trim(item.find("#c_memo").html()),
								"memo_color" : $.trim(item.find("#memo_color").html()),
								"memo_other" : $.trim(item.find("#memo_other").html()),
								"customer_id" : $.trim(item.find("#customer_id").html()),
								"auto_mps_id" : $.trim(item.find("#ivt_oper_listing").html())
							}));
						}
				//提交数据
					pop_up_box.loadWait();
					$.post("../pPlan/saveProductionPlan.do", {
						"dataArr" : "["+dataArr.join(",")+"]",
						"headship":"派工",
						"processName":"下计划通知",
						"description":"@comName-派工员-@clerkName:你有新的派工任务需要处理",
						"title":"你有新的派工任务需要处理",
						"url":"/pPlan/productionTrackingQry.do?ivt_oper_listing=",
						"c_title":"订单进度通知",
						"c_description":"尊敬的客户：@customerName，您的销售订单号：@orderNo，已经开始[生产中]，请耐心等待",
						"c_url":"/customer/myorder.do",
						"c_memo" :  $.trim($(".tabs-content").eq(lia).find("#c_memoMain").val()),
//						"batch_mark" :  $.trim($(".tabs-content:eq(0)").find("#c_memoMain").val()),
						"plan_end_date" : plan_end_date
					},function(data) {
						pop_up_box.loadWaitClose();
						if(data.success){
							pop_up_box.showMsg("提交成功！",function(){$(".find").eq(lia).click()});
						}else{
							pop_up_box.showMsg(data.msg);
						}
					});
				}else{
					pop_up_box.showMsg("没有选择下计划的数据！");
				}
			});
			
			//删除
			$(".delete").click(function(){
				if(!confirm("是否要删除已下计划数据?")){
					return;
				}
				var dataArr = [];
				var lia = $(".nav li").index($(".nav .active"));
				//生产计划
				if(lia == 2){
					var chks=$(".tabs-content").eq(lia).find("#list input[type='checkbox']:checked");
					for (var i = 0; i < chks.length; i++) {
						var item=$(chks[i]).parents(".dataitem");
						dataArr.push(JSON.stringify({
							"seeds_id" : $.trim(item.find("#seeds_id").html())
						}));
					}
				}
				//提交数据
				if(dataArr.length > 0){
					pop_up_box.loadWait();
					$.get("../pm/delProductionPlan.do", {
						"dataArr" : dataArr
					},function(data) {
						pop_up_box.loadWaitClose();
						if(data.success){
							pop_up_box.showMsg("删除成功！",function(){$(".find").eq(lia).click()});
						}else{
							pop_up_box.showMsg(data.msg);
						}
					});
				}else{
					pop_up_box.showMsg("请选择要删除的生产计划！");
				}
			});
			
			//关闭模态框
			$("#closeDiv,.close").click(function(){
				$("#modal").hide();
			});
			
			//保存特殊制造要求
			$("#saveMoreMemo").click(function(){
				var ctn = $(".nowHere").parents(".dataitem");
				ctn.find("#PH").html($("input[name='PH']").val());
				ctn.find("#c_memo").html($("input[name='c_memo']").val());
				ctn.find("#memo_color").html($("input[name='memo_color']").val());
				ctn.find("#memo_other").html($("input[name='memo_other']").val());
				$("#modal").hide();
				$("input[name='PH']").val("");
				$("input[name='c_memo']").val("");
				$("input[name='memo_color']").val("");
				$("input[name='memo_other']").val("");
				$(".nowHere").removeClass("nowHere");
			});
		}
}

//特殊工艺备注
var moreMemo = function(data){
	$(data).addClass("nowHere");
	var ctn = $(data).parents(".dataitem");
	$("input[name='PH']").val(ctn.find("#PH").html());
	$("input[name='c_memo']").val(ctn.find("#c_memo").html());
	$("input[name='memo_color']").val(ctn.find("#memo_color").html());
	$("input[name='memo_other']").val(ctn.find("#memo_other").html());
	$("#modal").show();
};

//作废
var unuse = function(data){
	var dom = $(data).parents(".dataitem");
	var seeds_id = dom.find("#seeds_id").html();
	if(seeds_id){
		pop_up_box.loadWait();
		$.get("../pm/unuseProductionPlan.do", {
			"seeds_id" : seeds_id
		},function(data) {
			pop_up_box.loadWaitClose();
			if(data.success){
				pop_up_box.showMsg("生产计划作废成功！",function(){$(".find:eq(2)").click()});
			}else{
				pop_up_box.showMsg(data.msg);
			}
		});
	}
};
$(function() {
	productionPlan.init();
});