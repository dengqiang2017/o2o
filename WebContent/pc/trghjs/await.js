$(function(){
	var index=0;
	var payzje=0;//支付总金额
	var orderlist=[];
	$('.pay').click(function(){
		//显示收货地址,
		var items=$(".orderbox>.orderbox01");
		var reg = new RegExp("^[0-9.]*$");
		var showb=false;
		for (var i = 0; i < items.length; i++) {
			var sum_si=$.trim($(items[i]).find("#sum_si").html());
			if (reg.test(sum_si)) {
				showb=true;
				payzje=payzje+parseFloat(sum_si);
				var orderNo=$(items[i]).find("#orderNo").html();
				var com_id=$(items[i]).find("#com_id").html();
				orderlist.push(JSON.stringify({"orderNo":orderNo,"item_id":orderNo,"sum_si":sum_si,"com_id":com_id}));
			}
		}
		//判断有没有已经报价的订单
		if(showb){
			//获取客户总支付金额
			payzje=numformat2(payzje*payPercentage);
			$(".verify_01>span").html(payzje);
			$('.reap').slideToggle();
			$('.closed').show();
		}else{
			pop_up_box.showMsg("没有找到已报价订单,请等待报价后再支付!");
		}
	});
	$('.reap_04').click(function(){//确认收货地址
		var shdz=$("#fhdzlist").find(".reap_02").eq(index).find("#shdz").val();
		if($.trim(shdz)==""){
			pop_up_box.toast("没有找到收货地址", 1000);
		}else{
			//保存收货地址
			savefhdz();
			//显示支付方式
			$('.verify').slideToggle();
			$('.reap').hide();
		}
	});
	//计算前期需要支付的金额的百分比
	var payPercentage=100;
	var customerName="";
	$.get("../tailorMade/getPayPercentage.do",function(data){
		payPercentage=parseFloat(data.payPercentage)/100;
		customerName=data.corp_name;
		if($.trim(data.ifUseCredit)=="否"){//是否尅打欠条
			$(".verify_02").find("li:eq(2)").hide();
		}else{
			$(".verify_02").find("li:eq(2)").show();
		}
	});
	/////////天仁钢化收货地址左右滑动js////////////
	//获取收货地址 
	////////
	//向左显示收货地址
	$(".reap_03_left").click(function(){
		if (index>0) {
			index=index-1;
		}else{
			index=0;
		}
		showShdz();
	});
	//向右显示收货地址
	$(".reap_03_right").click(function(){
		var len=$("#fhdzlist").find(".reap_02").length-1;
		if (len>index) {
			index=index+1;
		}else{
			index=len;
		}
		showShdz();
	});
	//显示收货地址
	function showShdz(){
		$(".reap_02").hide();
		$(".reap_02").eq(index).show();
	}
	//点击编辑收货地址
	$(".reap_03>img").click(function(){
		$(".reap_02").eq(index).find("#lxr").removeAttr('disabled');
		$(".reap_02").eq(index).find("#lxhm").removeAttr('disabled');
		$(".reap_02").eq(index).find("#shdz").removeAttr('disabled');
	});
	///获取客户的收货地址
	var fhdzitem=$("#fhdzitem");
	$.get("../customer/getFHDZList.do",function(data){
		$("#fhdzlist").html("");
		if(data){
			$.each(data,function(i,n){
				var item=$(fhdzitem.html());
				$("#fhdzlist").append(item);
				item.find("#lxr").val(n.lxr);
				item.find("#lxhm").val(n.lxPhone);
				item.find("#shdz").val(n.fhdz);
				if(n.mr){
					item.show();
					index=i;
				}
				item.find("#edit").click(function(){
					editfhdz(this);
				});
				item.find("#del").click(function(){
					delfhdz(this);
				});
			});
//		    $("input[type='tel'],input[type='text']").prop('readonly',true);
//		    $("textarea").prop('readonly',true);
		}else{
			var item=$(fhdzitem.html());
			$("#fhdzlist").append(item);
		}
	});
	//////////////
	function delfhdz(t){
		var li=$(t).parents(".reap_02");
		li.remove();
		///如果index>=总个数
		var len=$(".reap_02").length;
		if (index>=len) {
			index=$(".reap_02").length-1;
		}
		savefhdz();
	}
	/**
	 * 保存发货地址
	 */
	function savefhdz(){
		var lis=$("#fhdzlist").find(".reap_02");
		var list="[";
		for (var i = 0; i < lis.length; i++) {
			if (index==i) {
				list+=getfhdz($(lis[i]),true)+",";
			}else{
				list+=getfhdz($(lis[i]),false)+",";
			}
		}
		list=list.substring(0, list.length-1);
		list+="]";
		$.post("../customer/saveFHDZList.do",{
			"fhdzlist":list
		},function(data){
			if (data.success) {
				pop_up_box.toast("收货地址已保存!", 500);
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
	}
	/**
	 * 获取发货地址 返回json字符串
	 */
	function getfhdz(li,mr){
		var json={};
		var lxr=li.find("#lxr").val();
		var lxPhone=li.find("#lxhm").val();
		var fhdz=li.find("#shdz").val();
		json.lxr=lxr;
		json.lxPhone=lxPhone;
		json.fhdz=fhdz;
		json.mr=mr;
		return JSON.stringify(json);
	}
	/**
	 * 获取发货地址 返回json字符串
	 */
	function getselectfhdz(li){
		var json={};
		var lxr=li.find("#lxr").val();
		var lxPhone=li.find("#lxhm").val();
		var fhdz=li.find("#shdz").val();
		json.lxr=lxr;
		json.lxPhone=lxPhone;
		json.fhdz=fhdz;
		json.mr=true;
		return json;
	}
	////////////////////
	var orderitem=$("#item");
	var page=0;
	var totalPage=0;
	var count=0;
	function addItem(data){
		if(data&&data.rows&&data.rows.length>0){
			$.each(data.rows,function(i,n){
				var item=$(orderitem.html());
				$(".orderbox").append(item);
				item.find("#orderNo").html(n.ivt_oper_listing);
				item.find("#com_id").html(n.com_id);
				if (n.sum_si>0) {
					item.find("#sum_si").html(numformat2(n.sum_si));
				}else{
					item.find("#sum_si").html("请等待报价");
				}
				if(n.info){
					item.find("#demandInfo").html(n.info.demandInfo);
					item.find("#deliveryDate").html(n.info.deliveryDate);
					item.find(".swiper-wrapper").html("");
					$.each(n.imgs,function(j,m){
						var imghtml=$('<div class="swiper-slide"><img class="center-block"></div>');
						item.find(".swiper-wrapper").append(imghtml);
						imghtml.find("img").attr("src",".."+m);
						imghtml.click(function(){
							pop_up_box.showImg(".."+m);
						});
					});
				}
				item.find("#del").click({"orderNo":n.ivt_oper_listing},function(event){
					if (confirm("是否要删除该订单!")) {
						var t=$(this);
						$.post("../tailorMade/delTailorMade.do",{
							"orderNo":event.data.orderNo
						},function(data){
							if (data.success) {
								pop_up_box.showMsg("删除成功!");
								t.parents(".orderbox01").remove();
							} else {
								if (data.msg) {
									pop_up_box.showMsg("保存错误!" + data.msg);
								} else {
									pop_up_box.showMsg("保存错误!");
								}
							}
						})
					}
				});
			});
			totalPage=data.totalPage;
			count=data.totalRecord;
			var mySwiper = new Swiper ('.swiper-container', {
				loop: true,
				slidesPerView : 3,
				centeredSlides : true
			})
		}
	}
	$(".orderbox").html("");
	loadData();
	function loadData(){
		pop_up_box.loadWait();
		$.get("../tailorMade/getTailorMadeInfoPage.do",{
			"page":page,
			"count":count
		},function(data){
			pop_up_box.loadWaitClose();
			addItem(data);
		});
	}
	var addindex=0;
	$(window).scroll(function(){
		if (addindex==0) {
			if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
				addindex=1;
				if (page==totalPage) {
				}else{
					pop_up_box.loadWait();
					page+=1;
					loadData();addindex=0;
				}
			}
		}
	});
//	$("#qrpay")
	$(".verify_02>ul>li").click(function(){
		//提交订单数据
		var fhdz=getselectfhdz($("#fhdzlist").find(".reap_02").eq(index)).fhdz;
		var orderparam={
				"orderlist":"["+orderlist.join(",")+"]",
				"amount":payzje,
				"FHDZ":fhdz,
				"order":"tailorOrder"
		};
		var verify_02=$.trim($(this).html());
		if(verify_02=="打欠条"){
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
			$.cookie("customerName",customerName,{path:"/", expires: 1 });
			$.cookie("date",nowStr,{path:"/", expires: 1 });
			$.cookie("ddje",payzje,{path:"/", expires: 1 });
			$.cookie("ddzje",payzje,{path:"/", expires: 1 });
			$.cookie("order","tailorOrder",{path:"/", expires: 1 });
			$.cookie("ljqk",payzje,{path:"/", expires: 1 });
			$.cookie("FHDZ",fhdz,{path:"/", expires: 1 });
			$.cookie("orderlist","["+orderlist.join(",")+"]",{path:"/", expires: 1 });
			window.location.href="../customer/iou.do";
		}else{
			pop_up_box.postWait();
			orderparam.paystyle="JS001";
			orderparam.account=verify_02;
			orderparam.sum_si_origin=verify_02;
			orderparam.paystyletxt="账上款";
			$.post("../customer/savePaymoney.do",orderparam,function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("保存成功!",function(){
						window.location.reload(true);
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
});