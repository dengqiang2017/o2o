$(function(){
	$(".print").click(function(){
		$("#print").jqprint();
	});
	$(".find").click(function(){
		pop_up_box.loadWait();
		$("tbody").html("");
		var thlen=$("th").length;
		$.get("../pPlan/getWorkSumPriceList.do",{
			"searchKey":$.trim($("#searchKey").val()),
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			pop_up_box.loadWaitClose();
				if(data.leftlist.length>0){
					$.each(data.leftlist,function(i,n){
						var tr=getTr(thlen);
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
							}else{
								tr.find("td:eq("+j+")").html(n[name]);
							}
						}
						tr.find("td:eq(1)").css("width","150px");
						tr.find("td:eq(4)").css("width","50px");
						var btn=$('<button type="button" class="btn btn-primary">明细</button>');
						tr.find("td:eq(0)").html(btn);
						btn.click({"customer_id":$.trim(n.customer_id),"PH":$.trim(n.PH),"item_id":$.trim(n.Item_ID)},function(event){
							window.location.href="workPrice.do?customer_id="+event.data.customer_id+"&PH="+event.data.PH+"&item_id="+$.trim(event.data.item_id);
						});
					});
					/////放入单价///
					$.each(data.pricelist,function(i,n){
						var JSGXID=n.JSGXID; 
						var pgdh=n.pgdh;
						var thi=$("th").index($("th:contains("+n.JSGXID+")"));
						var pgi=$("tbody tr").index($("tbody tr:contains("+n.PH+")"));
						$("tbody tr:eq("+pgi+")").find("td").eq(thi).html(numformat2(n.price));
						$("tbody tr:eq("+pgi+")").find("td").eq(thi).css("width","80px");
					});
					////计算每行的总金额///
					$.each(data.leftlist,function(i){
						var sumje=0;
						for (var j = 4; j < $("th").length-1; j++) {
							var je=$("tbody tr:eq("+i+")").find("td").eq(j).html();
							if(je&&je!=""){
								sumje+=parseFloat(je);
							}
						}
						$("tbody tr:eq("+i+")").find("td").eq(thlen-1).html(numformat2(sumje));
					});
					////计算每列的总金额/////
					var tr=getTr(thlen);
					$("tbody").append(tr);
					tr.find("td:eq(0)").html('汇总');
					tr.find("td:eq(0)").addClass("hz");
					tr.find("td:eq(0)").css("padding",0);
					for (var j = 3; j < $("th").length; j++) {
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
		});
	});
	$(".find").click();
	
});