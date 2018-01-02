$(function(){
	setDateNow();
	var page=0;
	var count=0;
	var totalPage=0;
	$(".tabs-content").hide();
	$(".tabs-content:eq(0)").show();
	$("ul.nav>li").click(function(){
		var n=$("ul.nav>li").index(this);
		$("ul.nav>li").removeClass("active");
		$(this).addClass("active");
		$(".tabs-content").hide();
		$(".tabs-content").eq(n).show();
		if(n==0){
			if($.trim($(".tabs-content:eq(0) tbody:eq(0)").html())==""){
				$(".find").click();
			}
		}else{
			if($.trim($(".tabs-content:eq(2) tbody:eq(1)").html())==""){
				$(".find").click();
			}
		}
	});
	$(".find").click(function(){
		var n=$("ul>li").index($("li.active"));
		if(n==2){//分页数据
			page=0;
			count=0;
			$("tbody:eq(1)").html("");
			loadData();
		}else if(n==1||n==0){
			$("tbody:eq(0)").html("");
			pop_up_box.loadWait();
			$.get("../product/getProductViewList.do",{
				"searchKey":$.trim($("#searchKey").val()),
				"beginDate":$("#d4311").val(),
				"endDate":$("#d4312").val()
				},function(data){
					pop_up_box.loadWaitClose();
				var list=[];
				$.each(data,function(i,n){
					var json=[];
					json.push(n.item_sim_name,n.num);
					list.push(json);
					var len=2;
					var tr=getTr(len);
					$("tbody:eq(0)").append(tr);
					tr.find("td:eq(0)").html(n.item_sim_name);
					tr.find("td:eq(1)").html(n.num);
				});	
				loadChart(list, "line", "jqChart", "产品浏览记录", "访问量(次数)");
				loadChart(list, "Pie", "jqChart_pre", "产品浏览记录", "访问量(次数)");
//				loadChart(list, "RadarLine", "jqChart_pre", "产品浏览记录", "访问量(次数)");
//				loadChart(list, "Area", "jqChart_pre", "产品浏览记录", "访问量(次数)");
//				loadChart(list, "Bar", "jqChart_pre", "产品浏览记录", "访问量(次数)");
//				loadChart(list, "Bubble", "jqChart_pre", "产品浏览记录", "访问量(次数)");
				loadChart(list, "column", "jqChart_zhu", "产品浏览记录", "访问量(次数)");
//				updateJqchar("jqChart",list,10);
				
				
				
			});
		}else{
			
		}
	});
	$(".find").click();
	$(".nextPage").click(function(){
			page+=1;
			loadData();
	});
	function loadData(){
		pop_up_box.loadWait();
		$.get("../product/getProductViewPage.do",{
			"searchKey":$.trim($("#searchKey").val()),
			"beginDate":$("#d4311").val(),
			"endDate":$("#d4312").val(),
			"page":page,
			"count":count			
		},function(data){
			pop_up_box.loadWaitClose();
			if(data&&data.rows.length>0){
				$.each(data.rows,function(i,n){
					var len=$("thead:eq(1) th").length;
					var tr=getTr(len);
					$("tbody:eq(1)").append(tr);
					for (var i = 0; i < len; i++) {
						var th=$($("thead:eq(1) th")[i]);
						var name=$.trim(th.attr("data-name"));
						var show=th.css("display");
						var j=$("thead:eq(1) th").index(th);
						tr.find("td:eq("+j+")").html(n[name]);
					}
				});
				count=data.totalRecord;
				totalPage=data.totalPage;
				if(data.rows.length<10){
					pop_up_box.toast("已全部加载");
					$(".nextPage").hide();
				}else{
					$(".nextPage").show();
				}
			}else{
				pop_up_box.toast("已全部加载");
				$(".nextPage").hide();
			}
		});
	}
});
/*Area;Bar;Bubble;Column;Financial Chart - Candlestick;Financial Chart - Stock;Line;Pie;Radar Area;Radar Line
 Radar Spline Area;Radar Spline;Scatter;Spline Area;Spline;Stacked Column;Stacked Bar
 * 
 */