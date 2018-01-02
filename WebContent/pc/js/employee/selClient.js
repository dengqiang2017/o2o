var selectClient = {
	init : function(func,prex,upper) {
		if (!prex) {
			prex="";
			$("#seekh").click();// 进入订单页面先选择客户
		}
		if(!upper){
			upper="";
		}
		$("#findclient").click(function() {
			pop_up_box.loadWait();
			$.get(prex+"getCustomerByClerk_id.do", {
				"upper":upper,
				"keyname" : $.trim($("#clientkeyname").val())
			}, function(data) {
				$(".hide-table div").html("");
				loadclientul(data);
				pop_up_box.loadWaitClose();
				$("#clientkeyname").focus();
				page_client = data.page - 1;
				totalPage_client = data.totalPage;
				count_client = data.totalRecord;
				if (data.totalPage <= data.page&&((page_client+1)*data.pageRecord)>=data.totalRecord) {
					$(".btn_add_client").parent().hide();
				} else {
					$(".btn_add_client").parent().show();
				}
			});
		});
		$("#clientkeyname").val("");
		var clientul = $(".hide-msg");
		$("#findclient").click();
		$(document).keydown(function(e) {
			if (e.keyCode == 13) {
				if (!$(".left-hide-ctn").is(":hidden")) {
					$("#findclient").click();
				}
			}
		});
		function loadclientul(data) {
			if (data&&data.rows&&data.rows.length>0) {
				$.each(data.rows,function(i, n) {
					if ($.trim(n.corp_sim_name) != ""
							|| $.trim(n.movtel) != "") {
						var item = clientul.clone();
						$(".hide-table div").append(item);
						item.find("li:eq(0)").html(n.corp_sim_name);
						if (n.tel_no) {
							item.find("li:eq(1)").html(n.tel_no);
						}else{
							item.find("li:eq(1)").html(n.movtel);
						}
						item.find("li:eq(2)").html(
								"<input type='hidden' value='"
										+ n.customer_id + "' id='"
										+ n.customer_id + "'>");
						item.click({"customer_id":n.customer_id,
							"corp_sim_name":n.corp_sim_name,
							"ditch_type":n.ditch_type,
							"tel_no":n.tel_no,
							"movtel":n.movtel,
							},function(event) {
							var customer_id = $(this).find(
									"li:eq(2) input").val();
							$(".sim-msg li:eq(0)").html(
									$(this).find("li:eq(0)").html());
							$(".sim-msg li:eq(1)").html(
									$(this).find("li:eq(1)").html());
							if (func) {
								func(customer_id);
							}
							$("body").css("overflow","visible");
							$("#customer_id").val(customer_id);
							$("#ditch_type").html(event.data.ditch_type);
							$(".cover").click();
							cMsg.show(); 
						});
						var customer_id=getQueryString("customer_id");
						if($.trim(n.customer_id)==customer_id){
							item.click();
						}
					}
				});
			}
		}
		var page_client = 0;
		var totalPage_client = 0;
		var count_client = 0;
		$(".btn_add_client").click(function() {
			if (page_client==totalPage_client) {
				pop_up_box.showMsg("已全部加载!");
			}else{
			pop_up_box.loadWait();
			page_client+=1;
			$.get(prex+"getCustomerByClerk_id.do", {
				"upper" : upper,
				"count" : count_client,
				"keyname" : $("#clientkeyname").val(),
				"page" : page_client
			}, function(data) {
				pop_up_box.loadWaitClose();
				loadclientul(data);
				if (data.totalPage <= data.page&&((page_client+1)*data.pageRecord)>=data.totalRecord) {
					$(".btn_add_client").parent().hide();
				} else {
					$(".btn_add_client").parent().show();
				}
			});
			}

		});
	}
}

var expandClient={
		init:function(){
			///从1号到当天
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd"); 
			var onedays=nowStr.split("-");
			$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
			$(".Wdate:eq(1)").val(nowStr); 
		 
			$("#expand").click(function(){
				var form=$("form");
				if(form.is(":hidden")){
					form.show();
					$(this).text("隐藏搜索");
				}else{
					$(this).text("展开搜索");
					form.hide();
				}
			});
			if($(".folding-btn").css("display")=="none"){
				$("form").show();
			}else{
				$("form").hide();
			}
			//结算方式选择
			try {
				selectTree.settlement();
			} catch (e) {
			}
			//////
		}
}