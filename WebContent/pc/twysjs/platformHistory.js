$(function(){
	$.get("../pre/getPreAuth.do",function(data){
		if(!data||!data.cuoheHistory){
			alert("当前账号没有使用该功能权限,请联系内勤增加权限!");
			window.location.href="../pc/operatemanage.html";
		}
		loadData();
	});
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".input-sm").val("");
	var onedays=nowStr.split("-");
	$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
	$(".Wdate:eq(1)").val(nowStr);
    var page=0;
    var count=0;0
    var totalPage=0;
    $(".find").click(function(){
         page=0;
         count=0;
         totalPage=0;
         $("#listpage").show();
         $("#findlistpage").hide();
         $(".body2>ul").html("");
         loadData();
    });
	function loadData(){
		pop_up_box.loadWait();
		$.get("../pre/platformHistoryPage.do",{
			"rows":20,
			"type_id":$(".tbd1 .active3>span").html(),
			"type":$(".tbd2 .active3>span").html(),
			"beginDate":$("input[name='beginDate']").val(),
			"endDate":$("input[name='endDate']").val(),
			"m_flag":$("select[name='m_flag']").val(),
			"count":count,
			"page":page
		},function(data){
			pop_up_box.loadWaitClose();
    		if(data.rows&&data.rows.length>0){
    			$.each(data.rows,function(i,n){
    				var item=$($("#item").html());
    				$(".body2>ul").append(item);
    				item.find(".cz_boxTOP .classify").html(n.item_name);
    				item.find(".cz_boxTOP .one>.name").html(n.ygfName);
    				if(n.ygfDiqu&&n.ygfDiqu!=""){
    					item.find(".cz_boxTOP .one>.site").html("("+n.ygfDiqu+")");
    				}else{
    					item.find(".cz_boxTOP .one>.site").html("");
    				}
    				item.find(".cz_boxTOP .number").html(n.sgNum);
    				item.find(".cz_boxTOP .cost").html(n.sgPrice);
					var lsname=new String(n.item_name).split("-");
					if(lsname[1]=="仔猪"){
						item.find(".cz_boxTOP .cost").html(n.sgPrice+"元/头");
						item.find(".cz_boxBOTTOM .cost2").html(n.price+"元/头");
					}else{
						item.find(".cz_boxTOP .cost").html(n.sgPrice+"元/kg");
						item.find(".cz_boxBOTTOM .cost2").html(n.price+"元/kg");
					}
    				item.find(".cz_boxBOTTOM .name2").html(n.ysfName);
    				if(n.ygfDiqu&&n.ygfDiqu!=""){
    					item.find(".cz_boxBOTTOM .site2").html("("+n.ysfDiqu+")");
    				}else{
    					item.find(".cz_boxBOTTOM .site2").html("");
    				}
    				item.find(".cz_boxBOTTOM .number").html(n.num);
    				var now = new Date(n.cuohe_datetime);
    				var nowStr = now.Format("yyyy-MM-dd"); 
    				item.find(".date").html(nowStr);
    				if(n.m_flag=="0"){
    					item.find(".state").html("等待确认");
    				}else if(n.m_flag=="1"){
    					item.find(".state").html("预售方已确认,收购方未确认");
    				}else if(n.m_flag=="2"){
    					item.find(".state").html("收购方已确认,预售方未确认,");
    				}else if(n.m_flag=="3"){
    					item.find(".state").html("双方确认,交易完成");
    				}else{
    					item.find(".state").html("交易中");
    				}
    			});
    		}
			count=data.totalRecord;
			totalPage=data.totalpage;
		});
	}
	 $(window).scroll(function(){
	        if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height()-60)) {
	        	 if(page>totalpage){
	        		 page+=1;
	        		 loadData();
	        	 }
	        }
	     }); 
	
	 $('.body01>button').click(function(){
	        $('#findlistpage').show();
	        $('#listpage').hide();
	    });
	    $('.closed').click(function(){
	        $('#findlistpage').hide();
	        $('#listpage').show();
	    });
	    $('.tbd1>ul>li').click(function(){
	        $('.tbd1>ul>li').removeClass('active3');
	        if($(this).hasClass("active3")){
	        	$(this).removeClass('active3');
	        }else{
	        	$(this).addClass('active3');
	        }
	    });
	    $('.tbd2>ul>li').click(function(){
	        $('.tbd2>ul>li').removeClass('active3');
	        if($(this).hasClass("active3")){
	        	$(this).removeClass('active3');
	        }else{
	        	$(this).addClass('active3');
	        }
	    });
});