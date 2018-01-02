$(function(){
	if(!common.isPC()){
		$("#houyun_Select .modal-body").css("height",(document.body.clientHeight-60)+"px");
	}
	if($("th[data-name='elecState']").length>0&&$("th[data-name='elecState']").css("display")!="none"){
		$("#elecStateDiv").show();
	}
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
		var beginDate=$("input[name='beginDate']").val();
		var endDate=$("input[name='endDate']").val();
		var isDate="";
		if(beginDate==""&&endDate==""){
			isDate="&isDate=false";
		}
		$("#gzform input[name='rows']").val($("#rows").val());
		$.get("orderTrackingRecord.do"+page+isDate,$("#gzform").serialize(),function(data){
			pop_up_box.loadWaitClose();
			if (data&&data.rows&&data.rows.length) {
				var len=$("table:eq(0) th").length;
				$.each(data.rows,function(i,n){
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
									tr.find("td:eq("+j+")").html("<input type='checkbox' class='check'>&emsp;<input type='hidden' id='seeds_id' value='"+n.seeds_id
											+"'><input type='hidden' id='customer_id' value='"+n.customer_id+"'>"+orderxq);
//									tr.find("td:eq("+j+")").html("<div class='checkbox'><input type='hidden' value='"+n.seeds_id
//											+"'><input type='hidden' value='"+n.customer_id+"'></div>"+orderxq);
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
//								else if(name=="sd_oq"){
//									tr.find("td:eq("+j+")").html(numformat(n.sd_oq,0));
//								}else if(name=="ivtd_use_oq"){
//									tr.find("td:eq("+j+")").html(numformat(n.ivtd_use_oq,0));
//								}
							}else if(name=="dhdate"){
								if (n.so_consign_date) {
									var now = new Date(n.so_consign_date);
									var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
									tr.find("td:eq("+j+")").html(nowStr);
								}
							}else if(name=="zsnum"){
								if(!n.pack_unit){
									n.pack_unit=1;
								}
								tr.find("td:eq("+j+")").html(numformat(n.sd_oq/n.pack_unit,1));
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
								var wuliu=n.transport_AgentClerk_Reciever;
								if(!wuliu){
									wuliu=n.wuliu;
								}
								if(wuliu){
									var ta=$("#houyun_Select").find("select option[value='"+wuliu+"']").text();
									if(wuliu.indexOf("0-")>=0){
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
							}else{
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
							if($.trim($("#editNum #editOrderNum").html())!=""
								||$.trim($("#editNum #editOrderPrice").html())!=""
								||$.trim($("#editNum #edit_order_send_sum").html())!=""
								||$.trim($("#editNum #edit_order_send_qty").html())!=""){
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
					tr.find("#orderxq").click({
						"orderNo":$.trim(n.ivt_oper_listing),
						"item_id":$.trim(n.item_id),
						"corp_sim_name":$.trim(n.corp_sim_name),
						"FHDZ":$.trim(n.FHDZ),
						"com_id":$.trim(n.com_id)
						},function(event){
						$(".tc_body>ul").html("");
						$(".tc #corp_sim_name").html(event.data.corp_sim_name);
						var fs =event.data.FHDZ.split(";");
						if(fs&&fs.length==3){
							if(IsPC()){
								$(".tc #lxr").html(fs[0]+","+fs[1]);
							}else{
								$(".tc #lxr").html(fs[0]+",<a href='tel:"+fs[1]+"'>"+fs[1]+"</a>");
							}
							$(".tc #shdz").html(fs[2]);
							$(".tc #lxr").parent().show();
							$(".tc #shdz").parent().show();
						}else{
							if(!event.data.FHDZ){
								$(".tc #lxr").parent().hide();
								$(".tc #shdz").parent().hide();
							}else{
								$(".tc #lxr").html("");$(".tc #lxr").parent().hide();
								$(".tc #shdz").html(event.data.FHDZ);
							}
						}
						$.get("../orderTrack/getOrderHistory.do",event.data,function(data){
							$('.tc,.zhezhao').show();
							if(data&&data.length>0){
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
//				 $('table th:first-child').width($('table td:first-child').width());  
//				 for (var i = 2; i < len+1; i++) {
//					 var thl=$('table th:nth-child('+i+')').width();
//					 var tdl=$('table td:nth-child('+i+')').width();
//					 if(thl>tdl){
//						 var l=$('table td:nth-child('+i+')').html();
//						 $('table td:nth-child('+i+')').html(l+"<div>&ensp;&ensp;&ensp;&ensp;</div>");
//					 }else{
//						 $('table th:nth-child('+i+')').width($('table td:nth-child('+i+')').width()); 
//					 }
//				}
				setcheckbox(true);
				countgz=data.totalRecord;
				totalgz=data.totalPage;
				$("#page").html(pagegz+1);
				$("#totalRecord").html(data.totalRecord);
				$("#totalPage").html(data.totalPage+1);
			}
		});
	}
	////////////修改单价开始/////////
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
		var send_sum=$.trim($("#editNum #send_sum").val());//已发货数量
		var send_qty=$.trim($("#editNum #send_qty").val());//本次发货数量
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
			
			i=$("thead th").index($("thead th[data-name='corp_sim_name']"));
			var corp_sim_name=$.trim(tr.find("td:eq("+i+")").text());
			
			i=$("thead th").index($("thead th[data-name='dhdate']"));
			var dhdate=$.trim(tr.find("td:eq("+i+")").text());
			
			i=$("thead th").index($("thead th[data-name='ivt_oper_listing']"));
			var no=$.trim(tr.find("td:eq("+i+")").text());
			
			i=$("thead th").index($("thead th[data-name='sd_unit_price']"));
			var oldprice=tr.find("td:eq("+i+")").text();
			
			i=$("thead th").index($("thead th[data-name='sd_oq']"));
			var old_sd_oq=$.trim(tr.find("td:eq("+i+")").text());
			if(!price){
				price="";
			}
			if(!old_sd_oq||old_sd_oq==""){
				old_sd_oq="0";
			}
			if(!oldprice||oldprice==""){
				oldprice="0";
			}
			if(send_sum==""){
				send_sum=0;
			}else{
				send_sum=parseFloat(send_sum);
			}
			if(send_qty=="0"){
				send_qty="";
			}else if(send_qty!=""){
				send_qty=parseFloat(send_qty);
			}
			///////////////
			val=parseFloat(val);
			if(val>0||send_qty!=""){
				var yi_num=val-send_sum;
				if(yi_num<send_qty){
					pop_up_box.showMsg("本次发货数量超过订单未发数,请调整!");
					return;
				}
			}
			//////////////////
			pop_up_box.postWait();
			$.post("editOrderNum.do",{
				"seeds_id":seeds_id,
				"sd_oq":val,
				"old_sd_oq":old_sd_oq,
				"send_qty": send_qty,
				"send_sum":send_sum,
				"casing_unit":casing_unit,
				"item_unit":item_unit,
				"price":price,
//				"zsnum":zsnum,
				"oldprice":oldprice,
				"zhiwu":zhiwu,
				"c_memo":$.trim($("#editNum #c_memo").val()),
				"no":no,
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
	var proccess;//订单流程
	$.get("../manager/getOrderProces.do",{"type":"html"},function(data){
		proccess=data;
		zhijie();
	});
	$(".handle").hide();
	$("#caigou,#pPlan").hide();
	$("select:eq(0)").val("00");
    $("select:eq(0)").change(function(){
    	var index=$(this).get(0).selectedIndex;
    	$(".handle").hide();
    	$("#caigou,#pPlan").hide();
    	var orderTracking_operation=$.trim($("#orderTracking_operation").val());
    	if(orderTracking_operation!=""){
    		var val=$.trim($(this).val());
    		if(val&&val!="已结束"&&val!="打欠条"&&val!="预存款审批"){
    			for (var i = 0; i < proccess.length; i++) {
					var pro=proccess[i];
					if(pro.processName==val){
						if(pro.page.operation){//显示操作按钮
							$("button:contains('"+val+"')").show();
						}else{
							$("button:contains('"+val+"')").hide();
						}
						if(pro.page.purchase_btn_show){//显示下采购订单按钮
							$("#caigou").show();
						}else{
							$("#caigou").hide();
						}
						if(pro.page.pPlan_btn_show){//显示下采购订单按钮
							$("#pPlan").show();
						}else{
							$("#pPlan").hide();
						}
						break;
					}
				}
    		}
    	}
     	$(".find:eq(0)").click();
    });
    /////操作按钮
	$(".handle").click(function(){
		var checks=$("tbody").find(".check:checked");
//		var checks=$("tbody").find(".checkedbox");
		var txt=$.trim($(this).html());
		if(txt.indexOf("采购")>0){
			window.location.href="purchasingOrder.do";
		}else if (checks&&checks.length>0) {
			$("#houyun_Select").find(".xsmargin .btn-primary").html("确定"+txt);
			$("#houyun_Select").find(".xsmargin .btn-default").html("取消"+txt);
			$("#houyun_Select").show();
			$("#houyun_Select").find("select").val("");
			for (var i = 0; i < proccess.length; i++) {
				var pro=proccess[i];
				if(pro.processName==txt){
					if(pro.page.comfirm_ware){//确认拉货库房
						$("#selectWare").show();
					}else{
						$("#selectWare").hide();
					}
					if(pro.page.tihuoTime){//预计提货时间
						$("#tihuoTime").show();
					}else{
						$("#tihuoTime").hide();
					}
					if(pro.page.select_wuliu){//确认物流方式和司机
						$("#wuliufs,#wuliuxixin").show();
					}else{
						$("#wuliufs,#wuliuxixin").hide();
					}
					break;
				}
			}
		}else{
			pop_up_box.showMsg("请至少选择一项数据!");
		}
	});
	////////////
    $("#wuliufsxz").val("");
    $("#wuliufsxz").change(function(){
    	var val=$.trim($(this).val());
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
		$(".check").prop("checked",false);
//		$(".checkbox").removeClass("checkedbox");
		var page="?page=0&count=0";
		$("#page").html(pagegz);
		$("#totalRecord").html(countgz);
		$("#totalPage").html(totalgz);
		order_gz(page);
	});
	$("#rows").change(function(){
		$(".find").click();
	});
	//////////////从外部直接进入处理
	function zhijie(){
		// TODO 获取参数简化
		var params=window.location.href.split("?");
		if (params&&params.length>1) {
			var seeds_id=getQueryString("seeds_id");
			var processName=decode(getQueryString("processName"));
			var customer_id=getQueryString("customer_id");
//			var customer_id=decode(getQueryString("customer_id"));
			param=replaceAll(params[1],"%7C", "|");
			var bivt=param.indexOf("ivt_oper_listing")>0;//判断是否是订单编号
			if(param.split("=")[0]=="seeds_id"||param.split("=")[0]=="seeds_ids"){
				bivt=true;
			}
			if(seeds_id){
				$("#gzform").append("<input class='addparam' type='hidden' name='seeds_id' value='"+seeds_id+"'>");
			}
			if(customer_id){
//				$("#gzform").append("<input class='addparam' type='hidden' name='customer_id' value='"+customer_id+"'>");4
				$("input[name='customer_id']").val(customer_id);
			}
			if(processName){
				$("select:eq(0)").val(processName);
			}
			$("select:eq(0)").change();
//			params=param;
//			if (bivt) {
//				var param=params.split("&");
//				//将参数放入到form中
//				var type=param[0].split("=")[1];
//				var te=type.split("|");
//				var val=type;
//				if(te&&te.length>1){
//					val=te[0];
//					var processName=decode(te[1]);
//					$("select:eq(0)").val(processName);
//				}
//				if(isAutoFind=="true"){
//					$("#gzform").append("<input class='addparam' type='hidden' name='"+param[0].split("=")[0]+"' value='"+val+"'>");
//				}
//				
//				if(param&&param.length>1){
//					var processName=decode(param[1].split("=")[1]);
//					$("select:eq(0)").val(processName);
//				}
//				$("select:eq(0)").change();
//			}else{
//				params= params.split("|");
//				if (params.length>1) {
//					var processName=decode(params[0]);
//					var clientName=decode(params[1]);
//					$("select:eq(0)").val(processName);
//					if(isAutoFind=="true"){
//						$("input[name='searchKey']").val(clientName);
//					}
//					$("select:eq(0)").change();
//				}else{
//					if(params[0].indexOf("CGDD")>0){
//						if(isAutoFind=="true"){
//							$("input[name='searchKey']").val(params[0]);
//						}
//						$("select:eq(0)").val("核货");
//					}else{
//						var processName=decode(params[0]);
//						$("select:eq(0)").val(processName);
//					}
//					$("select:eq(0)").change();
//				}
//			}
		}else{
			$(".find:eq(0)").click();
		}
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
	$("#houyun_Select").find(".btn-default,.close").click(function(){
		$("#houyun_Select").hide();
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
	$("#thdixz").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do",{
			"type":"warehouse"
		},function(data){
			pop_up_box.loadWaitClose();
			if($("#warehouseTreePage").length>0){
				$("#warehouseTreePage").remove();
			}
			$("body").append(data);
			warehouse.init(function(){
				$("#didian").html("");
				$("#store_struct_id").val("");
				o2otree.selectInfo("store_struct_id","didian");
			});
		});
	});
	////////提货地点选择end///////////////////
	$("#houyun_Select").find(".btn-primary:eq(2)").click(function(){///物流方式选择确认提交按钮事件
		var houyun=$("#houyun_Select");
		var wuliu=$.trim(houyun.find("#wuliufsxz").val());
		var checks=$("tbody").find(".check:checked");
//		var checks=$("tbody").find(".checkedbox");
		var siji=$.trim(houyun.find("#driverinfo").val());
		var didian=houyun.find("#didian").html();
		var tidate=houyun.find("#tihuoDate").val();
		handleSelect(checks,wuliu,siji,didian,tidate);
		$("#houyun_Select").hide();
	});
	$("#check").click(function(){
		$("tbody").find(".check").prop("checked",$(this).prop("checked"));
	});
	/**
	 * 选择确认提交数据
	 */
	function handleSelect(checks,wuliu,siji,didian,tidate){
		var seeds_ids=[];
		var customer_ids=[];
		var items=[];
		var customer_names="";
//		var orders=[];
		for (var i = 0; i < checks.length; i++) {
			var check=$(checks[i]).parent(); 
			var seeds_id=check.find("#seeds_id").val();
			seeds_ids.push(seeds_id);
			var index=$(".table-bordered th").index($(".table-bordered th[data-name='corp_sim_name']"));
			var customer_name=check.parents("tr").find("td").eq(index).html();
			if (customer_names.indexOf(customer_name)<0) {
				if (customer_names=="") {
					customer_names=customer_name;
				}else{
					customer_names=customer_name+","+customer_names;
				}
			}
//			var customer_name=check.parents("tr").find("td").eq(index).html();
//			index=$(".table-bordered th").index($(".table-bordered th[data-name='ivt_oper_listing']"));
//			var ivt_oper_listing=check.parents("tr").find("td").eq(index).html();
//			orders.push(JSON.stringify({"customer_name":customer_name,"seeds_id":seeds_id,"orderNO":ivt_oper_listing}));
		}
		pop_up_box.postWait();
		// TODO 库管备货
		if (name.indexOf("库管备货")>=0) {
			url="../orderTrack/noticeKuguan.do";
			var params={
					"seeds_id":seedsId.join(","),
					"NoticeStyle":$("input[name='NoticeStyle']:checked").val(),
					"headship":"库管",
					"processName":name,
					"customer_names":customer_names,
					"msg":"的司机已经前来提货,请提前备货",
					"description":"",
					"url":"../orderTrack/driverWaybillDetail.do?type=beihuo|_seeds_id="+seedsId.join(",")
			};
			$.post("../orderTrack/noticeKuguan.do",params,function(data){
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
		    return;
		}
		var params={
				"name":$("select:eq(0)").val(),//当前流程名称
				"new":"new",
				"customer_names":customer_names,
				"seeds_id":seeds_ids.join(","),
//				"orders":"["+orders.join(",")+"]",
				"NoticeStyle":$("input[name='NoticeStyle']:checked").val()
		};
			var b=false;
			var Kar_paizhao="";
			var sfz="";
			if(wuliu&&wuliu.indexOf("-1")>=0){
				  Kar_paizhao=$.trim($("#houyun_Select").find("#Kar_paizhao").val());
				  sfz=$.trim($("#houyun_Select").find("#sfz").val());
				if(Kar_paizhao==""){
					pop_up_box.showMsg("您已经选择司机,请继续完善车牌号等信息!"); 
				}else if(sfz==""){
					pop_up_box.showMsg("您已经选择司机,请继续完善身份证等信息!"); 
				}else{
					b=true;
				}
			}else{
				b=true;
			}
			if (didian) {
				params.c_memo=didian;
				params.store_struct_id=$("#houyun_Select").find("#store_struct_id").html();
			}
			if(tidate){
				params.tidate=tidate;
			}
			if(b){
				params.wuliu=wuliu;
				params.driver=siji;
				params.Kar_paizhao=Kar_paizhao;
				params.idcard=sfz;
				/*
				 * "seeds_id":seeds_ids.join(","),
					"new":"new",
					"NoticeStyle":$("input[name='NoticeStyle']:checked").val(),
					"wuliu":wuliu,
					"driver":siji,
					"didian":didian,
					"Kar_paizhao":Kar_paizhao,
					"tidate":tidate,
					"idcard":sfz,
					"name":$("select:eq(0)").val(),
				 * */
			}
			$.post("saveHandle.do",params,function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("提交成功!",function(){
//						document.getElementsByClassName("form-horizontal").reset();
						$(".modal-body form").find("input").val("");
						$(".modal-body form").find("select").val("");
						$(".modal-body #didian").html("");
						$(".modal-body #store_struct_id").html("");
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
	//////////////////////
	/**
	 * 获取表格中选择的订单id
	 */
	function getSelectSeeds_id(){
		var checks=$("tbody").find(".check:checked");
//		var checks=$("tbody").find(".checkedbox");
		var seeds="";
		 if (checks&&checks.length>0) {
			 for (var i = 0; i < checks.length; i++) {
				var check=$(checks[i]).parent();
				var seeds_id=$.trim(check.find("#seeds_id").val());
				if(seeds==""){
					seeds=seeds_id;
				}else{
					seeds=seeds+","+seeds_id;
				}
			}
		 }
		 return $.trim(seeds);
	}
	$("#pPlan").click(function(){
		var seeds=getSelectSeeds_id();
		 if (seeds&&seeds!="") {
			 if(confirm("已经在采购中的产品不能再标识为生产,是否通知生产?")){
				 pop_up_box.postWait();
				 $.post("../orderTrack/noticePurchasingOrPPlan.do",{
					 "shipped":"生产",
					 "seeds_id":seeds,
					 "title":"客户订单核实，请及时下生产计划和安排生产",
					 "description":"@comName@Eheadship@clerkName:内勤已核准客户订单，请及时下生产计划和安排生产，请及时处理。",
					 "url":"/pPlan/productionPlan.do?seeds_id="+seeds,
					 "headship":"计调员"
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
			 }
		 }else{
			 pop_up_box.showMsg("请选择需要下计划的产品!");
		 }
	});
	$("#caigou").click(function(){
		var seeds=getSelectSeeds_id();
		 if (seeds&&seeds!="") {
			 if(confirm("已经在生产中的产品不能再标识为采购,是否通知采购?")){
				 pop_up_box.postWait();
				 var infourl="/employee/purchasingOrder.do?seeds_id="+seeds;
				 $.get("../orderTrack/noticePurchasingOrPPlan.do",{
					 "shipped":"采购",
					 "seeds_id":seeds,
					 "title":"客户订单缺货，需要采购协同",
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
			 }
		 }else{
			 pop_up_box.showMsg("请选择需要下采购的产品!");
		 }
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
		var chekcs=$("tbody").find(".check:checked");
//		var chekcs=$("tbody").find(".checkedbox");
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