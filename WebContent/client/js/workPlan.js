var clerk_id=getQueryString("clerk_id");
if(!clerk_id){
	clerk_id="";
}
WdatePicker({eCont:'databoxF',dateFmt:'yyyy-MM-dd' ,onpicked:function(dp){
    $('.demospan').text(dp.cal.getDateStr());
}});
WdatePicker({eCont:'databoxT',dateFmt:'yyyy-MM-dd', maxDate:'2120-10-01',onpicked:function(dp){
    $('.demospanT').text(dp.cal.getDateStr());
}});
$('.checked').click(function(){
    $("#mymodalT").modal("toggle");
});
$.get("../client/getEmployeeInfo.do",{
	"clerk_id":clerk_id
},function(data){
	$("#clerkName").html(data.clerk_name);
	$("#tel>a").html(data.user_id);
	if(!IsPC()){
		$("#tel>a").attr("href","tel:"+data.user_id);
	}
	$("#memo").html(data.c_memo);
	imgPath="001/userpic/"+data.clerk_id+"/Pic_You.png";
	if(data.weixin_img){
		$("#user_logo").attr("src",data.weixin_img);
	}else{
		$("#user_logo").attr("src","../"+imgPath+"?ver="+Math.random());
	}
});
$.get("../manager/getJSONArrayByFile.do",{
	"path":"planRet.json"
},function(data){
	if(data&&data.length>0){
		$("#planResult").html('<option value=""></option>');
		$(".modal-body #planResult").html('');
		$.each(data,function(i,n){
			$("#planResult").append('<option value="'+n.val+'">'+n.val+'</option>');
			$(".modal-body #planResult").append('<option value="'+n.val+'">'+n.val+'</option>');
		});
	}
});
////////////
var path="kouhao.txt";
$.get("../client/getJsonFile.do",{
	"path":path,
	"clerk_id":clerk_id
},function(data){
	if(data.success){
		$("#kouhao").val(data.msg);
	}
});
$("#kouhao").change(function(){
	pop_up_box.postWait();
	$.post("../client/saveJsonFile.do",{
		"path":path,
		"clerk_id":clerk_id,
		"json":$("#kouhao").val()
	},function(data){
		pop_up_box.loadWaitClose();
		if (data.success) {
			pop_up_box.toast("已保存!");
		} else {
			if (data.msg) {
				pop_up_box.showMsg("保存错误!" + data.msg);
			} else {
				pop_up_box.showMsg("保存错误!");
			}
		}
	});
});
//////////////
///获取跟进记录
var page=0;
var count=0;
var totalPage=0;
var descShowLen=15;
$(".find").click(function(){
	$("#mymodalT").modal("toggle");
});
$("#planResult").change(function(){
	page=0;
	count=0;
	loadData();
});
loadData();
var len=$("thead th").length;
function loadData(){
	if(totalPage<0){
		totalPage=0;
	}
	$("#page").html("第"+(page+1)+"页/共"+(totalPage+1)+"页");
	$("tbody").html("");
	pop_up_box.loadWait();
	$.get("../client/getWorkPlanPage.do",{
		"searchKey":$("#searchKey").val(),
		"beginDate":$("#beginDate").html(),
		"endDate":$("#endDate").html(),
		"clerk_id":clerk_id,
		"isEndDate":false,
		"planResult":$("#planResult").val(),
		"rows":20,
		"count":count,
		"page":page
	},function(data){
		pop_up_box.loadWaitClose();
		if (data.rows&&data.rows.length>0) {
			$.each(data.rows,function(xh,n){
				var tr=getTr(len);
				$("tbody").append(tr);
				for (var i = 0; i < len; i++) {
					var th=$($("thead th")[i]);
					var name=$.trim(th.attr("data-name"));
					var j=$("thead th").index(th);
					var show=th.css("display");
					if(show=="none"){
						tr.find("td:eq("+j+")").hide();
						tr.find("td:eq("+j+")").html(n[name]);
					}else{
						if(name=="xuhao"){
							tr.find("td:eq("+j+")").html(xh+1);
						}else if(name=="caozuo"){
							tr.find("td:eq("+j+")").html('<i class="fa fa-times-circle" aria-hidden="true"></i>');
							editplan(tr,j);
						}else if(name=="planContent"){
							tr.find("td:eq("+j+")").attr("title",n.planContent);
							if(n.planContent.length>descShowLen){
								tr.find("td:eq("+j+")").html(n.planContent.substr(0,descShowLen)+"...");
							}else{
								tr.find("td:eq("+j+")").html(n.planContent);
							}
						}else if(name=="planDescribe"){
							tr.find("td:eq("+j+")").attr("title",n.planDescribe);
							if(n.planDescribe.length>descShowLen){
								tr.find("td:eq("+j+")").html(n.planDescribe.substr(0,descShowLen)+"...");
							}else{
								tr.find("td:eq("+j+")").html(n.planDescribe);
							}
						}else{
							tr.find("td:eq("+j+")").html(n[name]);
						}
					}
				}
				delplan(tr,n.ivt_oper_listing);
			});
			$('.secition_list i').hover(function(){
		        $('.secition_list i').css({'color':'blue'});
		       $(this).css({'color':'#EA2000'})
		    });
		}
		totalPage=data.totalPage;
		count=data.totalRecord;
		if(totalPage<0){
			totalPage=0;
		}
		pageShow(totalPage);
	});
}
///增加
$('.pull-left i').click(function(){
	$("#editModal").modal("toggle");
	$("#fujian").html("");
	$(".modal #planTime").val("");
	$(".modal #planContent").val("");
	$(".modal #planResult").val("");
	$(".modal #planDescribe").val("");
	$(".modal #ivt_oper_listing").html("");
});
//修改
function editplan(item,k){
	item.find("td").not("td:eq("+k+")").click(function(){//编辑
		$("#editModal").modal("toggle");
		var tr=$(this).parents("tr");
		var j=$("thead th").index($("thead th[data-name='planContent']"));
		$(".modal #planContent").val(tr.find("td:eq("+j+")").attr("title"));
		j=$("thead th").index($("thead th[data-name='planTime']"));
		$(".modal #planTime").val(tr.find("td:eq("+j+")").html());
		j=$("thead th").index($("thead th[data-name='ivt_oper_listing']"));
		var ivt_oper_listing=tr.find("td:eq("+j+")").html();
		$(".modal #ivt_oper_listing").html(ivt_oper_listing);
		j=$("thead th").index($("thead th[data-name='planResult']"));
		$(".modal #planResult").val(tr.find("td:eq("+j+")").html());
		j=$("thead th").index($("thead th[data-name='planDescribe']"));
		$(".modal #planDescribe").val(tr.find("td:eq("+j+")").attr("title"));
		$("#fujian").html("");
		$.get("../client/getWorkPlanInfo.do",{
			"ivt_oper_listing":ivt_oper_listing,
			"clerk_id":clerk_id
		},function(data){
			if (data.urlList) {
				var urlList=$.parseJSON(data.urlList);
				for (var i = 0; i < urlList.length; i++) {
					addFujianItem(urlList[i].url,urlList[i].name);
				}
			}
		});
	});
}
function delplan(item,ivt_oper_listing){
	item.find("i").click({"ivt_oper_listing":ivt_oper_listing},function(event){//删除
		var t=this;
		if (confirm("是否要删除该记录!")) {
			$.post("../client/delWorkPlan.do",{
				"ivt_oper_listing":event.data.ivt_oper_listing
			},function(data){
				if (data.success) {
					pop_up_box.toast("删除成功!",1500);
					$(t).parents("tr").remove();
					xuhao();
				} else {
					if (data.msg) {
						pop_up_box.showMsg("删除错误!" + data.msg);
					} else {
						pop_up_box.showMsg("删除错误!");
					}
				}
			});
		}
	});
}
//$(window).scroll(function(){
//    if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height()-60)) {
//    		 page=page+1;
//    		 loadItem(); 
//    }
// }); 
///////////////////////
///保存工作记录
var now = new Date();
var nowStr = now.Format("yyyy-MM-dd"); 
$(".Wdate").val(nowStr);
$("#save").click(function(){
	var planContent=$.trim($(".modal #planContent").val());
	var planTime=$.trim($(".modal #planTime").val());
	if(planContent==""){
		pop_up_box.showMsg("请输入计划内容!", function(){
			$(".modal #planContent").focus();
		});
	}else if(planTime==""){
		pop_up_box.showMsg("请输入计划时间!");
	}else{
		var type=0;
		var ivt_oper_listing=$.trim($(".modal #ivt_oper_listing").html());
		var planResult=$.trim($(".modal #planResult").val());
		var planDescribe=$.trim($(".modal #planDescribe").val());
		if(ivt_oper_listing!=""){
			type=1;
		}
		pop_up_box.postWait();
		$.post("../client/saveWorkPlan.do",{
			"clerk_id":clerk_id,
			"planContent":planContent,
			"planResult":planResult,
			"planDescribe":planDescribe,
			"planTime":planTime,
			"ivt_oper_listing":ivt_oper_listing,
			"urlList":getFujian()
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.toast("保存成功!",1000);
				$("#editModal").modal("toggle");
				//数据回显
				 huixianData(type, len, data.msg, function(tr,name,j){
					 if(type==0){
						if(name=="caozuo"){
							editplan(tr,j);
						}
						delplan(tr,data.msg);
					}
				   if(name=="planContent"){
					   tr.find("td:eq("+j+")").attr("title",planContent);
					   if(planContent.length>descShowLen){
						   tr.find("td:eq("+j+")").html(planContent.substr(0,descShowLen)+"...");
					   }else{
						   tr.find("td:eq("+j+")").html(planContent);
					   }
					}else if(name=="planResult"){
						tr.find("td:eq("+j+")").html(planResult);
					}else if(name=="planDescribe"){
					 tr.find("td:eq("+j+")").attr("title",planDescribe);
					   if(planDescribe.length>descShowLen){
						   tr.find("td:eq("+j+")").html(planDescribe.substr(0,descShowLen)+"...");
					   }else{
						   tr.find("td:eq("+j+")").html(planDescribe);
					   }
					}else if(name=="planTime"){
						tr.find("td:eq("+j+")").html(planTime);
					}else if(name=="ivt_oper_listing"){
						tr.find("td:eq("+j+")").html(data.msg);
					}
				 });
				 ///////重新排序//////////////
				 xuhao();
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
//////////////
function imgUpload(t){
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImage.do?fileName=imgFile&fileNameNo=t&type="+Math.random(),
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":50
	},t,function(imgUrl){
		pop_up_box.loadWaitClose();
		addFujianItem(imgUrl,$("#imgFile").val());
	});
}