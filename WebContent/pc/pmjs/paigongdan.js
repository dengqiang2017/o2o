$(function(){
	var itemhtml=$("#item");
	var page=0;
	var count=0;
	var totalPage=0;
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	var onedays=nowStr.split("-");
	$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
	$(".Wdate:eq(1)").val(nowStr); 
	function loadData(){
		pop_up_box.loadWait();
		$.get("../pPlan/getWorkerProductionList.do",{
			"searchKey":$.trim($("#searchKey").val()),
			"beginDate":$(".Wdate:eq(0)").val(),
			"status":$("#status").val(),
			"endDate":$(".Wdate:eq(1)").val()			
		},function(data){
			pop_up_box.loadWaitClose();
			count=data.totalRecord;
			totalPage=data.totalPage;
			if(data&&data.rows.length>0){
				addindex=0;
				$.each(data.rows,function(i,n){
					var item=$(itemhtml.html());
					$(".container").append(item);
					item.find("#PH").html(n.PH);
					item.find("#PGSL").html(n.PGSL);
					item.find("#WGSL").html(n.WGSL);
					item.find("#dzjsl").html(n.PGSL-n.WGSL);
					item.find("#clerk_name").html(n.clerk_name);
					if(n.plan_end_date){
						var now = new Date(n.plan_end_date);
						var nowStr = now.Format("yyyy-MM-dd hh:mm"); 
						item.find("#plan_end_date").html(nowStr);
					}
					if(n.JJSJ){
						var now = new Date(n.JJSJ);
						var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
						item.find("#JJSJ").html(nowStr);
					}
					if(n.item_name){
						item.find("#item_name").html(n.item_name);
					}else{
						item.find("#item_name").html("定制产品");
					}
					if(n.detailc_memo){
						item.find("#detailc_memo").html(n.detailc_memo);
					}else{
						item.find("#detailc_memo").parent().hide();
					}
					if(n.memo_color){
						item.find("#memo_color").html(n.memo_color);
					}else{
						item.find("#memo_color").parent().hide();
					}
					if(n.memo_other){
						item.find("#memo_other").html(n.memo_other);
					}else{
						item.find("#memo_other").parent().hide();
					}
					if(n.c_memo){
						item.find("#c_memo").html(n.c_memo);
					}else{
						item.find("#c_memo").parent().hide();
					}
					item.find("#work_name").html(n.work_name);
					if(n.status==0){//未开始生产
						item.find(".kssc").show();
					}else if(n.status==1){//生产中
						item.find(".scz").show();
						item.find(".tqzj").show();
					}else if(n.status==2){//质检中
						item.find(".scz").html("质检中...");
						item.find(".scz").show();
					}else if(n.status==3){//已完成
						item.find(".scz").html("已完成");
						item.find(".scz").show();
					}else{
						item.find(".scz").html("未到该工序请等待!");
						item.find(".scz").show();
					}
					item.find(".showgximg").click({"ivt_oper_listing":n.ivt_oper_listing,
						"work_id":n.work_id,"item_id":n.item_id},function(event){
						$.get("../pPlan/getWorkImg.do",event.data,function(dataimg){
							if(dataimg.length>0){
								$("#imshow").html("");
								$.each(dataimg,function(im,nm){
									$("#imshow").append("<img style='display: none;' src='.."+nm+"'>");
								});
								$("#imshow").find("img:eq(0)").show();
								$(".image-zhezhao").show();
							}else{
								pop_up_box.showMsg("没有图纸!");
							}
						});
					});
					//开始生产
					item.find(".kssc").click({"ivt_oper_listing":n.ivt_oper_listing,"work_id":n.work_id,"item_id":n.item_id,"PH":n.PH},function(event){
						pop_up_box.postWait();
						event.data.status=1;
						$.get("../pPlan/beginProduction.do",event.data,function(data){
							pop_up_box.loadWaitClose();
							if (data.success) {
								pop_up_box.toast("提交成功!",500);
								item.find(".scz").show();
								item.find(".tqzj").show();
								item.find(".kssc").hide();
							} else {
								if (data.msg) {
									pop_up_box.showMsg("保存错误!" + data.msg);
								} else {
									pop_up_box.showMsg("保存错误!");
								}
							}
						});
					});
					//提请质检
					item.find(".tqzj").click({"ivt_oper_listing":n.ivt_oper_listing,
						"work_id":n.work_id,"item_id":n.item_id,
						"work_name":n.work_name,"PH":n.PH,
						"working_procedure_section":n.working_procedure_section
					},function(event){
						pop_up_box.postWait();
						event.data.title="生产现场流程质检通知";
						event.data.headship="质检";
						event.data.status=2;
						event.data.working_procedure_section=event.data.working_procedure_section;
						event.data.description="@comName-"+event.data.work_name+"-@clerkName：你有产品流程质检需要处理";
						$.get("../pPlan/noticeQualityCheck.do",event.data,function(data){
							pop_up_box.loadWaitClose();
							if (data.success) {
								pop_up_box.toast("提交成功!",500);
								item.find(".scz").html("质检中...");
								item.find(".tqzj").hide();
							} else {
								if (data.msg) {
									pop_up_box.showMsg("保存错误!" + data.msg);
								} else {
									pop_up_box.showMsg("保存错误!");
								}
							}
						});
					});
				});
			}
		});
	}
	$(".find").click(function(){
		page=0;
		$(".container").html("");
		loadData();
	});
	$("#status").change(function(){
		$(".find").click();
	});
	loadData();
	var addindex=0;
	$(window).scroll(function(){
		if (addindex==0) {
			if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
				addindex=1;
				if (page==totalPage) {
				}else{
					pop_up_box.loadWait();
					page+=1;
					 loadData();
				}
			}
		}
     });
	var index=0;
	$(".img-left").unbind("click");
	$(".img-left").click(function(){
		index=index-1;
		if(index<0){
			index=len-1;
		}
		$("#imshow").find("img").hide();
		$("#imshow").find("img:eq("+index+")").show();
	});
	$(".img-right").unbind("click");
	$(".img-right").click(function(){
		index=index+1;
		if(index>=len){
			index=0;
		}
		$("#imshow").find("img").hide();
		$("#imshow").find("img:eq("+index+")").show();
	});
	$("#closeimgshow,.image-zhezhao,#imshow img").click(function(){
		$(".image-zhezhao").hide();
	});
});