$(function(){
	planReport.init();
});

var planReport={
		init:function(){
///初始化日期为当前日期
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd"); 
			$(".Wdate").val(nowStr);
			$(".tabs-content:eq(0)>.subtabs-content").find(".Wdate:eq(1)").val("");
			$(".tabs-content:eq(0)>.subtabs-content").find(".Wdate:eq(2)").val("");
			var subtabs_content2=$(".tabs-content:eq(2)").find(".subtabs-content");
			var yue=subtabs_content2.find(".Wdate").val().split("-")[1];
			subtabs_content2.find("p").html("计划月份为:"+(parseInt(yue)+1)+"月");
			function loadExpandfind(){
				return "<div class='folding-btn m-t-b'>" +
				"<button type='button' class='btn btn-primary btn-folding expandfind'>展开搜索</button>" +
				"<button type='button' class='btn btn-danger excel btn-folding'>导出</button></div>";
			}
			$(".subtabs-content").prepend(loadExpandfind());
			$(".expandfind").click(function(){
				var t=$(this).parents(".subtabs-content");
				var form=t.find("form");
				if(form.is(":hidden")){
					form.show();
					$(this).text("隐藏搜索");
				}else{
					$(this).text("展开搜索");
					form.hide();
				}
			}); 
			if($(".folding-btn").css("display")=="none"){
				$("form").show();
			}else{
				$("form").hide();
			}
			$(".nav-tabs li").click(function() {
				var n = $(".nav-tabs li").index(this);
				if (n==0) {//日计划
					n=0;
				}else if (n==1) {//周计划
					n=4;
				}else{//月计划
					n=7;
				}
				$(".navsubtabs li:eq("+n+")").click();
			});
			$(".find").click(function(){
				var n=$(".find").index(this);
				var nav = $(".nav li").index($(".nav .active"));
				var navsubtabs = $(".navsubtabs li").index($(".navsubtabs .active"));
				pop_up_box.loadWait();
				if (nav==0) {//日计划
					if (navsubtabs==0) {//日计划分客户
						dayPlanClient();
					}else if (navsubtabs==1){//日计划部分客户
						dayPlanAllProduct();
					}else if(navsubtabs==2){//录入
						dayPlanDetail();
					}else{//分产品3
						dayProduct();
					}
				}else if (nav==1) {//周计划
					if (navsubtabs==4) {//周计划分客户
						weeklyPlanClient();
					}else if (navsubtabs==5){//周计划部分客户
						weeklyPlanAllProduct();
					}else{//周计划分产品6
						weekProduct();
					}
				}else{//月计划
					if (navsubtabs==7) {//分客户7 0
						monthlyPlanClient();
					}else if (navsubtabs==8) {//导入oracle8 1
						monthlyPlanOracle();
					}else if (navsubtabs==9) {//分产品9 2
						monthlyPlanProduct();
					}else{//分客户产品10 3
						monthlyPlan();
					}
				}
			});
			$(".excel").click(function(){
				var n=$(".excel").index(this);
				var nav = $(".nav li").index($(".nav .active"));
				var navsubtabs = $(".navsubtabs li").index($(".navsubtabs .active"));
				pop_up_box.loadWait();
				if (nav==0) {//日计划
					if (navsubtabs==0) {//日计划分客户0
						dayPlanClientExcel();
					}else if (navsubtabs==1){//日计划部分客户1
						dayPlanAllProductExcel();
					}else if(navsubtabs==2){//2
						dayPlanDetail("excel");
					}else{//3
						dayProductExcel();
					}
				}else if (nav==1) {//周计划
					if (navsubtabs==4) {//周计划分客户
						weeklyPlanClientProductExcel();
					}else if (navsubtabs==5){//周计划部分客户
						weeklyPlanAllProductExcel();
					}else{//周计划分产品6
						weekProductExcel();
					}
				}else{//月计划
					if (navsubtabs==7) {
						monthlyPlanClientExcel();
					}else if (navsubtabs==8) {
						monthlyPlanOracleExcel();
					}else if (navsubtabs==9) {
						monthlyPlanProductExcel();
					}else{
						monthlyPlanExcel();
					}
				}
			});
			
			$(".print").click(function(){
				var n=$(".print").index(this);
				var nav = $(".nav li").index($(".nav .active"));
				var navsubtabs = $(".navsubtabs li").index($(".navsubtabs .active"));
				if (nav==0) {//日计划
					if (navsubtabs==0) {//日计划分客户
					}else if (navsubtabs==1){//日计划部分客户
					}
				}else if (nav==1) {//周计划
					if (navsubtabs==2) {//周计划分客户
					}else if (navsubtabs==3){//周计划部分客户
						$("#print04").jqprint();
					}
				}else{//月计划
				}
			});
			var subtabs00={//分客户
					page:0,
					totalRecord:0,
					totalPage:0
			}
			var subtabs01={//日计划所有产品
					page:0,
					totalRecord:0,
					totalPage:0
			}
			var subtabs0_3={///日计划明细
					page:0,
					totalRecord:0,
					totalPage:0
			}
			var subtabs0_4={///日计划-分产品
					page:0,
					totalRecord:0,
					totalPage:0
			}
			var subtabs02={//周计划分客户
					page:0,
					totalRecord:0,
					totalPage:0
			}
			var subtabs03={// 周计划录入
					page:0,
					totalRecord:0,
					totalPage:0
			}
			var subtabs04={//月计划
					page:0,
					totalRecord:0,
					totalPage:0
			}
			/**
			 * 日计划明细
			 */
			function dayPlanDetail(excel){
				var subtabs_content=$(".tabs-content:eq(0)").find(".subtabs-content:eq(2)");
				var tbody0=subtabs_content.find("table:eq(0)>tbody");
				var type=subtabs_content.find("#type");
				var employeetype=$("#employeetype").val();
				if (!excel) {
					$.get("../product/planDayDetail.do",getParams(subtabs_content,type.val()),function(data){
						tbody0.html("");
						$.each(data.rows,function(i,n){
							var tr=getTr(12);
							tbody0.append(tr);
							if($.trim(n.if_Insert_Plan)=="是"){
								tr.css("background-color","red");
							}
							if (n.clerk_name) {
								if ($.trim(n.accountTurn_Flag)=="已结转") {
									tr.find("td:eq(0)").html("<div class='checkbox checkedbox'><input type='hidden' value='"+n.seeds_id+"'></div>");
								}else{
									tr.find("td:eq(0)").html("<div class='checkbox'><input type='hidden' value='"+n.seeds_id+"'></div>");
								}
							}else{
								tr.find("td:eq(0)").html("");
							}
							tr.find("td:eq(1)").html(n.dept_name);
							tr.find("td:eq(2)").html(n.dept_id);tr.find("td:eq(2)").hide();
							
							tr.find("td:eq(3)").html(n.clerk_name);
							tr.find("td:eq(4)").html(n.clerk_id);tr.find("td:eq(4)").hide();
							
							tr.find("td:eq(5)").html(n.corp_sim_name); 
							tr.find("td:eq(6)").html(n.customer.self_id); tr.find("td:eq(6)").hide();
							
							tr.find("td:eq(7)").html(n.item_name);
							tr.find("td:eq(8)").html(n.item.peijian_id);tr.find("td:eq(8)").hide();
							tr.find("td:eq(9)").html(n.sd_oq);
							if (n.so_consign_date&&n.so_consign_date!="") {
								var now = new Date(n.so_consign_date);
								var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
								tr.find("td:eq(10)").html(nowStr);
								var at = new Date(n.at_term_datetime);
								var nowStr = at.Format("yyyy-MM-dd"); 
								tr.find("td:eq(11)").html(nowStr);
							}
						});
						if (employeetype.indexOf("内勤")>0) {
							$("tr").find(".checkbox").click(function(){
								var accountTurn_Flag;
								if ($(this).hasClass("checkedbox")) {
									$(this).removeClass("checkedbox");
									accountTurn_Flag="N";
								}else{
									$(this).addClass("checkedbox");
									accountTurn_Flag="Y";
								}
								$.get("updatePlanFlag.do",{
									"accountTurn_Flag":accountTurn_Flag,
									"seeds_id":$(this).find("input").val()
								},function(data){});
							});
						}
						pop_up_box.loadWaitClose();
						subtabs0_3.page=data.page-1;
						subtabs0_3.totalPage=data.totalPage-1;
						subtabs0_3.totalRecord=data.totalRecord;
					});
				}else{
					var config;
					if ("周计划"==type.val()) {
						config="week";
					}else if ("月计划"==type.val()) {
						
					}else{
						config="day";
					}
					if (config) {
						$.get("../product/planDayDetailExcel.do?config="+config,getParams(subtabs_content,type.val()),function(data){
							pop_up_box.loadWaitClose();
							window.location.href=data.msg;
						});
					}else{
						pop_up_box.showMsg("月计划不提供导出!");
					}
				}
				if ("周计划"==type.val()) {
					subtabs_content.find('#zhuci').show();
				}else{
					subtabs_content.find('#zhuci').hide();
				}
			}
			/**
			 * 日计划分客户
			 */
			function dayPlanClient(){
				var subtabs_content=$(".tabs-content:eq(0)").find(".subtabs-content:eq(0)");
				var tbody0=subtabs_content.find("table:eq(0)>tbody");
				$.get("../product/weeklyPlanAllProduct.do?fenxi=day&day=day",getParams(subtabs_content,"日计划"),function(data){
					tbody0.html("");
					$.each(data.rows,function(i,n){
						var tr=getTr(9);
						tbody0.append(tr);
						tr.find("td:eq(0)").html(n.clerk_name);
						tr.find("td:eq(1)").html(n.dept_name);
						tr.find("td:eq(2)").html(n.corp_sim_name); 
						tr.find("td:eq(3)").html(n.item_name);
						if ($.trim(n.item_name)=="") {
							tr.find("td:eq(3)").html();
						}else{
							tr.find("td:eq(3)").html(n.item_name);
						}
						tr.find("td:eq(4)").html(n.sd_oq);
						if (n.so_consign_date&&n.so_consign_date!="") {
							var now = new Date(n.so_consign_date);
							var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
							tr.find("td:eq(5)").html(nowStr);
							var at = new Date(n.at_term_datetime);
							var nowStr = at.Format("yyyy-MM-dd"); 
							tr.find("td:eq(6)").html(nowStr);
						}
						if (n.order_datetime&&n.order_datetime!="") {
							var now = new Date(n.order_datetime);
							var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
							tr.find("td:eq(7)").html(nowStr);
						}
						tr.find("td:eq(8)").html(n.sd_oq_View_sdd02020);
						
					});
					pop_up_box.loadWaitClose();
					subtabs00.page=data.page-1;
					subtabs00.totalPage=data.totalPage-1;
					subtabs00.totalRecord=data.totalRecord;
					if (data.totalRecord>0) {
						daycount(subtabs_content,tbody0);
					}
				});  
			}
			function daycount(subtabs_content,tbody){
				$.get("../product/weeklyPlanAllProductCount.do",getParams(subtabs_content,"日计划"),function(data){
					var tr=getTr(5);
					tbody.append(tr);
					tr.find("td:eq(3)").html(data.item_id);
					tr.find("td:eq(4)").html(data.sd_oq);
				});
			}
			function daycount_Client(subtabs_content,tbody){
				$.get("../product/weeklyPlanAllProductCount.do",getParams(subtabs_content,"日计划"),function(data){
					var tr=getTr(5);
					tbody.append(tr);
					tr.find("td:eq(1)").html(data.item_id);
					tr.find("td:eq(2)").html(data.sd_oq);
				});
			}
			/**
			 * 日计划所有产品
			 */
			function dayPlanAllProduct(){
				var subtabs_content=$(".tabs-content:eq(0)").find(".subtabs-content:eq(1)");
				var tbody=subtabs_content.find("table>tbody");
				$.get("../product/weeklyPlanAllProduct.do?day=day",getParams(subtabs_content,"日计划"),function(data){
					tbody.html("");
					$.each(data.rows,function(i,n){
						var tr=getTr(9);
						tbody.append(tr);
						tr.find("td:eq(0)").html(n.dept_name);
						tr.find("td:eq(1)").html(n.item_name);//dept_name
						tr.find("td:eq(2)").html(n.sd_oq); 
						if ($.trim(n.item_name)=="") {
							tr.find("td:eq(1)").html(n.item_id);
						}else{
							tr.find("td:eq(1)").html(n.item_name);
						}
						if (n.so_consign_date&&n.so_consign_date!="") {
							var now = new Date(n.so_consign_date);
							var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
							tr.find("td:eq(3)").html(nowStr);
							var at = new Date(n.at_term_datetime);
							var nowStr = at.Format("yyyy-MM-dd"); 
							tr.find("td:eq(4)").html(nowStr);
						}
					});
					pop_up_box.loadWaitClose();
					subtabs01.page=data.page-1;
					subtabs01.totalPage=data.totalPage-1;
					subtabs01.totalRecord=data.totalRecord;
					if (data.totalRecord>0) {
						daycount_Client(subtabs_content,tbody);
					}
				}); 
				
			}
			/**
			 * 日计划-分产品导出
			 */
			function dayProductExcel(){
				var subtabs_content=$(".tabs-content:eq(0)").find(".subtabs-content:eq(3)");
				$.get("../product/dayProductExcel.do",getParams(subtabs_content,"日计划"),function(data){
					pop_up_box.loadWaitClose();
					window.location.href=data.msg;
				});
			}
			/**
			 * 日计划-分产品
			 */
			function dayProduct(){
				var subtabs_content=$(".tabs-content:eq(0)").find(".subtabs-content:eq(3)");
				var tbody=subtabs_content.find("table>tbody");
				$.get("../product/dayProduct.do?day=day",getParams(subtabs_content,"日计划"),function(data){
					tbody.html("");
					$.each(data.rows,function(i,n){
						var tr=getTr(4);///多少数据列
						tbody.append(tr);
						tr.find("td:eq(0)").html(n.sort_name);
						tr.find("td:eq(1)").html(n.item_sim_name);
						tr.find("td:eq(2)").html(n.sd_oq); 
						tr.find("td:eq(3)").html(n.sd_oq_View_sdd02020);
					});
					pop_up_box.loadWaitClose();
					subtabs0_4.page=data.page-1;
					subtabs0_4.totalPage=data.totalPage-1;
					subtabs0_4.totalRecord=data.totalRecord;
				});  
			}
			/**
			 * 周计划分客户
			 */
			function weeklyPlanClient(){
				var subtabs_content=$(".tabs-content:eq(1)").find(".subtabs-content:eq(0)");
				var tbody=subtabs_content.find("table>tbody");
				tbody.html(""); 
				$.get("../product/weeklyPlanAllProduct.do?fenxi=week",getParams(subtabs_content,"周计划"),function(data){
					$.each(data.rows,function(i,n){
						var tr=getTr(5);
						tbody.append(tr);
						tr.find("td:eq(0)").html(n.clerk_name);
						tr.find("td:eq(1)").html(n.dept_name);
						tr.find("td:eq(2)").html(n.corp_sim_name); 
						tr.find("td:eq(3)").html(n.item_name);
						if ($.trim(n.item_name)=="") {
							tr.find("td:eq(3)").html(n.item_id);
						}else{
							tr.find("td:eq(3)").html(n.item_name);
						}
						tr.find("td:eq(4)").html(n.sd_oq);
					});
					pop_up_box.loadWaitClose();
					subtabs02.page=data.page-1;
					subtabs02.totalPage=data.totalPage-1;
					subtabs02.totalRecord=data.totalRecord;
					if (data.totalRecord>0) {
						weekcount_Client(subtabs_content,tbody);
					}
				});
				
			}
			/**
			 * 周计划分产品导出
			 */
			function weekProductExcel(){
				var subtabs_content=$(".tabs-content:eq(1)").find(".subtabs-content:eq(2)");
				$.get("../product/weekProductExcel.do",getParams(subtabs_content,"周计划"),function(data){
					pop_up_box.loadWaitClose();
					window.location.href=data.msg;
				});
			}
			/**
			 * 周计划分产品
			 */
			function weekProduct(){
				var subtabs_content=$(".tabs-content:eq(1)").find(".subtabs-content:eq(2)");
				var tbody=subtabs_content.find("table>tbody");
				tbody.html(""); 
				$.get("../product/weekProduct.do",getParams(subtabs_content,"周计划"),function(data){
					$.each(data.rows,function(i,n){
						var tr=getTr(4);///多少数据列
						tbody.append(tr);
						tr.find("td:eq(0)").html(n.sort_name);
						tr.find("td:eq(1)").html(n.item_sim_name);
						tr.find("td:eq(2)").html(n.sd_oq); 
						tr.find("td:eq(3)").html(n.sd_oq_View_sdd02020);
					});
					pop_up_box.loadWaitClose();
					subtabs02.page=data.page-1;
					subtabs02.totalPage=data.totalPage-1;
					subtabs02.totalRecord=data.totalRecord; 
				});
			}
			
			function weekcount_Client(subtabs_content,tbody){
				$.get("../product/weeklyPlanAllProductCount.do",getParams(subtabs_content,"周计划"),function(data){
					var tr=getTr(5);
					tbody.append(tr);
					tr.find("td:eq(3)").html(data.item_id);
					tr.find("td:eq(4)").html(data.sd_oq);
				});
			}
			
			function weeklyPlanAllProductExcel(){
				var subtabs_content=$(".tabs-content:eq(1)").find(".subtabs-content:eq(1)");
//		window.location.href="../product/weeklyPlanAllProductExcel2.do?"+parseParam(getParams(subtabs_content,"周计划"));
				$.get("../product/weeklyPlanAllProductExcel.do?config=week&excel=excel",getParams(subtabs_content,"周计划"),function(data){
					pop_up_box.loadWaitClose();
					window.location.href=data.msg;
				});
			}
			function weeklyPlanClientProductExcel(){
				var subtabs_content=$(".tabs-content:eq(1)").find(".subtabs-content:eq(0)");
				$.get("../product/weeklyPlanAllProductExcel.do?config=weekfenxi&fenxi=week",getParams(subtabs_content,"周计划"),function(data){
					pop_up_box.loadWaitClose();
					window.location.href=data.msg;
				});
			}
			function dayPlanClientExcel(){
				var subtabs_content=$(".tabs-content:eq(0)").find(".subtabs-content:eq(0)");
				$.get("../product/weeklyPlanAllProductExcel.do?config=dayfenxi&fenxi=day&day=day",getParams(subtabs_content,"日计划"),function(data){
					pop_up_box.loadWaitClose();
					window.location.href=data.msg;
				});
			}
			function dayPlanAllProductExcel(){
				var subtabs_content=$(".subtabs-content:eq(1)");
				$.get("../product/weeklyPlanAllProductExcel.do?config=day&day=day",getParams(subtabs_content,"日计划"),function(data){
					pop_up_box.loadWaitClose();
					window.location.href=data.msg;
				});
			}
			function monthlyPlanExcel(){
				var subtabs_content=$(".tabs-content:eq(2)").find(".subtabs-content:eq(3)");
				$.get("../product/weeklyPlanAllProductExcel.do?config=dayfenxi&fenxi=month",getParams(subtabs_content,"月计划"),function(data){
					pop_up_box.loadWaitClose();
					window.location.href=data.msg;
				});
			}
			/**
			 * 周计划分客户
			 */
			function weeklyPlanAllProduct(){
				var subtabs_content=$(".tabs-content:eq(1)").find(".subtabs-content:eq(1)");
				var tbody=subtabs_content.find("table>tbody");
				tbody.html("");
				$.get("../product/weeklyPlanAllProduct.do",getParams(subtabs_content,"周计划"),function(data){
					$.each(data.rows,function(i,n){
						var tr=getTr(4);
						tbody.append(tr);
//				tr.find("td:eq(0)").html(n.dept_id);
						tr.find("td:eq(0)").html(n.dept_name);
//				tr.find("td:eq(2)").html(n.weeksnum);
//				tr.find("td:eq(3)").html(n.item_id);
//				subtabs_content.find("#zhouci").html();
						if ($.trim(n.item_name)=="") {
							tr.find("td:eq(1)").html(n.item_id);
						}else{
							tr.find("td:eq(1)").html(n.item_name);
						}
						tr.find("td:eq(1)").html(n.item_name);
						tr.find("td:eq(2)").html(n.sd_oq);
						tr.find("td:eq(3)").html(n.sd_oq_View_sdd02020);
					});
					pop_up_box.loadWaitClose();
					subtabs03.page=data.page-1;
					subtabs03.totalPage=data.totalPage-1;
					subtabs03.totalRecord=data.totalRecord;
					if (data.totalRecord>0) {
						weekcount(subtabs_content,tbody);
					}
				});
			}
			
			function weekcount(subtabs_content,tbody){
				$.get("../product/weeklyPlanAllProductCount.do",getParams(subtabs_content,"周计划"),function(data){
					var tr=getTr(4);
					tbody.append(tr);
					tr.find("td:eq(1)").html(data.item_id);
					tr.find("td:eq(2)").html(data.sd_oq);
					tr.find("td:eq(3)").html(data.sd_oq_View_sdd02020); 
				});
			}
//	$(".btn-primary:eq(3)").click();
			/**
			 * 月计划
			 */
			function monthlyPlan(){//7
				var subtabs_content=$(".tabs-content:eq(2)").find(".subtabs-content:eq(3)");
				var tbody=subtabs_content.find("table>tbody");
				tbody.html(""); 
				var yue=subtabs_content.find(".Wdate").val().split("-")[1];
				$.get("../product/weeklyPlanAllProduct.do?fenxi=month",getParams(subtabs_content,"月计划"),function(data){
					$.each(data.rows,function(i,n){
						var tr=getTr(7);
						tbody.append(tr);
						tr.find("td:eq(0)").html(n.corp_sim_name);
						tr.find("td:eq(1)").html(n.item_name);
						tr.find("td:eq(2)").html(yue); //月份
						tr.find("td:eq(3)").html(n.sd_oq);
						if ($.trim(n.item_name)=="") {
							tr.find("td:eq(1)").html(n.item_id);
						}else{
							tr.find("td:eq(1)").html(n.item_name);
						} 
					});
					pop_up_box.loadWaitClose();
					subtabs04.page=data.page-1;
					subtabs04.totalPage=data.totalPage-1;
					subtabs04.totalRecord=data.totalRecord;
					if (data.totalRecord>0) {
						monthcount(subtabs_content,tbody);
					}
				});
			}
			
			function monthcount(subtabs_content,tbody){
				$.get("../product/weeklyPlanAllProductCount.do",getParams(subtabs_content,"月计划"),function(data){
					var tr=getTr(7);
					tbody.append(tr);
					tr.find("td:eq(1)").html(data.item_id);
					tr.find("td:eq(3)").html(data.sd_oq);
				});
			}
			function monthlyPlanClientExcel(){
				var subtabs_content=$(".tabs-content:eq(2)").find(".subtabs-content:eq(0)");
				$.get("../product/monthlyPlanExcel.do?monthtype=client",getParams(subtabs_content,"月计划"),function(data){
					pop_up_box.loadWaitClose();
					window.location.href=data.msg;
				});
			}
			function monthlyPlanClient(){
				var subtabs_content=$(".tabs-content:eq(2)").find(".subtabs-content:eq(0)");
				var tbody=subtabs_content.find("table>tbody");
				tbody.html(""); 
				$.get("../product/monthlyPlan.do?monthtype=client",getParams(subtabs_content,"月计划"),function(data){
					$.each(data.rows,function(i,n){
						var tr=getTr(5);
						tbody.append(tr); 
						tr.find("td:eq(0)").html(n.clerk_name);
						tr.find("td:eq(1)").html(n.dept_name);
						tr.find("td:eq(2)").html(n.corp_sim_name); 
						tr.find("td:eq(3)").html(n.item_sim_name);
						if ($.trim(n.dept_name)=="") {
							tr.find("td:eq(1)").html("合计");
						}
						tr.find("td:eq(4)").html(n.sd_oq);
//				tr.find("td:eq(4)").html(n.sd_oq_View_sdd02020);
					});
					pop_up_box.loadWaitClose(); 
				});
				
			}
			function monthlyPlanOracleExcel(){
				var subtabs_content=$(".tabs-content:eq(2)").find(".subtabs-content:eq(1)");
				$.get("../product/monthlyPlanExcel.do",getParams(subtabs_content,"月计划"),function(data){
					pop_up_box.loadWaitClose();
					window.location.href=data.msg;
				});
			}
			function monthlyPlanOracle(){
				var subtabs_content=$(".tabs-content:eq(2)").find(".subtabs-content:eq(1)");
				var tbody=subtabs_content.find("table>tbody");
				tbody.html("");  
				$.get("../product/monthlyPlan.do",getParams(subtabs_content,"月计划"),function(data){
					$.each(data.rows,function(i,n){
						var tr=getTr(5);
						tbody.append(tr); 
						tr.find("td:eq(0)").html(n.dept_name);
						tr.find("td:eq(1)").html(n.item_sim_name);
						if ($.trim(n.dept_name)=="") {
							tr.find("td:eq(0)").html("合计");
						}
						tr.find("td:eq(2)").html(n.sd_oq);
						tr.find("td:eq(3)").html(n.sd_oq_View_sdd02020);
					});
					pop_up_box.loadWaitClose(); 
				});
			}
			function monthlyPlanProductExcel(){
				var subtabs_content=$(".tabs-content:eq(2)").find(".subtabs-content:eq(2)");
				$.get("../product/monthlyPlanExcel.do?monthtype=product",getParams(subtabs_content,"月计划"),function(data){
					pop_up_box.loadWaitClose();
					window.location.href=data.msg;
				});
			}
			
			function monthlyPlanProduct(){
				var subtabs_content=$(".tabs-content:eq(2)").find(".subtabs-content:eq(2)");
				var tbody=subtabs_content.find("table>tbody");
				tbody.html("");  
				$.get("../product/monthlyPlan.do?monthtype=product",getParams(subtabs_content,"月计划"),function(data){
					$.each(data.rows,function(i,n){
						var tr=getTr(4);
						tbody.append(tr); 
						tr.find("td:eq(0)").html(n.sort_name);
						tr.find("td:eq(1)").html(n.item_sim_name);
						if ($.trim(n.dept_name)=="") {
							tr.find("td:eq(0)").html("合计");
						}
						tr.find("td:eq(2)").html(n.sd_oq);
						tr.find("td:eq(3)").html(n.sd_oq_View_sdd02020);
					});
					pop_up_box.loadWaitClose(); 
				});
			}
			//////////
			$(".footer").append("v1.0.10.06");
		}
}


