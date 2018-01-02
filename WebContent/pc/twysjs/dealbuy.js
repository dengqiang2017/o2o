$(function(){
//	var now = new Date();
//	var nowStr = now.Format("yyyy-MM-dd"); 
//	now =addDate(nowStr,2);
//	nowStr = now.Format("yyyy-MM-dd"); 
//	$("input[name='endDate']").val(nowStr);
//	
//	now = new Date();
//	nowStr = now.Format("yyyy-MM-dd"); 
//	now =addDate(nowStr,-3);
//	nowStr = now.Format("yyyy-MM-dd"); 
//	$("input[name='beginDate']").val(nowStr);
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".input-sm").val("");
	var onedays=nowStr.split("-");
	$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01");
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	now =addDate(nowStr,1);
	nowStr = now.Format("yyyy-MM-dd"); 
	$(".Wdate:eq(1)").val(nowStr);
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
    $(".find").click(function(){
    	 $(".body02>ul").html("");
    	 page=0;     
    	 count=0;    
    	 totalPage=0;
    	 loadData();
    });
    var page=0;
    var count=0;
    var totalPage=0;
    function loadData(){
    	$('#findlistpage').hide();
        $('#listpage').show();
    	pop_up_box.loadWait();
    	$.get("../pre/preTradingPage.do",{
    		"rows":20,
    		"beginDate":$(".body input[name='beginDate']").val(),
			"endDate":$(".body input[name='endDate']").val(),
			"type_id":$(".tbd1 .active3>span").html(),
			"type":$(".tbd2 .active3>span").html(),
			"page":page,
			"count":count
    	},function(data){
    		pop_up_box.loadWaitClose();
    		if(data.rows&&data.rows.length>0){
    			$.each(data.rows,function(i,n){
    				var item=$($("#item").html());
    				$(".body02>ul").append(item);
					var pigname=new String(n.item_name).split("-");
					if(pigname[1]=="仔猪"){
						item.find("#price").html(n.price+"元/头");
					}else{
						item.find("#price").html(n.price+"元/kg");
					}
    				item.find("#item_name").html(n.item_name);
    				item.find("#num").html(n.sd_oq);

    				item.find("#data").html(n.time);
    				var weight=replaceAll(n.weight, "公斤", "");
    				weight=replaceAll(n.weight, "斤", "");
    				weight=replaceAll(n.weight, "kg", "");
    				if(n.item_name.indexOf("仔猪")>=0){
    					item.find("#range").html(numformat2(n.price*n.sd_oq));//金额
    				}else{
    					var wes=weight.split("-");
    					item.find("#range").html(numformat2(parseInt(wes[0])*n.price*n.sd_oq)+"~"+numformat2(parseInt(wes[1])*n.price*n.sd_oq));//金额
    				}
    				
    				if(n.m_flag=="0"){
    					item.find("#proceed").html("等待确认");
    				}else if(n.m_flag=="1"){
    					item.find("#proceed").html("预售方已确认,收购方未确认");
    				}else if(n.m_flag=="2"){
    					item.find("#proceed").html("收购方已确认,预售方未确认");
    				}else if(n.m_flag=="3"){
    					item.find("#proceed").html("双方确认,交易完成");
    				}else{
    					item.find("#proceed").html("销售中");
    				}
    				if(n.orderNo){
    					item.find("a").attr("href","../pre/preSaleConfirmPage.do?"+n.orderNo);
    				}
    			});
    			count=data.totalRecord;
    			totalPage=data.totalpage;
    			///计算总数
    			var lis=$(".body02>ul>li");
    			var zsnum=0;
    			var range1=0;
    			var range2=0;
    			for (var i = 0; i < lis.length; i++) {
    				var li=$(lis[i]);
    				zsnum+=parseInt(li.find("#num").html());
    				var range_1=parseInt(li.find("#range").html().split("~")[0]);
    				range1+=range_1;
    				var range_2=parseInt(li.find("#range").html().split("~")[1]);
    				if(!range_2){
    					range_2=range_1;
    				}
    				range2+=range_2;
    			}
    			$(".footer span:eq(0)").html(zsnum);
    			$(".footer span:eq(1)").html(range1+"~"+range2);
    		}
    	});
    	
    }loadData();
});