$(function() {
	//加载选择供应商页面,模拟搜索点击事件获取供应商信息
	selectSupplier.init(function(corpId) {
		$("#corp_id").val(corpId);
		getAmount();
		getYfAmount();
	});
	$(".qx,.close").click(function(){
		$("#info").hide();
		$("#sure").unbind("click");
	});
	$.get("setDefaultByClerkId.do",function(data){
		$.each(data,function(i,n){
			$("#clerk_name").html(n.clerk_name);
			$("#clerkId").val(n.clerk_id);
			$("#dept_name").html(n.dept_name);
			$("#deptId").val(n.dept_id);
		})
	});
	$(".dept").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do", {
			"type" : "dept"
		}, function(data) {
			pop_up_box.loadWaitClose();
			$("body").append(data);
			dept.init(function(){
					$("#deptId").val(treeSelectId);
					$("#dept_name").html(treeSelectName);
			});
		});
	});
	$(".clerk").click(function(){
		pop_up_box.loadWait();
		$.get("../manager/getDeptTree.do", {
			"type" : "employee"
		}, function(data) {
			pop_up_box.loadWaitClose();
			$("body").append(data);
			employee.init(function(){
					$("#clerkId").val(treeSelectId);
					$("#clerk_name").html(treeSelectName);
			});
		});
	});
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
	$("#time").val(nowStr);
	var orderNo=$("input[name='orderNo']");
	var amount=$("input[name='amount']");
	//自动生成采购付款单号
	$.get("getPayorderNo.do",function(data){
		orderNo.val(data);
	});
	$("input[name=dhAmount],input[name=orderNo],input[name=sum_si]").focus(function(){
		$(this).blur();
	});
	function loadItemName(name,id){
		return "<div class='paycheck-box'>"+name+"<span class='glyphicon glyphicon-ok'></span><input type='hidden' value='"+id+"'></div>";
	}
	$(".paycheck-box").click(function(){
		var lia=$(".paycheck-box").index(this);
		if (lia==0) {
			loadItem("账上款");
		}else if (lia==1) {
			loadItem("预存款");
		}
	});
	//获取结算方式信息
	$(".paycheck-box:eq(0)").click();
	function loadItem(type){
		$(".paycheck-ctn:eq(1)").html("");
		pop_up_box.loadWait();
		$.get("getSettlementList.do",{"type":type},function(data){
			pop_up_box.loadWaitClose();
			$.each(data,function(i,n){
				$(".paycheck-ctn:eq(1)").append(loadItemName(n.settlement_sim_name,n.sort_id));
			});
			$(".paycheck-ctn:eq(1)").find(".paycheck-box:eq(0)").addClass("active");
			$(".paycheck-box").click(function(){
				$(this).parents(".paycheck-ctn").find(".paycheck-box").removeClass("active");
			    $(this).addClass("active");
			});
		});
	}
	//提交采购付款单
	$(".btn-info").click(function(){
		var account=$("#account").find(".active");
		var paystyle=$("#paystyle").find(".active>input");
		var zftl=$("#zftl").find(".active");
		var paystyletxt=$("#paystyle").find(".active");
		var corp_id=$.trim($("#corp_id").val());
		var corp_name=$.trim($(".sim-msg").find("li:eq(0)").html());
		var rejg_hw_no=$.trim($(".sim-msg").find("li:eq(1)").html());
		if(rejg_hw_no==""){
			pop_up_box.showMsg("请选择采购订单!");
		}else if (account.length<=0) {
			pop_up_box.showMsg("请选择付款账户类型!");
		}else if ($.trim(paystyle.val())=="") {
			pop_up_box.showMsg("请选择结算方式!");
		}else if ($.trim(zftl.text())=="") {
			pop_up_box.showMsg("请选择支付通路!");			
		}else if ($.trim(amount.val())==""||amount.val()=="0") {
			pop_up_box.showMsg("请输入付款金额!",function(){
				amount.focus().select();
			});
		}else{
			$("#info").show();
			$("#sure").click(function(){
					var clerk_id=$.trim($(this).parent().parent().find("#clerkId").val());
					var dept_id=$.trim($(this).parent().parent().find("#deptId").val());
					if(clerk_id==''||clerk_id==null){
						pop_up_box.showMsg("请选择经办人!");
						return;
					}else if(dept_id==''||dept_id==null){
						pop_up_box.showMsg("请选择经办部门!");
						return;
					}
					var params={
							"orderNo":$.trim(orderNo.val()),
							"amount":$.trim(amount.val()),
							"account":$.trim(account.text()),
							"paystyletxt":$.trim(paystyletxt.text()),
							"sum_si_origin":$.trim(zftl.text()),
							"customer_id":corp_id,
							"paystyle":$.trim(paystyle.val()),
							"customerName":corp_name,
							"rejg_hw_no":rejg_hw_no,
							"dept_id":dept_id,
							"clerk_id":clerk_id
					};
					$("#info").hide();
					pop_up_box.postWait();
					$.post("savePayProcurement.do",params,function(data){
						pop_up_box.loadWaitClose();
						$("#sure").unbind("click");
						if (data.success) {
							pop_up_box.showMsg("付款信息已录入,点击确定进入上传付款凭证!", function(){
								$(".modal-cover-first,.modal-first").show();
							})
						}else{
							pop_up_box.showMsg(data.msg);
						}
					});
			})
		}
	});
	$(".btn-default,.close").click(function(){
		$(".modal-cover-first,.modal-first").hide();
	});
	//PC端上传凭证
	$("#scpzpc").click(function(){
		var imgurl=$.trim($(".modal-body").find("#filepath").val());
		if(imgurl!=""){
			$.post("../weixin/certificateImg.do",{
				"imgurl":imgurl,
				"weixin":weixin,
				"orderNo":$.trim(orderNo.val())
			},function(data){
				$(".modal-cover-first,.modal-first").hide();
				if (data.success) {
					pop_up_box.showMsg("上传成功!");
				} else {
					if (data.msg) {
						pop_up_box.showMsg("上传错误!" + data.msg);
					} else {
						pop_up_box.showMsg("上传错误!");
					}
				}
			});
		}
	});
	//微信端上传凭证
	var weixin=0;///用于在保存图片的时候判断上传类型
	if (is_weixin()) {
		$("#scpz").show();
		$("#upload-btn").hide();
		weixinfileup.init();
		$("#scpz").click(function(){
			weixin=1;
			weixinfileup.chooseImage(this,function(imgurl){
				weixinfileup.uploadImage(imgurl,function(url){
					$.get("../weixin/getWeixinFwqImg.do",{"url":url,"orderNo":orderNo.val()},function(data){
						if (data.success) {
							pop_up_box.showMsg("上传成功!",function(){
								window.location.href="../customer.do";
							});
						} else {
							if (data.msg) {
								pop_up_box.showMsg("上传错误!" + data.msg);
							} else {
								pop_up_box.showMsg("上传错误!");
							}
						}
					});
					
				});
				$(".modal-body").find("img").attr("src",imgurl);
				$("#imgFile").val(imgurl);
			});
		});
	}else{
		$("#scpz").hide();
		$("#upload-btn").show();
	}
});
function imgUpload(t){
	if (is_weixin()) {
		weixinfileup.chooseImage(t,function(imgurl){
			$(".modal-body").find("img").attr("src",imgurl);
		});
	}else{
		ajaxUploadFile({
			"uploadUrl":"../upload/uploadImage.do?fileName=imgFile",
			"msgId":"",
			"fileId":"imgFile",
			"msg":"",
			"fid":"filepath",
			"uploadFileSize":10
		},t,function(imgurl){
			pop_up_box.loadWaitClose();
			$("#filepath").val(imgurl);
			$(".modal-body").find("img").attr("src",".."+imgurl);
		});
	}
	
}
function getAmount(){
	var st_auto_no=$.trim($(".sim-msg li:eq(1)").html());
	$.get("getCgAmountByNo.do",{
		"st_auto_no":st_auto_no
	},function(data){
		var dhAmount=$("input[name='dhAmount']");
		dhAmount.val(parseFloat(data).toFixed(2));
	})
}
function getYfAmount(){
	var st_auto_no=$.trim($(".sim-msg li:eq(1)").html());
	$.get("getYfAmountByNo.do",{
		"st_auto_no":st_auto_no
	},function(data){
		var sum_si=$("input[name='sum_si']");
		if(data){
			sum_si.val(parseFloat(data).toFixed(2));
		}else{
			sum_si.val(0);
		}
	})
}
