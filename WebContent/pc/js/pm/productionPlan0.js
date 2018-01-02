//生产计划数据来源[产品]

var tabsIndex = 0;		//标签索引
var page = 1;			//当前页数
var currentRecord = 0;	//当前记录数
var totalRecord = 0;	//总记录数

$(function() {	
	productionPlan.init();		//初始化
	$(".find:eq(0)").click();	//查询
});

var productionPlan={
		init:function(){
			//查询条件赋值
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd"); 
			var onedays=nowStr.split("-");
			$("input[name='send_date']").val(onedays[0]+"-"+onedays[1]+"-01"); 
			$("input[name='plan_end_date']").val(nowStr); 
			
			//初始化
			var tabs0 = $(".tabs-content:eq(0)");
			var tabs1 = $(".tabs-content:eq(1)");
			var item01 = tabs0.find("#item01");
			var item02 = tabs0.find("#item02");
			var item03 = tabs1.find("#item01");
			var item04 = tabs1.find("#item02");
			var itemhtml = $("#item");
			item01.html("");
			item02.html("");
			item03.html("");
			item04.html("");
			$("#save").removeAttr("disabled");
			$(".btn-add:eq(" + tabsIndex + ")").parent().show();
			$(".tabs-content:eq(0)").show();
			$(".tabs-content:eq(1)").hide();
			
			//增加产品
			function addItem(data) {
				if (data && data.rows.length > 0) {
					if (tabsIndex == 0) {
						item1 = item01;
						item2 = item02;
					} else {
						item1 = item03;
						item2 = item04;
					}
					$.each(data.rows,function(i, n) {
						var item =$(itemhtml.parent().html());
						if (i % 2 == 0) {
							item1.append(item);
						} else {
							item2.append(item);
						}
						
						//填充产品信息
						item.find("#item_id").val(n.item_id);
						item.find("#item_name").html(n.item_name);
						item.find("#item_spec").html(n.item_spec);
						item.find("#item_type").html(n.item_type);
						item.find("#item_color").html(n.item_color);
						item.find("#class_card").html(n.class_card);
						item.find("#casing_unit").html(n.casing_unit);
						item.find("#item_unit").html(n.item_unit);
						item.find("#pack_unit").html(n.pack_unit);
						//增加点击事件
						item.find(".num").attr("onchange","num(this)");
						item.find(".zsum").attr("onchange","zsum(this)");
						item.find(".pro-check").attr("onclick","checked(this)");
						item.find("#moreMemo").attr("onclick","moreMemo(this)");
						
						if (item.find("img").length>0) {
							item.find("img").attr("src",
									"../"+com_id+"/img/" + $.trim(n.item_id)
											+ "/cp/0.png");
							item.find("img").error(function() {
								this.src = "../"+com_id+"/img/"
										+ $.trim(n.item_id) + "/cp/0.jpg";
								$(this).unbind("error");
							});
							 var url="../product/productDetail.do?item_id="+n.item_id;
								item.find("a").attr("href",url);
						}
						//根据下计划、已下计划、按产品生产、按计划生产填充数据
						if(tabsIndex == 0){
							//do nothing
						}else{
							if(!Number(n.pack_unit)){
								n.pack_unit = 1;
							}
							item.find(".num").val(n.JHSL/n.pack_unit);
							item.find(".num").attr("disabled","true");
							item.find(".zsum").val(n.JHSL);
							item.find(".zsum").attr("disabled","true");
							
							item.find("#status_trans").html(n.status_trans);
							if(n.status==0){
								item.find("#moreMemo").attr("onclick","unuse(this)");
								item.find("#moreMemo").html("作废");
							}else{
								item.find("#moreMemo").hide();
							}
							
							item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
							item.find("#PH").html(n.PH);
							item.find("#c_memo").html(n.c_memo);
							item.find("#memo_color").html(n.memo_color);
							item.find("#memo_other").html(n.memo_other);
							item.find("#seeds_id").html(n.seeds_id);
						}
					});
				}
			}
			
			//下计划、已下话tab切换
			$(".nav li").click(function() {
				var n = $(".nav li").index(this);
				$(".nav li").removeClass('active');
				$(this).addClass('active'); 
				$(".tabs-content").hide(); 
				$(".tabs-content:eq("+n+")").show(); 
				tabsIndex = n;
				if (n == 1) {
					if (tabs1.find("#item01").html()=="") {
						$(".find:eq(0)").click();
					}
					$("#save").attr("disabled",true);
					$("#allcheck").removeAttr("disabled");
					$(".btn-add:eq(" + tabsIndex + ")").parent().show();
				}else{
					$("#save").removeAttr("disabled");
					$("#allcheck").attr("disabled",true);
				}
			});
			$(".nav li").removeClass("active");
			$(".nav li:eq(0)").addClass("active");
			
			//加载更多产品信息
			$(".btn-add").click(function() {
				var lia = $(".nav li").index($(".nav .active"));
				if(lia == 0){
					if (currentRecord >=  totalRecord) {
						pop_up_box.showMsg("已全部加载!");
						$(".btn-add:eq(" + tabsIndex + ")").parent().hide();
					} else {
						pop_up_box.loadWait();
						page=page+1;
						$.get("../pm/getProductInfo.do", {
							"searchKey" : $.trim($("#searchKey").val()),
							"page" : page
						}, function(data) {
							pop_up_box.loadWaitClose();
							addItem(data);
							currentRecord = page*data.pageRecord;
							totalRecord = data.totalRecord;
						});
					}
				}else{
					if (currentRecord >=  totalRecord) {
						pop_up_box.showMsg("已全部加载!");
						$(".btn-add:eq(" + tabsIndex + ")").parent().hide();
					} else {
						pop_up_box.loadWait();
						page=page+1;
						$.get("../pm/getProductionPlanInfo.do", {
							"sd_order_id" : $.trim($("#sd_order_id").val()),
							"batch_mark" : $.trim($("#batch_mark").val()),
							"searchKey" : $.trim($("#searchKey").val()),
							"send_date" : $.trim($("input[name='send_date']").val()),
							"plan_end_date" : $.trim($("input[name='plan_end_date']").val()),
							"memo" : $.trim($("#memo").val()),
							"page" : page,
							"ver" : Math.random()
						}, function(data) {
							pop_up_box.loadWaitClose();
							addItem(data);
							currentRecord = page*data.pageRecord;
							totalRecord = data.totalRecord;
						});
					}
				}
			});
			
			//查找
			$(".find:eq(0)").click(function() {
				var lia = $(".nav li").index($(".nav .active"));
				pop_up_box.loadWait();
					if(lia==0){
						item01.html("");
						item02.html("");
						$.get("../pm/getProductInfo.do", {
							"searchKey" : $.trim($("#searchKey").val()),
							"ver" : Math.random()
						}, function(data) {
							pop_up_box.loadWaitClose();
							addItem(data);
							currentRecord = page*data.pageRecord;
							totalRecord = data.totalRecord;
						});
					}else{
						item03.html("");
						item04.html("");
						$.get("../pm/getProductionPlanInfo.do", {
							"sd_order_id" : $.trim($("#sd_order_id").val()),
							"batch_mark" : $.trim($("#batch_mark").val()),
							"searchKey" : $.trim($("#searchKey").val()),
							"send_date" : $.trim($("input[name='send_date']").val()),
							"plan_end_date" : $.trim($("input[name='plan_end_date']").val()),
							"memo" : $.trim($("#memo").val()),
							"page" : page,
							"ver" : Math.random()
						},function(data) {
							pop_up_box.loadWaitClose();
							addItem(data);
							currentRecord = page*data.pageRecord;
							totalRecord = data.totalRecord;
						});
					}
			});	
			
			//全部选中
			$("#allcheck").click(function(){
				var lia = $(".nav li").index($(".nav .active"));
				if(lia == 0){
					if($(".tabs-content:eq(0) .pro-check:eq(0)").hasClass("pro-checked")){
						$(".tabs-content:eq(0) .pro-check").each(function(){
							$(".tabs-content:eq(0) .pro-check").removeClass("pro-checked");
						});
					}else{
						$(".tabs-content:eq(0) .pro-check").each(function(){
							$(".tabs-content:eq(0) .pro-check").addClass("pro-checked");
						});
					}
				}else{
					if($(".tabs-content:eq(1) .pro-check:eq(0)").hasClass("pro-checked")){
						$(".tabs-content:eq(1) .pro-check").each(function(){
							$(".tabs-content:eq(1) .pro-check").removeClass("pro-checked");
						});
					}else{
						$(".tabs-content:eq(1) .pro-check").each(function(){
							$(".tabs-content:eq(1) .pro-check").addClass("pro-checked");
						});
					}
				}
				$(".tabs-content:eq(0) .pro-check:last").removeClass("pro-checked");
			});
			
			//提交
			$("#save").click(function(){
				var dataArr = [];
				var lia = $(".nav li").index($(".nav .active"));
				//生产计划
				if(lia == 0){
					$(".tabs-content:eq(0) #item").each(function(){
						if($(this).find(".pro-check").hasClass("pro-checked")){
							if($(this).find("#item_id").val()!="" && $(this).find("#item_id").val()!=null){
								if($(this).find(".zsum").val()!="" && $(this).find(".zsum").val()!=null){
									dataArr.push(JSON.stringify({
										"item_id" : $.trim($(this).find("#item_id").val()),
										"JHSL" : $.trim($(this).find(".zsum").val()),
										"PH" : $.trim($(this).find("#PH").html()),
										"c_memo" : $.trim($(this).find("#c_memo").html()),
										"memo_color" : $.trim($(this).find("#memo_color").html()),
										"memo_other" : $.trim($(this).find("#memo_other").html()),
										"customer_id" : "",
										"auto_mps_id" : $.trim($(this).find("#ivt_oper_listing_span").html())?$.trim($(this).find("#ivt_oper_listing_span").html()):"",
										"mps_id" : $.trim($(this).find("#sd_order_id_span").html())?$.trim($(this).find("#sd_order_id_span").html()):"",
										"mps_seeds_id" : $.trim($(this).find("#seeds_id_span").html())?$.trim($(this).find("#seeds_id_span").html()):""
									}));
								}
							}
						}
					});
				}
				//提交数据
				if(dataArr.length > 0){
					pop_up_box.loadWait();
					$.get("../pm/addProductionPlan.do", {
						"dataArr" : dataArr,
						"ivt_oper_listing" :  $.trim($(".ivt_oper_listing").html()),
						"sd_order_id" :  $.trim($(".sd_order_id").html()),
						"batch_mark" :  $.trim($("#batch_mark").val()),
						"send_date" : $.trim($("input[name='send_date']").val()),
						"plan_end_date" : $.trim($("input[name='plan_end_date']").val()),
						"ver" : Math.random()
					},function(data) {
						pop_up_box.loadWaitClose();
						if(data.success){
							pop_up_box.showMsg("生产计划添加成功！",function(){$(".find:eq(0)").click()});
						}else{
							pop_up_box.showMsg(data.msg);
						}
					});
				}else{
					pop_up_box.showMsg("请选择将要下计划的产品！");
				}
			});
			
			//删除
			$(".delete").click(function(){
				var dataArr = [];
				var lia = $(".nav li").index($(".nav .active"));
				//生产计划
				if(lia == 1){
					$(".tabs-content:eq(1) #item").each(function(){
						if($(this).find(".pro-check").hasClass("pro-checked")){
							if($(this).find("#seeds_id").html()!="" && $(this).find("#seeds_id").html()!=null){
								dataArr.push(JSON.stringify({
									"seeds_id" : $.trim($(this).find("#seeds_id").html())
								}));
							}else{
								pop_up_box.showMsg("删除失败！");
							}
						}
					});
				}

				//提交数据
				if(dataArr.length > 0){
					pop_up_box.loadWait();
					$.get("../pm/delProductionPlan.do", {
						"dataArr" : dataArr,
						"ver" : Math.random()
					},function(data) {
						pop_up_box.loadWaitClose();
						if(data.success){
							pop_up_box.showMsg("生产计划删除成功！",function(){$(".find:eq(0)").click()});
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
				var ctn = $(".nowHere").parent().parent();
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

//注册图片选择框选择或者取消功能
var checked = function(data){
	var flag = $(data).hasClass("pro-checked");
	if(flag){
		$(data).removeClass("pro-checked");
	}else{
		$(data).addClass("pro-checked");
	}
};

//数量监听事件
var num = function(data){
	var num = $(data).val();
	var parentDom = $(data).parent().parent().parent();
	var pack_unit = parentDom.find("#pack_unit").html();
	if(!Number(pack_unit)){
		pack_unit = 1;
	}
	parentDom.find(".zsum").val(num/pack_unit);
	parentDom.find(".pro-check").addClass("pro-checked");
};

//折算数量监听事件
var zsum = function(data){
	var zsum = $(data).val();
	var parentDom = $(data).parent().parent().parent();
	var pack_unit = parentDom.find("#pack_unit").html();
	if(!Number(pack_unit)){
		pack_unit = 1;
	}
	parentDom.find(".num").val(zsum*pack_unit);
	parentDom.find(".pro-check").addClass("pro-checked");
};

//特殊工艺备注
var moreMemo = function(data){
	$(data).addClass("nowHere");
	$("#modal").show();
};

//作废
var unuse = function(data){
	var dom = $(data).parent().parent();
	var seeds_id = dom.find("#seeds_id").html();
	if(seeds_id){
		pop_up_box.postWait();
		$.post("../pm/unuseProductionPlan.do", {
			"seeds_id" : seeds_id
		},function(data) {
			pop_up_box.loadWaitClose();
			if(data.success){
				pop_up_box.showMsg("生产计划作废成功！",function(){$(".find:eq(0)").click()});
			}else{
				pop_up_box.showMsg(data.msg);
			}
		});
	}
};