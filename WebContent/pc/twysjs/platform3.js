function cDateChange(){
	setTimeout(function(){
		$(".find").click();
	}, 300);
}
function cDateChangeY(){
	setTimeout(function(){
		$(".body-center:eq(0)").click();
	}, 300);
}
$(function(){
	$.get("../pre/getPreAuth.do",function(data){
		if(!data||!data.cuohe){
			alert("当前账号没有使用该功能权限,请联系内勤增加权限!");
			window.location.href="../pc/operatemanage.html";
		}else{
			if(!data.cuohebtn){
				$("#save").remove();
				pop_up_box.showMsg("当前账号只有查看权限");
			}
		}
		loadData();
	});
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	now =addDate(nowStr,5);
	nowStr = now.Format("yyyy-MM-dd"); 
	$("input[name='endDate']").val(nowStr);
	
	now = new Date();
	nowStr = now.Format("yyyy-MM-dd"); 
	now =addDate(nowStr,-3);
	nowStr = now.Format("yyyy-MM-dd"); 
	$("input[name='beginDate']").val(nowStr);
	var lihtml=$("#list .body02>ul").html();
	var cuoheysfitem=$("#cuoheitem .body-bottom>ul").html();
	$("#cuoheitem .body-bottom>ul").html("");
	$("#list .body02>ul").html("");
	$(".find").click(function(){
		loadData();
	});
//	$(".Wate").change()
	$("#list .Wdate,#customer_id").change(function(){
		loadData();
	});
	$("#selectDataList .Wdate").change(function(){
		$(".body-center:eq(0)").click();
	});
	$("#customer_id").val("CS1C002");
	var ygfEdit;
	function loadData(){
		////获取所有的预购方
		pop_up_box.loadWait();
		var customer_id=$("#customer_id").val();
    	$.get("../pre/getPreCustomerInfo.do",{
    		"customer_id":customer_id,
    		"beginDate":$("#list input[name='beginDate']").val(),
			"endDate":$("#list input[name='endDate']").val()
    	},function(data){
    		pop_up_box.loadWaitClose();
    		$("#list .body02>ul").html("");
    		if(data&&data.length>0){
    			$.each(data,function(i,n){
					var item=$(lihtml);
					$("#list .body02>ul").append(item);
					item.find(".pull-left-top>a>span:eq(0)").html(n.corp_name);
					if(!IsPC()){
						item.find(".pull-left-top>a").attr("href","tel:"+n.tel);
					}else{
						item.attr("title",n.corp_name+",电话:"+n.tel);
					}
					if(n.xzqh&&n.xzqh!=""){
						item.find(".pull-left-top span:eq(1)").html("("+n.xzqh+")");
					}else{
						item.find(".pull-left-top span:eq(1)").html("");
					}
					item.find(".pull-left-bottom>span:eq(0)").html(n.gynum);
					item.find(".pull-right-top>span:eq(0)").html(n.item_name);
					var pigname=new String(n.item_name).split("-");
					if(pigname[1]=="仔猪"){
						item.find(".pull-right-bottom>span:eq(0)").html(numformat2(n.guajia));
						item.find(".unit").html("元/头");
					}else{
						item.find(".pull-right-bottom>span:eq(0)").html(numformat2(n.guajia));
						item.find(".unit").html("元/kg");
					}
					if(customer_id=="CS1C002"){
						item.find("#buycls").html("收购");
						///进入选择的贩卖方
						item.click(n,function(event){
							$("#list").hide();
							$("#cuoheitem").show();
							$("#cuoheitem .pull-left-top>a>span:eq(0)").html($.trim(event.data.corp_name));
							if(event.data.xzqh&&$.trim(event.data.xzqh)!=""){
								$("#cuoheitem .pull-left-top>a>span:eq(1)").html("("+$.trim(event.data.xzqh)+")");
							}else{
								$("#cuoheitem .pull-left-top>a>span:eq(1)").html("");
							}
							$("#cuoheitem .pull-left-top>a>span:eq(2)").html(event.data.time);
							$("#cuoheitem #guajiano").html($.trim(event.data.ivt_oper_listing));
							$("#cuoheitem #item_id").html($.trim(event.data.item_id));
							$("#cuoheitem #customer_id").html($.trim(event.data.customer_id));
							if(!IsPC()){
								$("#cuoheitem .pull-left-top>a").attr("href","tel:"+n.tel);
							}else{
								$("#cuoheitem .body-top").attr("title",n.corp_name+",电话:"+n.tel);
							}
							var num=event.data.num-event.data.jnum;
							$("#cuoheitem .pull-left-bottom>span:eq(0)").html(num);
							$("#cuoheitem .pull-right-bottom>span:eq(0)").html(numformat2(event.data.guajia));
							$("#cuoheitem .pull-right-top>span:eq(0)").html(event.data.item_name);
							var chname=new String(event.data.item_name).split("-");
							if(chname[1]=="仔猪"){
								$("#cuoheitem .pull-right-bottom>span:eq(0)").html(numformat2(event.data.guajia));
								$("#cuoheitem .unit").html("元/头");
							}else{
								$("#cuoheitem .pull-right-bottom>span:eq(0)").html(numformat2(event.data.guajia));
								$("#cuoheitem .unit").html("元/kg");
							}
							$("#cuoheitem").find("ul").html("");
							//添加预售方
							$(".body-center:eq(0)").unbind("click");
							$(".body-center:eq(0)").click(event.data,function(event2){
								$("#cuoheitem").hide();
								$("#selectDataList").show();
								loadYsf(event.data.item_id,event.data.item_name,$(this).next().find("li"));
							});
						});
					}else{
						item.find("#buycls").html("出售");
					}
    			});
    		}
    	});
	}
	//贩卖方修改单价
	$("#ygfedit").click(function(){
		var guajia=$("#cuoheitem .cost").html();
		var num=$("#cuoheitem .pull-left-bottom>span:eq(0)").html();
		var item_id=$("#cuoheitem #item_id").html();
		var customer_id=$("#cuoheitem #customer_id").html();
		var guajiano=$("#cuoheitem #guajiano").html();
		var unit=$("#cuoheitem .unit").html();
		var name=$("#cuoheitem .pull-left-top>a>span:eq(0)").html();
		var xzqh=$("#cuoheitem .pull-left-top>a>span:eq(1)").html();
		var time=$("#cuoheitem .pull-left-top>a>span:eq(2)").html();
		$("#mymodal").modal("toggle");
		ygfEdit=$(this).parents(".body");
		$("#mymodal ul input").val(guajia);
		$("#mymodal ul>li:eq(1)>span").html(num);
		$("#mymodal .mol_body>h3").html(name);
		$("#mymodal .mol_body>p:eq(0)>span").html(xzqh);
		$("#mymodal .pull-left").html(time);
		$("#mymodal .unit").html(unit);
	});
	$("#cuoheitem>.header>a").click(function(){
		$("#list").show();
		$("#cuoheitem").hide();
	});
	$("#selectDataList>.header>a:eq(0)").click(function(){
		$("#cuoheitem").show();
		$("#selectDataList").hide();
	});
	var seletDataItem=$("#selectDataList>.qh>ul").html();
	function loadYsf(item_id,item_name,next){
		$("#selectDataList>.qh>ul").html("");
		$("#selectDataList #itemname").html(item_name);
        if($.trim($("#selectDataList>.qh>ul").html())==""){
        	pop_up_box.loadWait();
        	$.get("../pre/getPreCustomerInfo.do",{
        		"customer_id":"CS1C001",
        		"item_id":item_id,
        		"beginDate":$("#selectDataList .body01 input[name='beginDate']").val(),
    			"endDate":$("#selectDataList .body01 input[name='endDate']").val()
        	},function(data){
        		pop_up_box.loadWaitClose();
        		if(data&&data.length>0){
        			$.each(data,function(i,n){
    					var item=$(seletDataItem);
        				$("#selectDataList>.qh>ul").append(item);
        				item.find(".name").html(n.corp_name);
        				if(!IsPC()){
        					item.find("a").attr("href","tel:"+n.tel);
        				}else{
        					item.attr("title",n.corp_name+",电话:"+n.tel);
        				}
        				item.find(".name").append("<span style='display: none;'>"+$.trim(n.customer_id)
        						+"</span><span style='display: none;'>"+$.trim(n.item_id)+"</span>"
        						+"</span><span style='display: none;'>"+$.trim(n.ivt_oper_listing)+"</span>");
        				if(n.xzqh&&n.xzqh!=""){
    						item.find(".site").html("("+n.xzqh+")");
    					}else{
    						item.find(".site").html("");
    					}
        				item.find(".number").html(n.gynum);
						var tjname=new String($("#selectDataList #itemname").html());
						var unit;
						if(tjname[1]=="仔猪"){
							item.find(".cost").html(numformat2(n.guajia));
							unit="元/头";
						}else{
							item.find(".cost").html(numformat2(n.guajia));
							unit="元/kg";
						}
						item.find(".unit").html(unit);
        				item.find(".date").html(n.time);
        				item.find(".xg").click({"num":n.gynum,"name":n.corp_name,"xzqh":n.xzqh,"time":n.time,"unit":unit},function(event){
        			        $("#mymodal").modal("toggle");
        			        ygfEdit=$(this).parents("li");
        					$("#mymodal ul input").val(ygfEdit.find(".cost").html());
        					$("#mymodal ul>li:eq(1)>span").html(event.data.num);
        					$("#mymodal .mol_body>h3").html(event.data.name);
        					$("#mymodal .mol_body>p:eq(0)>span").html(event.data.xzqh);
        					$("#mymodal .pull-left").html(event.data.time);
        					$("#mymodal .unit").html(event.data.unit);
        					item.find('.tj').click();
        			    });
        				///查看图片
        				item.find(".fl01 img").click({"no":$.trim(n.ivt_oper_listing)},function(event){
        					$.get("../pre/getPreImgs.do",{
        						"no":event.data.no
        					},function(data){
        						$("#imshow").html("");
        						if (data&&data.length>0) {
        							$(".image-zhezhao").show();
        							for (var k = 0; k < data.length; k++) {
        								$("#imshow").append("<img class='center-block' src='"+data[k]+"'>");
        							}
        							$("#imshow img").hide();
        							$("#imshow img").eq(0).show();
        						} else {
        							pop_up_box.toast("没有图片!");
        						}
        					});
        				});
        				if(next&&next.text().indexOf($.trim(n.ivt_oper_listing))>0){
        					item.find(".tj").html('取消');
        					item.find(".tj").addClass('active');
         				}
        			});
        			 $('.tj').click(function(){
    			        var n = $(this).html();
    			        if(n=="添加"){
    			        	$(this).html('取消');
    			        	$(this).parents('.body02').addClass('active');
    			        }else{
    			        	$(this).html('添加');
    			        	$(this).parents('.body02').removeClass('active');
    			        }
        			 });
        			 
        		}
        	});
        }
	}
	var imgIndex=0;
	$(".zhezhao_left").click(function(){
		var len=$("#imshow img").length;
		$("#imshow img").hide();
		if(imgIndex<=0){
			$("#imshow img").eq(len-1).show();
			imgIndex=len-1;
		}else{
			$("#imshow img").eq(--imgIndex).show();
		}
	});
	$(".zhezhao_right").click(function(){
		var len=$("#imshow img").length;
		$("#imshow img").hide();
		if (imgIndex>=(len-1)) {
			$("#imshow img").eq(0).show();
			imgIndex=0;
		}else{
			$("#imshow img").eq(++imgIndex).show();
		}
	});
	$("#editPrice").click(function(){
		var val=$.trim($(".mol_body input:eq(0)").val());
		if(val!=""&&val!="0"){
			if(ygfEdit){
				ygfEdit.find(".cost").html(val);
				ygfEdit="";
			}else{
				$("#cuoheitem .cost").html(numformat2(val));
			}
			$("#mymodal").modal("toggle");
		}else{
			pop_up_box.showMsg("请输入挂价");
		}
	});
	 $(".qx").click(function(){
	        $("#mymodal").modal("hide");
	        ygfEdit="";
	 });
	 $("#cuoheitem .body-bottom>ul").html("");
	    $("#addYsf").click(function(){
	    	var adds=$("#selectDataList .body02"); 
	    	for (var i = 0; i < adds.length; i++) {
				var addTxt=$(adds[i]).find(".tj").html();
				if(addTxt=="取消"){
					var item=$(adds[i]);
					var ivt_oper_listing=item.find(".name>span:eq(2)").text();
					if($("#cuoheitem .body-bottom>ul").text().indexOf(ivt_oper_listing)>0){
						continue;
					}
					var ysf=$(cuoheysfitem);
					$("#cuoheitem .body-bottom>ul").append(ysf);
					ysf.find(".name").html(item.find(".name").html());
					ysf.attr("title",item.parent().attr("title"));
					if(!IsPC()){
						ysf.find(".name").parent().click({
							"tel":item.find(".name").parent().attr("href")
							},function(event){
							window.location.href=event.data.tel;
						});
					}
					ysf.find(".site").html(item.find(".site").html());
					ysf.find(".cost").html(item.find(".cost").html());
					ysf.find(".unit").html(item.find(".unit").html());
					ysf.find(".date").html(item.find(".date").html());
					ysf.find("#maxnum").html(item.find(".number").html());
					var maxnum=parseFloat($(".pull-left-bottom>span:eq(0)").html());
					var num=parseFloat(item.find(".number").html());
					ysf.find(".number").html(num);
					if(num>maxnum){
						ysf.find(".pull-right>input").val(maxnum);
					}else{
						ysf.find(".pull-right>input").val(num);
					}
					ysf.find(".btn").click(function(){
						$(this).parents("li").remove();
					});
					ysf.find(".pull-right>input").click(function(){
						$(this).select();
					});
					ysf.find(".pull-right>input").bind("input propertychange blur",function(){
						var maxnum=parseFloat($(this).parents(".box").find(".number").html());
						var num=parseFloat($(this).val());
						if(num>maxnum){
							pop_up_box.showMsg("超出最大可供应数!");
							$(this).val(maxnum);
						}
					});
				}
			}
	    	
	    	$("#cuoheitem").show();
			$("#selectDataList").hide();
	    });
	    $("#save").click(function(){
	    	saveCuohe();
	    });
//	    立即撮合
	    function saveCuohe(){
	    	///获取预购方
			var item=$("#cuoheitem");
			var ivt_oper_listing=item.find("#guajiano").html();
			var customer_id=item.find("#customer_id").html();
			var item_id=item.find("#item_id").html();
			var f_num=item.find(".pull-left-bottom>span:eq(0)").html();
			var name=item.find(".pull-left-top>a>span:eq(0)").html();
			var price=parseFloat(item.find(".pull-right-bottom>span:eq(0)").html());
			var ygfjson=JSON.stringify({"item_id":item_id,"ivt_oper_listing":ivt_oper_listing,
				"customer_id":customer_id,"num":f_num,"price":price,"name":name});
	    	///获取预售方
	    	var ysfs=$("#cuoheitem").find(".box");
	    	var ysfList=[];
	    	var bp=false;
	    	var znum=0;
	    	if(ysfs&&ysfs.length>0){
	    		for (var i = 0; i < ysfs.length; i++) {
					var item=$(ysfs[i]);
					var customer_id=item.find(".name>span:eq(0)").html();
					var item_id=item.find(".name>span:eq(1)").html();
					var ivt_oper_listing=item.find(".name>span:eq(2)").html();
					var name=item.find(".name>a").html();
					var num=item.find("input:eq(0)").val();
					if(num){
						var cost=parseFloat(item.find(".cost").html());
						if(price!=cost){
							bp=true;
//							break;
						}
						znum+=parseFloat(num);
						var json={"ivt_oper_listing":ivt_oper_listing,"item_id":item_id,
								"customer_id":customer_id,"num":num,"price":cost};
						ysfList.push(JSON.stringify(json));
					}
				}
	    	}else{
	    		pop_up_box.showMsg("请选择预售方!");
	    		return;
	    	}
	    	if(znum>parseFloat(f_num)){
	    		pop_up_box.showMsg("超出贩卖方收购数量,请重新确认养殖户出售数量!");
	    		return;
	    	}
//	    	if(bp){
//	    		pop_up_box.showMsg("撮合双方价格不一致,请重新核对价格!");
//	    		return;
//	    	}
	    	pop_up_box.postWait();
	    	$.post("../pre/saveCuoheInfo.do",{
	    		"beginDate":$("#list .body01 input[name='beginDate']").val(),
				"endDate":$("#list .body01 input[name='endDate']").val(),
	    		"type_id":$(".tbd1 .active3>span").html(),
	    		"type":$(".tbd2 .active3>span").html(),
	    		"ygfjson":ygfjson,
//	    		"ygfList":"["+ygfList.join(",")+"]",
	    		"ysfList":"["+ysfList.join(",")+"]",
	    		"description":"@comName-@customerName:你有一笔交易需要确认,猪种类型:"+$("#cuoheitem .pull-right-top>span").html()
	    	},function(data){
	    		pop_up_box.loadWaitClose();
	    		if (data.success) {
					pop_up_box.showMsg("保存成功!",function(){
						$("#list").show();
						$("#cuoheitem").find("ul").html("");
						$("#cuoheitem").hide();
						loadData();
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("保存错误!" + data.msg);
					} else {
						pop_up_box.showMsg("保存错误!");
					}
				}
	    	});
	    
	    }
});