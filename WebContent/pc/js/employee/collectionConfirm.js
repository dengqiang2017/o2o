var customer_id;
$(function(){
	collection.init();
	var url=window.location.href.split("?");
/////////////
	var isAutoFind=$("#isAutoFind").val();
	///////////
	if (isAutoFind=="true"&&url&&url.length>1) {
		if ("id"==url[1].split("&")[0].split("=")[0]) {
			customer_id=url[1].split("&")[0].split("=")[1];
			$(".sim-msg>li:eq(0)").html(decodeURI(url[1].split("&")[1].split("=")[1]));
			$(".sim-msg>li:eq(1)").html(url[1].split("&")[2].split("=")[1]);
			$("#seekh").hide();
		}else{
			customer_id="";
			if(url[1].split("=").length>0){
			}else{
				$("input[name='searchKey']").val(decode(url[1]));
			}
			$(".sim-table").hide();
		}
		selectClient.init(function(customerId) {},"../employee/");
		$(".find:eq(0)").click();
		$(".header-back").attr("href","orderTracking.do");
	}else{
		selectClient.init(function(customerId) {
			customer_id=customerId;
			$(".find:eq(0)").click();
		},"../employee/");
		$(".find:eq(0)").click();
	}
	$("#print").click(function(){
		$("#imshow").jqprint();
	});
});
var collection={
		countgz:0,
		totalgz:0,
		init:function(){
//			///从1号到当天
//			var now = new Date();
//			var nowStr = now.Format("yyyy-MM-dd"); 
//			var onedays=nowStr.split("-");
//			$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
//			$(".Wdate:eq(1)").val(nowStr); 
//			//结算方式选择
//			selectTree.settlement();
			var pagegz=0;
			
			expandClient.init();
			$(".find").click(function(){
				$("#customer_id").val(customer_id);
				pagegz=1;
				collection.countgz=0;
				collection.totalgz=0;
				collection.loadData();
			});
			$(".btn-default,.close").click(function(){
				$(".modal").hide();
			});
			//////////////////////////
			$("#modal_smsSelect").find(".btn-primary").click(function(){
				$("#modal_smsSelect").hide();
				var checks=$(".checkedbox");
				var list=[];
				for (var i = 0; i < checks.length; i++) {
					var item=$(checks[i]);
					var seeds_id=item.find("input").val();
					var customer_id=item.parents("tr").find("span:eq(1)").html();
					var corp_sim_name=item.parents("tr").find("lable").html();
					var recieved_id=item.parents("tr").find("td:eq(7)").html();
					var settlement_id=item.parents("tr").find("#settlement_id").html();
					var sum_si_origin=item.parents("tr").find("#sum_si_origin").val();
					var sum_si=item.parents("tr").find("input[data-num]").val();
					var time=item.parents("tr").find("td:eq(2)").html();
//					var c_memo=item.parents("tr").find("td:eq(8)").html();
					var json={};
					json.seeds_id=seeds_id;
					json.customer_id=customer_id;
					json.corp_sim_name=corp_sim_name;
					json.sum_si=sum_si;
					json.recieved_id=recieved_id;
					json.sum_si_origin=sum_si_origin;
					json.settlement_id=settlement_id;
					json.time=time;
//					json.c_memo=c_memo;
					json.confirm="Y";
					list.push(JSON.stringify(json));
				}
				$.get("collConfirm.do",{
					"NoticeStyle":$("input[name='NoticeStyle']:checked").val(),
					"list":"["+list+"]"
				},function(data){
					if (!data.success) {
						pop_up_box.showMsg("操作错误!"+data.msg);
					}else{
//						window.location.href="../employee.do";
						$(".find:eq(0)").click();
					}
				});
			});
			$("#qrsk").click(function(){
				var checks=$(".checkedbox");
				if(checks&&checks.length>0){
					$("#modal_smsSelect").show();
					$("#modal_smsSelect .modal-cover-first").show();
					$("#modal_smsSelect .modal-first").show();
				}else{
					pop_up_box.showMsg("请至少选择一项数据!");
				}
			});
			///////////////////////////////////////////
			var handleindex=0;
			$("#houyun_Select,#modal_smsSelect").find(".btn-default,.close").click(function(){
				$("#modal_smsSelect,#houyun_Select").hide();
				handleindex =0;
			});
			
			///////////////////////////////////////////
			$("#onePage").click(function(){
				pagegz=1;
				var page="?page=1&count="+collection.countgz;
				collection.loadData(page);
			});
			$("#uppage").click(function(){
				if (pagegz>1) {
					pagegz=pagegz+1;
					var page="?page="+pagegz+"&count="+collection.countgz;
					collection.loadData(page);
				}else{
					pop_up_box.showMsg("已到第一页");
				}
			});
			$("#nextPage").click(function(){
				if (pagegz<collection.totalgz) {
					pagegz=pagegz+1;
					var page="?page="+pagegz+"&count="+collection.countgz;
					collection.loadData(page);
				}else{
					pop_up_box.showMsg("已到最后一页");
				}
			});
			$("#endPage").click(function(){
				pagegz=collection.totalgz;
				var page="?page="+collection.totalgz+"&count="+collection.countgz;
				collection.loadData(page);
			});
			///////////////////

		},showimg:function(t){
			var orderNo=$.trim($(t).parents("tr").find("td:eq(7)").html());
			var len=0;
			$.get("getCertificateImg.do",{
				"orderNo":orderNo
			},function(data){
				if(data){
//					$(".image-zhezhao").show();
//					$("#imshow").html("");
					$(".imgshow").show();
					for (var i = 0; i < data.length; i++) {
						$(".imgshow img").attr("src",data[i]);
//						$("#imshow").append("<img src='../"+data[i]+"' class='center-block'>");
					}
//				$("#imshow").find("img:eq(0)").show();
//				len=data.length;
				}else{
					pop_up_box.showMsg("未上传凭证!");
				}
			});
//			var index=0;
//			$(".img-left").unbind("click");
//			$(".img-left").click(function(){
//				index=index-1;
//				if(index<0){
//					index=len-1;
//				}
//				$("#imshow").find("img").hide();
//				$("#imshow").find("img:eq("+index+")").show();
//			});
//			$(".img-right").unbind("click");
//			$(".img-right").click(function(){
//				index=index+1;
//				if(index>=len){
//					index=0;
//				}
//				$("#imshow").find("img").hide();
//				$("#imshow").find("img:eq("+index+")").show();
//			});
			$("#closeimgshow").click(function(){
				$(".image-zhezhao").hide();
			});
		},loadData:function(page){
			if (!page) {
				page="";
			}
			pop_up_box.loadWait(); 
			$("tbody:eq(0)").html("");
			$.get("collectionConfirmList.do"+page,$("form").serialize(),function(data){
				pop_up_box.loadWaitClose();
				$.each(data.rows,function(i,n){
					var tr=getTr(12);
					$("tbody:eq(0)").append(tr);
					tr.find("td:eq(1)").html('<button type="button" class="btn btn-danger" onclick="collection.showimg(this);">查看</button>');
					if($("#qrsk").length>0){
						tr.find("td:eq(1)").append('<button type="button" class="btn btn-danger" onclick="collection.uploadImg(this);">上传</button>');
					}
//					tr.find("td:eq(1)").hide();
//					$("th:eq(1)").hide();
					if (n.comfirm_flag=="Y") {
						tr.find("td:eq(0)").html('款项已到账');
					}else{
						tr.find("td:eq(0)").html('<div class="checkbox" style="margin-left: 0px; margin-top: 15px;"><input type="hidden" value="'+n.seeds_id
								+'"></div><span style="margin-left: 30px;float: left;margin-top: -26px;">款项确认</span>');
					}
					if (n.finacial_d) {
						tr.find("td:eq(2)").html(n.finacial_d.split(".")[0]);
					}
					tr.find("td:eq(3)").html("<lable>"+n.corp_sim_name+"</lable><span style='display: none;'>"+n.customer_id+"</span>");
					tr.find("td:eq(4)").html(numformat2(n.sum_si));
					tr.find("td:eq(5)").html("<input value='"+numformat2(n.sum_si)+"' data-num='num2' type='tel'>");
					tr.find("td:eq(6)").html("<span>"+n.settlement_sim_name+"</span>");
					tr.find("td:eq(6)").append('<button type="button" class="btn btn-danger">更改</button>');
					tr.find("td:eq(7)").html(n.recieved_id);
					tr.find("td:eq(8)").html("<input id='sum_si_origin' value='"+n.rcv_hw_no+"'>");//支付方式
					tr.find("td:eq(9)").html(n.dept_sim_name);
					tr.find("td:eq(10)").html(n.clerk_name);
					tr.find("td:eq(9)").hide();
					tr.find("td:eq(10)").hide();
					tr.find("td:eq(11)").html(n.c_memo);
					tr.find("td:eq(11)").hide();
					tr.find("td:eq(12)").hide();
					$("th:eq(11)").hide();
					$("th:eq(12)").hide();
//					tr.find("td:eq(10)").html("<a href='../user/showFile.do?url="+n.recievedPath+"' >查看摘要</a>");
//					tr.click(function(){
//						var b=$(this).find(".checkbox").hasClass("checkedbox");
//						if (b) {
//							$(this).find(".checkbox").removeClass("checkedbox");
//						}else{
//							$(this).find(".checkbox").addClass("checkedbox");
//						}
//					});
					tr.find("td:eq(6)>button").click(function(){
						var t=$(this);
						pop_up_box.loadWait(); 
						 $.get("../tree/getDeptTree.do",{"type":"settlement"},function(data){
							   pop_up_box.loadWaitClose();
							 $("body").append(data);
							 settlement.init(function(){
								 t.parent().find("span").html(treeSelectName+"<span style='display: none;' id='settlement_id'>"+treeSelectId+"</span>");
						     });
					   });
					});
				});
				initNumInput();
				setcheckbox();
				collection.countgz=data.totalRecord;
				collection.totalgz=data.totalPage; 
			});
		},uploadImg:function(t){
			var orderNo=$.trim($(t).parents("tr").find("td:eq(7)").html());
			$(".modal-cover-first,.modal-first").show();
			$(".btn-default,.close").click(function(){
				$(".modal-cover-first,.modal-first").hide();
			});
			///上传完成确定PC端的时候使用
			$("#scpzpc").unbind("click");
			$("#scpzpc").click(function(){
				var imgurl=$.trim($(".modal-body").find("#filepath").val());
				if(imgurl!=""){
					$.post("../weixin/certificateImg.do",{
						"imgurl":imgurl,
						"weixin":weixin,
						"orderNo":orderNo
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
			var weixin=0;///用于在保存图片的时候判断上传类型
			if (is_weixin()) {
				$("#scpz").show();
				$("#upload-btn").hide();
				weixinfileup.init();
				$("#scpz").unbind("click");
				$("#scpz").click(function(){
					weixin=1;
					weixinfileup.chooseImage(this,function(imgurl){
						weixinfileup.uploadImage(imgurl,function(url){
							$.get("../weixin/getWeixinFwqImg.do",{"url":url,"orderNo":orderNo},function(data){
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
							
						});
						$(".modal-body").find("img").attr("src",imgurl);
						$("#imgFile").val(imgurl);
					});
				});
			}else{
				$("#scpz").hide();
				$("#upload-btn").show();
			}
		}
}
function imgUpload(t){
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
