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
		$(".side-cover").hide();
	});
	
	if($(".tabs-content:eq(0)").find(".folding-btn").css("display")=="none"){
		$("#gzform").show();
	}else{
		$("#gzform").hide();
	}
	//客户端订单跟踪上传凭证
	$(".find").click(function(){
		pop_up_box.loadWait();
		pagegz=1;
		countgz=0;
		totalgz=0;
		var page="?page=0&count=0";
		order_gz(page);
 	});
//	$("select").change(function(){
//		var val=$.trim($(this).val());
//		 $(".find:eq(0)").click(); 
//	});
	var select=document.getElementsByName('type')[0]; 
     select.options[0].value="11";
	$("select").change(function(){
		var val=$.trim($(this).val());
		if(val=="已发货"){
			$("#qrsh").show();
			$("#pjdd").hide();
			$("#showsh").hide();
		}else if(val=="已结束"){
			$("#showsh").show();
			$("#pjdd").show();
			$("#qrsh").hide();
//			$("#qrsh").html("查看收货");
//			$("#pjdd").html("查看评价");
		}else{
			$("#showsh").hide();
			$("#qrsh").hide();
			$("#pjdd").hide();
		}
		 $(".find:eq(0)").click(); 
	});
	
	$("select").val("11");
	/////////处理从外部直接进入事件////////
	var url=window.location.href.split("?");
	 if (url.length>1) {
		 var param=url[1];
		 param=replaceAll(param,"%7C", "|");
		 if(param.indexOf("seeds_id")>=0){
			 var params=param.split("|");
			 if(params.length>1){
				 $("select[name='type']").val(decode(params[1]));
			 }
		 }else{
			 var params=param.split("|");
			 $("input[name='searchKey']").val(params[0]);
			 $("select[name='type']").val(decode(params[1]));
		 }
		 $("select[name='type']").change();
	}else{
		$(".find:eq(0)").click(); 
	}
