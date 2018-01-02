var order ={
		init:function(){
			var type=0;
			var item01 = $("#item01"); 
			var itemhtml=$("#item");
			item01.html(""); 
			var comid=getQueryString("com_id");
			if(comid!=""){
				com_id=comid;
			}else{
				comid=$.cookie("com_id",{path:"/"});
				if(comid){
					com_id=comid;
				}
				if(comid.indexOf("com_id=")==0){
					com_id="";
				}
			}
			if(!com_id){
				com_id="001";
			}
			///////
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd"); 
			$(".Wdate:eq(1)").val(nowStr);
			/////
			 $('body,html').animate({scrollTop:0},500);
			var page_plan=0;
			var count_plan=0;
			var totalPage_plan=0;
			function addItem(data){
				if (data&&data.rows.length>0) {
					var item1 = item01; 
					$.each(data.rows,function(i,n){
						var item=$(itemhtml.html());
						item1.append(item); 
						item.find("#item_id").val(n.item_id);
						item.find("#seeds_id").val(n.seeds_id);
						item.find("#com_id").append($.trim(n.com_id));
						
						var sd_unit_price=n.sd_unit_price;
						item.find("#sd_unit_price").html(sd_unit_price);
						item.find("#seeds_id").val(n.seeds_id);
						var lia = $(".nav li").index($(".nav .active"));
						
						if (lia==1) {
							item.find("#sd_oq").html(n.sy_num);
						}else if(lia==2){
							item.find(".zsum").val(n.sd_oq);
//							item.find(".zsum").val(n.pack_num);
						}else{
							item.find("#sd_oq").html(n.sd_oq);
						}
						///////////////////////
//						var val=$.trim(item.find(".zsum").val());
//						var pack_unit=n.pack_unit;
//						if (val!="") {
//							item.find(".p-middle").find(".num").val(numformat2(parseFloat(val)/parseFloat(pack_unit)));
//							item.find("#sum_si").html(numformat2(val*sd_unit_price));
//						}
						var val=productpage.itemInit(n,item);
						if (val) {
							item.find("#sum_si").html(numformat2(val*sd_unit_price));
						}
						
						item.find("#item_unit").html(n.item_unit);
						item.find(".item_unit").html(n.item_unit);
						var pack_unit=n.pack_unit;
						if (!pack_unit) {
							pack_unit=1;
						}
						item.find("#pack_unit").html(numformat2(pack_unit));
						item.find("#casing_unit").html(n.casing_unit);
						
						item.find("#item_name").html(n.item_name);
						item.find("#item_spec").html(n.item_spec);
						item.find("#item_type").html(n.item_type);
						item.find("#item_color").html(n.item_color);
						item.find("#class_card").html(n.class_card);
						item.find("#quality_class").html(n.quality_class);
						item.find("#price_type").html(n.price_type);
						item.find("#qz_days").html(n.qz_days);
						item.find("#use_oq").html(n.accn_ivt);
						if ($("#accnIvt").val()!="true") {
							item.find("#use_oq").parent().hide(); 
						}
						if ($.trim(n.ivt_oper_listingMyPlan)!="") {
							item.find("#ivt_oper_listingMyPlan").html(n.ivt_oper_listingMyPlan);
						}
						item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
						if (n.discount_ornot=="Y") {
							item.find("#discount_ornot").html("有");
						}else{
							item.find("#discount_ornot").html("无");
						}
						productpage.itemDateInit(n.discount_time_begin,item,"discount_time_begin");
						productpage.itemDateInit(n.discount_time,item,"discount_time");
						
						item.find("#sd_unit_price_DOWN").html(numformat2(sd_unit_price));
						item.find("#sd_unit_price_UP>strong").html(numformat2(sd_unit_price));
						item.find("#sd_unit_price").val(numformat2(sd_unit_price));
						item.find("#price_display").val(numformat2(n.price_display));
						item.find("#price_prefer").val(numformat2(n.price_prefer));
						item.find("#price_otherDiscount").val(numformat2(n.price_otherDiscount));
						if (item.find("img:eq(0)").length>0) {
						item.find("img:eq(0)").attr("src","/"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg?ver="+Math.random());
						if($.trim(n.com_id)=="001Y8"){
							var url="/product/productDetailEwm.do?item_id="+$.trim(n.item_id)+"&com_id="+$.trim(n.com_id);
							item.find("a").attr("href",url);
						}else{
							var url="/product/productDetail.do?item_id="+$.trim(n.item_id)+"&com_id="+$.trim(n.com_id);
							item.find("a").attr("href",url);
						}
						item.find("img:eq(0)").error(function(){
							$(this).remove();
						});
						}
						try {
							selectUnit(item);
						} catch (e) {}
					});
					productpage.setPageShow(data);
					productpage.detailClick(true,function(t){
						$(t).parents(".p-msg").find("input[data-number]:eq(0)").focus().select();
						$(t).parents(".product").find(".num").focus().select();
					});
				}
				$("#sum_si").parent().show();
			}
			function loadData(){
				if(!com_id){
					com_id="001";
				}
				pop_up_box.loadWait();
				$.get("/product/getZEROMOrderProduct.do",{
					"searchKey":$.trim($("#searchKey").val()),
					"customer_id" : customer_id, 
					"com_id" :com_id,
					"page":page,
					"count":count,
					"rows" :20
				},function(data){
					addItem(data);
					productpage.setPageParam(data);
					pop_up_box.loadWaitClose();
				});
			}
			$(".find").click(function(){
					item01.html("");
					page=0;
					count=0;
					loadData();
			});
			$(".allcheck").click(function() {
				var lia = $(".nav li").index($(".nav .active"));
				var tabs;
				if (lia==0) {
					tabs=tabs0;
				}else if (lia==1) {
					tabs=tabs1;
				}
				if ($.trim(tabs.find("#item01").html())!="") {
					if ($(this).html()=="全选") {
						tabs.find(".pro-check").addClass("pro-checked");
						$(this).html("取消");
					} else {
						$(this).html("全选");
						tabs.find(".pro-check").removeClass("pro-checked");
					}
				}
			});
			$("#saveOrder").click(function(){
				var chekcs=$(".pro-checked");
				if (chekcs&&chekcs.length>0) {
					var item_ids=[];
//					var price_type=$(chekcs[0]).parents("#item").find("#price_type").val();
					for (var i = 0; i < chekcs.length; i++) {
						var item_id=$(chekcs[i]).parents("#item").find("#item_id").val();
						item_id=$.trim(item_id);
						if (item_id!="") {
							var item=$(chekcs[i]).parents("#item");
							
							var sd_unit_price=item.find("#sd_unit_price").html();
							var ivt_oper_listing=item.find("#ivt_oper_listing").html();
							
							var pronum=item.find(".zsum").val();
							
							var pack_unit=$.trim(item.find("#pack_unit").html());//换算数量
							var casing_unit=item.find("#casing_unit").html();//包装单位
							var item_unit=item.find(".item_unit").html();//基本单位
							var sum_si=item.find("#sum_si").html();//基本单位
							var c_memo=$.trim(item.find("#c_memo").html());
							var memo_color=$.trim(item.find("#memo_color").html());
							var memo_other=$.trim(item.find("#memo_other").html());
							if (pronum==""||pronum=="0") {
								pronum="1";
								alert("请输入订单数量!");
								item.find(".zsum").focus().select();
								return ;
							}
							var itemdata={
									"ivt_oper_listing":ivt_oper_listing,
									"item_id":item_id, 
									"pronum":pronum,
									"pack_unit":pack_unit,
									"casing_unit":casing_unit,
									"item_unit":item_unit,
									"sum_si":sum_si,
									"c_memo":c_memo,
									"memo_color":memo_color,
									"memo_other":memo_other,
									"sd_unit_price":sd_unit_price
									}
							item_ids.push(JSON.stringify(itemdata));
							if (window.location.href.indexOf("customer")<=0) {
							item.remove();
							}
						}
					}
					pop_up_box.postWait();
					$("#"+customer_id).parents("ul").addClass("active");
					$("#saveOrder").attr("disabled", "disabled");
					$.post("/product/addOrderByZEROM.do",{
						"customer_id":customer_id,
						"itemIds":item_ids,
						"type":0
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							if (window.location.href.indexOf("customer")>0) {
								pop_up_box.showMsg("订单提交成功,增加["+item_ids.length+"]个产品,去支付吧!", function() {
									window.location.href="orderConfirm.do";
								});
								
							}else{
								pop_up_box.showMsg("订单提交成功,增加["+item_ids.length+"]个产品.", function() {
								});
							}
						}else{
							pop_up_box.showMsg("数据提交失败!错误:"+data.msg);
						}
						$("#saveOrder").removeAttr("disabled");
					});
				}else{
					pop_up_box.showMsg("请至少选择一个产品!");
				}
			});
			/////////////已下订单支付////////////
			$("#saveOrder_no").click(function(){
				var tabs=$(".tabs-content:eq(0)");
				var chekcs=tabs.find(".pro-checked");
				if (chekcs&&chekcs.length>0) {
				pop_up_box.showMsg("您还没有登录,去登录吧!",function(){
					window.location.href="login-kehu.html";
				});
			}else{
				pop_up_box.showMsg("请至少选择一个产品!");
			}
			});
			/////////////////////////////////////
			$(".right-btn").click(function(){
				$(".left-btn").click();
//				var  type= $(".p-c-group").find(".p-c-title").index($(".p-c-group").find(".active"));
				var array=$(".ui_shaixuan>ul").find(".active");
				var params=[];
				for (var i = 0; i < array.length; i++) {
					var arr=$(array[i]);
					var type= $(".ui_shaixuan>ul").index(arr.parent());
					var val=arr.find("input").val();
					if(!val){
						val=arr.find("span").html();
					}
					var filedId=arr.parents(".ui_shaixuan").find(".filedId").html();
					var param={};
					param.type=type;
					param.filedname=val;
					param.filedId=filedId;
					if (val.indexOf("全部")<0) {
						params.push(JSON.stringify(param));
					}
				}
				
				 pop_up_box.loadWait();
					item01.html("");
					page=0;
					count=0;
					loadData();
			});
			/**
			 * 加载筛选子项
			 */
			function loadhtmlclass(id,name){
				return "<li><span>"+name+"</span><input type='hidden' value='"+id+"'><i class='fa fa-check fa-fw'></i></li>";
			}
			/**
			 * @param index 位置
			 * @param name 查询字段名称
			 * @param type 字段对应中文
			 */
			function getClassList(index,name,type,typeid){
				if(typeid){
					$(".ui_shaixuan:eq("+index+")").find(".filedId").html(typeid);
				}else{
					$(".ui_shaixuan:eq("+index+")").find(".filedId").html(name);
				}
				$(".ui_shaixuan:eq("+index+")").find(".title").html(type);
				$.get("/product/getOneProductFiledList.do",{
					"com_id":com_id,
					"name":name
				},function(data){
					$(".ui_shaixuan:eq("+index+")").find("ul").html("");
					if (data.rows&&data.rows.length>0) {
						$.each(data.rows,function(i,n){
							if (n&&n.name) {
								$(".ui_shaixuan:eq("+index+")").find("ul").append(loadhtmlclass(n.id,n.name));
							}
						});
						o2od.classselectclick();
					}
					$(".ui_shaixuan").find("ul>li").unbind("click");
					$(".ui_shaixuan").find("ul>li").click(function(){
						if (!$(this).hasClass("active")) {
							$(this).parent().find("li").removeClass("active");
							$(this).parent().find("i").hide();
							$(this).addClass("active");
							$(this).parent().parent().find(".checked").html($(this).find("span").text());
							$(this).find("i").show();
						}else{
							$(this).removeClass("active");
							$(this).parent().parent().find(".checked").html("");
							$(this).find("i").hide();
						}
						
					});
				});
			}
			loadData();
			getClassList(0,"class_card","品牌");
			getClassList(1,"goods_origin","用途");
			getClassList(2,"sort_name","类别","type_id");
			getClassList(3,"store_struct_name","店铺","store_struct_id");
			$(window).scroll(function(){
					if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
						if (page==totalPage) {
						}else{
							page+=1;
							loadData(); 
						}
					}
		     });
		}
}
