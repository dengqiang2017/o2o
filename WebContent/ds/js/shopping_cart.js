if(!com_id){
	com_id="001Y10";
}
URLFiltering();
var shopping={
		init:function(){
			 $(".close_accout").hide();
			    if(!IsPC()){
			        $(".iphone").removeClass("iphone");
			        $(".iphone-bg").removeClass("iphone-bg");
			        $(".footer").addClass("navbar-fixed-bottom");
			    }
				//加载购物车订单
//				var item=$("#item");
			    function getZje(){
		       	 var ul=$(".shopping_cart_list>ul").find(".fa-check-circle");
		       	 var zje=0;
		       	 for (var i = 0; i < ul.length; i++) {
						var li=$(ul[i]).parents("li");
						var sd_oq=li.find("#sd_oq").html();
						var sd_unit_price=li.find("#sd_unit_price").html();
						zje+=sd_oq*sd_unit_price;
					}
		       	 $(".zje").html(zje);
		        }
				$(".shopping_cart_list>ul").html("");
				pop_up_box.loadWait();
				$.get("../product/getShopping.do",{
					"com_id":com_id
				},function(data){
					pop_up_box.loadWaitClose();
					if(data&&data.rows.length>0){
						$.each(data.rows,function(i,n){
							var itemhtml=$($("#item").html());
							$(".shopping_cart_list>ul").append(itemhtml);
							itemhtml.find("#sd_unit_price").html(n.sd_unit_price);
							itemhtml.find("#orderNo").html(n.ivt_oper_listing);
							itemhtml.find("#seeds_id").html(n.seeds_id);
							itemhtml.find("#item_name").html(n.item_name);
//							itemhtml.find("#casing_unit").html(n.casing_unit);
							itemhtml.find("#item_unit").html(n.item_unit);
							itemhtml.find("#item_color").html(n.item_color);
							if(n.memo_color){
								itemhtml.find("#memo_color").html($.trim(n.memo_color));
								itemhtml.find("#memo_color").click({"memo":$.trim(n.memo_color)},function(event){
									pop_up_box.showMsg(event.data.memo);
								});
							}else{
								itemhtml.find("#memo_color").parent().hide();
							}
//							itemhtml.find("#item_spec").html(n.item_spec);
//							itemhtml.find("#item_type").html(n.item_type);
							itemhtml.find("#pack_unit").html(n.pack_unit);
							itemhtml.find("#sd_oq").html(n.sd_oq);
							itemhtml.find("#pronum").val(n.sd_oq);
							itemhtml.find(".zsum").val(numformat(n.sd_oq/n.pack_unit,0));
							if (itemhtml.find("img").length>0) {
								itemhtml.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg");
							}
							itemhtml.find("img").click({"item_id":n.item_id,"com_id":n.com_id},function(event){
								window.location.href="commodity.jsp?item_id="+$.trim(event.data.item_id)+"&com_id="+$.trim(event.data.com_id);
							});
							itemhtml.find(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
							var b=$(this).hasClass("pro-checked");
							if (b) {
								$(this).removeClass("pro-checked");
							}else{
								$(this).addClass("pro-checked");
							}
						});
						itemhtml.find("#delshopping").click(function(){
							if(confirm("是否删除该产品!")){
								var t=$(this);
								var orderNo=$.trim(t.parents("li").find("#orderNo").html());
								var seeds_id=$.trim(t.parents("li").find("#seeds_id").html());
								pop_up_box.postWait();
								$.post("../product/delShopping.do",{
									"orderNo":orderNo,
									"seeds_id":seeds_id
								},function(data){
									pop_up_box.loadWaitClose();
									if (data.success) {
										t.parents("li").remove();
										getZje();
									}else{
										pop_up_box.showMsg("删除失败:"+data.msg);
									}
								});
							}
						});
						itemhtml.find(".add").click(function(){
							var num=parseFloat($(this).parent().find(".num").val());
							if (!num) {
								num=0;
							}
							$(this).parent().find(".num").val(num+1);
						});
						itemhtml.find(".sub").click(function(){
							var num=parseFloat($(this).parent().find(".num").val());
							if (!num) {
								$(this).parent().find(".num").val(1);
							}else{
								$(this).parent().find(".num").val(num-1);
							}
						});
						initNumInput();
						$(".num").bind("input propertychange blur", function() {
							var txt=$(this).val();
							var val=parseInt(txt);
							if(!val){
								$(this).val(1);
							}
							getZje();
						});
						});
						getZje();
						$('.editInfo').click(function(){
				             var txt = $(this).find('span').html();
				             var item=$(this).parents(".li");
				             var num=item.find("#sd_oq").html();
				             if(txt=='编辑'){
				                 $(this).find('span').html('完成');
				                 $(this).parents('.list_box').find('.product').hide();
				                 $(this).parents('.list_box').find('.operation').show();
				                 $(this).parents('.list_box').find('.del').show();
				                 item.find("#pronum").val(num);
				             }else{
				                 $(this).find('span').html('编辑');
				                 $(this).parents('.list_box').find('.product').show();
				                 $(this).parents('.list_box').find('.operation').hide();
				                 $(this).parents('.list_box').find('.del').hide();
				                 updateOrderSdOq(this);
				             }
				         });
						$(".memocolor").click(function(){
							var t=$(this);
							var memo=t.parents(".word_product").find("#memo_color").html();
							pop_up_box.showDialog("特殊工艺备注", "<textarea rows='5' cols='30' id='memotext'>"+memo+"</textarea>", function(){
								t.parents(".word_product").find("#memo_color").parent().show();
								t.parents(".word_product").find("#memo_color").html($("#memotext").val());
								t.next().html($("#memotext").val());
							});
						});
						function updateOrderSdOq(t){
							var txt=$(t).html();
							var item=$(t).parents("li");
							var num=$.trim(item.find("#pronum").val());
							var seeds_id=$.trim(item.find("#seeds_id").html());
							var memo_color=$.trim(item.find("#memo").html());
							if(!memo_color){
								memo_color="";
							}
							$.post("../customer/updateOrderSdOq.do",{
								"memo_color":memo_color,
								"num":num,
								"seeds_id":seeds_id
							},function(data){
								if (data.success) {
									item.find("#sd_oq").html(num);
									pop_up_box.toast("修改成功!",300);
									getZje();
								} else {
									if (data.msg) {
										pop_up_box.showMsg("保存错误!" + data.msg);
									} else {
										pop_up_box.showMsg("保存错误!");
									}
								}
							});
						}
						$(".editInfo>span:eq(0)").click(function(){//更新修改
							
						});
						$('.word_pitch>i').click(function(){
							 if($(this).hasClass('fa-check-circle')){
				                 $(this).removeClass('fa-check-circle').addClass('fa-circle-thin');
				             }
				             else{
				                 $(this).removeClass('fa-circle-thin').addClass('fa-check-circle');
				             }
							 if($(".shopping_cart_list .fa-check-circle").length==0){
								 $(".accout_left_check .fa-check-circle").removeClass('fa-check-circle').addClass('fa-circle-thin');
							 }
			                 getZje();
			         });
			         $('.accout_left_check').click(function(){
			             if($(this).find("i").hasClass('fa-check-circle')){
			                 $(this).find("i").removeClass('fa-check-circle').addClass('fa-circle-thin');
			                 $('.word_pitch i').removeClass('fa-check-circle').addClass('fa-circle-thin');
			             }
			             else{
			                 $(this).find("i").removeClass('fa-circle-thin').addClass('fa-check-circle');
			                 $('.word_pitch i').removeClass('fa-circle-thin').addClass('fa-check-circle');
			             }
			             getZje();
			         });
			         $(".close_accout").show();
					}
				});
				///结算订单
				$("#orderpay").click(function(){
					var chks=$(".fa-check-circle");
					if (chks&&chks.length>0) {
							var seeds="";
							var list=[];
							for (var i = 0; i < chks.length; i++) {
								var item=$(chks[i]).parents("li");
								var num=parseFloat(item.find("#sd_oq").html());
								if(num>=1){
									var seeds_id=$.trim(item.find("#seeds_id").html());
									list.push(JSON.stringify({"num":num,"seeds_id":seeds_id}));
								}
							}
							if(list.length>0){
								pop_up_box.postWait();
								$.post("../customer/orderpay.do",{
									"type":"shopping",
									"list":"["+list.join(",")+"]",
								},function(data){
									if (data.success) {
//										window.location.href="../customer/orderConfirm.do";
										window.location.href="pay.jsp?ver="+Math.random();
									} else {
										if (data.msg) {
											pop_up_box.showMsg("保存错误!" + data.msg);
										} else {
											pop_up_box.showMsg("保存错误!");
										}
									}
								});
							}else{
								pop_up_box.showMsg("购买数量不能为0");
							}
					}else{
						pop_up_box.showMsg("请至少选择一个产品!");
					}
				});
		}
}
customer.getCustomerInfo(function(){
	shopping.init();
}); 