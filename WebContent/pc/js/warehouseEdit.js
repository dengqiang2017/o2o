$(function(){
    var corp_name=$($("input")[1]);
    corp_name.bind("input propertychange blur",function(){
    	$($("input")[2]).val(makePy(corp_name.val()));
    });
	$(".btn-info").click(function(){
		var name=$.trim($($("input")[1]).val());
		if (name=="") {
			pop_up_box.showMsg("请输入库房名称")
		}else{
			pop_up_box.postWait(); 
			$.post("saveWarehouse.do",$("#wareForm").serialize(),function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("保存成功!回到列表页面!",function(){
						$("input").val("");
						$("textarea").val("");
						$("form>input").val("");
						window.location.href="warehouse.do";
					});
				}else{
					pop_up_box.showMsg("保存失败,错误:"+data.msg);
				}
			});
		}
	});
	$(".btn-success").click(function(){
		var n = $(".btn-success").index(this);
		var txt=$(this).parents(".form-group").find("label:eq(0)").html();
		   if (txt.indexOf("库房")>=0) {
			   o2o.loadTree("warehouse",function(){
				   warehouse.init(function(){
					   var name=$("#warehouseTreePage").find(".activeTable").find("td:eq(0)").text();
					   var id=$("#warehouseTreePage").find(".activeTable").find("td:eq(2)").html();
					   if(name==""){
						   name=$("#warehouseTreePage").find(".treeActive").text();
						   id=$("#warehouseTreePage").find(".treeActive").find("input").val();
					   }
					   $("#upper_storestruct_name").html(name);
					   $("#upper_storestruct").val(id);
				   });
			   },getQueryString("sort_id"));
		   }else if(txt.indexOf("部门")>=0){
			   o2o.loadTree("dept",function(){
				   dept.init(function(){
						$("#deptId").val(treeSelectId);
						$("#dept_name").html(treeSelectName);
					});
			   });
		   }else if(txt.indexOf("人")>=0){
			   o2o.loadTree("employee",function(){
				   employee.init(function(){
					   $("#clerkId").val(treeSelectId);
					   $("#clerk_name").html(treeSelectName);
				   });
			   });
		   }else if(txt.indexOf("区划")>=0){
			   o2o.loadTree("regionalism");
		   }else if(txt.indexOf("客户")>=0){
			   o2o.loadTree("client");
		   }
	});
	
});	