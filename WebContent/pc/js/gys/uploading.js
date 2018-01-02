$(function(){
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".date_box>span").html(nowStr);
	$(".btn-default").click(function(){
		$(".modal-cover-first,.modal-first").hide();
	});
	$(".body>ul").html("");
	$.get("getSupplierItemList.do",{
		"beginDate":nowStr,
		"endDate":nowStr
	},function(data){
		if(data&&data.length>0){
			$.each(data,function(i,n){
				var item=$($("#item").html());
				$(".body>ul").append(item);
				item.find("#item_name").html(n.item_name);
				item.find("#num").html(numformat2(n.num));
				item.find(".item_unit").html(n.item_unit);
				if(n.ware_num){
					item.find("input[type='number']").eq(0).val(numformat2(n.ware_num));
				}
				if(n.price){
					item.find("input[type='number']").eq(1).val(numformat2(n.price));
				}
				if(n.imgs&&n.imgs.length>0){
					item.find(".img-responsive").attr("src",n.imgs[0]);
				}
				if(n.m_flag==0){///0-验证中,1-验证通过,2验证失败,
					item.find("#mflag").addClass("po_img02");
					item.find(".btn_a").hide();
				}else if(n.m_flag==1){
					item.find("#mflag").addClass("po_img");
					item.find(".btn_a").html("重新上报提交");
				}else if(n.m_flag==2){
					item.find("#mflag").addClass("po_img03");
					item.find(".btn_a").html("重新上报提交");
				}else{
					item.find("#mflag").removeClass("po_img");
					item.find("#mflag").removeClass("po_img02");
					item.find("#mflag").removeClass("po_img03");
					item.find(".btn_a").html("确认并上报");
				}
				item.find("#upload-btn").click(function(){
					$(".modal-cover-first,.modal-first").show();
					var p=$(this).parents("li");
					$(".modal-first #scpzpc").unbind("click");
					$(".modal-first #scpzpc").click(function(){
						p.find("#filepath").html($(".modal-body").find("#filepath").html());
						p.find(".img-responsive").attr("src",$(".modal-body").find("img").attr("src"));
						$(".modal-cover-first,.modal-first").hide();
					});
				});
				item.find(".btn_a").click({"item_id":n.item_id,"item_name":n.item_name,"item_unit":n.item_unit},function(event){
					var p=$(this).parents("li");
					var t=$(this);
					var num=$.trim(p.find("input[type='number']").eq(0).val());
					var price=$.trim(p.find("input[type='number']").eq(1).val());
					if(num==""){
						pop_up_box.showMsg("请输入库存数量!",function(){
							p.find("input[type='number']").eq(0).focus();
						});
					}else if(price==""){
						pop_up_box.showMsg("请输入价格!",function(){
							p.find("input[type='number']").eq(1).focus();
						});
					}else{
						pop_up_box.postWait();
						$.post("saveUpPrice.do",{
							"item_id":event.data.item_id,
							"price":price,
							"ware_num":num,
							"imgUrl":p.find("#filepath").html(),
							"title":"供应商上报产品单价库存信息通知",
							"description":"@comName-@Eheadship-@clerkName:供应商【@gysName】已经上报【"+event.data.item_name+"】价格库存相关信息,价格:"+price+"元,库存:"+num+event.data.item_unit+",请点击进入系统进行查看",
							"headship":"采购"
						},function(data){
							pop_up_box.loadWaitClose();
							if (data.success) {
								pop_up_box.showMsg("提交成功!");
								p.find("#mflag").removeClass("po_img");
								p.find("#mflag").removeClass("po_img02");
								p.find("#mflag").removeClass("po_img03");
								p.find("#mflag").addClass("po_img02");
								t.hide();
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
		}
	});
	/////////////////////////////////
	var weixin=0;///用于在保存图片的时候判断上传类型
	if (is_weixin()) {
		$("#sctx").show();
		$(".modal-body #upload-btn").hide();
		weixinfileup.init();
		$("#sctx").click(function(){
			pop_up_box.loadWait();
			var imgPath="/temp/gys/product/"+new Date().getTime()+".jpg";
			weixinfileup.imguploadToWeixin(this, imgPath, undefined,function(){
				pop_up_box.loadWaitClose();
				$(".modal-body").find("img").attr("src",".."+imgPath);
				$(".modal-body").find("#filepath").html(imgPath);
			});
		});
	}else{
		$("#sctx").hide();
		$(".modal-body #upload-btn").show();
	}
	
});
function imgUpload(t,name){
	if (is_weixin()) {
		weixinfileup.chooseImage(t,function(imgurl){
			$(".modal-body").find("#filepath").html(imgurl);
			$(".modal-body").find("img").attr("src",imgurl);
		});
	}else{
		ajaxUploadFile({
			"uploadUrl":"../upload/uploadImage.do?fileName=imgFile",
			"msgId":"",
			"fileId":"imgFile",
			"msg":"",
			"fid":"",
			"uploadFileSize":50
		},t,function(imgurl){
			pop_up_box.loadWaitClose();
			$(".modal-body").find("img").attr("src",".."+imgurl);
			$(".modal-body").find("#filepath").html(imgurl);
		});
	}
}