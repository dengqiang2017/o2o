$(function(){
	$(".print").click(function(){
		$("#print").jqprint();
	});
	var customer_id="";
	var PH="";
	var item_id="";
	$(".find").click(function(){
		pop_up_box.loadWait();
		var thlen=$("th").length;
		for (var i = 5; i < thlen;) {
			$("th").eq(i).remove();
			thlen=thlen-1;
		}
		$("tbody").html("");
		$.get("../pPlan/getWorkPriceList.do",{
			"searchKey":$.trim($("#searchKey").val()),
			"customer_id":customer_id,
			"PH":PH,
			"item_id":item_id,
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			pop_up_box.loadWaitClose();
			var emlen=data.employeelist.length;
			if(emlen>0){
					$.each(data.employeelist,function(i,n){
						$("thead tr").append("<th>"+n.clerk_name+"<span style='display: none;'>"+n.clerk_id+"</span></th>");
					});
					$("thead tr").append("<th>汇总</th>");
				if(data.leftlist.length>0){
					$.each(data.leftlist,function(i,n){
						var tr=getTr(5+emlen);
						$("tbody").append(tr);
						for (var i = 0; i < $("th").length; i++) {
							var th=$($("th")[i]);
							var name=th.attr("data-name");
							var j=$("th").index(th);
							if(name=="item_sim_name"){
								if(n[name]==""){
									tr.find("td:eq("+j+")").html("定制产品");
								}else{
									tr.find("td:eq("+j+")").html(n[name]);
								}
							}else if(name=="work_name"){
								tr.find("td:eq("+j+")").html(n[name]+"<span style='display: none;'>"+n.JSGXID+"</span>");
							}else{
								tr.find("td:eq("+j+")").html(n[name]);
							}
						}
						tr.find("td:eq(0)").css("width","150px");
						tr.find("td:eq(3)").css("width","200px");
					});
					/////放入单价///
					$.each(data.pricelist,function(i,n){
						var JSGXID=n.JSGXID; 
						var pgdh=n.pgdh;
						var thi=$("th").index($("th:contains("+n.clerk_id+")"));
						var tri=$("tbody tr").index($("tbody tr:contains("+n.JSGXID+")"));
						var pgi=$("tbody tr").index($("tbody tr:contains("+n.pgdh+")"));
						$.each(data.leftlist,function(i){
							var j=$("tbody tr:eq("+i+")").html().indexOf(n.JSGXID);
							var k=$("tbody tr:eq("+i+")").html().lastIndexOf(n.pgdh);
							if(j>0&&k>0){
								$("tbody tr:eq("+i+")").find("td").eq(thi).html(numformat2(n.price));
								$("tbody tr:eq("+i+")").find("td").eq(thi).css("width","80px");
							}
						});
					});
					////计算每行的总金额///
					$.each(data.leftlist,function(i){
						var sumje=0;
						for (var j = 5; j < $("th").length-1; j++) {
							var je=$("tbody tr:eq("+i+")").find("td").eq(j).html();
							if(je&&je!=""){
								sumje+=parseFloat(je);
							}
						}
						$("tbody tr:eq("+i+")").append("<td width='100'>"+numformat2(sumje)+"</td>");
					});
					////计算每列的总金额/////
					var tr=getTr(5+emlen+1);
					$("tbody").append(tr);
					tr.find("td:eq(0)").html('汇总');
					tr.find("td:eq(0)").addClass("hz");
					tr.find("td:eq(0)").css("padding",0);
					for (var j = 5; j < $("th").length; j++) {
						var sumje=0;
						for (var i = 0; i < data.leftlist.length; i++) {
							var je=$("tbody tr:eq("+i+")").find("td").eq(j).html();
							if(je&&je!=""){
								sumje+=parseFloat(je);
							}
						}
						tr.find("td").eq(j).html(numformat2(sumje));
					}
				}
			}
		});
	});
	var params=window.location.href.split("?");
	if(params.length>1){
		params=params[1].split("&");
		customer_id=params[0].split("=")[1];
		PH=params[1].split("=")[1];
		item_id=params[2].split("=")[1];
		$(".header-title a").attr("href","javascript:history.go(-1)");
		$(".breadcrumb>li:eq(1)").show();
	}
	$(".find").click();
	
});