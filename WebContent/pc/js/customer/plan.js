$(function(){
	var page=0;
	var count=0;
	var totalPage=0;
//	if(browser.versions.iPhone){
//		$("input[type='tel']").attr("type","text");
//	}
	$(".find").click(function(){
		page=0;
		count=0;
		loadData();
	});
	$("#list").html("");
	var j=-1;
	function addItem(data){
		if (data&&data.rows.length>0) {
			$.each(data.rows,function(i,n){
				var item=$($("#item").html());
				var l=$("#list li").length;
				if(!l){
					l=0;
				}
				var k=(l/12)+"";
				if(k.indexOf(".")==-1){
					j+=1;
					$("#list").append('<div class="ls"><ul></ul><div class="clearfix"></div></div>');
				}
				$("#list ul:eq("+j+")").append(item);
				item.find("#item_name").html(n.item_name);
				item.find("#dhNum").html(numformat(n.sd_oq,0));
				item.find("#kucun").html(numformat(n.kucun,0));
				item.find("#item_id").html(n.item_id);
				item.find("#item_unit").html(n.item_unit);
				item.click({"item_id":n.item_id,"planNo":n.planNo,"maxnum":n.i_weight},function(event){
					setPlanNum(event.data.item_id,event.data.planNo,event.data.maxnum, $(this));
				});
				if(n.sd_oq&&n.sd_oq>0){
					item.find(".gou_img").show();
				}
			});
			setClass();
		}
		count=data.totalRecord;
		totalPage=data.totalPage;
	}
	//设置最大订货数
	$("#mymodal #dhs").bind("input propertychange blur",function(){
		var maxnum=parseFloat($("#mymodal #maxdhl").html());
		var num=parseFloat($(this).val());
		var t=$(this);
		if(maxnum<num){
			pop_up_box.showMsg("超出最大订货数!");
			t.val(maxnum);
		}
	});
	
	function setPlanNum(item_id,planNo,maxnum,t){
		$('.zz').show();
        $("#mymodal").modal("toggle");
        $('.ls>ul>li').removeClass('active');
        t.addClass('active');
        var kucun=t.find("#kucun").html();
        var dhs=t.find("#dhNum").html();
   	   $("#mymodal #lsj").html(0);
	   $("#mymodal #item_cost").html(0);
	   pop_up_box.loadWait();
		 $.get("../customer/getPlanProductInfo.do",{
      	   "item_id":item_id
         },function(info){
        	 pop_up_box.loadWaitClose();
        	 var planEndTime=parseInt($("#planEndTime").html().replace(":",""));
        	 var now=new Date();
        	 var nowStr = now.Format("hhmm"); 
        	 var now=parseInt(nowStr);
        	 if(planEndTime<now){
        		 $("#mymodal .btn-success").hide();
        		 $("#mymodal #msg").html("已过下计划时间段!");
        	 }
      	   $("#mymodal #item_name").html(info.item_name);
      	   $("#mymodal img").attr("src","../"+info.com_id+"/img/"+item_id+"/sl.jpg");
      	   $("#mymodal #item_detailspec_cn").html(info.item_detailspec_cn);
      	   $("#mymodal .casing_unit").html(info.casing_unit);
      	   $("#mymodal .item_unit").html(info.item_unit);
      	   $("#mymodal #lsj").html(numformat2(info.item_zeroSell));
		   $("#mymodal #item_cost").html(numformat2(info.item_cost));
      	   $("#mymodal #zrdhl").html(numformat(info.sd_oq,0));
      	   $("#mymodal #maxdhl").html(numformat(maxnum,0));
      	   if(kucun&&kucun!="0"){
      		   $("#mymodal #kucun").val(kucun);
      	   }else{
      		   $("#mymodal #kucun").val("");
      	   }
      	   if(dhs&&dhs!="0"){
      		   $("#mymodal #dhs").val(dhs);
      	   }else{
      		   $("#mymodal #dhs").val("");
      	   }
      	   $("#mymodal .btn-success").unbind("click");
      	   $("#mymodal .btn-success").click({
      		   "planNo":info.planNo,
      		   "item_id":item_id,
      		   "sd_unit_price": numformat2(info.item_zeroSell),
      		   "item_cost": numformat2(info.item_cost),
      		   "sd_order_direct":"日计划",
      		   "planNo":planNo
      	   },function(events){
      		 var now=new Date();
        	 var nowStr = now.Format("hhmm"); 
        	 var now=parseInt(nowStr);
        	 if(planEndTime<now){
        		 $("#dhs").val("");
        		 $("#kucun").val("");
        		 $('.zz').hide();
        		 $("#mymodal").modal("toggle");
        		 pop_up_box.showMsg("已过下计划时间段!");
        	 }
      		   pop_up_box.postWait();
      		   events.data.sd_oq=$("#mymodal #dhs").val();
      		   events.data.kucun=$("#mymodal #kucun").val();
      		   $.post("../product/savePlan.do",events.data,function(data){
      			   pop_up_box.loadWaitClose();
      			   if (data.success) {
      				   $("#dhs").val("");
      				   $("#kucun").val("");
      				   $('.zz').hide();
      	               $("#mymodal").modal("toggle");
						pop_up_box.toast("保存成功!", 500);
						t.find("#dhNum").html(events.data.sd_oq);
						t.find("#kucun").html(events.data.kucun);
						if(t.hasClass('active')){
			            	   t.find("div").show();//输入计划数量后打勾标记
			             }
						t.unbind("click");
						t.click({"item_id":item_id,"planNo":data.msg},function(eventt){
							setPlanNum(eventt.data.item_id,eventt.data.planNo, t);
						});
						t.next().click();
					} else {
						if (data.msg) {
							pop_up_box.showMsg("保存错误!" + data.msg);
						} else {
							pop_up_box.showMsg("保存错误!");
						}
					}
      		   });
      	   });
         });
	}
	function setClass(){
		var divs=$("#list .ls:not(.list)");
		if(divs.length>0){
			for (var i = 0; i < divs.length; i++) {
				var div=$(divs[i]);
				div.addClass("list");
				if(i==0){
					div.addClass("body01");
				}else if(i==1){
					div.addClass("body02");
				}else if(i==2){
					div.addClass("body03");
					break;
				}
			}
			setClass();
		}
	}
	function loadData(){
		pop_up_box.loadWait();
		$.get("../customer/getPlanProductPage.do",{
			"count":count,
			"page":page,
			"client":1,
			"rows":100,
			"searchKey":$("#searchKey").val()
		},function(data){
			pop_up_box.loadWaitClose();
			addItem(data);
		});
	}
	loadData();
	$(window).scroll(function(){
        if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
        	if(page<totalPage){
        		page+=1;
        		loadData();
        	}
        }
  });
});