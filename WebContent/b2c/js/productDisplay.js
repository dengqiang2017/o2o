var productDisplay={
		init:function(){
			 addVer($(".footer a"));
			$(".clear-btn").click(function(){
				$(".p-c-group>ul>li").removeClass("active");
				$(".glyphicon-ok").removeClass("glyphicon-ok");
				$(".checked").html("");
				$(".fa-check").css("display","");
			});
			$('.screen,.sceen').on('touchstart',function(){
				$('.side-cover').fadeIn();
				$('.product-check').fadeIn().removeClass('fadeOutLeft');
			});
			$('.side-cover').on('touchstart',function(){
				$('.side-cover').fadeOut();
				$('.product-check').addClass('fadeOutLeft');
			});
			$('.left-btn').on('touchstart',function(){
				$('.side-cover').fadeOut();
				$('.product-check').addClass('fadeOutLeft');
			});
			$(".left-btn").click(function(){
				$(".side-cover-phone").hide();
				$(".cover,.side-cover").hide();
				$(".product-check").hide();
				$("body").css("overflow","visible");
			});
			$('.p-c-title').click(function(){
				$('.p-c-group ul').hide();
				$(this).animate({background:'#333333'});
				$(this).parents('.p-c-group').find('ul').show();
			});
			$('.screen,.sceen').click(function(){
				$('.side-cover-phone').fadeIn();
				$('.product-check-phone').fadeIn().removeClass('fadeOutLeft');
			});
			$('.side-cover-phone').click(function(event){
				$('.side-cover-phone').fadeOut();
				$('.product-check-phone').addClass('fadeOutLeft');
			});
//			$('.product_display_list').niceScroll(
//					{cursoropacitymax: 0}
//			); 
			//   滑动swiper
//			var swiper = new Swiper('.swiper-container', {
//				slidesPerView: 4,
//				direction : 'vertical'
//			});
			var page=0;
			var count=0;
			var totalPage=0;
			var itemhtml=$("#xptsitem").html();
			$("#productList").html("");
			$("#searchKey").change(function(){
				 page=0;
				 count=0;
				 $("#productList").html("");
			    loadData();
			 });
			function loadData(){
				pop_up_box.loadWait();
				$.get("../product/getZEROMOrderProduct.do",{
					"searchKey":$.trim($("#searchKey").val()),
					"com_id" :com_id,
					"no" :"asc",
					"page":page,
					"count":count,
					"rows" :20
				},function(data){
					addItem(data);
					pop_up_box.loadWaitClose();
				});
			}
			function addItem(data){
				if (data&&data.rows.length>0) {
					$.each(data.rows,function(i,n){
						var item=$(itemhtml);
						$("#productList").append(item); 
						item.find("#item_name").html($.trim(n.item_name));
						item.find("#quality_class").html($.trim(n.quality_class));
						item.find("#ivt_oper_listing").html($.trim(n.ivt_oper_listing));
						item.find("#item_id").html($.trim(n.item_id));
						item.find("#com_id").html($.trim(n.com_id));
						item.find("#item_unit").html($.trim(n.item_unit));
						item.find("#price").html(numformat2(n.sd_unit_price));
						if(n.sd_unit_price==n.price_display){
							item.find("#price_display").hide();
						}else{
							item.find("#price_display").html("￥"+numformat2(n.price_display));
						}
						item.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg?ver="+Math.random());
						if(n.discount_ornot=="Y"){
//							item.find("img").before('<span class="hot">活动促销</span>');
						}else{
							item.find(".hot").remove();
						}
						item.find(".img,#item_name").click({"com_id":$.trim(n.com_id),"item_id":$.trim(n.item_id)},function(event){
							window.location.href="commodity.jsp?com_id="+$.trim(event.data.com_id)+"&item_id="+$.trim(event.data.item_id);
						});
						item.find(".num").bind("input propertychange blur",function(){
							var num=$(this).val();
							if(num&&parseInt(num)>0){
								$(this).parents(".dataitem").find(".check").prop("checked",true);
							}else{
								$(this).parents(".dataitem").find(".check").prop("checked",false);
							}
						});
						item.find("#memo").click(function(){
							var memo_color=$(this).next();
							var content=memo_color.html();
							pop_up_box.showDialog("特殊工艺备注", "<textarea rows='5' cols='30' id='memotext'>"+content+"</textarea>", function(){
								memo_color.html($("#memotext").val());
							});
						});
					});
					common.initNumInput();
					count=data.totalRecord;
					totalPage=data.totalPage;
				}
			}
			$(".find").click(function(){
				$("#productList").html("");
				page=0;
				count=0;
				loadData();
			});
			loadData();
		    pop_up_box.loadScrollPage(function(){
				if (page==totalPage) {
				}else{
					page+=1;
					loadData(); 
				}
			});
			//////////筛选部分///////
			function loadhtmlclass(id,name){
				return "<li><span>"+name+"</span><input type='hidden' value='"+id+"'><i class='glyphicon glyphicon-ok'></i></li>";
			}
			/**
			 * @param index 位置
			 * @param name 查询字段名称
			 * @param type 字段对应中文
			 */
			function getClassList(index,name,type,typeid,sortName){
				if(typeid){
					$(".ui_shaixuan:eq("+index+")").find(".filedId").html(typeid);
				}else{
					$(".ui_shaixuan:eq("+index+")").find(".filedId").html(name);
				}
				$(".ui_shaixuan:eq("+index+")").find(".title").html(type);
				if(!sortName){
					sortName="";
				}
				$.get("../product/getOneProductFiledList.do",{
					"com_id":com_id,
					"sortId":sortName,
					"name":name
				},function(data){
					$(".ui_shaixuan:eq("+index+")").find("ul").html("");
					if (data.rows&&data.rows.length>0) {
						$.each(data.rows,function(i,n){
							if (n&&n.name) {
								$(".ui_shaixuan:eq("+index+")").find("ul").append(loadhtmlclass(n.id,n.name));
							}
						});
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
			getClassList(0,"class_card","品牌");
			getClassList(1,"goods_origin","用途");
			getClassList(2,"sort_name","类别","type_id","");
			getClassList(3,"store_struct_name","店铺","store_struct_id");
		/////////////////////////////////////
			$(".right-btn").click(function(){
				$(".left-btn").click();
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
				 $("#productList").html("");
					page=0;
					count=0;
					$.get("../product/getZEROMOrderProduct.do",{
						"searchKey":$.trim($("#finding").find("#searchKey").val()),
						"com_id":com_id,
						"page":page,
						"count":count,
						"rows":20,
						"params" :"["+ params.join(",")+"]" 
					},function(data){
						pop_up_box.loadWaitClose();
						$(".left-btn").click();
						addItem(data); 
					});
			});
			/////
			/////////保存选择订单//////
			$("#saveOrder").click(function(){
				$.get("../customer/getCustomerSimpleInfo.do",{"com_id":com_id},function(data){
					if(!data){
						saveOrder();
					}else{//没有登录
						pop_up_box.showMsg("还没有登录,请登录后再下单!", function(){
							$.cookie("backurl",window.location.href,{ path: '/', expires: 1 });
							window.location.href="../pc/login.jsp?com_id="+com_id;
						});
					}
				});
			});
			function saveOrder(){
				var chks=$(".check:checked");
				if(chks&&chks.length>0){
					var list=[];
					for (var i = 0; i < chks.length; i++) {
						var chk=$(chks[i]).parents(".dataitem");
						var ivt_oper_listing=chk.find("#ivt_oper_listing").html();
						var com_id=chk.find("#com_id").html();
						var item_id=chk.find("#item_id").html();
						var memo_color=$.trim(chk.find("#memo_color").html());
						var num=chk.find(".num").val();
						if(num!=""&&num!="0"){
							var price=chk.find("#price").html();
							list.push(JSON.stringify({"ivt_oper_listing":ivt_oper_listing,"item_id":item_id,"com_id":com_id,"num":num,"price":price,"memo_color":memo_color}));
						}
					}
					if(list.length>0){
						pop_up_box.loadWait();
						$.post("../product/saveOrder.do",{
							"orderList":"["+list.join(",")+"]"
						},function(data){
							if (data.success) {
								pop_up_box.showMsg("提交成功!");
							} else {
								if (data.msg) {
									pop_up_box.showMsg("提交错误!" + data.msg);
								} else {
									pop_up_box.showMsg("提交错误!");
								}
							}
						});
					}else{
						pop_up_box.showMsg("请输入购买产品数量!");
					}
				}else{
					pop_up_box.showMsg("请选择购买产品!");
				}
			}
		}
}
productDisplay.init();