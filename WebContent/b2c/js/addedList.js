var addedList={
		init:function(){
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
				$.get("../product/getOrderProduct.do",{
					"searchKey":$.trim($("#searchKey").val()),
					"com_id" :com_id,
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
						loadProInfo(item, n);
						item.find("#sd_unit_price").html(common.numformat2(n.sd_unit_price));
						if(n.sd_unit_price==n.price_display){
							item.find("#price_display").hide();
						}else{
							item.find("#price_display").html("￥"+common.numformat2(n.price_display));
						}
						if(n.client_item_name){
							item.find("#item_name").html(n.client_item_name+"-"+n.peijian_id);
						}
//						item.find("#peijian_id").val(n.peijian_id);
//						item.find("img").click({"com_id":$.trim(n.com_id),"item_id":$.trim(n.item_id)},function(event){
//							window.location.href="commodity.jsp?add=add&com_id="
//								+$.trim(event.data.com_id)+"&item_id="+$.trim(event.data.item_id);
//						});
						item.find("#num").bind("input propertychange blur",function(){
							var val=$.trim($(this).val());
							var item=$(this).parents(".dataitem");
							var pack_unit=item.find("#pack_unit").html();
							var sd_unit_price=item.find("#sd_unit_price").html();
							val=common.strToNum(val);
							sd_unit_price=common.strToNum(sd_unit_price);
							pack_unit=common.strToNum(pack_unit,1);
							var zsum=0
							if(pack_unit>1){
								zsum=val*pack_unit;
							}else{
								zsum=val/pack_unit;
							}
							if(zsum<0){
								zsum=0;
							}
							item.find("#zsum").val(zsum);
							var sum_si=val*sd_unit_price;
							if(sum_si>0){
								item.find("input[type='checkbox']").prop("checked",true);
							}else{
								item.find("input[type='checkbox']").prop("checked",false);
							}
							item.find("#sum_si").html(sum_si);
						});
						item.find("#zsum").bind("input propertychange blur",function(){
							var val=$.trim($(this).val());
							var item=$(this).parents(".dataitem");
							var pack_unit=item.find("#pack_unit").html();
							var sd_unit_price=item.find("#sd_unit_price").html();
							val=common.strToNum(val);
							sd_unit_price=common.strToNum(sd_unit_price);
							num=common.strToNum(num);
							pack_unit=common.strToNum(pack_unit,1);
							var num=0;
							if(pack_unit>1){
								num=val/pack_unit;
							}else{
								num=val*pack_unit;
							}
							if(num<0){
								num=0;
							}
							item.find("#num").val(num);
							var sum_si=num*sd_unit_price;
							if(sum_si>0){
								item.find("input[type='checkbox']").prop("checked",true);
							}else{
								item.find("input[type='checkbox']").prop("checked",false);
							}
							item.find("#sum_si").html(sum_si);
						});
						addedList.moreMemo(n, item);
					});
					count=data.totalRecord;
					totalPage=data.totalPage;
					common.initNumInput();
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
			getClassList(2,"sort_name","类别","type_id","%TY380%");
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
					$.get("../product/getOrderProduct.do",{
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
			///提交订单
			$("#save").click(function(){
				var checks=$("#productList #check:checked");
				if(checks&&checks.length>0){
					var item_ids=[];
					for (var i = 0; i < checks.length; i++) {
						var item=$(checks[i]).parents(".dataitem");
						var item_id=item.find("#item_id").html();
						item_id=$.trim(item_id);
						if (item_id!="") {
							var sd_unit_price=common.isnull0(item.find("#sd_unit_price").html());
							var pronum=common.isnull0(item.find("#num").val());
							var pack_unit=common.isnull0(item.find("#pack_unit").html());//换算数量
							var sum_si=common.isnull0(item.find("#sum_si").html());//金额
							var ivt_oper_listing=item.find("#ivt_oper_listing").html();
							var casing_unit=item.find("#casing_unit").html();//包装单位
							var item_unit=item.find("#item_unit").html();//基本单位
							var c_memo=$.trim(item.find("#c_memo").html());
							var memo_color=$.trim(item.find("#memo_color").html());
							var memo_other=$.trim(item.find("#memo_other").html());
							if (pronum==0) {
								pop_up_box.showMsg("请输入订单数量!",function(){
									item.find("#num").focus().select();
								});
							}else{
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
								item.remove();
							}
						}
					}
					pop_up_box.postWait();
					$.post("../product/addOrder.do",{
						"itemIds":"["+item_ids.join(",")+"]"
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
							pop_up_box.showMsg("提交成功,请尽快进行支付并在【我要付款】中上传支付凭证!");
						} else {
							if (data.msg) {
								pop_up_box.showMsg("提交错误!" + data.msg);
							} else {
								pop_up_box.showMsg("提交错误!");
							}
						}
					});
				}else{
					pop_up_box.showMsg("请选择要下单的产品!");
				}
			});
		},moreMemo:function(n,item){
			function moreMemoInit(t_parent){
				$(".modal-first").find("input[name='c_memo']").val(t_parent.find("#c_memo").html());
				$(".modal-first").find("input[name='memo_color']").val(t_parent.find("#memo_color").html());
				$(".modal-first").find("input[name='memo_other']").val(t_parent.find("#memo_other").html());
				$("#moreMemosave").unbind("click");
				$("#moreMemosave").click(function(){
					t_parent.find("#c_memo").html($(".modal-first").find("input[name='c_memo']").val());
					t_parent.find("#memo_color").html($(".modal-first").find("input[name='memo_color']").val());
					t_parent.find("#memo_other").html($(".modal-first").find("input[name='memo_other']").val());
					$(".modal-cover-first,.modal-first").hide();
				});
			}
			item.find("#c_memo").html(n.c_memo);
			item.find("#memo_color").html(n.memo_color);
			item.find("#memo_other").html(n.memo_other);
			item.find("#moreMemo").click(function(){
				var t_parent=$(this).parent();
				if ($(".modal-first").length>0) {
					$(".modal-cover-first,.modal-first").show();
					moreMemoInit(t_parent);
				}else{
					pop_up_box.loadWait();
					$.get("../product/moreMemo.do",function(data){
						pop_up_box.loadWaitClose();
						$("body").append(data);
						$(".close,.btn-default").click(function(){
							$(".modal-cover-first,.modal-first").hide();
						});
						$("#moreMemoClear").click(function(){
							$(".modal-first").find("input").val("");
						});
						moreMemoInit(t_parent);
					});
				}
			});
		
		}
}
addedList.init();