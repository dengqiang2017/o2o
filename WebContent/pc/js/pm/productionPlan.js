//客户编码，全局变量
var customer_id;
$(function() {
	//选择客户初始化
	productionPlan.init();
	selectClient.init(function(customerId) {
			tabsIndex=0;
			customer_id=customerId;
			$(".find:eq(0)").click();
		},"../employee/");
});

var productionPlan={
		init:function(){
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
			$("#save,#allcheck").removeAttr("disabled");
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
						item.find("#item_id").val(n.item_id);
						item.find("#item_name").html(n.item_name);
						item.find("#item_spec").html(n.item_spec);
						item.find("#item_type").html(n.item_type);
						item.find("#item_color").html(n.item_color);
						item.find("#item_struct").html(n.item_struct);
						item.find("#class_card").html(n.class_card);
						item.find("#vendor_id").html(n.vendor_id);
						item.find("#item_unit").html(n.item_unit);
						item.find("#casing_unit").html(n.casing_unit);
						item.find("#pack_unit").html(n.pack_unit);
						if (item.find("img").length>0) {
							item.find("img").attr("src",
									"../"+com_id+"/img/" + $.trim(n.item_id)
											+ "/cp/0.png");
							item.find("img").error(function() {
								this.src = "../"+com_id+"/img/"
										+ $.trim(n.item_id) + "/cp/0.jpg";
								$(this).unbind("error");
							});
						}
						if(tabsIndex == 1){
							item.find("#oper_oq").val(n.oper_oq);
							item.find("#oper_oq").attr("disabled","true");
							item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
						}
					});
					productpage.setPageShow(data);
					productpage.detailClick(true,function(t){
						t.parents(".p-msg").find(".num").focus().select();
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
						$(".find").click();
					}
				}
			});
			$(".nav li").removeClass("active");
			$(".nav li:eq(0)").addClass("active");
			//加载更多产品信息
			$(".btn-add").click(function() {
				var lia = $(".nav li").index($(".nav .active"));
				if(lia == 0){
					if (page ==  totalPage) {
						pop_up_box.showMsg("已全部加载!");
					} else {
						pop_up_box.loadWait();
						page=page+1;
						$.get("../pm/getProductInfo.do", {
							"searchKey" : $.trim($("#searchKey").val()),
							"count" : count,
							"page" : page
						}, function(data) {
							pop_up_box.loadWaitClose();
							addItem(data);
						});
					}
				}else{
					if (paged== totalPaged) {
						pop_up_box.showMsg("已全部加载!");
					} else {
						pop_up_box.loadWait();
						paged+=1;
						$.get("../pm/getProductionPlanInfo.do", {
							"searchKey" : $.trim($("#searchKey").val()),
							"store_date" : $.trim($("#store_date").val()),
							"planned_delivery_date" : $.trim($("#planned_delivery_date").val()),
							"c_memoMain" : $.trim($("#c_memoMain").val()),
							"ver" : Math.random()
						}, function(data) {
							pop_up_box.loadWaitClose();
							addItem(data);
						});
					}
				}
			});

			//查找
			$(".find").click(function() {
				var lia = $(".nav li").index($(".nav .active"));
				pop_up_box.loadWait();
					if(lia==0){
						item01.html("");
						item02.html("");
						$.get("../pm/getProductInfo.do", {
							"searchKey" : $.trim($("#searchKey").val())
						}, function(data) {
							pop_up_box.loadWaitClose();
							addItem(data);
							productpage.setPageParam(data);
						});
					}else{
						item03.html("");
						item04.html("");
						$.get("../pm/getProductionPlanInfo.do", {
							"searchKey" : $.trim($("#searchKey").val()),
							"store_date" : $.trim($("#store_date").val()),
							"planned_delivery_date" : $.trim($("#planned_delivery_date").val()),
							"c_memoMain" : $.trim($("#c_memoMain").val()),
							"ver" : Math.random()
						},function(data) {
							pop_up_box.loadWaitClose();
							addItem(data);
							productpage.setPageParam(data);
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
								if($(this).find("#oper_oq").val()!="" && $(this).find("#oper_oq").val()!=null){
									dataArr.push(JSON.stringify({
										"item_id" : $.trim($(this).find("#item_id").val()),
										"oper_oq" : $.trim($(this).find("#oper_oq").val())
									}));
								}else{
									pop_up_box.showMsg("请输入产品【"+$(this).find("#item_name").html()+"】的数量！");
								}
							}else{
								pop_up_box.showMsg("获取产品【"+$(this).find("#item_name").html()+"】的编码失败！");
							}
						}
					});
				}
				//已下计划
				else{
					
				}
				//提交数据
				if(dataArr.length > 0){
					pop_up_box.loadWait();
					$.get("../pm/addProductionPlan.do", {
						"dataArr" : dataArr,
						"ver" : Math.random()
					},function(data) {
						pop_up_box.loadWaitClose();
						if(data.success){
							pop_up_box.showMsg("生产计划添加成功！",function(){$(".find").click()});
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
				if(lia == 0){
					
				}
				//已下计划
				else{
					$(".tabs-content:eq(1) #item").each(function(){
						if($(this).find(".pro-check").hasClass("pro-checked")){
							if($(this).find("#item_id").val()!="" && $(this).find("#item_id").val()!=null
									&& $(this).find("#oper_oq").val()!="" && $(this).find("#oper_oq").val()!=null
									&& $(this).find("#ivt_oper_listing").html()!="" && $(this).find("#ivt_oper_listing").html()!=null){
								dataArr.push(JSON.stringify({
									"item_id" : $.trim($(this).find("#item_id").val()),
									"oper_oq" : $.trim($(this).find("#oper_oq").val()),
									"ivt_oper_listing" : $.trim($(this).find("#ivt_oper_listing").html())
								}));
							}else{
								pop_up_box.showMsg("获取产品【"+$(this).find("#item_name").html()+"】的信息失败！");
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
							pop_up_box.showMsg("生产计划删除成功！",function(){$(".find").click()});
						}else{
							pop_up_box.showMsg(data.msg);
						}
					});
				}else{
					pop_up_box.showMsg("请选择要删除的生产计划！");
				}
			});
		}
}