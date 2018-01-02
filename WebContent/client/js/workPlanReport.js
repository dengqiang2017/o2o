var workPlanReport={
		init:function(){}
}

var page=0;
var count=0;
var totalPage=0;
var descShowLen=25;
var now = new Date();
var nowStr = now.Format("yyyy-MM-dd"); 
var onedays=nowStr.split("-");
$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
$(".Wdate:eq(1)").val(nowStr);
//$(".btn-folding").click(function(){
//	var form=$("form");
//	if(form.is(":hidden")){
//		form.show();
//		$(this).text("隐藏搜索");
//	}else{
//		$(this).text("展开搜索");
//		form.hide();
//	}
//});
//if(!common.isPC()){
//	if($(".btn-folding").is(":hidden")){
//		$("form").show();
//	}else{
//		$("form").hide();
//	}
//}
$.get("../manager/getJSONArrayByFile.do",{
	"path":"planRet.json"
},function(data){
	if(data&&data.length>0){
		$("#planResult").html('<option value=""></option>');
		$.each(data,function(i,n){
			$("#planResult").append('<option value="'+n.val+'">'+n.val+'</option>');
		});
	}
});
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
		"beginDate":$("#d4311").val(),
		"endDate":$("#d4312").val(),
		"all":"all",
		"isBeginDate":false,
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
loadData();
$(".excel").click(function(){
	pop_up_box.loadWait();
	$.get("../client/getWorkPlanExcel.do",{
		"searchKey":$("#searchKey").val(),
		"beginDate":$("#d4311").val(),
		"endDate":$("#d4312").val(),
		"all":"all",
		"isBeginDate":false,
		"isEndDate":false,
		"planResult":$("#planResult").val()
	},function(data){
		pop_up_box.loadWaitClose();
		if(data.success){
			window.location.href=data.msg;
		}
	});
});