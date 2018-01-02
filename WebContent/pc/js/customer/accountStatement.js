$(function(){
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".input-sm").val("");
	var onedays=nowStr.split("-");
	$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
	$(".Wdate:eq(1)").val(nowStr); 
	var cids=window.location.href.split("?");
	if (cids&&cids.length>1) {
//		cids=cids[1].split("&");
//		$("input[name='key_words']").val(cids[0].split("=")[1]);
//		try {
//			$("#clientname").html(decodeURI(cids[1].split("=")[1])+" 关闭");
//		} catch (e) {}
	}
    function importImg(sig){///保存
    	var data=$.trim(sig.jSignature('getData'));
    	if (data.length>6000) {
    		$("img").attr("src",data);
    		$("#signature,#clear").remove();
    		$("img").show();
    		return false;
		}else{
			alert("请签名!");
			return true;
		}
    }
  //客户端订单跟踪上传凭证
    if(window.location.href.indexOf("cdsydq")>0){
    	$("#qianzi").hide();
    }
    try {
    	$("#signature").jSignature();
	} catch (e) {}
	var height=$('#signature').css("height");
	var width=$('#signature').css("width");
	$('#signature').find("canvas").css("height",height);
	$('#signature').find("canvas").attr("height",height.split("px")[0]);
	$('#signature').find("canvas").css("width",document.body.clientWidth+"px");
	$('#signature').find("canvas").attr("width",document.body.clientWidth);
	$('#signature').jSignature('clear');
	 $("img").hide();
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
	$(".btn-default").click(function(){
		$(this).parents("input-group").find("span.input-sm").html("");
		$(this).parents("input-group").find("input.input-sm").val("");
	});
	$('.qs_btn').click(function(){
	$('#mymodal2').toggle();
	});
	$('.close').click(function(){
	$('#mymodal2').hide();
	});
	$('.gb2').click(function(){
	$('#mymodal2').hide();
	});
	$(".btnsize").click(function(){
		if (importImg($('#signature'))) {
			return;
		}
		var pros=$(".pro-checked");
		if(pros&&pros.length>0){
			var list=[];
			for (var i = 0; i < pros.length; i++) {
				var tr=$(pros[i]).parents("tr");
				var param={};
				var no=tr.find("td:eq(1)").html();
				param.no=no;
				var seeds_id=tr.find("input").val();
				param.seeds_id=seeds_id;
				list.push(JSON.stringify(param));
			}
			$.post("confirmQianming.do",{"list":"["+list.join(",")+"]","img":$("img").attr("src")},function(data){
				if (data.success) {
					pop_up_box.showMsg("提交成功!");
					window.location.href="../customer.do";
					$('#mymodal2').hide();
					$(".find:eq(0)").click();
				} else {
					if (data.msg) {
						pop_up_box.showMsg("提交错误!" + data.msg);
					} else {
						pop_up_box.showMsg("提交错误!");
					}
				}
			});
		}else{
			pop_up_box.showMsg("请至少选择一项客户对账单!");
		}
	});
	$("#settlement").click(function(){
		var i=$(".btn-success").index(this);
		pop_up_box.loadWait(); 
		 $.get("../tree/getDeptTree.do",{"type":"settlement"},function(data){
			   pop_up_box.loadWaitClose();
			 $("body").append(data);
			 settlement.init(function(){
				 $("#settlement_name").html(treeSelectName);
				 $("#settlement_id").val(treeSelectId);
			 });
		 });
	});
	$("input[name='if_check']").click(function(){
		$(".find").click();
	});
	$(".find").click(function(){
		if (findflag==1) {
			return;
		}else{
			pop_up_box.loadWait(); 
			$("tbody").html("");
			var json={//"client_id":customer_id,
					"beginDate":$("input[name='beginDate']").val(),
					"endDate":$("input[name='endDate']").val(),
					"key_words":$("input[name='key_words']").val(),
					"if_LargessGoods":"否",
//					"if_check":"全部",
					"if_check":$("input[name='if_check']:checked").val(),
					"settlement_sortID":$("input[name='settlement_sortID']").val()};
			$.get("../report/accountStatementList.do",json,function(data){
				pop_up_box.loadWaitClose();
				$.each(data.rows,function(i,n){
					var tr=getTr(12);
					$("tbody").append(tr);
//					var qianming=$.trim(n.qianming);
					if(n.qianmingTime>0){
						tr.find("td:eq(0)").html("已签字确认");
					}else{
						if(n.sd_order_id){
						tr.find("td:eq(0)").html('<div class="pro-check"></div><input type="hidden" value="'+n.seeds_id+'">');
						}
					}
					tr.find("td:eq(1)").html(n.sd_order_id);
					if (n.openbill_date>0) {
						var now = new Date(n.openbill_date);
						var nowStr = now.Format("yyyy-MM-dd"); 
						tr.find("td:eq(2)").html(nowStr);
					}
					
//					tr.find("td:eq(3)").html(n.openbill_type);
					if(n.sd_order_id){
					if(n.sd_order_id.indexOf("XSKD")>0){
						tr.find("td:eq(3)").html("下订单");
					}else if(n.sd_order_id.indexOf("XSSK")>0){
						tr.find("td:eq(3)").html("付款");
					}
					}
					tr.find("td:eq(4)").html(n.settlement_sim_name);
					$("th:eq(4)").hide();
					tr.find("td:eq(4)").hide();
					tr.find("td:eq(5)").html(numformat(n.accept_sum,2));
					tr.find("td:eq(6)").html(numformat(n.allaccept_sum,2));
					tr.find("td:eq(7)").html(numformat(n.surplus_sum,2));
					tr.find("td:eq(8)").html(n.item_sim_name);
					tr.find("td:eq(9)").html(numformat(n.sd_oq,2));
					tr.find("td:eq(11)").html($.trim(n.beizhu));
					if(n.qianmingTime>0){
						var now = new Date(n.qianmingTime);
						var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
						tr.find("td:eq(10)").html(nowStr);
					}
					///只有销售单据和收款单据才可以增加备注
					if(n.sd_order_id&&(n.sd_order_id.indexOf("XSKD")>0||n.sd_order_id.indexOf("XSSK")>0)){
						tr.find("td:eq(11)").click(function(){
							var t=$(this);
							var val=$.trim(t.html());
							$("#addbeizhu").show();
							$("#addbeizhu textarea").val(val);
							$("#addbeizhu textarea").focus();
							
							var seeds_id=t.parents("tr").find("input:eq(0)").val();
							var sd_order_id=$.trim(t.parents("tr").find("td:eq(1)").html());
							$("#savebeizhu").unbind("click");
							$("#savebeizhu").click({"seeds_id":seeds_id,"sd_order_id":sd_order_id,"val":val,"t":t},function(event){
								var iptval=$.trim($("#addbeizhu textarea").val());
								event.data.t.html(iptval);
								if(iptval!=event.data.val){
									///获取行seeds_id
									$.post("../customer/postdzdMemo.do",{
										"seeds_id":event.data.seeds_id,
										"sd_order_id":event.data.sd_order_id,
										"c_memo":iptval
									});
								}
								$("#addbeizhu").hide();
							});
//							if(t.html().indexOf("input")<0){
//								var ipt=$("<input value='"+val+"' id='cmemo' width='100%'>");
//								t.html(ipt);ipt.focus();
//							}else{
//								$(this).find("input").blur();
//							}
//							t.find("input").unbind("blur");
//							t.find("input").blur(function(){
//								var iptval=$.trim($(this).val());
//								t.html(iptval);
//								if(iptval!=val){
//									///获取行seeds_id
//									$.post("../customer/postdzdMemo.do",{
//										"seeds_id":seeds_id,
//										"sd_order_id":sd_order_id,
//										"c_memo":iptval
//									});
//								}
//							});
						});
					}
					if(n.beizhu){
					tr.find("td:eq(12)").html(n.beizhu.split("订单编号")[0]);
					}
					tr.find("td:eq(13)").hide();
					$("th:eq(12)").hide();
				});
				$(".pro-check").unbind("click");
				$(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
					var b=$(this).hasClass("pro-checked");
					if (b) {
						$(this).removeClass("pro-checked");
					}else{ 
						$(this).addClass("pro-checked");
					}
				});
			});
		}
	});
	$(".closedig,.close").click(function(){
		$("#addbeizhu").hide();
	});
	$(".find").click();
});