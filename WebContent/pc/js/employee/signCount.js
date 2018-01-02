$(function(){
	///////////////////响应树形相关///////////// 
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	var onedays=nowStr.split("-");
	$(".begindate").val(onedays[0]+"-"+onedays[1]+"-01"); 
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
	$("#find").click(function(){
		loadData();
	});
	$("#parambtn").click(function(){
		$("#modal_smsSelect").show();
	});
	$("#modal_smsSelect .btn-default,#modal_smsSelect .close,.modal-first").click(function(){
		$("#modal_smsSelect").hide();
	});
	$("#modal_smsSelect .btn-primary").click(function(){
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
	$(".print").click(function(){
		$("#print").jqprint();
	});
	var time6="19:30:00";
	function loadData(){
		var searchKey=$.trim($("#searchKey").val());
		var date=$(".Wdate").val();
		pop_up_box.loadWait();  
		var time1="07:00:00";
		var modal=$(".modal-body");
		var time2=modal.find("#morningBeginTime").val();//上午上班时间
		var time3=modal.find("#morningLateTime").val();//上午迟到时间
		var time4=modal.find("#afternoonBeginTime").val();//下午上班时间
		var time5=modal.find("#afternoonEndTime").val();//下午下班时间
		$.get("getSignInfoCount.do",{
			"searchKey":searchKey,
			"beginDateS":$(".begindate").val(),
			"endDateS":$(".enddate").val(),
			"time1":time1,
			"time2":time2,
			"time3":time3,
			"time4":time4,
			"time5":time5,
			"time6":time6,
			"dept_id":treeSelectId
		},function(data){
			pop_up_box.loadWaitClose();
			$("tbody").html("");
			$.each(data,function(i,n){
				var b=$("tbody td:contains("+n.clerk_name+")");
				if(b&&b.length>0){
					var tr=b.parent();
					if(n.name=="全部签到"){
						var k=$("th").index($("th[data-name='全部签到']"));
						tr.find("td:eq("+k+")").html(n.num);
					}else if(n.name=="正常签到"){
						var k=$("th").index($("th[data-name='正常签到']"));
						tr.find("td:eq("+k+")").html(n.num);
					}else if(n.name=="上午迟到"){
						var k=$("th").index($("th[data-name='上午迟到']"));
						tr.find("td:eq("+k+")").html(n.num);
					}else if(n.name=="下午签到"){
						var k=$("th").index($("th[data-name='下午签到']"));
						tr.find("td:eq("+k+")").html(n.num);
					}else if(n.name=="未签到"){
						var k=$("th").index($("th[data-name='未签到']"));
						tr.find("td:eq("+k+")").html(n.num);
					}else if(n.name=="下班正常签到"){
						var k=$("th").index($("th[data-name='下班正常签到']"));
						tr.find("td:eq("+k+")").html(n.num);
					}
				}else{
					var tr=getTr($("th").length);
					$("tbody").append(tr);
					for (var i = 0; i < $("th").length; i++) {
						var th=$($("th")[i]);
						var name=th.attr("data-name");
						var j=$("th").index(th);
						tr.find("td:eq("+j+")").html(n[name]);
					}
					if(n.name=="全部签到"){
						var k=$("th").index($("th[data-name='全部签到']"));
						tr.find("td:eq("+k+")").html(n.num);
					}else if(n.name=="正常签到"){
						var k=$("th").index($("th[data-name='正常签到']"));
						tr.find("td:eq("+k+")").html(n.num);
					}else if(n.name=="上午迟到"){
						var k=$("th").index($("th[data-name='上午迟到']"));
						tr.find("td:eq("+k+")").html(n.num);
					}else if(n.name=="下午签到"){
						var k=$("th").index($("th[data-name='下午签到']"));
						tr.find("td:eq("+k+")").html(n.num);
					}else if(n.name=="未签到"){
						var k=$("th").index($("th[data-name='未签到']"));
						tr.find("td:eq("+k+")").html(n.num);
					}else if(n.name=="下班正常签到"){
						var k=$("th").index($("th[data-name='下班正常签到']"));
						tr.find("td:eq("+k+")").html(n.num);
					}
				}
			});
			//计算早退
			var trs=$("tbody tr");
			var zc=$("th").index($("th[data-name='正常签到']"));
			var cd=$("th").index($("th[data-name='上午迟到']"));
			var xw=$("th").index($("th[data-name='下午签到']"));
			var xbzc=$("th").index($("th[data-name='下班正常签到']"));
			var zt=$("th").index($("th[data-name='早退']"));
			for (var i = 0; i < trs.length; i++) {
				var tr=$(trs[i]);
				var zcs=parseInt(isnull0(tr.find("td").eq(zc).html())); 
				var cds=parseInt(isnull0(tr.find("td").eq(cd).html()));
				var xws=parseInt(isnull0(tr.find("td").eq(xw).html()));
				var xbzcs=parseInt(isnull0(tr.find("td").eq(xbzc).html()));
				var zts=zcs+cds+xws-xbzcs;
				tr.find("td").eq(zt).html(zts);
			}
			selectTr();
		});
	}
}); 
////////////////////////
function nearlyWeeks (mode, weekcount, end) {
    /*
	    功能：计算当前时间（或指定时间），向前推算周数(weekcount)，得到结果周的第一天的时期值；
	    参数：
    mode -推算模式（'cn'表示国人习惯【周一至周日】；'en'表示国际习惯【周日至周一】）
    weekcount -表示周数（0-表示本周， 1-前一周，2-前两周，以此推算）；
    end -指定时间的字符串（未指定则取当前时间）；
    */
    if (mode == undefined) mode = "cn";
    if (weekcount == undefined) weekcount = 0;
    if (end != undefined)
        end = new Date(new Date(end).toDateString());
    else
        end = new Date(new Date().toDateString());
    var days = 0;
    if (mode == "cn")
        days = (end.getDay() == 0 ? 7 : end.getDay()) - 1;
    else
        days = end.getDay();
    return new Date(end.getTime() - (days + weekcount * 7) * 24 * 60 * 60 * 1000);
};
function getWorkDayCount (mode, beginDay, endDay) {
    /*
    功能：计算一段时间内工作的天数。不包括周末和法定节假日，法定调休日为工作日，周末为周六、周日两天；
    参数：
    mode -推算模式（'cn'表示国人习惯【周一至周日】；'en'表示国际习惯【周日至周一】）
    beginDay -时间段开始日期；
    endDay -时间段结束日期；
    */
    var begin = new Date(beginDay.toDateString());
    var end = new Date(endDay.toDateString());
    //每天的毫秒总数，用于以下换算
    var daytime = 24 * 60 * 60 * 1000;
    //两个时间段相隔的总天数
    var days = (end - begin) / daytime + 1;
    //时间段起始时间所在周的第一天
    var beginWeekFirstDay = nearlyWeeks(mode, 0, beginDay.getTime()).getTime();
    //时间段结束时间所在周的最后天
    var endWeekOverDay = nearlyWeeks(mode, 0, endDay.getTime()).getTime() + 6 * daytime;
    //由beginWeekFirstDay和endWeekOverDay换算出，周末的天数
    var weekEndCount = ((endWeekOverDay - beginWeekFirstDay) / daytime + 1) / 7 * 2;
    //根据参数mode，调整周末天数的值
    if (mode == "cn") {
        if (endDay.getDay() > 0 && endDay.getDay() < 6)
            weekEndCount -= 2;
        else if (endDay.getDay() == 6)
            weekEndCount -= 1;
        if (beginDay.getDay() == 0) weekEndCount -= 1;
    }
    else {
        if (endDay.getDay() < 6) weekEndCount -= 1;
        if (beginDay.getDay() > 0) weekEndCount -= 1;
    }
    //根据调休设置，调整周末天数（排除调休日）
    $.each(WLD.Setting.WeekendsOff, function (i, offitem) {
        var itemDay = new Date(offitem.split('-')[0] + "/" + offitem.split('-')[1] + "/" + offitem.split('-')[2]);
        //如果调休日在时间段区间内，且为周末时间（周六或周日），周末天数值-1
        if (itemDay.getTime() >= begin.getTime() && itemDay.getTime() <= end.getTime() && (itemDay.getDay() == 0 || itemDay.getDay() == 6))
            weekEndCount -= 1;
    });
    //根据法定假日设置，计算时间段内周末的天数（包含法定假日）
    $.each(WLD.Setting.Holiday, function (i, itemHoliday) {
        var itemDay = new Date(itemHoliday.split('-')[0] + "/" + itemHoliday.split('-')[1] + "/" + itemHoliday.split('-')[2]);
        //如果法定假日在时间段区间内，且为工作日时间（周一至周五），周末天数值+1
        if (itemDay.getTime() >= begin.getTime() && itemDay.getTime() <= end.getTime() && itemDay.getDay() > 0 && itemDay.getDay() < 6)
            weekEndCount += 1;
    });
    //工作日 = 总天数 - 周末天数（包含法定假日并排除调休日）
    return days - weekEndCount;
};