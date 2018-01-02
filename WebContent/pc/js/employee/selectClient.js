$(function() {
	var regionalism_name_cn=$("#regionalism_name_cn");
	var regionalismId=$("#regionalismId");
	var corp_name=$("#corp_name");
	var user_id=$("#user_id");
	var orderhtml=window.location.href;
	orderhtml=orderhtml.split("?")[1];
	var type="";
	if (orderhtml) {
		type=orderhtml.split("=")[1];
	}
//	if (type=="3") {
//		$("#order").html("代下计划");
//	}
	function getTr(client){
		var tr="<tr>";
		var ditch_type=ifnull(client.ditch_type);
		if (ditch_type=="") {
			ditch_type="消费者";
		}
		if (type=="0"||type=="0#dibu") {
			tr+="<td><div class='checkbox'><input type='checkbox'></div></td>";
		}
//		<a href='../product/clientEdit.do?customer_id="+ifnull(client.customer_id)
//			+"&info=info' title='点击查看详细'>"+ifnull(client.corp_name)+"</a>
		tr+="<td><input type='hidden' value='"+ifnull(client.customer_id)+"'>"+ifnull(client.corp_name)+"</td>"
		tr+="<td>"+ifnull(client.tel_no)+"</td>";
		tr+="<td>"+ditch_type+"</td>";
		tr+="<td>"+ifnull(client.regionalism_name_cn)+"</td>";
		tr+="<td>"+ifnull(client.corp_reps)+"</td><td>"+ifnull(client.FHDZ)+"</td>";
		tr+="<td>"+ifnull(client.Kar_Driver)+"</td><td>"+ifnull(client.Kar_Driver_Msg_Mobile)+"</td>";
		tr+="<td>"+ifnull(client.HYS)+"</td><td>"+ifnull(client.HYS_tel)+"</td>";
		tr+="<td>"+ifnull(client.HY_style)+"</td></tr>";
		return tr;
	}
	try {
		$("tbody").html("");
		$.get("../tree/getCustomerPage.do",{
			"employeeId":$("#employeeId").val(),
			"ditch_type":$("#ditch_type").val()
		},function(data){
			$.each(data.rows,function(i,n){
				$("tbody").append(getTr(n));
			});
			selectTr();
			$("#page").val("0");
			$("#totalPage").val(data.totalPage);
		});
		$.get("../tree/getTree.do",{"type":"client","employeeId":$("#employeeId").val(),"ver":Math.random()},function(data){
			var  ulli="<ul>";
			$.each(data,function(i,n){
				ulli+=treeliinit(n.corp_name,n.customer_id);
			});
			ulli+="</ul>";
			$(".tree").html(ulli);
			o2otree.next_tree("client",function(n){
				return treeli(n.corp_name,n.customer_id);
			},undefined,function(treeId){
				o2otree.clickGetTable("../tree/getCustomerPage.do?ditch_type="+$("#ditch_type").val(),treeId, function(n){
					return getTr(n);
				});
			});
			$(".tree").find("span:contains('我公司')").click();
			window.location.href="#dibu";
		});
	} catch (e) {}
////////////////////////////////
	//存储选择项的数组
//	var customerIdList=[];
//	$.cookie("customer_id",customerIdList);
	$("#find").click(function(){
		var corp_name=$("#corp_name").val();
		var user_id=$("#user_id").val();
		var employeeId=$("#employeeId").val();
		var movtel=$("#movtel").val();
		pop_up_box.loadWait();
		window.location.href="#add";
		$.get("../tree/getCustomerPage.do",{
			"searchKey":corp_name,
			"user_id":user_id,
			"employeeId":employeeId,
			"regionalism_id":regionalismId.val(),
			"ditch_type":$("#ditch_type").val(),
			"ver":Math.random() 
		},function(data){
			pop_up_box.loadWaitClose();
			$("tbody").html("");
			$.each(data.rows,function(i,n){
				$("tbody").append(getTr(n));
			});
			$("#page").val("0");
			$("#totalPage").val(data.totalPage);
			treeSelectId="";
			selectTr();
		});
	});
	function loadData(page){
		var corp_name=$("#corp_name").val();
		var user_id=$("#user_id").val();
		var employeeId=$("#employeeId").val();
		var movtel=$("#movtel").val();
		pop_up_box.loadWait();
		$.get("../tree/getCustomerPage.do",{
			"searchKey":corp_name,
			"user_id":user_id,
			"employeeId":employeeId,
			"regionalism_id":regionalismId.val(),
			"movtel":movtel,
			"ditch_type":$("#ditch_type").val(),
			"page":page,
			"ver":Math.random()
		},function(data){
			pop_up_box.loadWaitClose();
			$("tbody").html("");
			$.each(data.rows,function(i,n){
				$("tbody").append(getTr(n));
			});
			selectTr();
			$("#totalPage").val(data.totalPage);
		});
	}
	//1.首页
	$("#beginpage").click(function(){
		$("#page").val("0");
		loadData($("#page").val());
	});
	//2.尾页
	$("#endpage").click(function(){
		$("#page").val($("#totalPage").val());
		loadData($("#totalPage").val());
	});
	$("#uppage").click(function(){
		var page=$("#page").val();
		page=parseInt(page)-1;
		if (page>=0) {
			$("#page").val(page);
			loadData(page);
		}else{
			pop_up_box.showMsg("已到第一页!");
		}
	});
	$("#nextpage").click(function(){
		var  totalpage=$("#totalPage").val();
		var  page=$("#page").val();
		  page=parseInt(page)+1;
		if (page<=totalpage) {
			$("#page").val(page);
			loadData(page);
		}else{
			pop_up_box.showMsg("已到最后一页!");
		}
	});
	$("#regionalismBtn").click(function(){
		pop_up_box.loadWait();
		 $.get("../tree/getDeptTree.do",{"type":"regionalism"},function(data){
			 pop_up_box.loadWaitClose();
			   $("body").append(data);
		 });
	});
	////////////////////////////////
	$("#add").click(function(){
		var chekcs=$("input:checked");
		if (chekcs&&chekcs.length>0) {
			var customer_name="";
			var customer_ids="";
			for (var i = 0; i < chekcs.length; i++) {
				var customer=$(chekcs[i]).parents("tr").find(" td:eq(1)").text(); 
				var customer_id=$(chekcs[i]).parents("tr").find("input[type='hidden']").val();
				customer_name=customer_name+","+customer;
				customer_ids=customer_id+","+customer_ids;
			}
			$.cookie("customer_name",customer_name);
			$.cookie("customer_id",customer_ids);
			$.cookie("ditch_type",$("#ditch_type").val());
			window.location.href="add_old.do";
		}else{
			pop_up_box.showMsg("请至少选择一个客户!");
		}
	});
	$("#allcheck").click(function(){
		$("input:checkbox").prop("checked",$("#allcheck").prop("checked"));
	});
	$("#order").click(function(){
		 $.cookie("customer_id",$(".activeTable").find("input[type='hidden']").val());
		 if (type=="3") {
			 window.location.href="salePlan.do";
		}else{
		 window.location.href="order.do";
		}
	});
});