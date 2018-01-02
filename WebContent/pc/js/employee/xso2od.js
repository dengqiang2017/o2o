$(function(){
	pageshow.init();
//    if($("#platformsPhone").length>0){
//	  //给客服增加电话号码
//	  var platformsHeadship=$("#platformsHeadship").val();
//	  if(!platformsHeadship){
//		  platformsHeadship="客服";
//	  }
//		$.get("../user/getPlatformsPhone.do",{
//			"headship":platformsHeadship
//		},function(data){
//			$("#platformsPhone").attr("href","tel:"+data[0].movtel);
//		});
//      }
    if ($("#kefulist").length>0) {
    	var platformsHeadship=$("#platformsHeadship").val();
    	if(!platformsHeadship){
    		platformsHeadship="客服";
    	}
    	var com_id=$.trim($("#com_id").val());
    	if(com_id==""){
    		com_id=$.trim($("#com_id").html());
    	}
    	$.get("../user/getPlatformsPhone.do",{
    		"headship":platformsHeadship,
    		"com_id":com_id
    	},function(data){
    		$("#kefulist>ul").html("");
    		$.each(data,function(i,n){
    			if(IsPC()){
    				$("#kefulist>ul").append('<li><a>'+n.movtel+'</a><div class="clear"></div></li>');
    			}else{
    				$("#kefulist>ul").append('<li><a href="tel:'+n.movtel+'">'+n.movtel+'</a><div class="clear"></div></li>');
    			}
    		});
			$('.home_footer_left,.btn_style,.phone').click(function(){
			 $("#mymodal").modal("toggle");
	        });
			if(!IsPC()){
				$("#kefulist>ul").find("a").click(function(){
					$(this).parent().click();
					return false;
				});
				$("#kefulist>ul>li").click(function(){
					var url=$(this).find("a").attr("url");
					try {
						callneiqing(url);
					} catch (e) {
						window.location.href=url;
					}
				});
			}
			$('#kefulist>ul>li>a').click(function(){
			    $('#kefulist>ul>li>a').css({'text-decoration':'none'})
			    });
    	});
	}
});
var pageshow={
		init:function(){
//			$(".nav li").removeClass('active'); 
			$(".tabs-content").hide();
			$(".tabs-content:eq(0)").show(); 
			$(".nav li").click(function(){
				var n = $(".nav li").index(this);
				$(".nav li").removeClass('active');
				$(this).addClass('active'); 
				$(".tabs-content").hide(); 
				$(".tabs-content:eq("+n+")").show(); 
			});
			$(".nav li:eq(0)").addClass('active');
//			$(".nav-tabs li").removeClass("active");
//			$(".nav-tabs li:eq(0)").addClass("active"); 
//			$(".nav-tabs li").click(function() {
//				var n = $(".nav-tabs li").index(this);
//				$(".tabs-content").hide(); 
//				$(".tabs-content:eq("+n+")").show(); 
//			});
			 $(window).scroll(function(){
			        if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height()-60)) {
			        	var lia = $(".nav li").index($(".nav .active"));
			        	$(".btn-add:eq("+lia+")").click();
			        }
			     });  
			$("#account .paycheck-box").removeClass("active");
			$("#account .paycheck-box").click(function(){
			  $("#account .paycheck-box").removeClass("active");
			  $(this).addClass("active");
			});

			$("#paystyle .paycheck-box").removeClass("active");
			$("#paystyle .paycheck-box").click(function(){
			  $("#paystyle .paycheck-box").removeClass("active");
			  $(this).addClass("active");
			});

			$(".navsubtabs li").removeClass("active");
			$(".navsubtabs li:eq(0)").addClass("active");
			$(".subtabs-content").hide();
			$(".subtabs-content:eq(0)").show();
			$(".navsubtabs li").click(function() {
			  var n = $(".navsubtabs li").index(this);
			  $(".navsubtabs li").removeClass("active");
			  $(".navsubtabs li:eq("+n+")").addClass("active"); 
			  $(".subtabs-content").hide();
			  $(".subtabs-content:eq("+n+")").show();
			});
			$('.tree li:has(ul)').addClass('parent_li').find(' > span').attr('title', 'Collapse this branch');
			$('.tree li.parent_li > span').on('click', function (e) {
				var children = $(this).parent('li.parent_li').find(' > ul > li');
				if (children.is(":visible")) {
					children.hide();
					$(this).attr('title', 'Expand this branch').find(' > i').addClass('icon-plus-sign').removeClass('icon-minus-sign');
				} else {
					children.show();
					$(this).attr('title', 'Collapse this branch').find(' > i').addClass('icon-minus-sign').removeClass('icon-plus-sign');
				}
				e.stopPropagation();
			});
			
			$(".tree li span").removeClass('activeT');
			$(".tree li span").click(function(){
				var n = $(".tree li span").index(this);
				$(".tree li span").removeClass('activeT');
				$(".tree li span:eq("+n+")").addClass('activeT');
			});
			
			$("tbody tr").removeClass('activeTable');
			$("tbody tr").click(function(){
				$("tbody tr").removeClass('activeTable');
				$(this).addClass('activeTable');
			});
			
			$(".img-lg img").hide();
			$(".img-lg img:eq(0)").show();
			var n = 0;
			$(".arrow-left1").click(function() {
				if (n>0) {
					n = n-1
				}
				else{
					n = $(".img-lg img").length-1
				}
				$(".img-lg img").hide();
				$(".img-lg img:eq("+n+")").show();
			});
			
			$(".arrow-right1").click(function() {
				if (n< $(".img-lg img").length-1) {
					n = n+1
				}
				else{
					n = 0
				}
				$(".img-lg img").hide();
				$(".img-lg img:eq("+n+")").show();
			});
			

			
			$(".psearch-item").removeClass("activePI");
			$(".psearch-item").click(function() {
				$(".psearch-item").removeClass("activePI");
				$(this).addClass("activePI")
			});
			
			$(".pro-img-lg img").hide();
			$(".pro-img-lg img:eq(0)").show();
			$(".pro-img-xs img").removeClass("activeImg");
			$(".pro-img-xs img:eq(0)").addClass("activeImg");
			$(".pro-img-xs img").click(function() {
				var n = $(".pro-img-xs img").index(this);
				$(".pro-img-xs img").removeClass("activeImg");
				$(this).addClass("activeImg");
				$(".pro-img-lg img").hide();
				$(".pro-img-lg img:eq("+n+")").show();
			});
			
			var timer = setInterval(Auto,4000);
			var m = 0;
			function Auto(){
				if(m < $(".pro-img-lg img").length-1){
					m = m + 1;
				}
				else{
					m = 0;
				}
				$(".pro-img-lg img").hide();
				$(".pro-img-lg img:eq("+m+")").show();
				$(".pro-img-xs img").removeClass("activeImg");
				$(".pro-img-xs img:eq("+m+")").addClass("activeImg");
			};
			$(".pro-img-lg img").hover(function() {
				clearTimeout(timer);
			}, function() {
				timer = setInterval(Auto,4000);
			});
			
			$(".side-cover").hide();
			$(".folding-content").hide();
			$(".btn-folding").click(function(){
				$(".side-cover").show();
//				$(".modal").show();
				$(".folding-content").show();
			});
			
			$(".side-cover").click(function(){
				$(".side-cover,.product-check").hide();
				$(".folding-content").hide();
				 $("body").css("overflow","visible");
			});
			$("#side-cover").click(function(){
				$(".side-cover").hide();
				$(".folding-content").hide();
			});
			
			$("#account .paycheck-box").removeClass("activeP");
			$("#account .paycheck-box").click(function(){
				$("#account .paycheck-box").removeClass("activeP");
				$(this).addClass("activeP");
			});
			
			$("#paystyle .paycheck-box").removeClass("activeP");
			$("#paystyle .paycheck-box").click(function(){
				$("#paystyle .paycheck-box").removeClass("activeP");
				$(this).addClass("activeP");
			});
			
			/////////////////////
