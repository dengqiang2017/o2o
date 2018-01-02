$(function(){
	
	$("#selectPerson").click(function(){
		$.get("selectPerson.do",function(data){
			$("body").append(data);
			selectPerson.init(function(weixinID,name){
				$(".person").append(name);
				$("#person").append(weixinID);
			});
		});
	});
	$("#clearPerson").click(function(){
		$(".person").html("");
		$("#person").html("");
	});
	$(".send").click(function(){
		var content=$.trim($("textarea").val());
		var person=$.trim($("#person").html());
		if (person=="") {
			pop_up_box.showMsg("没有选择接收人!");
			return;
		}
		if (content!="") {
			var html="<div class='my-msg'><div class='my-head'><img src='../pcxy/image/chat-head2.jpg'>";
			html+="</div><div class='my-content'><span>"+content+"</span></div></div>"
			$(".message-box").append(html);
			$.post("beginSendMSg.do",{
				"weixinID":person,
				"content":content
			},function(data){
				
			});
		}
	});
	
});

var selectPerson={
		init:function(func){
			pageshow.init();
			$("#close,.close").click(function(){
				$(".modal-cover,.modal").remove();
			});
			$(".btn-primary").click(function(){
				var n=$(".btn-primary").index(this);
				var weixinID="";
				var name="";
				if (n==0) {//选择所有人
					weixinID="1";
				}else{//自主选择人
					var empl_responsive=$(".table-responsive:eq(0)");
					var checks=empl_responsive.find(".checkedbox");
					if (checks&&checks.length>0) {
						for (var i = 0; i < checks.length; i++) {
							var tr=$(checks[i]).parents("tr");
							if ($.trim($(".person").html())=="") {
								name=tr.find("td:eq(1)").text();
								weixinID=tr.find("td:eq(5)").text();
							}else{
								name=name+","+tr.find("td:eq(1)").text();
								weixinID=weixinID+"|"+tr.find("td:eq(5)").text();
							}
						}
					}
					
					var cus_responsive=$(".table-responsive:eq(2)");
					checks=cus_responsive.find(".checkedbox");
					if (checks&&checks.length>0) {
						for (var i = 0; i < checks.length; i++) {
							var tr=$(checks[i]).parents("tr");
							if ($.trim($(".person").html())=="") {
								name=tr.find("td:eq(1)").text();
								weixinID=tr.find("td:eq(5)").text();
							}else{
								name=name+","+tr.find("td:eq(1)").text();
								weixinID=weixinID+"|"+tr.find("td:eq(5)").text();
							}
						}
					}
					func(weixinID,name);
					$(".modal-cover,.modal").remove();
				}
			});
			
			$(".find").click(function(){
				var lia = $(".nav li").index($(".nav .active"));
				if (lia==0) {
					loadEmployee();
				}else if (lia==1) {
					loadDept();
				}else if (lia==2) {
					loadCustomer();
				}else{
					
				}
			});
			$(".find:eq(0)").click();
			function loadEmployee(){
				var empl_responsive=$(".table-responsive:eq(0)");
				$.get("getEmployeeWeixinID.do",{
					"searchKey":$.trim($(".tabs-content:eq(0)").find("input[name='searchKey']").val())
				},function(data){
					empl_responsive.find("tbody").html("");
					$.each(data,function(i,n){
						var tr=getTr(6);
						empl_responsive.find("tbody").append(tr);
						tr.find("td:eq(0)").append("<div class='checkbox'></div>");
						tr.find("td:eq(1)").append(n.clerk_name);
						tr.find("td:eq(2)").append(n.dept_sim_name);
						tr.find("td:eq(3)").append(n.movtel);
						tr.find("td:eq(4)").append(n.weixin);
						tr.find("td:eq(5)").append(n.weixinID);
					});
					selectPerson.checkSelect(empl_responsive);
				});
			}
			function loadCustomer(){
				var cus_responsive=$(".table-responsive:eq(2)");
				$.get("getCustomerWeixinID.do",{
					"searchKey":$.trim($(".tabs-content:eq(2)").find("input[name='searchKey']").val())
				},function(data){
					cus_responsive.find("tbody").html("");
					$.each(data,function(i,n){
						var tr=getTr(6);
						cus_responsive.find("tbody").append(tr);
						tr.find("td:eq(0)").append("<div class='checkbox'></div>");
						tr.find("td:eq(1)").append(n.corp_sim_name);
						tr.find("td:eq(2)").append(n.dept_sim_name);
						tr.find("td:eq(3)").append(n.tel_no);
						tr.find("td:eq(4)").append(n.weixin);
						tr.find("td:eq(5)").append(n.weixinID);
					});
					selectPerson.checkSelect(cus_responsive);
				});
			}
		},
		checkSelect:function(table_responsive){
			table_responsive.find(".checkbox").unbind("click");
			table_responsive.find(".checkbox").click(function(){//注册图片选择框 选择或者取消功能
				var b=$(this).hasClass("checkedbox");
				if (b) {
					$(this).removeClass("checkedbox");
				}else{
					$(this).addClass("checkedbox");
				}
				var lia = table_responsive.find(".checkbox").index(this);
				if (lia==0) {
					var b=$(this).hasClass("checkedbox");
					if (b) {
						table_responsive.find(".checkbox").addClass("checkedbox");
					}else{
						table_responsive.find(".checkbox").removeClass("checkedbox");
					}
				}
			});
		}
}