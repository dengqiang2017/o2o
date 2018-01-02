$(function(){
	var customer_id;
	selectClient.init(function(customerId) {
		customer_id=customerId;
		$(".find").click();
	},"../employee/");
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd");
	$(".input-sm").val("");
	var onedays=nowStr.split("-");
	$(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
	$(".Wdate:eq(1)").val(nowStr); 
	$("#addNo").click(function(){
		$.get("../pc/receivablesAdd.html",function(data){
			$("body").append(data);
		});
	});
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
	$("#print").click(function(){
		$("#imshow").jqprint();
	});
	if($(".folding-btn").css("display")=="none"){
		$("form").show();
	}else{
		$("form").hide();
	}$("th:eq(7)").hide();
	$(".find").click(function(){
		if (findflag==1) {
			return;
		}else{
			if ($.trim($("#customer_id").val())=="") {
				$("#customer_id").val(customer_id);
			}
			pop_up_box.loadWait(); 
			$(".table-responsive").find("tbody").html("");
			$.get("receivablesReportList.do",$("form").serialize(),function(data){
				$.each(data.rows,function(i,n){
					var tr=getTr(10);
					$(".table-responsive").find("tbody").append(tr);
					if (n.finacial_d) {
						tr.find("td:eq(0)").html(n.finacial_d.split(" ")[0]);
					}
					tr.find("td:eq(1)").html(n.corp_sim_name);
					tr.find("td:eq(2)").html(numformat2(n.sum_si));
					tr.find("td:eq(3)").html(n.settlement_sim_name);
					tr.find("td:eq(4)").html(n.sum_si_origin);
					tr.find("td:eq(5)").html(n.recieved_id);
					tr.find("td:eq(6)").html(n.dept_sim_name);
					tr.find("td:eq(7)").html(n.clerk_name);
					if(n.rejg_hw_no.indexOf("null")>=0){
						tr.find("td:eq(8)").html("");
					}else{
						tr.find("td:eq(8)").html(n.rejg_hw_no);
					}
					tr.find("td:eq(7)").hide();
					if(n.recieved_id){
						tr.find("td:eq(9)").html('<button type="button" class="btn btn-danger" onclick="showimg(this);">查看凭证</button>');
					}
				});
				pop_up_box.loadWaitClose();
			});
		}
	});
	$(".btn-default").click(function(){
		$(this).parents("input-group").find("span.input-sm").html("");
		$(this).parents("input-group").find("input.input-sm").val("");
	});
	
	$("#settlement").click(function(){
		var i=$(".btn-success").index(this);
		pop_up_box.loadWait(); 
			 $.get("../tree/getDeptTree.do",{"type":"settlement"},function(data){
				   pop_up_box.loadWaitClose();
				 $("body").append(data);
				 settlement.init(function(){
					 $("#settlement_name").html(treeSelectName);
					 $("#settlement_id").val(treeSelectId);
				 });
	   });
	});
});
function showimg(t){
	var orderNo=$.trim($(t).parents("tr").find("td:eq(5)").html());
	var len=0;
	$.get("../employee/getCertificateImg.do",{
		"orderNo":orderNo
	},function(data){
		if(data){
			$(".image-zhezhao").show();
			$("#imshow").html("");
			for (var i = 0; i < data.length; i++) {
				$("#imshow").append("<img src='../"+data[i]+"' class='center-block'>");
			}
		$("#imshow").find("img:eq(0)").show();
		len=data.length;
		}else{
			pop_up_box.showMsg("未上传凭证!");
			
		}
	});
	$("#closeimgshow").click(function(){
		$(".image-zhezhao").hide();
	});
}