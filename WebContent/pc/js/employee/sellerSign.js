/**
 * 业务员签到查询
 */
var imgPath="";
$(function(){
	///////////////////响应树形相关///////////// 
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".begindate").val(nowStr); 
	$(".begintime").val("08:00:00"); 
	$(".enddate").val(nowStr);
	$(".endtime").val("19:30:00");
	var leftcover=$(".left-hide-ctn,.cover");
	var page=0;
	var count=0;
	var totalPage=0;
	$("#treeAll").click(function(){
		page=0;
		$(".pull-left>span").html(1);
		loadData();
	});
	try {
		o2o.next_tree("dept",function(n){
			return treeli(n.dept_name,n.sort_id);
		},undefined,function(treeId){
			treeSelectId=treeId;
			page=0;count=0;
			loadData();
		});
		if ($(".tree ul").find("ul li span").length==1) {
		$(".tree ul").find("ul li span").click();
		} 
	} catch (e) {}
//////////////////////////////////
	$(".excel").click(function(){//导出Excel
		var searchKey=$("#searchKey").val(); 
		pop_up_box.loadWait();
		$.get("employeeSignExport.do",{
			"searchKey":searchKey,
			"datatype":"1",
			"beginDateS":$(".begindate").val(),
			"endDateS":$(".enddate").val(),
			"begintime":$(".begintime").val(),
			"endtime":$(".endtime").val(),
			"type":$("#type").val(),
			"page":page,
			"count":count,
			"dept_id":treeSelectId
		},function(data){
			pop_up_box.loadWaitClose();
			window.location.href=data.msg;
		});
	});
	$("#modal_smsSelect .btn-default,#modal_smsSelect .close").click(function(){
		$("#modal_smsSelect input").val("");
		$("#modal_smsSelect").hide();
	});
	$("#rizhidialog .btn-default,#rizhidialog .close").click(function(){
		$("#rizhidialog").hide();
	});
	$("#find").click(function(){
		page=0;
		count=0;
		$(".pull-left>span").html(1);
		loadData();
	});
	$("#find").click();
	function loadData(){
		var searchKey=$.trim($("#searchKey").val());
		var date=$(".Wdate").val();
		$("#page").val(page);
		pop_up_box.loadWait();  
		$.get("getSignInfoList.do",{
			"searchKey":searchKey,
			"datatype":"1",
			"type":$("#type").val(),
			"beginDateS":$(".begindate").val(),
			"endDateS":$(".enddate").val(),
			"begintime":$(".begintime").val(),
			"endtime":$(".endtime").val(),
			"page":page,
			"count":count,
			"yewuyuan":"业务员",
			"dept_id":treeSelectId
		},function(data){
			pop_up_box.loadWaitClose();
			$("tbody:eq(0)").html("");
			$.each(data.rows,function(i,n){
				var tr=getTr(12);
				$("tbody:eq(0)").append(tr);
				var signTime="";
				for (var i = 0; i < $("th").length; i++) {
					var th=$($("th")[i]);
					var name=th.attr("data-name");
					var j=$("th").index(th);
					if(name=="signTime"){
						if(n.signTime&&n.signTime!=""){
							signTime=n.signTime.split(" ")[1]; 
						}
						tr.find("td:eq("+j+")").html(signTime);
					}else if(name=="customer_id"){
						if(n.seeds_id){
							var sleectCustomer=$('<span>'+n.corp_sim_name+'</span><button class="btn btn-primary" type="button">选择</button>');
							tr.find("td:eq("+j+")").html(sleectCustomer);
							tr.find("td:eq("+j+")>button").click({"seeds_id":n.seeds_id,"customer_id":$.trim(n.customer_id)},function(event){
								var t=$(this);
								pop_up_box.loadWait(); 
								$.get("../manager/getClientTree.do",function(data){
									pop_up_box.loadWaitClose();
									$("body").append(data);
									client.init(function(){
										treeSelectId=$.trim(treeSelectId);
										if(event.data.customer_id!=treeSelectId){
											$.post("../employee/updateSignInfo.do",{
												"seeds_id":event.data.seeds_id,
												"customer_id":treeSelectId
											},function(data){
												pop_up_box.toast("提交成功!", 500);
												$(".modal,.modal-cover").remove();
												treeSelectId="";
											});
											t.parent().find("span").html(treeSelectName);
										}
									});
								});
							});
						}
					}else if(name=="rizhi"){
						if(n.seeds_id){
							aname="下载模板";
							if(n.rizhipath.indexOf("20")>=0){
								aname="下载日志";
							}
							var muban=$('<a  class="btn btn-primary" href="..'+n.rizhipath+'" target="_blank">'+aname+'</a>');
							
							var uprizi=$('<button class="btn btn-primary" type="button">上传</button>');
							tr.find("td:eq("+j+")").html(muban);
							tr.find("td:eq("+j+")").append(uprizi);
							uprizi.click({"clerk_id":$.trim(n.clerk_id),"com_id":$.trim(n.com_id),"seeds_id":n.seeds_id,"signDate":n.signDate},function(event){
								imgPath="/"+event.data.com_id+"/rizhi/"+event.data.clerk_id+"/"+event.data.signDate+"_"+event.data.seeds_id+"_业务人员拜访日志.xlsx";
								$("#rizhidialog,#rizhidialog .modal-first").show();
							});
						}
					}else if(name=="pingfen"){
						tr.find("td:eq("+j+")").html(n[name]);
						if($.trim($("#pingfen").html())!=""){
							tr.find("td:eq("+j+")").click({"seeds_id":n.seeds_id},function(event){
								var t=$(this);
								var val=$.trim(t.html());
								$("#modal_smsSelect").show();
								$("#modal_smsSelect input").val(val).select();
								$("#modal_smsSelect .btn-primary").unbind("click");
								$("#modal_smsSelect .btn-primary").click(function(){
									var v=$("#modal_smsSelect input").val();
									if(v!=""&&v!=val){
										$.post("../employee/updateSignInfo.do",{
											"pingfen":v,
											"seeds_id":event.data.seeds_id
										},function(data){
											pop_up_box.toast("提交成功!", 500);
										});
									}
									t.html(v);
									$("#modal_smsSelect input").val("");
									$("#modal_smsSelect").hide();
//								var len=$(".table-responsive:eq(2) tbody:eq(0) tr").length-1;
//								$(".table-responsive:eq(2) tbody:eq(0) tr:eq("+len+")").find("td:eq(2)").html(getSumNum(len,index, 2));
								});
							});
						}
					}else{
						tr.find("td:eq("+j+")").html(n[name]);
					}
				}
				tr.click({"clerk_id":$.trim(n.clerk_id),"signDate":n.signDate},function(event){
					var signDate=event.data.signDate;
					$.get("sginedList.do",{"clerk_id":event.data.clerk_id,
						"datatype":"1",
						"type":$("#type").val(),
						"beginDateS":signDate,//$(".begindate").val(),
						"endDateS":signDate,//$(".enddate").val(),
						"begintime":$(".begintime").val(),
						"endtime":$(".endtime").val()
					},function(data){
						if(data&&data.length>0){
							$("#container").show();
							$("#img").html("");
							sellerinit(data);
							var date="";
							var clerk_id=data[0].clerk_id;
//							$.each(data,function(i,n){
//								if(date.indexOf(n.signDate)<0){
//									date=date+","+n.signDate;
//								}
//							});
//							var dates=date.split(",");
							$("#img").html("");
//							for (var i = 0; i < dates.length; i++) {
//								if(dates[i]!=""){
//									loadLogImg(clerk_id,dates[i]);
//								}
//							}
							loadLogImg(clerk_id,signDate);
						}else{
							$("#img").html("");
							$("#container").hide();
							pop_up_box.toast("无数据!",500);
						}
					});
				});
			});
			selectTr();
			count=data.totalRecord;
			totalPage=data.totalPage;
			$("#totalPage").html(data.totalPage);
			$(".pull-left>span").html(data.totalRecord);
		});
	}
	$("textarea").val("");
	$("#img").html("");
	function loadLogImg(clerk_id,date){
			$.get("showSignInfo.do",{
				"clerk_id":clerk_id,
				"date":date
			},function(data){
				$("textarea").val("");
					$.each(data.imgs,function(i,n){
						var time=n.split("/");
						time=time[time.length-1];
						$("#img").append("<div><a href='../pc/image-view.html?"+n
								+"' target='_blank'><img src='"+n+"' style='width: 200px;height: 200px;'></a><br><span>"+time+"</span></div>");
					});
			});
	}
	//1.首页
	$("#beginpage").click(function(){
		page=0;
		loadData();
	});
	//2.尾页
	$("#endpage").click(function(){
		page=totalPage;
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
	$("#nextpage").click(function(){
		  page=parseInt(page)+1;
		if (page<=totalPage) {
			loadData();
		}else{
			pop_up_box.showMsg("已到最后一页!");
		}
	});
	////////////////////////////////
}); 
//////////////////////////////////
var geocoder,map, marker = null;
var sellerinit = function(data) {
	var center = new qq.maps.LatLng(30.694260,104.01430);  
	  map = new qq.maps.Map(document.getElementById("container"), {
	    center: center,
	    zoom: 12
	});  
	  if(data&&data.length>0){
		for (var i = 0; i < data.length; i++) {
			latlngs=new qq.maps.LatLng(parseFloat(data[i].latitude),parseFloat(data[i].longitude));
				var dianinfo='<div style="width:280px;height:100px;">' +data[i].c_memo+"<br>地址:"+
				data[i].address+'<br>时间:'+data[i].signTime + '</div>';
				(function(n){
					var info = new qq.maps.InfoWindow({
						map: map  
					});
					var marker = new qq.maps.Marker({
						position: latlngs, 
						animation:qq.maps.MarkerAnimation.DROP,
						map: map 
					}); 
					info.open();
					info.setContent(dianinfo); 
					info.setPosition(latlngs); 
					qq.maps.event.addListener(marker, 'click', function() {
						info.open(); 
					}); 
				})(i); 
		}
	  } 
	}
function imgUpload(t){
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImageZs.do?fileName=imgFile&imgPath="+imgPath,
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"filepath",
		"uploadFileSize":10
	},t,function(imgurl){
		pop_up_box.loadWaitClose(); 
		pop_up_box.showMsg("上传成功!");
		$("#rizhidialog").hide();
	});
}
///////////////////////////////