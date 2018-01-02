common.URLFiltering();
$(function(){
	var page=0;
	var count=0;
	var totalPage=0;
	$(".find").click(function(){
		page=0;
		count=0;
		$("#list").html("");
		loadData();	
	});
	var now = new Date();
	var nowStr = now.Format("yyyy-MM");
	$(".Wdate:eq(0)").val(nowStr+"-01");
	var nowStr = now.Format("yyyy-MM-dd");
	$(".Wdate:eq(1)").val(nowStr);
	var type=0;
	var com_id=getComId();
	function loadData(){
		pop_up_box.loadWait(); 
		$.get("../customer/collectionConfirmList.do",{
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val(),
			"comfirm_flag":$("#comfirm_flag").val(),
		},function(data){
			pop_up_box.loadWaitClose();
			if(data&&data.rows&&data.rows.length){
				$.each(data.rows,function(i,n){
					var item =$($("#item").html());
					$("#list").append(item);
					item.find("#date").html(n.finacial_d);
					item.find("#rcv_hw_no").html(n.rcv_hw_no);
					item.find("#no").html(n.recieved_id);
					item.find("#sort_id").html(n.sort_id);
					item.find("#je").html(n.sum_si);
					var b=true;
					if(n.img){//已上传图片
						item.find("#imgsrc").html(n.img+"?ver="+Math.random());
						b=false;
					}
					initBtnClick(item);
					if(n.comfirm_flag=="N"){
						item.find("#flag").html("未确认");
						initBtn(item);
					}else{
						item.find("#flag").html("已确认");
						item.find(".divider:eq(0)").remove();//移除第一个横线后,
						item.find(".divider:eq(0)").remove();//下一次移除还是从第一条开始
						item.find("#bullhorn").remove();
						item.find(".divider:eq(1)").remove();//下一次移除还是从第一条开始
						if(!b){//已经确认并且已上传图片的就不允许再次上传
							item.find(".divider:eq(0)").remove();
							item.find(".upload").remove();
						}
						item.find(".edit,#del").remove();
					}
				});
			}
			count=data.totalRecord;
			totalPage=data.totalPage;
		});
	}
	///加载结算方式到下拉选择中////
	$.get("../customer/getSettlementList.do",function(data){
		if(data&&data.length>0){
			$.each(data,function(i,n){
				$("#settlement").append("<option value='"+n.sort_id+"'>"+n.settlement_sim_name+"</option>");
			});
		}
	});
	function initBtnClick(item){
		item.find("#showimg").click(function(){//查看图片
			var img=$(this).parents(".dataitem").find("#imgsrc").html();
			if(img!=""){
				$(".modal img").attr("src",img);
				$(".modal").show();
			}else{
				pop_up_box.toast("没有上传支付凭证!",2000);
			}
		});
		item.find(".upload").click(function(){//上传图片
			$(".modal-first").show();
			$(".upload").removeClass("upload_active");
			$(this).addClass("upload_active");
			$(".modal-first .modal-title").html("上传支付凭证图片");
			$(".modal-first .modal-body").find(".form-group").show();
			$(".modal-first .modal-body").find(".form-group:eq(0),.form-group:eq(1)").hide();
			type=2;
			var img=$(this).parents(".dataitem").find("#imgsrc").html();
			if(img!=""){
				$(".modal-first .modal-body").find("img").attr("src",img);
			}else{
				$(".modal-first .modal-body").find("img").attr("src","images/paydef.jpg");
			}
		});
	}
	function initBtn(item){
		item.find(".edit").click(function(){
			$(".modal-first").show();
			$(".edit").removeClass("edit_active");
			$(this).addClass("edit_active");
			$(".modal-first .modal-title").html("编辑支付信息");
			$(".modal-first .modal-body").find(".form-group").show();
			$(".modal-first .modal-body").find(".form-group:eq(2)").hide();
			type=1;
			$(".modal-first .modal-body").find("#jeipt").val($(this).parents(".dataitem").find("#je").html());
			$(".modal-first .modal-body").find("#settlement").val($(this).parents(".dataitem").find("#sort_id").html());
		});
		item.find("#del").click(function(){
			if(confirm("是否删除该付款记录,删除后不能恢复!")){
				pop_up_box.postWait();
				var item=$(this).parents(".dataitem");
				var no=item.find("#no").html();
				$.post("../customer/delCollection.do",{
					"recieved_id":no
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.toast("删除成功!", 2000);
						item.remove();
					} else {
						if (data.msg) {
							pop_up_box.showMsg("提交错误!"
									+ data.msg);
						} else {
							pop_up_box.showMsg("提交错误!");
						}
					}
				});
			}
		});
		/////申请确认////
		item.find("#bullhorn").click(function(){
			pop_up_box.postWait();
			var item=$(this).parents(".dataitem");
			var recieved_id=item.find("#no").html();
			$.get("../weixin/noticeConfirm.do",{
				"title":"客户申请核实收款通知",
				"headship":"出纳",
				"orderNo":recieved_id
			},function(data){
				pop_up_box.toast("通知成功!", 2000);
				item.find("#bullhorn").remove();
			});
		});
	}
	$("#addPay").click(function(){
		$(".modal-first").show();
		$(".modal-first .modal-body").find(".form-group").show();
		$(".modal-first .modal-title").html("新增支付信息");
		$(".modal-first .modal-body").find("img").attr("src","images/paydef.jpg");
		$(".modal-first input").val("");
		type=0;
	});
	loadData();
	$(".btn-default,.close").click(function(){
		closeModal();
	});
	function closeModal(){
		$(".modal-first,.modal").hide();
		$(".upload").removeClass("upload_active");
		$(".edit").removeClass("edit_active");
	}
	///////修改保存///
	$("#save").click(function(){
		if(type==0){//新增
			addPayInfo();
		}else if(type==1){//保存编辑
			editsave();
		}else{//上传凭证
			uploadPingz();
		}
	});
	/////新增保存////
	function addPayInfo(){
		var je=$("#jeipt").val();
		if(je!=""){
			je=parseFloat(je);
			if(je>1){
				pop_up_box.postWait();
				var imgurl=$.trim($(".modal-first .modal-body").find("#filepath").val());
				var txt=$("#settlement").find("option:selected").text();
				var weixin=0;
				if (is_weixin()) {
					weixin=1;
				}
				$.post("../customer/savePaymoney.do",{
					"imgurl":imgurl,
					"weixin":weixin,
					"amount":je,
					"account":txt,
					"paystyle":$("#settlement").val(),
					"rcv_hw_no":$("#settlement").val(),
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						closeModal();
						pop_up_box.toast("保存成功!", 2000);
						var item =$($("#item").html());
						if($("#list .dataitem:eq(0)").length>0){
							$("#list .dataitem:eq(0)").before(item);
						}else{
							$("#list").append(item);
						}
						var now = new Date();
						var nowStr = now.Format("yyyy-MM-dd HH:mm");
						item.find("#date").html(nowStr);
						item.find("#rcv_hw_no").html(txt);
						item.find("#sort_id").html($("#settlement").val());
						item.find("#no").html(data.msg);
						item.find("#je").html(je);
						item.find("#flag").html("未确认");
						var b=true;
						if(imgurl!=""){//已上传图片
							item.find("#imgsrc").html("../"+com_id+"/"+data.msg+".jpg?ver="+Math.random());
							b=false;
						}
						initBtnClick(item);
						initBtn(item);
					} else {
						if (data.msg) {
							pop_up_box.showMsg("保存错误!" + data.msg);
						} else {
							pop_up_box.showMsg("保存错误!");
						}
					}
				});
			}else{
				pop_up_box.toast("支付金额必须大于1!", 1000);
			}
		}else{
			pop_up_box.toast("请输入支付金额!", 1000);
		}
	}
	/////修改保存///
	function editsave(){
		var je=$("#jeipt").val();
		if(je!=""){
			je=parseFloat(je);
			if(je>1){
				var item=$(".edit_active").parents(".dataitem");
				pop_up_box.postWait();
				$.post("../customer/saveEditPayInfo.do",{
					"sum_si":je,
					"recieved_id":item.find("#no").html(),
					"rcv_hw_no":$("#settlement").val(),
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						closeModal();
						pop_up_box.toast("保存成功!",2000);
						var txt=$("#settlement").find("option:selected").text();
						item.find("#je").html(je);
						item.find("#sort_id").html($("#settlement").val());
						item.find("#rcv_hw_no").html(txt);
					} else {
						if (data.msg) {
							pop_up_box.showMsg("保存错误!" + data.msg);
						} else {
							pop_up_box.showMsg("保存错误!");
						}
					}
				});
			}else{
				pop_up_box.toast("支付金额必须大于1!", 1000);
			}
		}else{
			pop_up_box.toast("请输入支付金额!", 1000);
		}
	}
	/////////上传支付凭证/////
	function uploadPingz(){
		var imgurl=$.trim($(".modal-first .modal-body").find("#filepath").val());
		if(imgurl!=""){
			var item=$(".upload_active").parents(".dataitem");
			$.post("../weixin/certificateImg.do",{
				"headship":"出纳",
				"imgurl":imgurl,
				"orderNo":item.find("#no").html()
			},function(data){
				$(".modal-first").hide();
				if (data.success) {
					closeModal();
					$("#filepath").val("");
					pop_up_box.toast("上传成功!",2000);
					item.find("#imgsrc").html(data.msg+"?ver="+Math.random());
				} else {
					if (data.msg) {
						pop_up_box.showMsg("上传错误!" + data.msg);
					} else {
						pop_up_box.showMsg("上传错误!");
					}
				}
			});
		}
	}
	var weixin=0;///用于在保存图片的时候判断上传类型
	if (is_weixin()) {
		$("#scpz").show();
		$("#upload-btn").hide();
		weixinfileup.init();
		$("#scpz").click(function(){
			weixin=1;
			weixinfileup.chooseImage(this,function(imgurl){
				weixinfileup.uploadImage(imgurl,function(url){
					if(type==2){//单独上传时候才执行
						var item=$(".upload_active").parents(".dataitem");
						$.get("../weixin/getWeixinFwqImg.do",{
							"url":url,
							"headship":"出纳",
							"orderNo":item.find("#no").html()
						},function(data){
							if (data.success) {
								closeModal();
								pop_up_box.toast("上传成功!",2000);
								item.find("#imgsrc").html(data.msg+"?ver="+Math.random());
							} else {
								if (data.msg) {
									pop_up_box.showMsg("上传错误!" + data.msg);
								} else {
									pop_up_box.showMsg("上传错误!");
								}
							}
						});
					}else{
						$("#filepath").val(url);
					}
				});
				$(".modal-first .modal-body").find("img").attr("src",imgurl);
				$("#imgFile").val(imgurl);
			});
		});
	}else{
		$("#scpz").hide();
		$("#upload-btn").show();
	}
	/////////////////////////上传凭证///end///////
	common.initNumInput();
	pop_up_box.loadScrollPage(function(){
		if (page==totalPage) {
		}else{
			page+=1;
			loadData(); 
		}
	});
});
function imgUpload(t){
	$(".modal-first .modal-body").find("img").attr("src","images/paydef.jpg");
	$("#filepath").val("");
	if (is_weixin()) {
		weixinfileup.chooseImage(t,function(imgurl){
//			$("#filepath").val(imgurl);
			$(".modal-first .modal-body").find("img").attr("src",imgurl);
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
			$(".modal-first .modal-body").find("img").attr("src",".."+imgurl);
		});
	}
	
}