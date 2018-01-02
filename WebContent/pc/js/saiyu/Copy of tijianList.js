var customer_id="";
$(function(){
	selectClient.init(function(customerId) {
		customer_id=customerId;
		$(".find:eq(0)").click();
		$(".center-block").attr("src","");
	},"../employee/");
	tijian.init();
	$("#c-msg").click();
});

var  tijian={
		loadData:function(page,func){
			var searchKey=$("#searchKey").val();
			pop_up_box.loadWait();
			$.get("getCustomerTijian.do",{
				"searchKey":searchKey,
				"page":page,
				"customer_id": customer_id//$("#customerId").val()
			},function(data){
				$("tbody").html("");
				pop_up_box.loadWaitClose();
				$.each(data.rows,function(i,n){
					var item=getTr(11);
					$("tbody").append(item);
					item.find("td:eq(0)").html("<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='editClient(this);'>修改</button>" +
							"<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='delClient(this);'>删除</button>" +
							"<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='guanlianProduct(this);'>推荐产品</button>");
					item.find("td:eq(1)").html("<input type='hidden' value='"+ifnull(n.ivt_oper_listing)+"'>"+n.position_big);
					item.find("td:eq(2)").html(n.position);
					item.find("td:eq(3)").html(n.item_brand);
					item.find("td:eq(4)").html(n.item_name);
					item.find("td:eq(5)").html(n.item_standard);
					item.find("td:eq(6)").html(n.item_color);
					item.find("td:eq(7)").html(n.item_num);
					item.find("td:eq(8)").html(n.c_memo);
					item.find("td:eq(9)").html(n.sd_order_id);
					item.find("td:eq(10)").html(n.ivt_oper_listing);
				});
				$("tbody tr").removeClass('activeTable');
				$("tbody tr").unbind("click");
				$("tbody tr").click(function(){
					$("tbody tr").removeClass('activeTable');
					$(this).addClass('activeTable');
					$(".center-block").attr("src","");
					 $.get("getTijianImg.do",{
						 "ivt_oper_listing":$(this).find("input").val()
					 },function(data){
						 if(data){
							 $.each(data,function(i,n){
								 $(".center-block").eq(i).attr("src",n); 
							 });
						 }
					 });
				});
				$("#totalPage").html(data.totalPage);$(".pull-left .form-control").val(data.totalRecord);
				if (func) {
					func();
				}
			});
		},
		init:function(){
			$(".find").click(function(){
				loadData(0);
			});
			$(".find:eq(0)").click();
			function loadData(page){
				tijian.loadData(page);
			}
			//1.首页
			$("#beginpage").click(function(){
				$("#page").val("0");
				loadData($("#page").val());
			});
			//2.尾页
			$("#endpage").click(function(){
				$("#page").val($("#totalPage").html());
				loadData($("#totalPage").html());
			});
			$("#uppage").click(function(){
				var page=$("#page").val();
				page=parseInt(page)-1;
				if (page>=0) {
					$("#page").val(page);
					loadData(page);
				}else{
					pop_up_box.showMsg("已到第一页!");
				}
			});
			$("#nextpage").click(function(){
				var  totalpage=$("#totalPage").html();
				var  page=$("#page").val();
				  page=parseInt(page)+1;
				if (page<=totalpage) {
					$("#page").val(page);
					loadData(page);
				}else{
					pop_up_box.showMsg("已到最后一页!");
				}
			});
			$("#addTijian").click(function(){
				if(customer_id){
					getEditHtml("","tijianEdit.do");
				}else{
					pop_up_box.showMsg("请选择客户!");
				}
			});
		}
}
function editClient(t){
	var tr=$(t).parents("tr");
	var ivt_oper_listing=tr.find("input").val();
	getEditHtml(ivt_oper_listing,"tijianEdit.do");
}
function guanlianProduct(t){
	 $.get("../tree/productSelect.do",function(data){
		   pop_up_box.loadWaitClose();
		   $("body").append(data);
		   product.init(function(){
			   $("#item_id").val($(".modal").find("tr.activeTable").find("td:eq(0)>input").val());
			   $("#item_id_name").html($(".modal").find("tr.activeTable").find("td:eq(0)").text());
		   });
	   });
}

function getEditHtml(ivt_oper_listing,url){
	if (!ivt_oper_listing) {
		ivt_oper_listing="";
	}
	$.get(url,{
		"customer_id":customer_id,
		"ivt_oper_listing":ivt_oper_listing
	},function(data){
		$("#listpage").hide();
		$("#editpage").html(data);
		tijianEdit.init();
	});
}
function delClient(t){
	var tr=$(t).parents("tr");
	if (window.confirm("是否要删除该记录?")) {
		var ivt_oper_listing=tr.find("input:eq(0)").val();
		$.post("tijiandel.do",{"customer_id":customer_id,"ivt_oper_listing":ivt_oper_listing},function(data){
			if (data.success) {
				tr.remove();
			}else{
				pop_up_box.showMsg(data.msg);
			}
		});
	}
}

function imgImport(t,key){
	pop_up_box.postWait(); 
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName="+key,
		"msgId":"msg",
		"fileId":key,
		"msg":"",
		"fid":"",
		"uploadFileSize":1000
	},t,function(imgurl){
		pop_up_box.loadWaitClose(); 
		$.get("saveTijianImg.do",{"path":imgurl},function(data){
			if (data.success) {
				pop_up_box.showMsg("图片导入成功!");
			} else {
				if (data.msg) {
					pop_up_box.showMsg("图片导入错误!" + data.msg);
				} else {
					pop_up_box.showMsg("图片导入错误!");
				}
			}
		});
	});
}
