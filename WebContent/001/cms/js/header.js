var header={
		init:function(func){
			if($(".cimg img:eq(0)").length>0){
				if(window.location.href.indexOf("jsp")<0){
					var img=$(".cimg img:eq(0)")[0].src;
					weixinShare.init($("title").html(),$("meta[name='description']").attr("content"),img);
				}
			}
			$.get("copyright.html",function(data){
				if(data){
					$("#copyright").remove();
					$(".container").append(data);
				}
			});
			$.get("header.html",function(data){
				if(data){
					$("nav").remove();
					$("div:eq(0)").before(data);
					$(".headerA a").removeClass("hactive");
					$(".headerA a").removeClass("text");
					for (var i = 0; i < $(".headerA a").length; i++) {
						var a=$($(".headerA a")[i]);
						var href=a.attr("href").split("?")[0].split("#")[0];
						if(window.location.href.indexOf(href)>=0){
							a.addClass("hactive");
							a.addClass("text");
						}
						a.attr("href",href+"?ver="+Math.random());
					}
					if(window.location.href.indexOf("html")<0){
						var a=$($(".headerA a")[0]);
						a.addClass("hactive");
						a.addClass("text");
					}
				}
				$("nav .col-md-8 a").click(function(){
					$("nav .col-md-8 a").removeClass("hactive");
					$(this).addClass("hactive");
				});
				if(!common.isPC()){
					$(".header .col-md-8").addClass("list-group");
					$(".header .col-md-8").addClass("cover");
					$(".header .col-md-8 a").addClass("list-group-item");
					$(".header .glyphicon-th-list").click(function(){
						$(".header .col-md-8").show();
					});
					$(".cover").click(function(){
						$(".header .col-md-8").hide();
					});
				}
				try {
					cmsjs.init();
				} catch (e) {}
				if(func){
					func();
				}
			});

		},getComId:function(){
//			var com_id=common.getQueryString("com_id");
//			if(!com_id){
//				com_id="001";
//			}
			return $("#comId").html();
		}
}