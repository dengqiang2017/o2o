var leave={
		//选择员工
		selectEmployee:function(){
			$(".selectEmployee").click(function(){
			   var item=$(this).parents(".item-card");
			   pop_up_box.loadWait(); 
			   $.get("../tree/getDeptTree.do",{"type":"employee","ver":Math.random()},function(data){
				   pop_up_box.loadWaitClose();
				   $("body").append(data);
				   employee.init(function(){
					    var tr=$(".modal").find(".activeTable");
					    item.find("dd:eq(0)").html(tr.find("a").html());       //名称
					    item.find("dd:eq(1)").html(tr.find("td:eq(2)").html());//部门名称
					    item.find("dd:eq(2)").html(tr.find("input").val());    //内码
				   });
			   });				
			});
		}
}

$(function(){
	leave.selectEmployee();
	//离职
	$("#leave").click(function(){
		var clerk_id_a=$.trim($(".item-msg:eq(0)").find("dd:eq(2)").html());
		if (clerk_id_a&&clerk_id_a!="") {
			$.post("saveLeave.do",{
				"clerk_id_a":clerk_id_a,
				"change_flag":"1"
			},function(data){
				if(data.success){
					pop_up_box.showMsg("确认离职成功!",function(){
						window.location.href = "workHandover.do";
					});
				}else{
					pop_up_box.showMsg("确认离职失败!"+data.msg);
				}
			});
		}else{
			pop_up_box.showMsg("请选择员工!");
		}
	});
	
	//离职交接
	$("#leaveTransfer").click(function(){
		var clerk_id_a=$.trim($(".item-msg:eq(0)").find("dd:eq(2)").html());
		var clerk_id_b=$.trim($(".item-msg:eq(1)").find("dd:eq(2)").html());
		if (clerk_id_a&&clerk_id_a!=""&&clerk_id_b&&clerk_id_b!="") {
			$.post("saveLeave.do",{
				"clerk_id_a":clerk_id_a,
				"clerk_id_b":clerk_id_b,
				"change_flag":"2"
			},function(data){
				if(data.success){
					pop_up_box.showMsg("确认交接成功!",function(){
						window.location.href = "workHandover.do";
					});
				}else{
					pop_up_box.showMsg("确认交接失败!"+data.msg);
				}
			});
		}else{
			pop_up_box.showMsg("请选择员工!");
		}
	});
	
	//换岗交接
	$("#shifHandover").click(function(){
		var clerk_id_a=$.trim($(".item-msg:eq(0)").find("dd:eq(2)").html());
		var clerk_id_b=$.trim($(".item-msg:eq(1)").find("dd:eq(2)").html());
		if (clerk_id_a&&clerk_id_a!=""&&clerk_id_b&&clerk_id_b!="") {
			$.post("saveLeave.do",{
				"clerk_id_a":clerk_id_a,
				"clerk_id_b":clerk_id_b,
				"change_flag":"3"
			},function(data){
				if(data.success){
					pop_up_box.showMsg("确认交接成功!",function(){
						window.location.href = "workHandover.do";
					});
				}else{
					pop_up_box.showMsg("确认交接失败!"+data.msg);
				}
			});
		}else{
			pop_up_box.showMsg("请选择员工!");
		}
	});
})