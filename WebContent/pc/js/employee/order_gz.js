$(function(){
	$("#expand").click(function(){
		var form=$("#gzform");
		if(form.is(":hidden")){
			form.show();
			$(this).text("隐藏搜索");
		}else{
			$(this).text("展开搜索");
			form.hide();
		}
	});
	if($(".folding-btn").css("display")=="none"){
		$("#gzform").show();
	}else{
		$("#gzform").hide();
	}
	$("table:eq(0)").find("tr:eq(0)").sortable({axis:"x"});
//	$("table:eq(0)").find("tr:eq(0)").disableSelection();
//	$("th").resizable({ghost: true});
	/////////////
	var isAutoFind=$("#isAutoFind").val();
	///////////
	var pagegz=0;
	var countgz=0;
	var totalgz=0;
	$("tbody").html("");
	var emplHeadship=$.trim($("#emplHeadship").val());
	var emplclerk_name=$.trim($("#emplclerk_name").val());
	if(window.location.href.indexOf("cdsydq")>0){
		$("th:eq(14)").show();
		$("select[name='elecState']").parents(".col-sm-3").show();
	}
	function isProShow(){
		var b=true;
		if($("select:eq(0)").val()=="00"){
			b=false;
		}else if($("select:eq(0)").val()=="打欠条"){
			b=false;
		}else if($("select:eq(0)").val()=="已发货"){
			b=false;
		}else if($("select:eq(0)").val()=="待评价"){
			b=false;
		}else if($("select:eq(0)").val()=="已结束"){
			b=false;
		}else{
			b=true;
		}
		return b;
	}
	function order_gz(page){
		if (!page) {
			page="";
		}
		var tbody=$("tbody:eq(0)");
		tbody.html("");
		pop_up_box.loadWait();
		$.get("orderTrackingRecord.do"+page,$("#gzform").serialize(),function(data){
			pop_up_box.loadWaitClose();
			if (data&&data.rows) {
				$.each(data.rows,function(i,n){
					var len=$("table:eq(0) th").length;
					var tr=getTr(len);
					tbody.append(tr); 
					var Status_OutStore=$.trim(n.Status_OutStore);
					var showpj='<button id="showpj" class="btn btn-primary" type="button">评价</button>';
					var shou='<button id="showQian" class="btn btn-primary" type="button">收货</button>';
					var orderxq='<button id="orderxq" class="btn btn-primary" type="button">详情</button>';
					$("th>.checkbox").show();
					for (var k = 0; k < len; k++) {
						var th=$($("table th")[k]);
						var name=$.trim(th.attr("data-name"));
						var show=th.css("display");
						var j=$("table th").index(th);
						if(show=="none"){
							tr.find("td:eq("+j+")").hide();
						}else{
							if(name==""){
								if(Status_OutStore=="已结束"){
									tr.find("td:eq("+j+")").html(shou+showpj+orderxq);
									$("th>.checkbox").hide();
								}else{
									tr.find("td:eq("+j+")").html("<div class='checkbox'><input type='hidden' value='"+n.seeds_id+"'><input type='hidden' value='"+n.customer_id+"'></div>"+orderxq);
								}
								if(isProShow()){
									tr.find("td:eq("+j+")").show();
									$("th:eq("+j+")").show();
								}
							}else if(name=="item_sim_name"){
								if(n.item_id.indexOf("NO.")>=0){
									tr.find("td:eq("+j+")").html("定制产品<input type='hidden' id='item_id' value='"+$.trim(n.item_id)+"'>");
								}else{
									tr.find("td:eq("+j+")").html(n.item_sim_name+"<input type='hidden' id='item_id' value='"+$.trim(n.item_id)+"'>");
								}
							}else if(name=="je"){
								tr.find("td:eq("+j+")").html(numformat2(n.sd_oq*n.sd_unit_price));
							}else if(name=="sd_oq"){
								tr.find("td:eq("+j+")").html(numformat(n.sd_oq,0));
							}else if(name=="ivtd_use_oq"){
								tr.find("td:eq("+j+")").html(numformat(n.ivtd_use_oq,0));
							}else if(name=="zsnum"){
								tr.find("td:eq("+j+")").html(numformat(n.sd_oq/n.pack_unit,1));
							}else if(name=="dhdate"){
								if (n.so_consign_date) {
									var now = new Date(n.so_consign_date);
									var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
									tr.find("td:eq("+j+")").html(nowStr);
								}
							}else if(name=="zhuisuo"){
								if (n.ioupath) {
									tr.find("td:eq("+j+")").html('<a target="_blank" href="../report/accountStatement.do?id='+n.customer_id+'&name='+n.corp_sim_name+
											'&tel='+n.user_id+'">查明细</a>&emsp;<a target="_blank" href="'+n.ioupath+'" >查欠条</a>');
								}else{
									tr.find("td:eq("+j+")").html('<a target="_blank" href="../report/accountStatement.do?id='+n.customer_id
											+'&name='+n.corp_sim_name+'&tel='+n.user_id+'">查明细</a>');
								}
							}else if(name=="elecState"){
								switch (n.elecState) {
								case 1:
								tr.find("td:eq("+j+")").html("已预约未安装");
								break;
								case 2:
									tr.find("td:eq("+j+")").html("已安装未验收评价");
									break;
								case 3:
									tr.find("td:eq("+j+")").html("已验收未支付");
									break;
								case 4:
									tr.find("td:eq("+j+")").html("已支付");
									break;
							default:
								tr.find("td:eq("+j+")").html("未预约");
								break;
							}
								if(window.location.href.indexOf("cdsydq")>0){
									tr.find("td:eq("+j+")").show();
								}else{
									tr.find("td:eq("+j+")").hide();
								}
							}else if(name=="wuliu"){
								if(n.transport_AgentClerk_Reciever){
									var ta=$("#houyun_Select").find("select option[value='"+n.transport_AgentClerk_Reciever+"']").text();
									if(n.transport_AgentClerk_Reciever.indexOf("0-")>=0){
										ta="公司库房:"+ta;
									}else{
										ta="供应商库房"+ta;
									}
									tr.find("td:eq("+j+")").html(ta);
								}
							}else if(name=="c_memo"){
								if(n.c_memo){
									tr.find("td:eq("+j+")").html($.trim(n.c_memo));
								}
								if(n.memo_other){
									tr.find("td:eq("+j+")").append("<br>"+$.trim(n.memo_other));
								}
								if(n.memo_color){
									tr.find("td:eq("+j+")").append("<br>"+$.trim(n.memo_color));
								}
							}else if(name=="fangl"){
								tr.find("td:eq("+j+")").html(numformat2(n.price_otherDiscount*n.sd_oq));
							}
							else{
								if(n[name]){
									tr.find("td:eq("+j+")").html($.trim(n[name]));
								}
							}
						}
						var showAmount=$.trim($("#showAmount").val());
						if(showAmount!=""||emplclerk_name=="001"){
							if(name=="sd_unit_price"||name=="je"){
								tr.find("td:eq("+j+")").show();
								$("th:eq("+j+")").show();
							}
						}else{
							if(name=="sd_unit_price"||name=="je"){
								tr.find("td:eq("+j+")").hide();
								$("th:eq("+j+")").hide();
							}
						}
						if((name=="sd_oq"||name=="sd_unit_price")&&Status_OutStore!="已结束"){
							if($.trim($("#editNum #editOrderNum").html())!=""||$.trim($("#editNum #editOrderPrice").html())!=""){
								tr.find("td:eq("+j+")").click({
									"pack_unit":n.pack_unit,
									"seeds_id":n.seeds_id,
									"sd_oq":n.sd_oq,
									"send_sum":n.send_sum,
									"sd_unit_price":numformat2(n.sd_unit_price)
									},function(event){
									///判断当前是在那一列
									$("#editNum").show();
									var val=event.data.sd_oq;
									if($.trim($("#editNum #editOrderNum").html())!=""){
										$("#editNum #sd_oq").val(event.data.sd_oq);
										$("#editNum #send_sum").val(event.data.send_sum);
										$("#editNum #pack_unit").html(event.data.pack_unit);
										$("#editNum #seeds_id").html(event.data.seeds_id);
										var zsnum=numformat(parseFloat(val)/parseFloat(event.data.pack_unit),0);
										if(!zsnum){
											zsnum=0;
										}
										$("#editNum #zsnum").val(zsnum);
									}
									if($.trim($("#editNum #editOrderPrice").html())!=""){
										$("#editNum #price").val(event.data.sd_unit_price);
									}
									
								});
							}
						}
					}
					/////显示客户/////
					
					////显示供应商////
					///查看收货签名
					tr.find("#showQian").unbind("click");
					tr.find("#showQian").click({"orderNo":$.trim(n.ivt_oper_listing),"item_id":$.trim(n.item_id),"seeds_id":$.trim(n.seeds_id)},function(event){
//						window.location.href="shouhuoed.do?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&seeds_id="+event.data.seeds_id;
						$.get("shouhuoed.do",event.data,function(data){
							$("#orderinfo").html(data);
							$("#orderlist").hide();
//							evaluation.init(event.data.orderNo,event.data.item_id,event.data.com_id);
						});
					});
					tr.find("#showpj").unbind("click");
					tr.find("#showpj").click({"orderNo":$.trim(n.ivt_oper_listing),"item_id":$.trim(n.item_id),"com_id":$.trim(n.com_id)},function(event){
						$.get("pingjia.do",event.data,function(data){
							$("#orderinfo").html(data);
							$("#orderlist").hide();
							evaluation.init(event.data.orderNo,event.data.item_id,event.data.com_id);
						});
//						window.location.href="pingjia.do?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id+"&show=false";
					});
					///显示订单跟踪历史消息
					tr.find("#orderxq").click({"orderNo":$.trim(n.ivt_oper_listing),"item_id":$.trim(n.item_id),"com_id":$.trim(n.com_id)},function(event){
						$.get("../orderTrack/getOrderHistory.do",event.data,function(data){
							$('.tc,.zhezhao').show();
							if(data&&data.length>0){
								$(".tc_body>ul").html("");
								var hisitem;
								for (var i = 0; i < data.length; i++) {
									var n=data[i];
									var item=$("<li>"+n.content+"<br>"+n.time+"</li>");
									if (i==0) {
										$(".tc_body>ul").append(item);
									}else{
										hisitem.before(item);
									}
									hisitem=item;
								}
							}
						});
					});
					tr.click(function(){
						$(this).addClass("");
					});
				});
				$("tbody tr").click(function(){
					$("tbody tr").removeClass('activeTable');
					$(this).addClass('activeTable');
				});
				setcheckbox(true);
				countgz=data.totalRecord;
				totalgz=data.totalPage;
			}
		});
	}
	////////////修改单价/////////
	$("#editNum #closedig,#editNum .close").click(function(){
		$("#editNum").hide();
	});
	$("#editNum #sd_oq").bind("input propertychange blur",function(){
		var val=$(this).val();
		if(val!=""||val!="0"){
			var pack_unit=$("#editNum #pack_unit").html();
			var v=val/pack_unit;
			$("#editNum #zsnum").val(numformat2(v));
		}else{
			$("#editNum #zsnum").val("0");
		}
	});
	$("#editNum #zsnum").bind("input propertychange blur",function(){
		var val=$(this).val();
		if(val!=""){
			var pack_unit=$("#editNum #pack_unit").html();
			var v=val*pack_unit;
			$("#editNum #sd_oq").val(numformat2(v));
		}else{
			$("#editNum #sd_oq").val("0");
		}
	});
	$("#confimEdit").click(function(){
		var val=$.trim($("#editNum #sd_oq").val());
		var send_sum=$.trim($("#editNum #send_sum").val());
		var send_qty=$.trim($("#editNum #send_qty").val());
		var zsnum=$.trim($("#editNum #zsnum").val());
		var price=$.trim($("#editNum #price").val());
		if(val!=""){
			var seeds_id=$("#editNum #seeds_id").html();
			var zhiwu=$("#editNum #zhiwu").val();
			var tr=$("tbody tr").find("td:eq(0) input[value='"+seeds_id+"']").parents("tr");
			var i=$("thead th").index($("thead th[data-name='item_unit']"));
			var item_unit=tr.find("td:eq("+i+")").html();
			
			i=$("thead th").index($("thead th[data-name='casing_unit']"));
			var casing_unit=$.trim(tr.find("td:eq("+i+")").text());
			
			i=$("thead th").index($("thead th[data-name='item_sim_name']"));
			var item_sim_name=$.trim(tr.find("td:eq("+i+")").text());
			var item_id=$.trim(tr.find("td:eq("+i+")").find("#item_id").val());
			
			i=$("thead th").index($("thead th[data-name='corp_sim_name']"));
			var corp_sim_name=$.trim(tr.find("td:eq("+i+")").text());
			
			i=$("thead th").index($("thead th[data-name='dhdate']"));
			var dhdate=$.trim(tr.find("td:eq("+i+")").text());
			
			i=$("thead th").index($("thead th[data-name='ivt_oper_listing']"));
			var ivt_oper_listing=$.trim(tr.find("td:eq("+i+")").text());
			
			i=$("thead th").index($("thead th[data-name='sd_unit_price']"));
			var oldprice=tr.find("td:eq("+i+")").text();
			
			i=$("thead th").index($("thead th[data-name='zsnum']"));
			var oldzsnum=$.trim(tr.find("td:eq("+i+")").text());
			if(!price){
				price="";
			}
			if(!zsnum||zsnum==""){
				zsnum="0";
			}
			if(!oldzsnum||oldzsnum==""){
				oldzsnum="0";
			}
			if(!oldprice||oldprice==""){
				oldprice="0";
			}
			if(send_sum==""){
				send_sum="0";
			}
			if(send_qty==""){
				send_qty="0";
			}
			var yi_sum=parseFloat(send_qty)+parseFloat(send_sum);
			if(send_sum=="0"){
				send_sum="";
			}
			if(send_qty=="0"){
				send_qty="";
			}
			var customer_id
			pop_up_box.postWait();
			$.post("editOrderNum.do",{
				"customer_id":tr.find("td:eq(0)").find("input:eq(1)").val(),
				"item_id":item_id,
				"store_struct_id":"",
				"beizhu":"",
				"seeds_id":seeds_id,
				"sd_oq":val,
				"send_qty": send_qty,
				"send_sum":send_sum,
				"yi_sum":yi_sum,
				"casing_unit":casing_unit,
				"item_unit":item_unit,
				"price":price,
				"zsnum":zsnum,
				"oldprice":oldprice,
				"oldzsnum":oldzsnum,
				"zhiwu":zhiwu,
				"no":ivt_oper_listing,
				"title":"订单产品数量修改通知",
				"description":"@comName-@Eheadship-@clerkName:@name,修改了客户【"
					+corp_sim_name+"】订单产品名称为【"+item_sim_name+"】,订货日期:"+dhdate+""
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.toast("修改成功!", 500);
					$("#editNum").hide();
					
					i=$("thead th").index($("thead th[data-name='sd_oq']"));
					tr.find("td:eq("+i+")").html(val);
					
					i=$("thead th").index($("thead th[data-name='send_sum']"));
					tr.find("td:eq("+i+")").html(yi_sum);
					
					i=$("thead th").index($("thead th[data-name='send_qty']"));
					tr.find("td:eq("+i+")").html(send_qty);
					
					i=$("thead th").index($("thead th[data-name='zsnum']"));
					tr.find("td:eq("+i+")").html($("#editNum #zsnum").val());
					
					i=$("thead th").index($("thead th[data-name='sd_unit_price']"));
					tr.find("td:eq("+i+")").html(price);
					
					i=$("thead th").index($("thead th[data-name='je']"));
					var je=parseFloat(val)*parseFloat(price);
					tr.find("td:eq("+i+")").html(numformat2(je));
				}else{
				   pop_up_box.showMsg("保存错误,请联系管理员!");
				}
			});
		}else{
			pop_up_box.showMsg("请输入订单数量!");
		}
	});
	///////////修改单价结束//////
	/////////下拉选择//
	$(".handle").hide();
	$(".caigou").hide();
	$("select:eq(0)").val("00");
    $("select:eq(0)").change(function(){
    	var index=$(this).get(0).selectedIndex;
    	$(".handle").hide();
    	$(".caigou").hide();
    	var orderTracking_operation=$.trim($("#orderTracking_operation").val());
    	if(orderTracking_operation!=""){
    		var val=$.trim($(this).val());
//    		if(val&&val.indexOf("库管")<0&&val.indexOf("安排物流")<0&&val.indexOf("已发货")<0){
    		if(val&&val!="已结束"&&val!="打欠条"&&val!="预存款审批"){
    			if(val.indexOf("生产")<0){
    				$("button:contains('"+val+"')").show();
    				if($("button:contains('"+val+"')").html()) {
    					if($("button:contains('"+val+"')").html().indexOf("款")>=0){
    						if(emplHeadship.indexOf("财务")>=0||emplclerk_name=="001"){
    							$("button:contains('"+val+"')").show();
    						}else{
    							$("button:contains('"+val+"')").hide();
    						}
    					}
    					if($("button:contains('"+val+"')").html().indexOf("核货")>=0){
    						if(window.location.href.indexOf("huaian")>0){
    							$(".caigou").hide();
    						}else{
    							$(".caigou").show();
    						}
    					}
    					if(emplHeadship.indexOf("商务")<0){
    						$("button:contains('订单审核')").hide();
    					}
    					if(emplHeadship.indexOf("张总")<0){
    						$("button:contains('订单初审')").hide();
    					}
    				}
    			}
    		}
    	}
     	$(".find:eq(0)").click();
    });
    $("#wuliufsxz").change(function(){
    	var val=$(this).val();
    	if(val.indexOf("-1")>=0){//公司配送时显示出司机相关信息
    		$("#wuliuxixin").show();
    	}else{
    		$("#wuliuxixin").find("input").val("");
    		$("#wuliuxixin").hide();
    		
    	}
    });
    $("#wuliuxixin").find("input").val("");
    $("select:eq(1)").change(function(){
    	$(".find:eq(0)").click();
    });
    //////////////////////
	$(".find").click(function(){
		pagegz=0;
		countgz=0;
		totalgz=0;
		$(".checkbox").removeClass("checkedbox");
		var page="?page=0&count=0";
		order_gz(page);
	});
	//////////////从外部直接进入处理
	var params=window.location.href.split("?");
	if (params&&params.length>1) {
		param=replaceAll(params[1],"%7C", "|");
		var bivt=param.indexOf("ivt_oper_listing")>0;//判断是否是订单编号
		if(param.split("=")[0]=="seeds_id"||param.split("=")[0]=="seeds_ids"){
			bivt=true;
		}
		params=param;
		if (bivt) {
			var param=params.split("&");
				//将参数放入到form中
				var type=param[0].split("=")[1];
				var te=type.split("|");
				var val=type;
				if(te&&te.length>1){
					val=te[0];
					var processName=decode(te[1]);
					$("select:eq(0)").val(processName);
				}
				if(isAutoFind=="true"){
				$("#gzform").append("<input class='addparam' type='hidden' name='"+param[0].split("=")[0]+"' value='"+val+"'>");
				}
			if(param[0].split("=")[0]=="seeds_id"){
				$("#gzform").append("<input class='addparam' type='hidden' name='seeds_id' value='"+val+"'>");
			}
			if(param&&param.length>1){
				var processName=decode(param[1].split("=")[1]);
				$("select:eq(0)").val(processName);
			}
			$("select:eq(0)").change();
		}else{
			params= params.split("|");
			if (params.length>1) {
				var processName=decode(params[0]);
				var clientName=decode(params[1]);
				$("select:eq(0)").val(processName);
				if(isAutoFind=="true"){
					$("input[name='searchKey']").val(clientName);
				}
				$("select:eq(0)").change();
			}else{
				if(params[0].indexOf("CGDD")>0){
					if(isAutoFind=="true"){
						$("input[name='searchKey']").val(params[0]);
					}
					$("select:eq(0)").val("核货");
				}else{
					var processName=decode(params[0]);
					$("select:eq(0)").val(processName);
				}
				$("select:eq(0)").change();
			}
		}
	}else{
		$(".find:eq(0)").click();
	}
	////////////////
	$("#onePage").click(function(){
		pagegz=0;
		var page="?page=0&count="+countgz;
		order_gz(page);
	});
	$("#uppage").click(function(){
		if (pagegz>=1) {
			pagegz=pagegz-1;
			var page="?page="+pagegz+"&count="+countgz;
			order_gz(page);
		}else{
			pop_up_box.showMsg("已到第一页");
		}
	});
	$("#nextPage").click(function(){
		if (pagegz<=totalgz) {
			pagegz=pagegz+1;
			var page="?page="+pagegz+"&count="+countgz;
			order_gz(page);
		}else{
			pop_up_box.showMsg("已到最后一页");
		}
	});
	$("#endPage").click(function(){
		pagegz=totalgz;
		var page="?page="+totalgz+"&count="+countgz;
		order_gz(page);
	});
	///////////////////
	var handleindex=0;
	$("#houyun_Select,#modal_smsSelect").find(".btn-default,.close").click(function(){
		$("#modal_smsSelect,#houyun_Select").hide();
		handleindex =0;
	});
	$("#modal_smsSelect").find(".btn-primary").click(function(){
		var checks=$("tbody").find(".checkedbox");
		handleSelect(checks, handleindex);
		$("#modal_smsSelect,#houyun_Select").hide();
		handleindex =0;
	});
	//货运司机信息浏览选择表
	$("#houyun_Select").find("#drivexz").click(function(){
		  pop_up_box.loadWait(); 
		   $.get("../tree/getDeptTree.do",{"type":"driver","ver":Math.random()},function(data){
			   pop_up_box.loadWaitClose();
			   $("body").append(data);
			   driver.init(false,function(){
				   var td=$(".modal").find("tr.activeTable").find("td");
				   $("#houyun_Select").find("#driverinfo").val($.trim(td.eq(0).text())+"-"+$.trim(td.eq(1).text()));
				   $("#houyun_Select").find("#Kar_paizhao").val($.trim(td.eq(2).text()));
				   $("#houyun_Select").find("#sfz").val($.trim(td.eq(3).text()));
			   });
		   });
	});
	////////提货地点选择begin///////////////////
	var thdd=$("#thdd_smsSelect");
	var saveindex=0;
	$.get("getThddTxt.do",function(data){
		if(data&&data.length>0){
			thdd.find("ul").html("");
			$.each(data,function(i,n){
				var liitem="<div class='radio'><label class='radio-inline'>";
				liitem+="<input type='radio' name='thdd' value='"+n+"'>"+n+"</label>";
				liitem+="<button type='button' class='btn btn-default'>删除</button></div>";
				liitem=$(liitem);
				thdd.find("ul").append(liitem);
				liitem.find(".btn-default").click(function(){
					$(this).parents(".radio").remove();
					saveindex=1;
				});
			});
		}
	});
	$("#houyun_Select").find("#thdixz").click(function(){
		$("#thdd_smsSelect").show();
	});
	$("#thdd_smsSelect").find(".btn-primary:eq(0)").click(function(){
		var thddval=$.trim(thdd.find("textarea").val());
		if(thddval!=""){
			thdd.find("ul").append("<li><input type='radio' value='"+thddval+"' name='thdd'>"+thddval+"</li>");
			thdd.find("textarea").val("");
			saveindex=1;
		}
	});
	$("#thdd_smsSelect").find(".btn-primary:eq(1)").click(function(){
		$("#houyun_Select").find("#didian").val(thdd.find("input[name='thdd']:checked").val());
		thdd.hide();
		if(saveindex==0){
			return;
		}
		var li=thdd.find("input[name='thdd']");
		var thddval="";
		if(li&&li.length>0){
			for (var i = 0; i < li.length; i++) {
				if(thddval==""){
					thddval=$(li[i]).val();
				}else{
					thddval=thddval+"|"+$(li[i]).val();
				}
			}
			$.post("saveThddTxt.do",{
				"thddval":thddval
			},function(){
				pop_box_up.toast("已保存提货地点!");
				saveindex=0;
			});
		}
	});
	$("#thdd_smsSelect").find(".btn-default,.close").click(function(){
		$("#thdd_smsSelect").hide();
	});
	////////提货地点选择end///////////////////
	$("#houyun_Select").find(".btn-primary:eq(2)").click(function(){///物流方式选择确认提交按钮事件
		var wuliu=$.trim($("#houyun_Select").find("select").val());
		if(wuliu==""){
			pop_up_box.showMsg("请选择物流方式!");
		}else{
			var b=false;
			if($("#houyun_Select").find("#didian").val()==""){
				pop_up_box.showMsg("请选择提货地点!");
			}else{
				b=true;
			}
			if(b){
				var checks=$("tbody").find(".checkedbox");
				var houyun=$("#houyun_Select");
				var siji=$.trim(houyun.find("#driverinfo").val());
				var didian=houyun.find("#didian").val();
				var tidate=houyun.find("#tihuoDate").val();
				handleSelect(checks, handleindex,wuliu,siji,
						didian,tidate);
				$("#modal_smsSelect,#houyun_Select").hide();
				handleindex =0;
			}
		} 
	});
	/**
	 * 选择确认提交数据
	 */
	function handleSelect(checks,index,wuliu,siji,didian,tidate,shr,shdz,shphone){
		var seeds_ids=[];
		var customer_ids=[];
		var items=[];
		for (var i = 0; i < checks.length; i++) {
			var check=$(checks[i]); 
			var seeds_id=check.find("input:eq(0)").val();
			seeds_ids.push(seeds_id);
//			var index=$(".table-bordered th").index($(".table-bordered th[data-name='ivtd_use_oq']"));
//			var kcnum=check.parents("tr").find("td").eq(index).html();
//			index=$(".table-bordered th").index($(".table-bordered th[data-name='item_sim_name']"));
//			var item_sim_name=check.parents("tr").find("td").eq(index).text();
//			var item_id=check.parents("tr").find("td").eq(index).find("input").val();
//			index=$(".table-bordered th").index($(".table-bordered th[data-name='sd_oq']"));
//			var sd_oq=check.parents("tr").find("td").eq(index).html();
//			index=$(".table-bordered th").index($(".table-bordered th[data-name='ivt_oper_listing']"));
//			var orderNo=check.parents("tr").find("td").eq(index).html();
//			items.push(JSON.stringify({"seeds_id":seeds_id,"kcNum":kcnum,"item_id":item_id,"item_sim_name":item_sim_name,"sd_oq":sd_oq,"orderNo":orderNo}));
		}
		pop_up_box.postWait();
		if(wuliu&&wuliu.indexOf("-1")<0){//不是公司配送
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
			$.post("../orderTrack/saveHandle.do",{
				"seeds_id":seeds_ids.join(","),
				"NoticeStyle":$("input[name='NoticeStyle']:checked").val(),
				"wuliu":wuliu,//物流方式
				"didian":didian,//提货地点
				"msg":"请完善并确认车牌号及司机，前往提货",
				"description":"已在此之前，线下与您沟通好物流方式、提货地点，请完善并确认车牌号、司机、预计提货时间等物流信息后，将物流信息分享给您指定的司机，前往提货。",
				"addName":"description",//名称加在位置
				"wuliumsg":$("#houyun_Select").find("select:eq(0)").find("option:selected").text(),//
				"Kar_paizhao":$("#Kar_paizhao").val(),//提货地点
				"name":$("select:eq(0)").val(),//当前流程名称
				"type":index
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("提交成功!",function(){
						$(".find").click();
					});
				}else{
					if (data.msg) {
						pop_up_box.showMsg("提交失败!"+data.msg);
					}else{
						pop_up_box.showMsg("提交失败!");
					}
				}
			});
		}else{//公司派送司机0-1
			var b=false;
			var Kar_paizhao="";
			var sfz="";
			if(wuliu){
				  Kar_paizhao=$.trim($("#houyun_Select").find("#Kar_paizhao").val());
				  sfz=$.trim($("#houyun_Select").find("#sfz").val());
				if(Kar_paizhao==""){
					pop_up_box.showMsg("您已经选择司机,请继续完善车牌号等信息!"); 
				}else if(sfz==""){
					pop_up_box.showMsg("您已经选择司机,请继续完善身份证等信息!"); 
				}else if(tidate==""){
					pop_up_box.showMsg("您已经选择司机,请继续完善预计提货时间信息!"); 
				}else{
					b=true;
				}
			}else{
				b=true;
			}
			if(b){
				$.post("saveHandle.do",{
					"seeds_id":seeds_ids.join(","),
					"NoticeStyle":$("input[name='NoticeStyle']:checked").val(),
					"wuliu":wuliu,
					"driver":siji,
					"didian":didian,
					"Kar_paizhao":Kar_paizhao,
					"tidate":tidate,
					"shr":shr,
					"idcard":sfz,
					"shdz":shdz,
					"shphone":shphone,
					"name":$("select:eq(0)").val(),
					"type":index
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("提交成功!",function(){
							$(".find").click();
						});
					}else{
						if (data.msg) {
							pop_up_box.showMsg("提交失败!"+data.msg);
						}else{
							pop_up_box.showMsg("提交失败!");
						}
					}
				});
			}
		}
	}
	
	var handleindex =0;
	$(".handle").click(function(){
		handleindex = $(".handle").index(this);
		var checks=$("tbody").find(".checkedbox");
		if($(this).html().indexOf("采购")>0){
			window.location.href="purchasingOrder.do";
		}else if (checks&&checks.length>0) {
			var modal="";
			if ($(this).html().indexOf("拉货")>0||$(this).html().indexOf("司机")>0) {
				modal =$("#houyun_Select");
			} else{
				modal =$("#modal_smsSelect");
				var txt=$.trim($(this).html());
				modal.find(".btn-primary").html("确定"+txt);
				modal.find(".btn-default").html("取消"+txt);
			}
			modal.show();
		}else{
			pop_up_box.showMsg("请至少选择一项数据!");
		}
	});
	
	$(".caigou").click(function(){
		var checks=$("tbody").find(".checkedbox");
		var seeds="";
		var description="";
		 if (checks&&checks.length>0) {
			 for (var i = 0; i < checks.length; i++) {
				var check=$(checks[i]); 
				var seeds_id=check.find("input:eq(0)").val();
				var item_name=check.find("td:eq(2)").text();
				if(seeds==""){
					seeds=seeds_id;
					description="产品名称:"+item_name
				}else{
					description=description+";产品名称:"+item_name;
					seeds=seeds+","+seeds_id;
				}
			}
		 }
//		 else{
//				pop_up_box.showMsg("请至少选择一项数据!");
//		}
			 pop_up_box.postWait();
			 var infourl="/employee/purchasingOrder.do?type=0|_seeds_id="+seeds;
			 if(seeds==""){
				 infourl="/employee/purchasingOrder.do";
			 }
			 $.get("../orderTrack/noticeNeiqing.do",{
//				 "msg":"由于产品库存不足,请尽快进行采购!",
				 "msg":"客户订单缺货，需要采购",
				 "addName":"description",
				 "description":"@comName@Eheadship@clerkName:内勤已核准客户订单缺货，需要下达采购订单，请及时处理。",
				 "url":infourl,
				 "headship":"采购"
			 },function(data){
				 pop_up_box.loadWaitClose();
				 if (data.success) {
					pop_up_box.showMsg("通知成功!",function(){
						$(".find:eq(0)").click();
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("通知错误!" + data.msg);
					} else {
						pop_up_box.showMsg("通知错误!");
					}
				}
			 });
			 
		 
	});
	///////////打印二维码////////////////
	$(".print").click(function(){
		 $('#mymodal').modal("toggle");
		 var wd=parseFloat($("#wd").val())-40;
		 $(".printitem>div:eq(1)").css("max-width",wd+"px");
	});
	$("#imgymwd").bind("input propertychange blur",function(){
		$(".printitem").css("margin-left",this.value+"px");
	});
	$("#imgymhd").bind("input propertychange blur",function(){
		$(".printitem").css("height",this.value+"px");
	});
	$("#snbool").parent().show();
	$("#scewm").click(function(){
		var chekcs=$("tbody").find(".checkedbox");
		if (chekcs&&chekcs.length>0) {
			var qrUrls=[];$("#page1").html("");
			var snbool=$("#snbool").prop("checked");
			function getprintdiv(item_id,com_id,sn){
				var qrURL=$("#urlPrefix").html()+"/product/productDetail.do?item_id="+item_id+"&com_id="+com_id+sn;
				var printdiv=$($(".printdiv").html());
				$("#page1").append(printdiv);
				printdiv.find("a").click({"qrURL":qrURL},function(event){
					window.open(event.data.qrURL);
				});
				printdiv.find("#item_name").html(item.find("td:eq(2)").text());
				printdiv.find("#item_spec").html(item.find("td:eq(19)").html());
				printdiv.find("#item_type").html(item.find("td:eq(20)").html());
				printdiv.find("#item_color").html(item.find("td:eq(21)").html());
				printdiv.find("#class_card").html(item.find("td:eq(22)").html());
				return qrURL;
			}
			for (var i = 0; i < chekcs.length; i++) {
				var item=$(chekcs[i]).parents("tr");
				var item_id=$.trim(item.find("#item_id").val());
				var com_id=$.trim($("#com_id").html());
				if(snbool){
					var ivt_oper_listing=$.trim(item.find("td:eq(13)").html());
					var num=parseFloat(item.find("td:eq(4)").html());
					for (var k = 0; k < num; k++) {
						var sn=ivt_oper_listing+"_"+k;
						qrUrls.push(getprintdiv(item_id,com_id,"&sn="+sn));
					}
				}else{
					qrUrls.push(getprintdiv(item_id,com_id,""));
				}
			}
			$.get('../employee/generateQRCode.do',{
				"qrUrls":qrUrls.join(","),
				"width":$("#wd").val(),
				"height":$("#hd").val(),
				"image_width":$("#imgwd").val(),
				"image_height":$("#imghd").val()
			},function(data){
				if (data.success) {
					if(data.msg){
						var urls=data.msg.split(",");
						for (var i = 0; i < $("#page1").find(".printitem").length; i++) {
							var item=$($("#page1").find(".printitem")[i]);
							item.find("img").attr("src",".."+urls[i]);
						}
					}
				} else {
					if (data.msg) {
						pop_up_box.showMsg("生成错误!" + data.msg);
					} else {
						pop_up_box.showMsg("生成错误!");
					}
				}
			});
		}else{
			pop_up_box.showMsg("请至少选择一个产品!");
		}
	});
	$("#beginprint").click(function(){
		$("#page1").jqprint();
	});
	
});