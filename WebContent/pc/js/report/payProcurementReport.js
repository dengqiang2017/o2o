$(function() {
	choiceSupplier.init(function(corpId) {
		$("#corp_id").val(corpId);
		loadData();
	});
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
	//调用jquery插件打印图片
	$("#print").click(function(){
		$("#imshow").jqprint();
	});
	if($(".folding-btn").css("display")=="none"){
		$("#gzform").show();
	}else{
		$("#gzform").hide();
	}
	var page=0;
	var totalPage=0;
	var count=0;
	$("tbody").html("");
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd");
	$(".Wdate:eq(1)").val(nowStr);
	$(".find").click(function(){
		loadData();
	})
	function loadData(){
		var tbody=$("tbody");
		tbody.html("");
		pop_up_box.loadWait();
//		var searchKey=$(".form-control input-sm").val();
		var beginDate=$.trim($("#gzform").find(".Wdate:eq(0)").val());
		var endDate=$.trim($("#gzform").find(".Wdate:eq(1)").val());
		var customer_id=$.trim($("#corp_id").val());
		$.get("getPaymentSheet.do",{
//			"searchKey":searchKey,
			"beginDate":beginDate,
			"endDate":endDate,
			"customer_id":customer_id,
			"page":page,
			"count":count
		},function(data){
			pop_up_box.loadWaitClose();
			if (data&&data.rows) {
				$.each(data.rows,function(i,n){
					var tr=getTr(9);
					tbody.append(tr); 
					tr.find("td:eq(0)").html(n.recieved_auto_id);
					tr.find("td:eq(1)").html(n.corp_name);
					tr.find("td:eq(2)").html(n.movtel);
					tr.find("td:eq(3)").html(n.finacial_d);
					tr.find("td:eq(4)").html(n.sum_si);
					tr.find("td:eq(5)").html(n.sum_si_origin);
					tr.find("td:eq(6)").html(n.dept_name);
					tr.find("td:eq(7)").html(n.clerk_name);
					tr.find("td:eq(8)").html('<button type="button" class="btn btn-danger">查看凭证</button>');
					tr.find("td:eq(8)").find(".btn-danger").click({"imgpath":n.imgpath},function(event){
						pop_up_box.showImg(event.data.imgpath);
//						var orderNo=$.trim($(this).parents("tr").find("td:eq(0)").html());
//						var len=0;
//						$.get("../employee/getCertificateImg.do",{
//							"orderNo":orderNo
//						},function(data){
//							if(data){
//								$(".image-zhezhao").show();
//								$("#imshow").html("");
//								for (var i = 0; i < data.length; i++) {
//									$("#imshow").append("<img src='../"+data[i]+"' class='center-block'>");
//								}
//							$("#imshow").find("img:eq(0)").show();
//							len=data.length;
//							}else{
//								pop_up_box.showMsg("未上传凭证!");
//							}
//						});
//						$("#closeimgshow").click(function(){
//							$(".image-zhezhao").hide();
//						});
					});
					totalPage=data.totalPage;
					count=data.totalRecord;
					$("#page").html("当前页:"+page);
					})
				}
			})
		}
		$(".btn-default").click(function(){
			$(this).parents("input-group").find("span.input-sm").html("");
			$(this).parents("input-group").find("input.input-sm").val("");
		});
		$("#onePage").click(function(){
			page=0;
			loadData();
		});
		$("#uppage").click(function(){
			page=parseInt(page)-1;
			if (page>=0) {
				loadData();
			}else{
				pop_up_box.showMsg("已到第一页!");
			}
		});
		$("#nextPage").click(function(){
			page=parseInt(page)+1;
			if (page<=totalPage) {
				loadData();
			}else{
				pop_up_box.showMsg("已到最后一页!");
			}
		});
		$("#endPage").click(function(){
			page=totalPage;
			loadData();
		});
});

