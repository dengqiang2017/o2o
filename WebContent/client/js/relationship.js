var customer_id=getQueryString("customer_id");
if(!customer_id){
	pop_up_box.showMsg("请先选择客户!", function(){
		window.location.href="clientList.jsp";
	});
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
$(".zj>a").attr("href","footmark.html?customer_id="+customer_id);
//1.获取客户基本信息
$.get("../manager/getCustomerInfo.do",{
	"id":customer_id
},function(data){
	$("#clerk_name").html(data.corp_sim_name);
	$("#movtel>a").html(data.movtel);
	if (!IsPC()) {
		$("#movtel>a").attr("href","tel:"+data.movtel);
	}
	$("#memo").html(data.c_memo);
	imgPath="001/userpic/"+data.customer_id+"/Pic_You.png";
	if(data.weixin_img){
		$("#user_logo").attr("src",data.weixin_img);
	}else{
		$("#user_logo").attr("src","../"+imgPath+"?ver="+Math.random());
	}
	try {
		if(!data.corp_sim_name||parseInt(data.corp_sim_name)>0){
			$("#corp_sim_name").val(data.weixin_name);
			$("#clerk_name").html(data.weixin_name);
		}
	} catch (e) {}
	$(".news>a").attr("href","send.html?weixinID="+$.trim(data.weixinID)+"&name="+$.trim($("#clerk_name").html())+"&customer_id="+customer_id);
});
$.get("../manager/getJSONArrayByFile.do",{
	"path":"callonRet.json"
},function(data){
	if(data&&data.length>0){
		$("#visitResult").html('<option value=""></option>');
		$(".modal-body #visitResult").html('');
		$.each(data,function(i,n){
			$("#visitResult").append('<option value="'+n.val+'">'+n.val+'</option>');
			$(".modal-body #visitResult").append('<option value="'+n.val+'">'+n.val+'</option>');
		});
	}
});
///获取跟进记录
var page=0;
var count=0;
var totalPage=0;
var descShowLen=25;
$(".find").click(function(){
	$("#mymodalT").modal("toggle");
});
$("#visitResult").change(function(){
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
	$.get("../client/getVisitPage.do",{
		"searchKey":$("#searchKey").val(),
		"beginDate":$("#beginDate").html(),
		"endDate":$("#endDate").html(),
		"customer_id":customer_id,
		"visitResult":$("#visitResult").val(),
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
							editvisit(tr,j);
						}else if(name=="visitContent"){
							tr.find("td:eq("+j+")").attr("title",n.visitContent);
							if(n.visitContent.length>descShowLen){
								tr.find("td:eq("+j+")").html(n.visitContent.substr(0,descShowLen)+"...");
							}else{
								tr.find("td:eq("+j+")").html(n.visitContent);
							}
						}else{
							tr.find("td:eq("+j+")").html(n[name]);
						}
					}
				}
				delvisit(tr,n.ivt_oper_listing);
			});
			$('.secition_list i').hover(function(){
		        $('.secition_list i').css({'color':'blue'});
		       $(this).css({'color':'#EA2000'})
		    });
		}
		totalPage=data.totalPage;
		count=data.totalRecord;
		pageShow(totalPage);
		if(totalPage<0){
			totalPage=0;
		}
	});
}
$('.pull-left i').click(function(){
	$("#editModal").modal("toggle");
	$("#fujian").html("");
	$(".modal #visitTime").val("");
	$(".modal #visitContent").val("");
	$(".modal #visitResult").val("");
	$(".modal #visitDescribe").val("");
	$(".modal #ivt_oper_listing").html("");
});
function editvisit(item,k){
	item.find("td").not("td:eq("+k+")").click(function(){//编辑
		$("#editModal").modal("toggle");
		var tr=$(this).parents("tr");
		var j=$("thead th").index($("thead th[data-name='visitContent']"));
		$(".modal #visitContent").val(tr.find("td:eq("+j+")").attr("title"));
		j=$("thead th").index($("thead th[data-name='visitTime']"));
		$(".modal #visitTime").val(tr.find("td:eq("+j+")").html());
		j=$("thead th").index($("thead th[data-name='ivt_oper_listing']"));
		var ivt_oper_listing=tr.find("td:eq("+j+")").html();
		$(".modal #ivt_oper_listing").html(ivt_oper_listing);
		j=$("thead th").index($("thead th[data-name='visitResult']"));
		$(".modal #visitResult").val(tr.find("td:eq("+j+")").html());
		j=$("thead th").index($("thead th[data-name='visitDescribe']"));
		$(".modal #visitDescribe").val(tr.find("td:eq("+j+")").html());
		$("#fujian").html("");
		$.get("../client/getVisitInfo.do",{
			"ivt_oper_listing":ivt_oper_listing,
			"customer_id":customer_id
		},function(data){
			if (data.urlList) {
				var urlList=$.parseJSON(data.urlList);
				for (var i = 0; i < urlList.length; i++) {
					var url=urlList[i];
					addFujianItem(urlList[i].url,urlList[i].name);
				}
			}
		});
	});
}
function delvisit(item,ivt_oper_listing){
	item.find("i").click({"ivt_oper_listing":ivt_oper_listing},function(event){//删除
		var t=this;
		if (confirm("是否要删除该记录!")) {
			$.post("../client/delVisit.do",{
				"ivt_oper_listing":event.data.ivt_oper_listing
			},function(data){
				if (data.success) {
					pop_up_box.toast("删除成功!");
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
///跟进结构标准化设置
///保存拜访记录
var now = new Date();
var nowStr = now.Format("yyyy-MM-dd hh:mm"); 
$(".Wdate").val(nowStr);
$("#save").click(function(){
	var visitContent=$.trim($(".modal #visitContent").val());
	var visitTime=$.trim($(".modal #visitTime").val());
	if(visitContent==""){
		pop_up_box.showMsg("请输入拜访内容描述!", function(){
			$(".modal #visitContent").focus();
		});
	}else if(visitTime==""){
		pop_up_box.showMsg("请输入拜访时间!");
	}else{
		var type=0;
		var ivt_oper_listing=$.trim($(".modal #ivt_oper_listing").html());
		var visitResult=$.trim($(".modal #visitResult").val());
		if(ivt_oper_listing!=""){
			type=1;
		}
		pop_up_box.postWait();
		$.post("../client/saveVisitInfo.do",{
			"customer_id":customer_id,
			"visitContent":visitContent,
			"visitResult":visitResult,
			"visitTime":visitTime,
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
							editvisit(tr,j);
						}
						delvisit(tr,data.msg);
					}
				   if(name=="visitContent"){
					   if(visitContent.length>descShowLen){
						   tr.find("td:eq("+j+")").html(visitContent.substr(0,descShowLen)+"...");
					   }else{
						   tr.find("td:eq("+j+")").html(visitContent);
					   }
					   tr.find("td:eq("+j+")").attr("title",visitContent);
					}else if(name=="visitResult"){
						tr.find("td:eq("+j+")").html(visitResult);
					}else if(name=="visitDescribe"){
//						tr.find("td:eq("+j+")").html(visitDescribe);
					}else if(name=="visitTime"){
						tr.find("td:eq("+j+")").html(visitTime);
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