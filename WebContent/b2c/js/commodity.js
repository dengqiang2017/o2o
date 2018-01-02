//////////////////////////////
var login=false;
customer.getCustomer(function(b){
	if(b!=false){
		login=true;
	}
	if(window.location.search.indexOf("|_")>0){
		window.location.href=common.replaceAll(window.location.search,"\\|_", "&");
	}else{
		commodity.init();
	}
});
var commodity={
		init:function(){
			var url=common.replaceAll(window.location.search,"\\|_", "&");
			var code=common.getQueryString("code",url);
			if(!IsPC()){
//				$(".contant").removeClass("contant");
//				$(".commodity_footer").addClass("navbar-fixed-bottom");
				$(".commodity_footer").addClass("navbar");
				$(".commodity_footer").addClass("navbar-default");
				$(".commodity_footer").addClass("navbar-fixed-bottom");
			}
			//获取产品详情
			if(document.referrer==""||document.referrer.indexOf("commodity.jsp")>=0){
				$(".shopping_back>a").attr("href","index.jsp?com_id="+com_id);
			}else{
				$(".shopping_back>a").attr("href",document.referrer);
			}
			var item_id=$.trim(common.getQueryString("item_id",url));
			var type=common.getQueryString("type",url);
			
			var memo_color=getCookieval("memo_color");
			if(!memo_color){
				memo_color="";
				$("#memo_color").html("");
			}else{
				$("#memo_color").html(memo_color);
			}
			if(type){
				var itemNum=getCookieval("itemNum");
				if(!itemNum){
					itemNum=1;
				}
				var item_color=getCookieval("item_color");
				if(!item_color){
					item_color="";
				}
				var item_type=getCookieval("item_type");
				if(!item_type){
					item_type="";
				}
				localStorage.removeItem("itemNum");
				localStorage.removeItem("item_color");
				localStorage.removeItem("memo_color");
				localStorage.removeItem("item_type");
				localStorage.removeItem("use_oq");
				localStorage.removeItem("backurl");
				$("#sctxt,#s_item_color").html(item_color+" "+item_type);
				if(item_color&&item_type){
					if(type=="order"){
						orderpay();
						return;
					}else if(type=="shopping"){
						addshopping(function(){
							window.location.href="shopping_cart.jsp";
						});
						return;
					}
				}
			}
			$("#memo").click(function(){
				var content=$("#memo_color").html();
				pop_up_box.showDialog("特殊工艺备注", "<textarea rows='5' cols='30' id='memotext'>"+content+"</textarea>", function(){
					$("#memo_color").html($("#memotext").val());
					localStorage.setItem("memo_color",$("#memo_color").html());
				});
			});
			$("#chat").attr("href","chat.jsp?com_id="+com_id);
//$("#kefulist a").attr("href","chat.jsp?com_id="+com_id);
			pop_up_box.loadWait();
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd"); 
			var onedays=nowStr.split("-");
			var add=common.getQueryString("add");
			if(!add){
				add="";
			}
			$.get("../product/getProductDetail.do",{
				"beginDate":onedays[0]+"-"+onedays[1]+"-01",
				"endDate":nowStr,
				"com_id":com_id,
				"item_id":item_id,
				"add":add,
				"customer_id":"CS1_ZEROM"
			},function(data){
				pop_up_box.loadWaitClose();
				$("#item_name").html($.trim(data.item_name));
				$("#fenx_jinbi").html($.trim(data.fenx_jinbi));
				$("#sd_unit_price").html(numformat2(data.sd_unit_price));
				if($.trim(data.moreColor)=="true"){
					$("#moreColor").show();
				}
				$("#price").html(numformat2(data.sd_unit_price));
				if(data.sd_unit_price==data.price_display){
					$("#price_display").parent().hide();
				}else{
					$("#price_display").html(numformat2(data.price_display));
				}
				
				$("#AZTS_free").html(numformat2(data.AZTS_free));
				$("#salesVolume").html(data.salesVolume);//月销量
				$("#itemName").html($.trim(data.item_name));
				$("#typeName").html($.trim(data.sort_name));
				$("#item_type").html($.trim(data.item_type));
				$("#casing_unit").html($.trim(data.casing_unit));
				$("#item_unit").html($.trim(data.item_unit));
				$("#item_style").html($.trim(data.item_style));
				$("#item_color").html($.trim(data.item_color));
				$("#class_card").html($.trim(data.class_card));
				$("#pack_unit").html($.trim(data.pack_unit));
				$("#i_weight").html($.trim(data.i_weight));
				$("#item_spec").html($.trim(data.item_spec));
				$("#item_struct").html($.trim(data.item_struct));
				$("#vendor_name").html($.trim(data.vendor_name));
				$("#goods_origin").html($.trim(data.goods_origin));
				$("#quality_class").html($.trim(data.quality_class));
				$("#item_id").html($.trim(data.item_id));
				//////////////////////////////////////
				showColorLi(data.item_color,"selectList");
				showColorLi(data.item_type,"typeList");
				if(!data.item_color){
					$(".amend_sex_top .check-hue:eq(0)").hide();
				}
				if(!data.item_type){
					$(".amend_sex_top .check-hue:eq(1)").hide();
				}
				///
//				if($.trim($("#sctxt").html())!=""){
//					var item_color=$("#sctxt").html().split(" ")[0];
//					var item_type=$("#sctxt").html().split(" ")[0];
//					$("#selectList").find("label:contains("+item_color+")").parent().addClass("ys_active");
//					$("#typeList").find("label:contains("+item_type+")").parent().addClass("ys_active");
//				}
				////////////////////
				function showColorLi(txt,id){
					if(txt){
						var cs= txt.split(";");
						if(cs&&cs.length>0){
							for (var i = 0; i < cs.length; i++) {
								var li=$("<li><label>"+cs[i]+"</label></li>");
								$("#"+id).append(li);
								li.click(function(){
									var item_type=$.trim($(this).find("label:eq(0)").html());
									if($(this).hasClass("ys_active")){
										$(this).removeClass("ys_active");
										cleraSelect();
									}else{
										$("#"+id).find("li").removeClass("ys_active");
										$(this).addClass("ys_active");
									}
									getkucun();
								});
							}
							if($("#"+id).find("li").length==1){
								$("#"+id).find("li:eq(0)").click();
							}
						}
					}
				}
				function cleraSelect(){
					var item_color=$("#selectList .ys_active").text();
					var item_type=$("#typeList .ys_active").text();
					if(!item_color&&!item_type){
						$("#use_oq").html(999);
						$("#price").html(0);
						$("#s_item_color").html("");
						$("#item_id").html("");
						$("#sctxt").html("");
					}
				}
				function getkucun(){
					var item_color=$("#selectList .ys_active").text();
					var item_type=$("#typeList .ys_active").text();
					if(!item_color){
						item_color="";
					}else{
						item_color=item_color;
					}
					if(!item_type){
						item_type="";
					}else{
						item_type=item_type;
					}
					$("#item_id").html(item_id);
					$("#s_item_color,#sctxt").html(item_color+" "+item_type);
					if(item_color==""&&item_type==""){
						return;
					}
					$("#use_oq").html(0);
					$("#price").html(0);
					$.get("../product/getProductAccnIvt.do",{
						"item_id":item_id,
						"item_color":"%"+item_color+"%",
						"item_type":"%"+item_type+"%",
						"com_id":com_id,
						"add":add,
						"customer_id":"CS1_ZEROM"
					},function(data){
						$("#use_oq").html(data.kucun);
						$("#price").html(data.price);
					});
				}
				///////////////////////////////
				});
			$("#selectList").html("");
			//加载图片
			$("#imageGallery,#fade").html("");
			$.get("../"+com_id+"/img/"+item_id+"/cp.txt",function(data){
				data=data.split(",");
				for (var i = 0; i < data.length; i++) {
					var name=data[i];
					if (IsPC()) {
						$("#imageGallery").append("<li data-thumb='"+name+"'> <a href='"+name+"' target='_blank'> <img src='"+name+"' /></a></li>");
					}else{
						$("#fade").append("<li> <a href='"+name+"' data-lightbox='roadtrip'> <img src='"+name+"' /></a></li>");
					}
				}
				var imgsrc=window.location.host+data[0].replace("\\.\\.","");
				weixinShare.init($("#item_name").html(),$("meta[name='description']").attr("content"),imgsrc);
				window.prettyPrint && prettyPrint();
				if (IsPC()) {
					 var slider =$('#imageGallery').lightSlider({
						gallery:true,
						minSlide:1,
						maxSlide:1,
						currentPagerPosition:'left'  
					}); 
					$('#fade').parent().hide();
				}else{
					$('#imageGallery').parent().hide();
					var slider =$('#fade').lightSlider({
						minSlide:1,
						maxSlide:1,
						mode:'fade'
					});
					slider.goToPrevSlide(); //跳到上一张图片
					slider.goToNextSlide(); //跳到下一张图片
				}
			});
			/////
			$.get("../product/getImgUrl.do",{
				"item_id":item_id,
				"com_id":com_id
			},function(data){
//				if (data.cps) {
//					for (var i = 0; i < data.cps.length; i++) {
//						var name=data.cps[i];
//						if (IsPC()) {
//							$("#imageGallery").append("<li data-thumb='"+name+"'> <a href='"+name+"' target='_blank'> <img src='"+name+"' /></a></li>");
//						}else{
//							$("#fade").append("<li> <a href='"+name+"' data-lightbox='roadtrip'> <img src='"+name+"' /></a></li>");
//						}
////						$(".swiper-wrapper").append("<div class='swiper-slide'><a href='"+name+"' data-lightbox='roadtrip'<img class='img-responsive' src='"+name+"'></a></div>");
//					}
//					$("#imageGallery img").hide();
//					$("#imageGallery img:eq(0)").show();
//					var imgsrc=window.location.host+data.cps[0].replace("\\.\\.","");
//					weixinShare.init($("#item_name").html(),$("meta[name='description']").attr("content"),imgsrc);
//				}
		$(".pro-img>ul").html("");
		if (data.xjs) {
			for (var i = 0; i < data.xjs.length; i++) {
				var name=data.xjs[i];
				if(name.indexOf("mp4")>=0){
					$(".pro-img>ul").append("<li><video controls='controls'  preload='none' height='400' width='480' src='"+name+"'></video></li>");
				}else{
					$(".pro-img>ul").append("<li><img src='"+name+"'></li>");
				}
			}
		}
		$("#item_sl_jpg").attr("src",data.sl);
		///
		$.get("/"+com_id+"/img/"+item_id+"/article.html",function(data){
			$("#cpxj").html(data);
		});
	});
			$.get("../product/getProductEval.do",{
				"com_id":com_id,
				"item_id":item_id
			},function(data){
				if(data&&data.length>0){
					$.each(data,function(i,n){
						var item=$($("#pingjiaitem").html());
						$(".product_evaluation_list>ul").append(item);
						var name=n.eval.name;
						item.find("#name").html(name);
						item.find("#yijian").html(n.eval.yijian);
						item.find(".time").html(n.eval.time);
						if(n.eval.spzl>=0){
							for (var j = 0; j < n.eval.spzl; j++) {
								item.find("#xinxin").append("<img src='../pc/images/xing.png' style='width: 20px;'>");
							}
						}
						if(n.imgs){
							for (var j = 0; j < n.imgs.length; j++) {
								item.find("#pingjia").append("<img src='"+n.imgs[j]+"' style='width: 80px;'>");
							}
							item.find("#pingjia>img").click(function(){
								$(".image-zhezhao").show();
								$("#imshow>img").attr("src",$(this).attr("src"));
							});
						}
					});
					//////////////
					$(".image-zhezhao #closeimgshow").click(function(){
						$(".image-zhezhao").hide();
					});
					var index=0;
					$(".img-right").click(function(){
						var imgs=$("#pingjia").find("img");
						var len=imgs.length;
						if(index>=len){
							index=0;
						}else{
							index+=1;
						}
						$("#imshow>img").attr("src",$(imgs[index]).attr("src"));
					});
					$(".img-left").click(function(){
						var imgs=$("#pingjia").find("img");
						var len=imgs.length;
						if(index<=0){
							index=len;
						}else{
							index-=1;
						}
						$("#imshow>img").attr("src",$(imgs[index]).attr("src"));
					});
				}
			});
			///////////////////////////////
			$(".add").click(function(){
				var num=parseFloat($(this).parent().find(".num").val());
				if (!num) {
					num=1;
				}
				$(this).parent().find(".num").val(num+1);
				$(this).parent().find(".num").blur();
			});
			$(".sub").click(function(){
				var num=parseFloat($(this).parent().find(".num").val());
				if (!num||num=="0") {
					$(this).parent().find(".num").val(1);
				}else{
					if ((num-1)==0) {
						$(this).parent().find(".num").val(1);
					}else{
						$(this).parent().find(".num").val(num-1);
					}
				}
				$(this).parent().find(".num").blur();
			});
			///////////////////////////////
			$('.side-cover').click(function(){
				$('.side-cover').fadeOut();
				$('.amend_sex').removeClass('fadeInUpBig').addClass('fadeOutDownBig');
				$("body").unbind("touchmove");
			});
			$('.title i').click(function(){
				$('.side-cover').fadeOut();
				$('.amend_sex').removeClass('fadeInUpBig').addClass('fadeOutDownBig');
				$("body").unbind("touchmove");
			});
			$('.tabs-content').eq(0).css({'display':'block'});
			$('.nav-tabs li').click(function(){
				$('.nav-tabs li').removeClass('active');
				$(this).addClass('active');
				var n = $('.nav-tabs li').index(this);
				$('.tabs-content').css({'display':'none'});
				$('.tabs-content').eq(n).css({'display':'block'})
			});
			var mark = true ;
			var selecttype=2;
			$('.delivery').click(function(){
				$('.side-cover').fadeIn();
				$('.amend_sex').removeClass('fadeOutDownBig').addClass('fadeInUpBig');
				mark = false;
				$("body").bind("touchmove",function(event){
					event.preventDefault();
				});
//    if(selecttype==2){
//    	$(".confim").hide();
//    }else{
//    	$(".confim").show();
//    }
			});
			$(".join:eq(0)").click(function(){
//				if($.trim($("#sctxt").html())==""){
//					$('.delivery').click();
//					selecttype=0;
//				}else{
					$(".join:eq(1)").click();
//				}
			});
			$(".buy:eq(0)").click(function(){
//				if($.trim($("#sctxt").html())==""){
//					$('.delivery').click();
//					selecttype=1;
//				}else{
					orderpay();
//				}
			});
			$(".buy:eq(1)").click(function(){
//				if($.trim($("#sctxt").html())==""){
//					$('.delivery').click();
//					selecttype=1;
//				}else{
					orderpay();
//				}
			});
			$(".join:eq(1)").click(function(){
//				var item_color=$.trim($("#selectList .ys_active").text());
//				var item_type=$.trim($("#typeList .ys_active").text());
				var item_color=$("#sctxt").html().split(" ")[0];
				var item_type=$("#sctxt").html().split(" ")[1];
//				if(item_color!=""&&item_type!=""){
				var use_oq=parseInt( $("#use_oq").html());
//		if (use_oq<=0) {
//			if(datainfo.zeroStockOrder=="true"){
//				if (confirm("当前选择的颜色无货是否加入购物车！")) {
//				pop_up_box.showMsg("该颜色无货,请选择其它颜色或者联系客服预定！");
//				}else{
//					return;
//				}
//			}else{
//				pop_up_box.showMsg("当前选择的颜色无货请选择其它颜色！");
//				return;
//			}
//		}
					if(!login){
						pop_up_box.showMsg("您还没有登录,请登录后再操作", function(){
							var num=$(".num").val();
							if(num==""||num=="0"){
								num="1";
							}
							var backurl=window.location.href+"&type=shopping";
							localStorage.setItem("itemNum",num);
							localStorage.setItem("item_color",item_color);
							localStorage.setItem("memo_color",$("#memo_color").html());
							localStorage.setItem("item_type",item_type);
							localStorage.setItem("use_oq",use_oq);
							localStorage.setItem("backurl",backurl);
//							$.cookie("itemNum",num,{ path: '/', expires: 1 });
//							$.cookie("memo_color",$("#memo_color").html(),{ path: '/', expires: 1 });
//							$.cookie("item_color",item_color,{ path: '/', expires: 1 });
//							$.cookie("item_type",item_type,{ path: '/', expires: 1 });
//							$.cookie("backurl",backurl,{ path: '/', expires: 1 });
							window.location.href="../pc/login.jsp?com_id="+com_id;
						});
						return;
					}
					//把购物车需要的数据序列化为json数据,然后在进行存储和获取 
					addshopping(function(){
						window.location.href="shopping_cart.jsp";
					});
//				}else{
//					pop_up_box.toast("请选择颜色分类规格!",1500);
//				}
			});
			$(".orderpay").click(function(){
				orderpay();
			}); 
			function orderpay(){
//				var item_color=$.trim($("#selectList .ys_active").text());
//				var item_type=$.trim($("#typeList .ys_active").text());
				var item_color=$("#sctxt").html().split(" ")[0];
				var item_type=$("#sctxt").html().split(" ")[1];
//				if(item_color==""||item_type==""){
//					pop_up_box.toast("请选择颜色规格!",1500);
//					return;
//				}
//				var use_oq=parseInt( $("#use_oq").html());
	//	if (use_oq<=0) {
	//		if(datainfo.zeroStockOrder=="true"){
	//			if (confirm("当前选择的颜色无货是否继续购买！")) {
	//			pop_up_box.showMsg("该颜色无货,请选择其它颜色或者联系客服预定！");
	//			}else{
	//				return;
	//			}
	//		}else{
	//			pop_up_box.showMsg("当前选择的颜色无货请选择其它颜色！");
	//			return;
	//		}
	//	}
				if(!login){
					pop_up_box.showMsg("您还没有登录,请登录后再操作", function(){
						var num=$(".num").val();
						if(num==""||num=="0"){
							num="1";
						}
						var backurl=window.location.href+"&type=order";
						localStorage.setItem("itemNum",num);
						localStorage.setItem("item_color",item_color);
						localStorage.setItem("memo_color",$("#memo_color").html());
						localStorage.setItem("item_type",item_type);
						localStorage.setItem("use_oq",use_oq);
						localStorage.setItem("backurl",backurl);
//						$.cookie("itemNum",num,{ path: '/', expires: 1 });
//						$.cookie("item_color",item_color,{ path: '/', expires: 1 });
//						$.cookie("memo_color",$("#memo_color").html(),{ path: '/', expires: 1 });
//						$.cookie("item_type",item_type,{ path: '/', expires: 1 });
//						$.cookie("use_oq",use_oq,{ path: '/', expires: 1 });
//						$.cookie("backurl",backurl,{ path: '/', expires: 1 });
						window.location.href="../pc/login.jsp?com_id="+com_id;
					});
					return;
				}
				///////////////////////////
				pop_up_box.postWait();
				$.post("../customer/orderpay.do",{
					"orderpay":com_id+"_"+item_id+"_"+$(".num").val(),
					"com_id":com_id,
					"memo_color":$("#memo_color").html(),
					"sd_unit_price":$("#sd_unit_price").html(),
					"item_color":item_color,
					"item_type":item_type,
					"item_id":item_id,
					"num":$(".num").val(),
					"s_n":common.getQueryString("s_n",url)
				},function(data){
					pop_up_box.loadWaitClose();
					if(data.success){
						localStorage.clear();
//						removeCookie();
						window.location.href="pay.jsp?ver="+Math.random();
					}else{
						if(data.msg){
							pop_up_box.showMsg(data.msg);
						}
					}
				});
				///////////////////////
			}
			function addshopping(func){
				var item_color=$.trim($("#selectList .ys_active").text());
				var item_type=$.trim($("#typeList .ys_active").text());
				pop_up_box.postWait();
				$.post("../customer/shopping.do",{
					"shopping":com_id+"_"+item_id+"_"+$(".num").val(),
					"com_id":com_id,
					"item_color":item_color,
					"memo_color":$("#memo_color").html(),
					"item_type":item_type,
					"item_id":item_id,
					"zsum":$(".num").val(),
					"s_n":common.getQueryString("s_n",url)
				},function(data){
					pop_up_box.loadWaitClose();
					if(data.success){
						localStorage.clear();
//						removeCookie();
						pop_up_box.toast("加入成功,去购物车查看!",1000); 
						if(func){
							func();
						}
					}else{
						if(data.msg){
							pop_up_box.showMsg(data.msg);
						}
					}
				});
			}
		
		}
}
