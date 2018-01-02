$.ajaxSetup({  
	async : false  
});

$(function(){
	var com_id=getQueryString("com_id");
	if(com_id){
		window.location.href="operateEdit.do?com_id="+com_id;
		loadData(com_id);
	}
	var page=0;
	var totalPage=0;
	var count=0;
	function loadData(com_id){
		var searchKey=$("#searchKey").val();
		pop_up_box.loadWait();
		$.get("getOperatePage.do",{
			"page":page,
			"count":count,
			"searchKey":searchKey,
			"com_id":com_id
		},function(data){
			$("#list tbody").html("");
			pop_up_box.loadWaitClose();
			$.each(data.rows,function(i,n){
				var len=$("#list th").length;
				var tr=getTr(len);
				$("#list tbody").append(tr);
				for (var i = 0; i < len; i++) {
					var th=$($("#list th")[i]);
					var name=th.attr("data-name");
					var show=th.css("display");
					var j=$("#list th").index(th);
					if(show=="none"){
						tr.find("td:eq("+j+")").hide();
					}else{
						if(j>=0){
							if(name=="com_sim_name"){
								tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(n.com_id)+"'>"+n[name]);
							}
							else{
								tr.find("td:eq("+j+")").html(n[name]);
							}
						}
					}
				}
				var btn="";
				if($("#del_hi").val()=="true"){
					btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='editOperate(this);'>修改</button>";
				}
				if($("#edit_hi").val()=="true"){
					btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='delOperate(this);'>删除</button>";
				}
				tr.find("td:eq(0)").html(btn);
			});
			totalPage=data.totalPage;
			count=data.totalRecord;
			selectTr();
			$("#totalPage").html(data.totalPage);
			$(".pull-left .form-control").html(data.totalRecord);
		});
	}
	$("#treeAll").click(function(){
		page=0;
		count=0;
		loadData();
	}); 
	try {
		o2o.next_tree("operate",function(n){
			return treeli(n.com_sim_name,$.trim(n.com_id));
		},undefined,function(treeId){
			page=0;
			count=0;
			loadData(treeId);
		});
	} catch (e) {}
	$("#addNextClient").click(function(){
		var tr=$("tbody").find(".activeTable");
		if(tr.length>0){
			var name=tr.find("td:eq(1)").text();
			var id=tr.find("input").val();
			window.location.href="operateEdit.do?next=next&com_sim_name="+name+"&com_id="+id;
		}else{
			pop_up_box.showmsg("请选择一个运营商!");
		}
			
	});
////////////////////////////////
	$("#find").click(function(){
		page=0;
		count=0;
		loadData();
	});
	$("#find").click();
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
function editOperate(t){
	var tr=$(t).parents("tr");
	var com_id=tr.find("input").val();
	window.location.href="operateEdit.do?com_id="+com_id;
}
function delOperate(t){
	if(confirm("是否删除该运营商?")){
		var tr=$(t).parents("tr"); 
		var com_id=tr.find("input").val();
		$.post("delClient.do",{"treeId":com_id,"type":"operate"},function(data){
			if (data.success) {
				tr.remove();
			}else{
				pop_up_box.showMsg(data.msg);
			}
		});
	}
}