function zhuci(){
	var week=parseInt($dp.cal.getP('W','W'))+1;
	$(this).parents(".subtabs-content").find('#zhuci').html("计划周次为:"+week+"周");
}
function yuefen(){
	var subtabs_content=$(this).parents(".subtabs-content");
	var yue=subtabs_content.find(".Wdate").val().split("-")[1];
	subtabs_content.find("p").html("计划月份为:"+(parseInt(yue)+1)+"月");
}
function zhuciday(){
	if ($(this).parents(".subtabs-content").find("#type").val()=="周计划") {
		var week=parseInt($dp.cal.getP('W','W'))+1;
		$(this).parents(".subtabs-content").find('#zhuci').show();
		$(this).parents(".subtabs-content").find('#zhuci').html("计划周次为:"+week+"周");
	}else{
		$(this).parents(".subtabs-content").find('#zhuci').hide();
	}
}
function clearDate(){
	var wd=$(this).parents(".subtabs-content").find(".Wdate").index(this);
	if (wd==0) {
		$(this).parents(".subtabs-content").find(".Wdate:eq(1)").val("");
		$(this).parents(".subtabs-content").find(".Wdate:eq(2)").val("");
	}else{
		$(this).parents(".subtabs-content").find(".Wdate:eq(0)").val("");
	}
}
/**
 * 周计划所有产品 参数组合
 */
function getParams(subtabs_content,plantype){
	var atBeginTime=subtabs_content.find(".Wdate:eq(1)").val();
	var atEndnTime=subtabs_content.find(".Wdate:eq(2)").val();
	if (atBeginTime&&$.trim(atBeginTime)!="") {
		 atBeginTime=atBeginTime+" 00:00:00";
	}
	if (atEndnTime&&$.trim(atEndnTime)!="") {
		atEndnTime=atEndnTime+" 23:59:59";
	}
	var param={
			"item_name":subtabs_content.find("#item_name").val(),
			"beginDate":subtabs_content.find(".Wdate:eq(0)").val(),
			"atBeginTime":atBeginTime,
			"atEndTime":atEndnTime,
			"find":"find",
			"customer_name":subtabs_content.find("#customer_name").val(),
			"sd_order_direct":plantype,
			"type":subtabs_content.find("#type").val(),
			"ver":Math.random()
	};
	return param;
}