var productClassEdit={
		init:function(){
			initNumInput();
			var sort_id=$("#editpage").find("#sort_id");
			editUtils.editinit("../product/getProductClassBySordId", sort_id.val());
			
			var sort_name=$("input[name='sort_name']"); 
			sort_name.bind("input propertychange blur",function(){
				$("input[name='easy_id']").val(makePy(sort_name.val()));
			});
			if($("#info").val()=="info"){
				$("input").attr("disabled","disabled");
				$("select").attr("disabled","disabled");
				$(".btn-success ").attr("disabled","disabled");
				$("#saveClient").hide();
			}
			$(".btn-success").click(function(){
				   var n = $(".btn-success").index(this);
				   var type=$(this).parents(".form-group").find("label").text();
				   if(type.indexOf("类别")>=0){
					   $.get("../manager/getDeptTree.do",{"type":"cls","id":sort_id.val()},function(data){
						   $("body").append(data);
					 		procls.init(function(){
					 			$("#upper_sort_name").html(treeSelectName);
					 			$("#upper_sort_id").val(treeSelectId);
					 		});
					   });
				   }else if(type.indexOf("库房")>=0){
					   $.get("../manager/getDeptTree.do",{"type":"warehouse"},function(data){
						   $("body").append(data);
					   });
				   }
			 });
			$("#edit").click(function(){
				$("input").removeAttr("disabled");
				$("select").removeAttr("disabled");
				$(".btn-success ").removeAttr("disabled");
				$("#edit").hide();
				$("#saveClient").show();
			});
			$("#save").click(function(){
				if($.trim(sort_name.val())==""){
					pop_up_box.showMsg("请输入类别名称!");
				}else{
				$.post("../product/saveProductClass.do",$("#editForm").serialize(),function(data){
					if(data.success){
						pop_up_box.toast("保存成功", 1000);
		   				var type = 1;
						var cid = sort_id.val();
						var oldid=cid;
						if (cid == "") {
							cid = data.msg;
							type = 0;
						}
						 sort_id.val(cid);
						editUtils.tableShowSyn(type,getbtn(),function(tr,j,name) {
							if(name=="sort_name"){
								var val=$("#editForm input[name='sort_name']").val(); 
								tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(cid)+"'>"+val);
								var li=$(".parent_li input[value='"+oldid+"']").parent().parent();
								li.find("i").html(val);
								li.find("input").val(cid);
							}else if(name=="if_statistic"){
								tr.find("td:eq("+j+")").html($("#editForm select[name='if_statistic'] option:selected").text());
							}
						});
					}else{
						pop_up_box.showMsg(data.msg);
					}
				});
				}
			});
		}
}