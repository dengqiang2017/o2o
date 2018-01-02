$(function(){
	spruceCase.init();
});
var spruceCase={
		init:function(){
		   if(!IsPC()){
		        $(".spruce_case_footer").addClass("navbar-fixed-bottom");
		        $(".header-phone").addClass("navbar-fixed-top");
		        $(".contant").removeClass("contant");
		    }
			var item_id=getQueryString("item_id");
			pop_up_box.loadWait();
			$.get("../product/getSpruceInfo.do",{
				"com_id":com_id,
				"item_id":item_id
			},function(data){
				pop_up_box.loadWaitClose();
				if(data){
					//显示案例信息和设计师信息
					$("#proName").html(data.proName);
					$("#item_spec").html(data.item_spec);
					$("#item_type").html(data.item_type);
					$("#item_struct").html(data.item_struct);
					if (data.price) {
						$("#price").html(data.price/10000);
					}
					$("#miaosu").html(data.miaosu);
					//设计师信息显示　　datum.html
					$(".clerkName").html(data.clerkName);
					$("#describe").html(data.describe);
					if (IsPC()) {
						$("#tel").click({"tel":data.movtel},function(event){
							pop_up_box.showMsg("电话号码:"+event.data.tel);
						});
					}else{
						$("#tel").attr("href","tel:"+data.movtel);
					}
					$("#chat").click({"id":$.trim(data.clerk_id)},function(event){
						window.open("chat.jsp?clerk_id="+event.data.id+"&com_id="+com_id,"_blank");
					});
					$("#tx").attr("src","../"+$.trim(com_id)+"/"+$.trim(data.clerk_id)+"/img"+"/sfz.jpg");
					$(".spruce_case_bottom").click({"com_id":com_id,"clerk_id":data.clerk_id},function(event){
						window.location.href="datum.jsp?com_id="+event.data.com_id+"&clerk_id="+event.data.clerk_id;
					});
				}
				/////////////////
				var ver="001";
				//加载图片
				$("#imageGallery,#fade").html("");
				$.get("../product/getImgUrl.do",{
					"item_id":item_id,
					"com_id":com_id
				},function(data){
					if (data.cps) {
						for (var i = 0; i < data.cps.length; i++) {
							var name=data.cps[i];
							$("#fade").append("<li> <a href='productImg.html?type=product&url="+item_id+"&cp=cp&com_id="+com_id+"' target='_blank'> <img src='"+name+"?ver="+ver+"' /></a></li>");
							$(".swiper-wrapper").append("<div class='swiper-slide'><img class='img-responsive' src='"+name+"'></div>");
						}
						var imgsrc=$(".swiper-slide img")[0].src;
						weixinShare.init($("#proName").html(),$("#item_struct").html(),imgsrc);
					}
					$(".pro-img>ul").html("");
					if (data.xjs) {
						for (var i = 0; i < data.xjs.length; i++) {
							var name=data.xjs[i];
							if(name.indexOf("mp4")>=0){
								$(".pro-img>ul").append("<li><video controls='controls'  preload='none' height='400' width='480' src='"+name+"?ver="+ver+"'></video></li>");
							}else{
								$(".pro-img>ul").append("<li><img src='"+name+"?ver="+ver+"'></li>");
							}
						}
					}
					$("#item_sl_jpg").attr("src",data.sl);
					window.prettyPrint && prettyPrint();
					$('#imageGallery').parent().hide();
					var slider =$('#fade').lightSlider({
						minSlide:1,
						maxSlide:1,
						mode:'fade'
					});
					slider.goToPrevSlide(); //跳到上一张图片
					slider.goToNextSlide(); //跳到下一张图片
				});
				////////////////////////////////
			});
		}
}