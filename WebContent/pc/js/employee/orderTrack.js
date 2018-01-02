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
	/////////////
	var isAutoFind=$("#isAutoFind").val();
	$("#wuliufs").hide();
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
		var tbody=$("tbody");
		tbody.html("");
		pop_up_box.loadWait();
		$.get("orderTrackingRecord.do"+page,$("#gzform").serialize(),function(data){
			pop_up_box.loadWaitClose();
			if (data&&data.rows) {
				$.each(data.rows,function(i,n){
					var len=$("table th").length;
					var tr=getTr(len);
					tbody.append(tr); 
					var Status_OutStore=$.trim(n.Status_OutStore);
					var showpj='<button id="showpj" class="btn btn-primary" type="button">评价</button>';
					var shou='<button id="showQian" class="btn btn-primary" type="button">收货</button>';
					var orderxq='<button id="orderxq" class="btn btn-primary" type="button">详情</button>';
					$("th>.checkbox").show();
					if(Status_OutStore=="已结束"){
						tr.find("td:eq(0)").html(shou+showpj+orderxq);
						$("th>.checkbox").hide();
					}else{
						tr.find("td:eq(0)").html("<div class='checkbox'><input type='hidden' value='"+n.seeds_id+"'><input type='hidden' value='"+n.customer_id+"'></div>"+orderxq);
					}
					if(isProShow()){
						tr.find("td:eq(0)").show();
						$("th:eq(0)").show();
					}
					for (var k = 0; k < len; k++) {
						var th=$($("table th")[k]);
						var name=$.trim(th.attr("data-name"));
						var show=th.css("display");
						var j=$("table th").index(th);
						if(show=="none"){
							tr.find("td:eq("+j+")").hide();
						}else{
							if(name=="item_sim_name"){
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
								}else if(n.memo_other){
									tr.find("td:eq("+j+")").html($.trim(n.memo_other));
								}else{
									tr.find("td:eq("+j+")").html($.trim(n.memo_color));
								}
							}
							else{
								if(n[name]){
									tr.find("td:eq("+j+")").html($.trim(n[name]));
								}
							}
						}
						if(emplHeadship.indexOf("出纳")>=0||emplHeadship.indexOf("内勤")>=0||emplHeadship.indexOf("商务")>=0||emplclerk_name=="001"){
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
						if(name=="sd_oq"&&Status_OutStore!="已结束"){
							if($.trim($("#editNum #editNum").html())!=""){
								tr.find("td:eq("+j+")").click({"pack_unit":n.pack_unit,"seeds_id":n.seeds_id},function(event){
									var val=$(this).html();
									$("#editNum").show();
									$("#editNum #sd_oq").val(val);
									$("#editNum #pack_unit").html(event.data.pack_unit);
									$("#editNum #seeds_id").html(event.data.seeds_id);
									$("#editNum #zsnum").val(numformat(parseFloat(val)/parseFloat(event.data.pack_unit),0));
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
		var val=$("#editNum #sd_oq").val();
		var zsnum=$("#editNum #zsnum").val();
		if(val!=""){
			var seeds_id=$("#editNum #seeds_id").html();
			var zhiwu=$("#editNum #zhiwu").val();
			var tr=$("tbody tr").find("td:eq(0) input[value='"+seeds_id+"']").parents("tr");
			var i=$("thead th").index($("thead th[data-name='item_unit']"));
			var item_unit=tr.find("td:eq("+i+")").html();
			i=$("thead th").index($("thead th[data-name='item_sim_name']"));
			var item_sim_name=tr.find("td:eq("+i+")").text();
			i=$("thead th").index($("thead th[data-name='ivt_oper_listing']"));
			var no=tr.find("td:eq("+i+")").text();
			pop_up_box.postWait();
			$.post("editOrderNum.do",{
				"seeds_id":seeds_id,
				"sd_oq":val,
				"zhiwu":zhiwu,
				"title":"订单产品数量修改通知",
				"description":"@comName-@Eheadship-@clerkName:@name,修改了订单产品名称为【"+item_sim_name+"】的数量为:"+zsnum+item_unit+",订单编号:"+no
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					$("#editNum").hide();
					i=$("thead th").index($("thead th[data-name='sd_oq']"));
					tr.find("td:eq("+i+")").html(val);
					i=$("thead th").index($("thead th[data-name='zsnum']"));
					tr.find("td:eq("+i+")").html($("#editNum #zsnum").val());
					i=$("thead th").index($("thead th[data-name='sd_unit_price']"));
					var sd_unit_price=tr.find("td:eq("+i+")").html();
					i=$("thead th").index($("thead th[data-name='je']"));
					var je=parseFloat(val)*parseFloat(sd_unit_price);
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
	$(".handle").hide();
	$(".caigou").hide();
	$("select:eq(0)").val("00");
    $("select:eq(0)").change(function(){
    	var index=$(this).get(0).selectedIndex;
    	$(".handle").hide();
    	$(".caigou").hide();
    	var valnow=$.trim($(this).val());
    	var val;
    	if(valnow!="已发货"&&valnow!="已结束"&&valnow!="打欠条"&&valnow!="预存款审批"){
    	val=$(this).find("option:eq("+(index)+")").val();
    	}else{
    		val=valnow;
    	}
    	if(val){
    		if(window.location.href.indexOf("huaian")>=0){
    			if(val=="核货"||val=="库管备货"||val=="通知收货"){
    				$("button:contains('"+val+"')").show();
    			}
    		}else{
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
//    					$("button:contains('下采购订单')").show();
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
    $("#wuliuxixin").hide();
    $("#wuliufsxz").val("0-2");
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
	////////////////分页按钮功能/////////
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
	///////////////////选择提货地点,时间,司机信息,发送消息方式//////////
	var handleindex=0;
	$("#houyun_Select,#modal_smsSelect").find(".btn-default,.close").click(function(){
		$("#houyun_Select,#modal_smsSelect").hide();
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
			if(wuliu=="0-2"){
				if($("#houyun_Select").find("#didian").val()==""){
					pop_up_box.showMsg("请选择提货地点!");
				}else if($("#houyun_Select").find("#tihuoDate").val()==""){
					pop_up_box.showMsg("请选择提货时间!");
				}else{
					b=true;
				}
			}else{
				if($("#houyun_Select").find("#driverinfo").val()==""){
					pop_up_box.showMsg("请选择司机!");
				}else if($("#houyun_Select").find("#didian").val()==""){
					pop_up_box.showMsg("请选择司机提货地点!");
				}else if($("#houyun_Select").find("#tihuoDate").val()==""){
					pop_up_box.showMsg("请选择提货时间!");
				}else{
					b=true;
				}
			}
			if(b){
				var checks=$("tbody").find(".checkedbox");
				var houyun=$("#houyun_Select");
				var siji=houyun.find("#driverinfo").val();
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
	function handleSelect(checks,index,wuliu,siji,didian,tidate){
		var seedsId=[];
		var customer_names="";
		for (var i = 0; i < checks.length; i++) {
			var check=$(checks[i]); 
			var seeds_id=check.find("input:eq(0)").val();
			seedsId.push(seeds_id);
			var customer_name=$.trim(check.parents("tr").find("td:eq(1)").html());
			if (customer_names.indexOf(customer_name)<0) {
				if (customer_names=="") {
					customer_names=customer_name;
				}else{
					customer_names=customer_name+","+customer_names;
				}
			}
		}
		var name=$("select:eq(0)").val();
		
		var index=$("select:eq(0)").get(0).selectedIndex;
    	name=$("select:eq(0)").find("option:eq("+(index)+")").val();
    	
		pop_up_box.postWait();
		var url="saveHandle.do";
		var params={
				"seeds_id":seedsId.join(","),
				"NoticeStyle":$("input[name='NoticeStyle']:checked").val(),
				"wuliu":wuliu,
				"driver":siji,
				"didian":didian,
				"tidate":tidate,
				"name":name,
				"type":index
			};
		// TODO 库管备货
		if (name.indexOf("库管")>=0) {
			url="../orderTrack/noticeKuguan.do";
				params={
						"seeds_id":seedsId.join(","),
						"NoticeStyle":$("input[name='NoticeStyle']:checked").val(),
						"headship":"库管",
						"processName":name,
						"customer_names":customer_names,
						"msg":"的司机已经前来提货,请提前备货",
						"description":"",
						"url":"../orderTrack/driverWaybillDetail.do?type=beihuo|_seeds_id="+seedsId.join(",")
				};
		}
		$.post(url,params,function(data){
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
	var handleindex =0;
	$(".handle").click(function(){
		handleindex = $(".handle").index(this);
		var checks=$("tbody").find(".checkedbox");
		if($(this).html().indexOf("采购")>0){
			window.location.href="purchasingOrder.do";
		}else if (checks&&checks.length>0) {
			var modal="";
			if ($(this).html().indexOf("拉货")>0||$(this).html().indexOf("司机")>0||$(this).html().indexOf("核货")>=0) {
				modal =$("#houyun_Select");
			} else{
				modal =$("#modal_smsSelect");
			}
			if($(this).html().indexOf("核货")>=0){
				$("#driveInfo").hide();
			}
			var txt=$.trim($(this).html());
			modal.find("#confimdig").html(txt);
			modal.find("#closedig").html("取消");
			modal.show();
		}else{
			pop_up_box.showMsg("请至少选择一项数据!");
		}
	});
	
	
});