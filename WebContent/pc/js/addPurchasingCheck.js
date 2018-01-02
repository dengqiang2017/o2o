$(function() {
	//修改
	$("#editInitialProcurement").click(function(){
		var ivt_num_detail=$(".active_table #ivt_num_detail").val();
		pop_up_box.loadWait();
		$.get("",{
			"ivt_num_detail":ivt_num_detail
		},function(data){
			pop_up_box.loadWaitClose();
			$.each(data.rows,function(i,n){
				$("#itemId").val(n.item_id);
				$("#item_name").html(n.item_name);
				$("#deptId").val(n.dept_id);
				$("#dept_name").html(n.dept_name);
				$("#clerkId").val(n.clerk_id);
				$("#clerk_name").html(n.clerk_name);
			});
			$("#addWareInit").show();
		});
	});
	//删除
	$("#delInitialProcurement").click(function(){
		if (window.confirm("是否删除该条记录?")){
			var ivt_num_detail=$(".active_table #ivt_num_detail").val();
			pop_up_box.postWait();
			$.post("../manager/delClient.do",{"ivt_num_detail":ivt_num_detail,"type":"inventory"},
				function(data){
				pop_up_box.loadWaitClose();
				if (data.success){
					pop_up_box.showmsg("删除成功!",function(){
						$("form>input").val("");
						window.location.href="purchasingCheck.do";
					});
				}else{
					pop_up_box.showMsg(data.msg);
				}
			});
		}
	});
	//搜索
	$(".find").click(function(){
		$.get("",{
			"searchKey":$.trim($("#searchKey").val()),
		},function(data){
			pop_up_box.loadWaitClose();
			$("tbody").html("");
			$.each(data.rows,function(i,n){
				var ul=getTr(n);
				$("tbody").append(ul);
			});
		});
	});
	//1.首页
	$("#beginpage").click(function(){
		$("#page").val("0");
		loadData($("#page").val());
	});
	//2.尾页
	$("#endpage").click(function(){
		$("#page").val($("#totalPage").val());
		loadData($("#totalPage").val());
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
		var  totalpage=$("#totalPage").val();
		var  page=$("#page").val();
		  page=parseInt(page)+1;
		if (page<=totalpage){
			$("#page").val(page);
			loadData(page);
		}else{
			pop_up_box.showMsg("已到最后一页!");
		}
	});
	//打开新增采购入库页面
	$("#addProcurement").click(function(){
//		$.cookie("backshowfind",JSON.stringify(getParamsBack()));
		window.location.href="addStorage.do";
	});
//	var backparams=$.cookie("backshowfind");
//	if (backparams&&backparams!="null") {
//		backparams=$.parseJSON(backparams);
//		$("#page").val(backparams.page);
//			if (backparams.item_name!=""||backparams.item_type!=""||backparams.type_name!=""||backparams.easy_id!="") {
//				pop_up_box.loadWait();
//				$.get("getProductList.do",{
//					"searchKey":$("#searchKey").val(),
//					"page":backparams.page,
//					"ver":Math.random()
//				},function(data){
//					pop_up_box.loadWaitClose();
//					$("tbody").html("");
//					$.each(data.rows,function(i,n){
//						$("tbody").append(getTr(n));
//					});
//					$("#totalPage").val(data.totalPage);
//					$(".pull-left .form-control").val(data.totalRecord);
//					selectTr();
//					treeSelectId="";
//				});
//			}else if (backparams.treeId!="") {
//					o2o.clickGetTable("getProductList.do?page="+backparams.page,treeId, function(n){
//						return getTr(n);
//					});
//			}else{
//				pop_up_box.loadWait();
//				$.get("getProductList.do",{
//					"page":backparams.page,
//					"ver":Math.random()
//				},function(data){
//					pop_up_box.loadWaitClose();
//					$("tbody").html("");
//					$.each(data.rows,function(i,n){
//						$("tbody").append(getTr(n));
//					});
//					$("#totalPage").val(data.totalPage);$(".pull-left .form-control").val(data.totalRecord);
//					selectTr();
//					treeSelectId="";
//				});
//			}
//		 
//	}
//	$.cookie("backshowfind",null); 
}); 
