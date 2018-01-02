$(function(){
	var customer_id;
	selectClient.init(function(customerId) {
		customer_id=customerId;
		$("tbody").html("");
		var corp_name=$(".sim-msg>li:eq(0)").html();
		var telno=$(".sim-msg>li:eq(1)").html();
		$("#corp_name").html(corp_name);
		$("#telno").html(telno);
		$("#customer_id").val(customer_id);
		$(".find:eq(0)").click();
	},"../../employee/");
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".input-sm").val("");
	var onedays=nowStr.split("-");
	$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
	$(".Wdate:eq(1)").val(nowStr); 
	$("select").val("已结束");
	$("table:eq(0)").find("tr:eq(0)").sortable({axis:"x"});
	$("#expand").click(function(){
		var form=$("form");
		if(form.is(":hidden")){
			form.show();
			$(this).text("隐藏搜索");
		}else{
			$(this).text("展开搜索");
			form.hide();
		}
	});
	if($(".folding-btn").css("display")=="none"){
		$("form").show();
	}else{
		$("form").hide();
	}
	$(".print").click(function(){
		$("#print").jqprint();
	});
	$("#printqiamming").click(function(){
		$("#imshow").jqprint();
	});
	$(".find").click(function(){
		$("#qianming").attr("src","");
			if (!customer_id||$.trim(customer_id)=="") {
				$("#seekh").click();
				return;
			}
			if ($.trim($("#customer_id").val())=="") {
				$("#customer_id").val(customer_id);
			}
			pop_up_box.loadWait(); 
			$("tbody").html("");
			var corp_sim_name="";
			if ($.trim($(".sim-msg>li:eq(0)").html())!="") {
				corp_sim_name=$.trim($(".sim-msg>li:eq(0)").html());
			}
			$.get("../../employee/orderTrackingRecord.do",$("form").serialize(),function(data){
				pop_up_box.loadWaitClose();
				var seeds_id;
				$.each(data.rows,function(i,n){
					var len=$("table th").length;
					var tr=getTr(len);
					$("tbody").append(tr);
					function loadDataByThead(i,len,func){
						for (var k = 0; k < len; k++) {
							var th=$($("table:eq("+i+") th")[k]);
							var name=$.trim(th.attr("data-name"));
							var show=th.css("display");
							var j=$("table:eq("+i+") th").index(th);
							if(show=="none"){
								tr.find("td:eq("+j+")").hide();
							}else{
								func(j,name);
							}
						}
					}
						loadDataByThead(0,len,function(j,name){
							if(name=="date"){
								if (n.at_term_datetime_Act>0) {
									var now = new Date(n.at_term_datetime_Act);
									var nowStr = now.Format("yyyy-MM-dd hh:mm:ss"); 
									tr.find("td:eq("+j+")").html(nowStr);
								}
							}else if(name=="je"){
								tr.find("td:eq("+j+")").html(numformat2(n.sd_oq*n.sd_unit_price));
							}else if(name=="sd_oq"){
								tr.find("td:eq("+j+")").html(numformat(n.sd_oq,0));
							}else if(name=="sd_unit_price"){
								tr.find("td:eq("+j+")").html(numformat2(n.sd_unit_price));
							}else if(name=="qianming"){
								$.get("../../report/getQianmingimg.do",{"orderNo":$.trim(n.ivt_oper_listing),"item_id":$.trim(n.item_id)},function(data){
									if(data.msg){
										tr.find("td:eq(8)").html("<img src='"+data.msg+"'>");
										tr.find("td:eq(8)>img").click(function(){
											if(this.src){
												$('#imshow').append("<img class='center-block' src='"+this.src+"'>");
												$('.image-zhezhao').show();
											}
											else{
												alert('没有发现签名');
											}
										});
										
									}
								});
							}else{
								if(n[name]){
									tr.find("td:eq("+j+")").html($.trim(n[name]));
								}
							}
						});
				}); 
			});
	});
	$('.gb').click(function(){
		$('.image-zhezhao').hide();
		$('#imshow').html('');
	});
});