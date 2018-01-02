var deptEdit={
		init:function(){
			initNumInput();
			var sort_id=$("#editpage").find("#sort_id");
			editUtils.editinit("getDeptInfo", sort_id.val());
			
		    var dept_sim_name=$("#editpage").find("input[name='dept_sim_name']");
		    var dept_name=$("#editpage").find("input[name='dept_name']");
		    dept_sim_name.bind("input propertychange blur",function(){
		    	dept_name.val(dept_sim_name.val());
		    	$("#editpage").find("input[name='easy_id']").val(makePy(dept_sim_name.val()));
		    });
			
		    $("#editpage").find(".btn-success").click(function(){
		   	 var n = $("#editpage").find(".btn-success").index(this);
			   var type=$(this).parents(".form-group").find("label").text();
			   if(type.indexOf("部门")>=0){
				   pop_up_box.loadWait();
				   $.get("getDeptTree.do",function(data){
					   pop_up_box.loadWaitClose();
					   $("body").append(data);
					   dept.init(function(){
						   $("#editpage").find("#upper_dept_id").val(treeSelectId);
						   $("#editpage").find("#upper_dept_name").html(treeSelectName);
					   });
				   });
			   }
		    });
		    $("#editpage").find(".btn-info").click(function(){
		   		if ($.trim(dept_sim_name.val())=="") {
		   			pop_up_box.showMsg("请输入部门名称!");
		   		}else{
//		   			$("#upper_dept_name").prop("disabled",true);
		   			pop_up_box.postWait(); 
		   			$.post("saveDept.do",$("#editpage").find("#editForm").serialize(),function(data){
		   				pop_up_box.loadWaitClose();
		   				if (data.success) {
		   				 pop_up_box.toast("保存成功", 1000);
		   				 var type = 1;
							var cid = sort_id.val();
							var oldid=cid;
							if (cid == "") {
								type = 0;
							}
							if(data.msg){
								cid = data.msg;
							}
							sort_id.val(cid);
							editUtils.tableShowSyn(type,getbtn(),function(tr,j,name) {
								if(name=="dept_sim_name"){
									var val=$("#editForm input[name='dept_sim_name']").val(); 
									tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(cid)+"'>"+val);
									var li=$(".parent_li input[value='"+oldid+"']").parent().parent();
									li.find("i").html(val);
									li.find("input").val(cid);
								}else if(name=="m_flag"){
									var val=$("#editForm select[name='m_flag']").val(); 
									tr.find("td:eq("+j+")").html(getMFlagName(val));
								}
							});
		   				}else{
		   					pop_up_box.showMsg("数据保存失败,错误:"+data.msg);
		   				}
		   			});
		   		}
		   	});
			
		}
}