//	 $(".find:eq(0)").click(); 
	var pagegz=1;
	var countgz=0;
	var totalgz=0;
	function order_gz(page){
		if (!page) {
			page="";
		}
		var tbody=$(".tabs-content:eq(0)").find("tbody");
		tbody.html("");
		pop_up_box.loadWait();
		$.get("orderTrackingRecord.do"+page,$("#gzform").serialize(),function(data){
			pop_up_box.loadWaitClose();
			if (data&&data.rows) {
				$.each(data.rows,function(i,n){
					var tr=getTr(13);
					tbody.append(tr); 
					var pjdd='<button id="pjia" class="btn btn-primary btn-folding btn-sm" type="button">评价订单</button>';
					var shou='<button id="shou" class="btn btn-primary btn-folding btn-sm" type="button">查看收货</button>';
					var showpj='<button id="pjia" class="btn btn-primary btn-folding btn-sm" type="button">查看评价</button>';
					var orderxq='<button id="orderxq" class="btn btn-primary btn-folding btn-sm" type="button">详情</button>';
//					if($.trim(n.Status_OutStore)=="已发货"){
//						tr.find("td:eq(0)").html(shou);
//					}else if($.trim(n.Status_OutStore)=="待评价"){
//						tr.find("td:eq(0)").html(pjdd);
//					}else if($.trim(n.Status_OutStore)=="已结束"){
//						tr.find("td:eq(0)").html(showpj);
//					}else{
//						tr.find("td:eq(0)").html("");
//					}
					var inp='<div class="pro-check" style="float: left;width: 30px;"></div><input type="hidden" id="seeds_id" value="'+n.seeds_id+'">';
					var item_id='<input type="hidden" id="item_id" value="'+$.trim(n.item_id)+'">';
					inp+=item_id;
					if($.trim(n.Status_OutStore)=="已发货"){
						tr.find("td:eq(0)").html(inp+orderxq);
					}else if($.trim(n.Status_OutStore)=="已结束"){
						if(n.pingjiaed){
							tr.find("td:eq(0)").html(shou+showpj+item_id+orderxq);
						}else{
							tr.find("td:eq(0)").html(shou+pjdd+item_id+orderxq);
						}
					}else{
						tr.find("td:eq(0)").html(orderxq);
					}
					
					tr.find("td:eq(1)").html(n.item_sim_name);
					
					tr.find("td:eq(2)").html(n.sd_oq);
					tr.find("td:eq(3)").html(n.casing_unit);
					tr.find("td:eq(4)").html(numformat(n.sd_oq/n.pack_unit,0));
					tr.find("td:eq(5)").html(n.item_unit);
					
					tr.find("td:eq(6)").html(n.sd_unit_price);
					tr.find("td:eq(7)").html(numformat2(n.sd_oq*n.sd_unit_price));
					if (n.so_consign_date) {
						var now = new Date(n.so_consign_date);
						var nowStr = now.Format("yyyy-MM-dd");
						tr.find("td:eq(8)").html(nowStr);
					}
					tr.find("td:eq(9)").html(n.Status_OutStore);
					tr.find("td:eq(10)").html(n.ivt_oper_listing);
					tr.find("#pjia").click({"orderNo":$.trim(n.ivt_oper_listing),"item_id":$.trim(n.item_id),"com_id":$.trim(n.com_id)},function(event){
						window.location.href="pingjia.do?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&com_id="+event.data.com_id;
					});
//					tr.find("#showpj").click({"orderNo":$.trim(n.ivt_oper_listing),"item_id":$.trim(n.item_id)},function(event){
//						window.location.href="pingjia.do?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&show=false";
//					});
					tr.find("#shou").click({"orderNo":$.trim(n.ivt_oper_listing),"item_id":$.trim(n.item_id),"seeds_id":$.trim(n.seeds_id)},function(event){
						window.location.href="shouhuoed.do?orderNo="+event.data.orderNo+"&item_id="+event.data.item_id+"&seeds_id="+event.data.seeds_id;
					});
					if(n.Kar_paizhao){
						tr.find("td:eq(11)").html($.trim(n.Kar_paizhao));
					}
					if(n.HYS){
						var siji=$.trim(n.HYS).split(",");
						if(siji.length==2){
							var sijiphone=siji[1];
							sijiphone="<a href='tel:"+sijiphone+"'>"+sijiphone+"</a>"
							tr.find("td:eq(12)").html($.trim(siji[0]+","+sijiphone));
						}else{
							tr.find("td:eq(12)").html($.trim(n.HYS));
						}
					}
//					if(n.transport_AgentClerk_Reciever){
//						var ta=$("#houyun_Select").find("select option[value='"+n.transport_AgentClerk_Reciever+"']").text();
//						tr.find("td:eq(13)").html(ta);
//					}
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
//									if(i==(data.historyInfo.length-1)){
//										item.find(".state_img02>img").attr("src","images/07_ring.png");
//										item.find(".state_img02").addClass("state_img01");
//										item.find(".li_margin02").addClass("li_margin");
//									}
								}
							}
						});
					});
				});
				countgz=data.totalRecord;
				totalgz=data.totalPage;
				$(".pro-check").unbind("click");
				$(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
					var b=$(this).hasClass("pro-checked");
					if (b) {
						$(this).removeClass("pro-checked");
					}else{ 
						$(this).addClass("pro-checked");
					}
				});
			}
		});
	}
	$("#qrsh").click(function(){
		var pros=$("tbody").find(".pro-checked");
		if(pros&&pros.length>0){
			var list="";
			var seeds="";
			for (var i = 0; i < pros.length; i++) {
				var ivt_oper_listing=$.trim($(pros[i]).parents("tr").find("td:eq(10)").html());
				var item_id=$.trim($(pros[i]).parents("tr").find("#item_id").val());
				var seeds_id=$.trim($(pros[i]).parents("tr").find("#seeds_id").val());
				var json={"orderNo":ivt_oper_listing,"item_id":item_id,"seeds_id":seeds_id};
				if(list!=""){
					list=JSON.stringify(json)+","+list;
				}else{
					list=JSON.stringify(json);
				}
				if(seeds!=""){
					seeds=seeds_id+","+seeds;
				}else{
					seeds=seeds_id;
				}
			}
			$.cookie("orderparams","["+list+"]");
			window.location.href="shouhuo.do?seeds_id="+seeds;
		}else{
			pop_up_box.showMsg("请选择至少选择一个产品!");
		}
	});
	
	$("#showsh").click(function(){
		var check=$("tbody").find(".pro-checked");
		if(check){
			var orderNo="";
			var seeds_id="";
			for (var i = 0; i < check.length; i++) {
				var item=$(check[i]).parents("tr");
				if(orderNo==""){
					orderNo=$.trim(item.find("td:eq(10)").html());
					item_id=$.trim(item.find("#item_id").val());
					seeds_id=$.trim(item.find("#seeds_id").val());
				}else{
					orderNo=$.trim(item.find("td:eq(10)").html());
					item_id=$.trim(item.find("#item_id").val());
					seeds_id=$.trim(item.find("#seeds_id").val())+",";
				}
			}
			window.location.href="shouhuoed.do?orderNo="+orderNo+"&seeds_id="+seeds_id+"&item_id="+item_id;
		}else{
			pop_up_box.showMsg("请选择要查看的产品");
		}
	});
	$("#pjdd").click(function(){
		var pros=$("tbody").find(".pro-checked");
		if(pros&&pros.length>0){
			var list="";
			for (var i = 0; i < pros.length; i++) {
				var ivt_oper_listing=$.trim($(pros[i]).parents("tr").find("td:eq(10)").html());
				var item_id=$.trim($(pros[i]).parents("tr").find("#item_id").val());
				var json={"orderNo":ivt_oper_listing,"item_id":item_id};
				if(list!=""){
					list=JSON.stringify(json)+","+list;
				}else{
					list=JSON.stringify(json);
				}
			}
			$.cookie("orderparams","["+list+"]");
			window.location.href="pingjia.do";
		}else{
			pop_up_box.showMsg("请选择至少选择一个产品!");
		}
	});
///////////////////////////////
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
	
});