//			$(".checkbox").removeClass("checkedbox");
//			$("tr>.checkbox").click(function(){
//				if ($(this).hasClass("checkedbox")) {
//					$(".checkbox").removeClass("checkedbox");
//				}else{
//					$(".checkbox").addClass("checkedbox");
//				}
//			});
			///////////侧滑出客户选择项
			$(".left-hide-ctn").hide();
			$(".cover").hide();
			$("#seekh").click(function(){
			  $(".left-hide-ctn").show();
			  $(".cover").show();
//			  $(".nav li:eq(0)").click();
			  $("body").css("overflow","hidden");
			  $("#clientkeyname").focus().select();
			});

			$(".left-btn").click(function(){
				$(".left-hide-ctn").hide();
				$(".cover,.side-cover").hide();
				$(".product-check").hide();
				$("body").css("overflow","visible");
			});
			$(".cover").click(function(){
			  $(".left-hide-ctn").hide();
			  $(".cover").hide();
			  $(".product-check").hide();
			  $("body").css("overflow","visible");
			});
			$("#manager_expand").click(function(){
				var form=$(".left-hide-ctn,.cover");
				if(form.is(":hidden")){
					form.show();
					$("#searchKey").focus().select();
				}else{
					form.hide();
				}
			}); 
			$(document).keydown(function(e) {
				if (e.keyCode == 13) {
					$("#find").click();
				}
			});
			
			$(".product-check").hide();
			$(".cover").hide();
			$("#product-check").click(function(){
			  $(".product-check").show();
			  $(".cover,.side-cover").show();
			  $("body").css("overflow","hidden");
			});
			
			$(".clear-btn").click(function(){
				$(".p-c-group>ul>li").removeClass("active");
				$(".checked").html("");
			});
		}
}
var o2od={
		init:function(){
			var timer = setInterval(Auto,4000);
			var m = 0;
			function Auto(){
			  if(m < $(".pro-img-lg img").length-1){
			    m = m + 1;
			  }
			  else{
			    m = 0;
			  }
			  $(".pro-img-lg img").hide();
			  $(".pro-img-lg img:eq("+m+")").show();
			  $(".pro-img-xs img").removeClass("activeImg");
			  $(".pro-img-xs img:eq("+m+")").addClass("activeImg");
			};
			$(".pro-img-lg img").hover(function() {
			  clearTimeout(timer);
			}, function() {
			  timer = setInterval(Auto,4000);
			});
		},
		classselectclick:function(){
			$(".p-c-content > ul").hide();
			$(".p-c-content > ul:eq(0)").show();
			$(".p-c-title").removeClass("active");
			$(".p-c-title:eq(0)").addClass("active");
			$(".p-c-title").click(function(){
			  var n = $(".p-c-title").index(this);
			  $(".p-c-title").removeClass("active");
			  $(this).addClass("active");
			  $(".p-c-content > ul").hide();
			  $(".p-c-content > ul:eq("+n+")").show();
			});
		},showDrive:function(t,driveId,type){
			var param=driveId+"_"+type+"&";
			if(type=="list"){
				var tr=$(t).parents("tr");
				var customer_id=$.trim(tr.find("input[type='hidden']").val());
				var customer_name=$.trim(tr.find("a:eq(0)").html());
				var tel_no=$.trim(tr.find("td:eq(2)").html());
				param=param+customer_name+"_"+tel_no+"_"+customer_id;
			}else{
				var customer_id=$("#customerId").val();
				var customer_name=$("#corp_sim_name").val();
				var tel_no=$("#tel_no").val();
				param=param+customer_name+"_"+tel_no+"_"+customer_id;
			}
			window.location.href="../manager/driver.do?"+param;
		}
};

 