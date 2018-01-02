$(function(){
	var no=window.location.href.split("?")[1];
	if(!no){
		pop_up_box.showMsg("参数错误!",function(){
			window.history.go(-1);
		});
		return;
	}
	if(no.indexOf("=")>=0){
		no=no.replace("=","");
	}
	var li=$(".ul_box>ul>li:eq(0)");
	$(".ul_box>ul").html("");
	pop_up_box.loadWait();
	$.get("../pre/preSaleConfirmListQuery.do",{
		"no":no
	},function(data){
		pop_up_box.loadWaitClose();
		$.each(data,function(i,n){
			var item=$("<li>"+li.html()+"</li>");
			$(".ul_box>ul").append(item);
			var prex="收购";
			if(n.customer_id&&n.customer_id.indexOf("CS1C001")>=0){//显示养殖户数据,预购方进入
				prex="预售";
				if(n.m_flag==2||n.m_flag==3){//养殖户已经确认
					$("#save").hide();
				}else{
					$("#save").show();
				}
				if(n.address&&n.latlng){
					item.find(".address").html("地址:"+n.address.replace("中国", ""));
					item.find(".address").parent().click({"name":n.corp_name,"address":n.address,"coord":n.latlng},function(event){
						var url="http://apis.map.qq.com/tools/poimarker?type=0&";
						url+="marker=coord:"+event.data.coord+";title:"+event.data.name;
						url+="&key=KDPBZ-MLJCV-A4TP2-UF7RY-NEU2E-MDF34&referer=小猪动车";
						window.location.href=url;
					});
				}else{
					item.find(".address").parent().hide();
				}
			}else{//预售方进入
				if(n.m_flag==1||n.m_flag==3){//养殖户已经确认
					$("#save").hide();
				}else{
					$("#save").show();
				}
				item.find(".address").parent().hide();
			}
			item.find("p:eq(0)>span:eq(0)").html(prex+"人:"+n.corp_name);
			item.find("p:eq(1)>span:eq(0)").html(prex+"数量:"+n.num+"头");
			item.find("p:eq(3)>span:eq(0)").html("猪种:"+n.item_name);
			var lsname=new String(n.item_name);
			if(lsname[1]=="仔猪"){
				item.find("p:eq(2)>span:eq(0)").html(prex+"价格:"+numformat2(n.price)+"元/头");
			}else{
				item.find("p:eq(2)>span:eq(0)").html(prex+"价格:"+numformat2(n.price)+"元/kg");
			}
			item.find("#gua_num").html("挂价数量:"+n.gua_num);
			item.find("#gua_price").html("挂价数量:"+n.gua_price);
			$(".body>p:eq(0)").html(n.time);
			if(IsPC()){
				item.find("p:eq(0)").attr("title",n.movtel);
			}else{
				item.find("p:eq(0)").click({"tel":n.movtel},function(event){
					window.location.href="tel:"+event.data.tel;
				});
			}
			if(n.m_flag=="0"){
				item.find("p:eq(4)").html("状态:等待确认");
			}else if(n.m_flag=="1"){
				item.find("p:eq(4)").html("状态:预售方已确认,收购方未确认");
			}else if(n.m_flag=="2"){
				item.find("p:eq(4)").html("状态:收购方已确认,预售方未确认");
			}else if(n.m_flag=="3"){
				item.find("p:eq(4)").html("状态:双方确认,交易完成");
			}
			item.find("#showImg").click({"orderNo":$.trim(n.pre_trading_no)},function(event){
				$.get("../pre/getPreImgs.do",{
					"no":event.data.orderNo
				},function(data){
					$("#imshow").html("");
					if (data&&data.length>0) {
						$(".image-zhezhao").show();
						for (var k = 0; k < data.length; k++) {
							$("#imshow").append("<img class='center-block' src='"+data[k]+"'>");
						}
						$("#imshow img").hide();
						$("#imshow img:eq(0)").show();
					} else {
						pop_up_box.toast("没有图片!");
					}
				});
			});
		});
	});
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
	$("#save").click(function(){
		pop_up_box.postWait();
		$.post("../pre/preSaleConfirm.do",{
			"no":no
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("提交成功!",function(){
					window.history.go(-1);
					window.location.href="../pc/dealbuy.html?ver=001";
				});
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
	});
	$("#closeimgshow").click(function(){
		$(".image-zhezhao").hide();
	});
//	$("#showImg").click(function(){
//		$.get("../pre/getPreImgs.do",{
//			"no":no
//		},function(data){
//			if (data&&data.length>0) {
//				$(".image-zhezhao").show();
//				$("#imshow").html("");
//				for (var k = 0; k < data.length; k++) {
//					$("#imshow").append("<img src='"+data[k]+"'>");
//				}
//			} else {
//				pop_up_box.showMsg("没有图片!");
//			}
//		});
//	});
});