$(function(){
	try {
//		o2o.treeAll("dept",function(n){
//			return getTr(n);
//		});
//		pop_up_box.loadWait();
		//获取部门一级菜单
		$.get("../tree/getTree.do",{"type":"dept"},function(data){
			pop_up_box.loadWaitClose();
			o2o.initTree(data,function(n){
				return treeliinit(n.dept_name,n.sort_id);
			});
			o2o.next_tree("dept",function(n){
				return treeli(n.dept_name,n.sort_id);
			},undefined,function(treeId){
				loadData(treeId);
			});
		});
//		o2o.editClient("deptEdit.do?sort_id=");
//		o2o.delClient("dept"); 
	} catch (e) {}
// 	$("#treeAll").click();
// 	var page=0;
// 	var count=0;
// 	var totalPage=0;
	$("#find").click(function(){
		loadData();
	}); 
	loadData();
	function loadData(sort_id){
		if (!sort_id) {
			sort_id="";
		}
//		$("#page").val(page);
		var searchKey=$("#searchKey").val();
		pop_up_box.loadWait();
		$.get("getDeptByUpper_dept_id.do",{
			"searchKey":searchKey,
//			"page":page,
//			"count":count,
			"m_flag":$("#m_flag").val(),
			"easy_id":$("#easy_id").val(),
			"dept_manager":$("#dept_manager").val(),
			"treeId":sort_id
		},function(data){
			$("#listpage tbody").html("");
			pop_up_box.loadWaitClose();
			$.each(data,function(i,n){
					var len=$("#listpage th").length;
					var tr=getTr(len);
					$("#listpage tbody").append(tr);
					for (var i = 0; i < len; i++) {
						var th=$($("#listpage th")[i]);
						var name=$.trim(th.attr("data-name"));
						var show=th.css("display");
						var j=$("#listpage th").index(th);
						var val=$.trim(n[name]);
						if(show=="none"){
							tr.find("td:eq("+j+")").hide();
						}else if(name=="m_flag"){
						   tr.find("td:eq("+j+")").html(getMFlagName(val));
						}else if(name=="working_status"){
							if(val=="1"){
								tr.find("td:eq("+j+")").html("使用");
							}else{
								tr.find("td:eq("+j+")").html("停用");
							}
						} else{
							if(j>=0){
								if(name=="dept_sim_name"){
									tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(n.sort_id)+"'>"+val);
								}else{
									tr.find("td:eq("+j+")").html(val);
								}
							}
						}
					}
					tr.find("td:eq(0)").html(getbtn());
			});
			selectTr();
//			$("#totalPage").html(data.totalPage);
//			$(".pull-left .form-control").val(data.totalRecord);
//			totalPage=data.totalPage;
//			count=data.totalRecord;
		});
	}
	$("#addDept").click(function(){
		editUtils.loadPage("deptEdit.do",function(){
			deptEdit.init();
		});
	});
});

function editDept(t){
	var sort_id=$(t).parents("tr").find("input").val();
	editUtils.loadPage("deptEdit.do?sort_id="+sort_id,function(){
		deptEdit.init();
	});
}
function delDept(t){
	var tr=$(t).parents("tr");
	if (window.confirm("是否要删除该记录?")) {
		var sort_id=tr.find("input").val();
		pop_up_box.postWait();
		$.post("delClient.do",{"treeId":sort_id,"type":"dept"},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				tr.remove();
				$(".parent_li input[value='"+sort_id+"']").parent().parent().remove();
			}else{
				pop_up_box.showMsg(data.msg);
			}
		});
	}
}
function getbtn(){
	   var btn="";
		if($("#edit_hi").val()=="true"){
			btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='editDept(this);'>修改</button>";
		}
		if($("#del_hi").val()=="true"){
			btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='delDept(this);'>删除</button>";
		}
	   return btn;
}
function getMFlagName(m_flag){
	var m_flagName="生产";
	   switch (ifnull(m_flag)) {
	   case "1":
		   m_flagName="营销";
		break;
	   case "2":
		   m_flagName="管理";
		   break;
	   case "3":
		   m_flagName="财务";
		   break;
	   }
	   return m_flagName;
}