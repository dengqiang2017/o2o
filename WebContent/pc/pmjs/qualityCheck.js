$(function(){
	
	$(".glyphicon-menu-left:eq(1),.sczj").click(function(){
		$("#listpage").show();
		$("#qualityIn").hide();
	});
	
	$(".find").click(function(){
		pop_up_box.loadWait();
		$("tbody").html("");
		$.get("../pPlan/getQualityCheckList.do",{
			"status":$("#status").val(),
			"headship":"%质检%",
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val(),
			"searchKey":$.trim($("#searchKey").val())
		},function(data){
			pop_up_box.loadWaitClose();
			if(data&&data.length>0){
				$.each(data,function(i,n){
					var tr=getTr(7);
					$("tbody").append(tr);
					tr.find("td:eq(1)").html(n.PH);
					if(n.item_name){
						tr.find("td:eq(2)").html(n.item_name);
					}else{
						tr.find("td:eq(2)").html("定制产品");
					}
					tr.find("td:eq(3)").html(n.work_name);
					tr.find("td:eq(4)").html(n.clerk_name);
					tr.find("td:eq(5)").html(n.PGSL);
					tr.find("td:eq(0)").css("min-width","50px");
					tr.find("td:eq(6)").css("min-width","50px");
					if(n.status==2){
						tr.css("font-weight","bold");
						var td0=$('<div class="check center-block"></div>');
						var tdend=$('<button type="button" class="btn btn-primary" style="margin-right: 0">质检</button>');
						tr.find("td:eq(0)").append(td0);
						tr.find("td:eq(6)").append(tdend);
						tdend.click(n,function(event){
							$("#listpage").hide();
							$("#qualityIn").show();
							$("#qualityIn").find("input[data-num='num']").val("");
							$("#qualityIn").find("input[data-num='num']").focus();
							$("#qualityIn").find("#PH").html(event.data.PH);
							$("#qualityIn").find("#PGSL").html(event.data.PGSL);
							$("#qualityIn").find("#WGSL").html(event.data.WGSL);
							$("#qualityIn").find("#dzjsl").html(event.data.PGSL-event.data.WGSL);
							$("#qualityIn").find("#work_name").html(event.data.work_name);
							if(event.data.item_name){
								$("#qualityIn").find("#item_name").html(event.data.item_name);
							}else{
								$("#qualityIn").find("#item_name").html("定制产品");
							}
							$("#qualityIn").find("#clerk_name").html(event.data.clerk_name);
							$("#qualityIn").find("#plan_end_date").html(event.data.plan_end_date);
							$("#qualityIn").find(".center-block").unbind("click");
							
							if(event.data.detailc_memo){
								$("#qualityIn").find("#detailc_memo").html(event.data.detailc_memo);
							}else{
								$("#qualityIn").find("#detailc_memo").parent().hide();
							}
							if(event.data.memo_color){
								$("#qualityIn").find("#memo_color").html(event.data.memo_color);
							}else{
								$("#qualityIn").find("#memo_color").parent().hide();
							}
							if(event.data.memo_other){
								$("#qualityIn").find("#memo_other").html(event.data.memo_other);
							}else{
								$("#qualityIn").find("#memo_other").parent().hide();
							}
							if(event.data.c_memo){
								$("#qualityIn").find("#c_memo").html(event.data.c_memo);
							}else{
								$("#qualityIn").find("#c_memo").parent().hide();
							}
							
							var t=$(this).parents('tr');
							$("#qualityIn").find(".showgximg").click({"ivt_oper_listing":event.data.ivt_oper_listing,
								"work_id":event.data.work_id,"item_id":event.data.item_id},function(event){
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
							
							$("#qualityIn").find(".center-block").unbind("click");
							$("#qualityIn").find(".center-block").click(event.data,function(eventbtn){
								var num=$.trim($("#qualityIn").find("input").val());
								if(num==""||num=="0"){
									pop_up_box.showMsg("请输入质检通过数量!");
									return;
								}
								pop_up_box.postWait();
								eventbtn.data.num=num;
								eventbtn.data.status=1;
								eventbtn.data.title="生产派工通知";
								eventbtn.data.description="@comName-@clerkName：你有生产任务需要执行";
								eventbtn.data.title_check="生产质检结果通知";
								eventbtn.data.description_check="@comName-@clerkName：你有生产任务质检结果通知,本次质检合格数量:"+num+",剩余生产数量:@sysl";
								$.post("../pPlan/qualityChecked.do",eventbtn.data,function(data){
									pop_up_box.loadWaitClose();
									if (data.success) {
										pop_up_box.showMsg("提交成功!",function(){
											$("#listpage").show();
											$("#qualityIn").hide();
											t.remove();
										});
									} else {
										if (data.msg) {
											pop_up_box.showMsg("保存错误!"
													+ data.msg);
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
		});
	});
	$(".find:eq(0)").click();
	$("#qualityIn").find("input[data-num='num']").bind("input propertychange blur",function(){
		var val=$(this).val();//输入的质检数量
		var dzjsl=parseFloat($("#qualityIn").find("#dzjsl").html());//待质检数量
		if(val>dzjsl){
			$(this).val("");
			pop_up_box.showMsg("质检通过数量不能大于待质检数量!");
		}
	});
			
});