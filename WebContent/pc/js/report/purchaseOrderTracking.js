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
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd");
	$(".Wdate:eq(1)").val(nowStr);
	var firstDay=nowStr.split("-");
	$(".Wdate:eq(0)").val(firstDay[0]+"-"+firstDay[1]+"-01");
	///////////
	var pagegz=0;
	var countgz=0;
	var totalgz=0;
	$("tbody").html("");
	var emplHeadship=$.trim($("#emplHeadship").val());
	var emplclerk_name=$.trim($("#emplclerk_name").val());
	$("select").change(function(){
		order_gz("");
	})
	function order_gz(page){
		if (!page) {
			page="";
		}
		var tbody=$("tbody");
		tbody.html("");
		pop_up_box.loadWait();
		$.get("vendorOrderList.do"+page,$("#gzform").serialize(),function(data){
			pop_up_box.loadWaitClose();
			if (data&&data.rows) {
				$.each(data.rows,function(i,n){
					var tr=getTr(17);
					tbody.append(tr); 
					tr.find("td:eq(0)").html(n.st_auto_no);
					var now = new Date(n.at_term_datetime);
					var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
					tr.find("td:eq(1)").html(nowStr);
					tr.find("td:eq(2)").html(n.rep_qty);
					if(n.rksl){
						tr.find("td:eq(3)").html(n.rksl);
						tr.find("td:eq(4)").html(parseFloat(n.rep_qty)-parseFloat(n.rksl));
					}else{
						tr.find("td:eq(3)").html(0);
						tr.find("td:eq(4)").html(parseFloat(n.rep_qty)-0);
					}
					if(n.m_flag==0){
						tr.find("td:eq(5)").html("未处理");
					}else if(n.m_flag==1){
						tr.find("td:eq(5)").html("已作废");
					}else if(n.m_flag==2){
						tr.find("td:eq(5)").html("已处理有货");
					}else if(n.m_flag==3){
						tr.find("td:eq(5)").html("已处理无货");
					}else if(n.m_flag==4){
						tr.find("td:eq(5)").html("已发货");
					}else if(n.m_flag==5){
						tr.find("td:eq(5)").html("已收货");
					}else if(n.m_flag==8){
						tr.find("td:eq(5)").html("已通知安排物流");
					}else if(n.m_flag==9){
						tr.find("td:eq(5)").html("已提交物流信息");
					}
					tr.find("td:eq(6)").html(n.corp_name);
					tr.find("td:eq(7)").html(n.movtel);
					tr.find("td:eq(8)").html(n.item_id);
					tr.find("td:eq(9)").html(n.item_name);
					tr.find("td:eq(10)").html(n.price);
					tr.find("td:eq(11)").html(n.item_spec);
					tr.find("td:eq(12)").html(n.item_type);
					tr.find("td:eq(13)").html(n.item_color);
					tr.find("td:eq(14)").html(n.item_unit);
					
					tr.find("td:eq(15)").html((n.price)*(n.rep_qty));
					tr.find("td:eq(16)").html(n.discount_rate);
				});
				setcheckbox(true);
				countgz=data.totalRecord;
				totalgz=data.totalPage;
			}
		});
	}
    //////////////////////
	$(".find").click(function(){
		pagegz=1;
		countgz=0;
		totalgz=0;
		$(".checkbox").removeClass("checkedbox");
		order_gz("");
	});
	//////////////从外部直接进入处理
	var params=window.location.href.split("?");
	if (params&&params.length>1) {
		var bivt=params[1].indexOf("ivt_oper_listing")>0;//判断是否是订单编号
		if(params[1].split("=")[0]=="seeds_id"||params[1].split("=")[0]=="seeds_ids"){
			bivt=true;
		}
		params=params[1];
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
	////////////////
	$("#onePage").click(function(){
		pagegz=1;
		var page="?page=1&count="+countgz;
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