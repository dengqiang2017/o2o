/**
 * 上班签到查询
 */
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
	///////////////////
	function getFindTime(func){
		var begintime="";
		var endtime="";
		var type=$("#type").val();
		var modal=$(".modal-body");
		if(type=="1"){//早上上班时间
			begintime="07:00:00";
			endtime=modal.find("#morningBeginTime").val();//上午上班时间
		}else if(type=="2"){//上午迟到
			begintime=modal.find("#morningBeginTime").val();//上午上班时间
			endtime=modal.find("#morningLateTime").val();//上午迟到时间
		}else if(type=="3"){//上午早退
			begintime=modal.find("#morningLateTime").val();//上午迟到时间
			endtime=modal.find("#morningendTime").val();//上午下班时间
		}else if(type=="4"){//下午迟到
			begintime=modal.find("#afternoonBeginTime").val();//下午上班时间
			endtime=modal.find("#afternoonLateTime").val();//下午下班时间
		}else if(type=="5"){
			begintime=modal.find("#afternoonLateTime").val();//下午上班时间
			endtime=modal.find("#afternoonEndTime").val();//下午下班时间
		}
		func(begintime,endtime);
	}
//////////////////////////////////
	$(".excel").click(function(){//导出Excel
		var searchKey=$("#searchKey").val(); 
		pop_up_box.loadWait();
		var begintime="";
		var endtime="";
		getFindTime(function(b,e){
			begintime=b;
			endtime=e;
		});
		$.get("employeeSignExport.do",{
			"searchKey":searchKey,
			"datatype":"0",
			"beginDateS":$(".begindate").val(),
			"endDateS":$(".enddate").val(),
			"begintime":begintime,
			"endtime":endtime,
			"type":$("#type").val(),
			"page":page,
			"count":count,
			"dept_id":treeSelectId
		},function(data){
			pop_up_box.loadWaitClose();
			window.location.href=data.msg;
		});
	});
	$("#find").click(function(){
		page=0;
		count=0;
		$(".pull-left>span").html(1);
		loadData();
	});
	$("#parambtn").click(function(){
		$("#modal_smsSelect").show();
	});
	$("#modal_smsSelect .btn-default,#modal_smsSelect .close,.modal-first").click(function(){
		$("#modal_smsSelect").hide();
	});
	$.get("getSignFindParam.do",function(data){
		var modal=$(".modal-body");
		if(data){
			modal.find("#morningBeginTime").val(data.morningBeginTime);
			modal.find("#morningLateTime").val(data.morningLateTime);
			modal.find("#morningendTime").val(data.morningendTime);
			modal.find("#afternoonBeginTime").val(data.afternoonBeginTime);
			modal.find("#afternoonLateTime").val(data.afternoonLateTime);
			modal.find("#afternoonEndTime").val(data.afternoonEndTime);
		}
		$("#find").click();
	});
	$("#modal_smsSelect .btn-primary").click(function(){
		var modal=$(".modal-body");
		pop_up_box.postWait(); 
		var json=JSON.stringify({
			"morningBeginTime":modal.find("#morningBeginTime").val(),
			"morningLateTime":modal.find("#morningLateTime").val(),
			"morningendTime":modal.find("#morningendTime").val(),
			"afternoonBeginTime":modal.find("#afternoonBeginTime").val(),
			"afternoonLateTime":modal.find("#afternoonLateTime").val(),
			"afternoonEndTime":modal.find("#afternoonEndTime").val()
		});
		$.post("saveSignFindParam.do",{
			"param":json
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				$("#modal_smsSelect").hide();
				pop_up_box.toast("提交成功", 500);
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
	});
	function loadData(){
		var searchKey=$.trim($("#searchKey").val());
		var date=$(".Wdate").val();
		$("#page").val(page);
		pop_up_box.loadWait();  
		var begintime="";
		var endtime="";
		getFindTime(function(b,e){
			begintime=b;
			endtime=e;
		});
		$.get("getSignInfoList.do",{
			"searchKey":searchKey,
			"datatype":"0",
			"beginDateS":$(".begindate").val(),
			"endDateS":$(".enddate").val(),
			"begintime":begintime,
			"endtime":endtime,
			"type":$("#type").val(),
			"page":page,
			"count":count,
			"dept_id":treeSelectId
		},function(data){
			pop_up_box.loadWaitClose();
			$("tbody").html("");
			$.each(data.rows,function(i,n){
				var tr=getTr(8);
				$("tbody").append(tr);
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
					}else{
						tr.find("td:eq("+j+")").html(n[name]);
					}
				}
				tr.click({"clerk_id":$.trim(n.clerk_id),"date":n.signDate,"longitude":n.longitude,"latitude":n.latitude},function(event){
					if(event.data.latitude){
						$("#container").show();
						codeLatLng(event.data.latitude,event.data.longitude);
						loadLogImg(event.data.clerk_id,event.data.date);
					}else{
						$("#container").hide();
					}
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
				$("#img").html("");
					$.each(data.imgs,function(i,n){
						$("#img").append("<a href='../pc/image-view.html?"+n
								+"' target='_blank'><img src='"+n+"' style='width: 200px;height: 200px;'></a>");
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
	init();
}); 

var geocoder,map, marker = null;
var init = function() {
    var center = new qq.maps.LatLng(30.6256, 104.04276);
    map = new qq.maps.Map(document.getElementById('container'),{
        center: center,
        zoomLevel: 16,
        zoom: 16
    });
    geocoder = new qq.maps.Geocoder();
}

function codeLatLng(lat,lng) {
	init();
    //获取输入框的经纬度
    var latLng = new qq.maps.LatLng(lat, lng);
    //对指定经纬度进行解析
    geocoder.getAddress(latLng);
    //设置服务请求成功的回调函数
    geocoder.setComplete(function(result) {
        map.setCenter(result.detail.location);
        var marker = new qq.maps.Marker({
            map: map,
            position: result.detail.location
        });
        //点击Marker会弹出反查结果
        var info = new qq.maps.InfoWindow({
            map: map
        });
        qq.maps.event.addListener(marker, 'click', function() {
            info.open();
            info.setContent('<div style="width:280px;height:100px;">' +
                result.detail.address + '</div>');
            info.setPosition(result.detail.location);
        });
    });
    //若服务请求失败，则运行以下函数
    geocoder.setError(function() {
        alert("出错了，请输入正确的经纬度！");
    });

}
