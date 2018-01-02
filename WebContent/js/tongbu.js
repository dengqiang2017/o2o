$(function(){
	//获取待同步文件或文件夹名称
	var li=$("#tongbulist").html();
	$("#tongbulist").html("");
	$.get("login/getFileList.do",{"path":"tongbu"},function(data){
		if(data&&data.length>0){
			$.each(data,function(i,n){
				var item=$(li);
				$("#tongbulist").append(item);
				item.find("#srcFile").html(n);
			});
		}
	});
	$(".add").click(function(){
		var xli=$("<div class='col-lg-4'>"+$(this).parents(".col-lg-4").html()+"</div>");
		$("#xiangmulist").append(xli);
		xli.find("input").val("");
		xli.find(".add").click(function(){
			var xli=$("<div class='col-lg-4'>"+$(this).parents(".col-lg-4").html()+"</div>");
			$("#xiangmulist").append(xli);
		});
	});
	
	$("#beixuanh2").click(function(){
		if($("#beixuan").css("display")=="none"){
			$("#beixuan").show();
		}else{
			$("#beixuan").hide();
		}
	});
	$("#daitongbu").click(function(){
		if($("#xiangmulist").css("display")=="none"){
			$("#xiangmulist").show();
		}else{
			$("#xiangmulist").hide();
		}
	});
	$("#beixuan input").click(function(){
		$(this).select();
	});
	$("#save").click(function(){
		var xiangmus=$("#xiangmulist .col-lg-4");
		var tongbus=$("#tongbulist .col-lg-4");
		var list=[];
		for (var j = 0; j < xiangmus.length; j++) {
			var xiangmu=$(xiangmus[j]).find("input").val();
			for (var i = 0; i < tongbus.length; i++) {
				// xzdc/
				var src=$(tongbus[i]).find("#srcFile").html();
				var srcpath="tongbu/"+src;
				var dest=$.trim($(tongbus[i]).find("input").val());
				if(dest&&dest!=""){
					var destpath=xiangmu+"/"+dest+"/"+src;
					var json={"src":srcpath,"dest":destpath,"base":xiangmu};
					list.push(JSON.stringify(json));
				}
			}
		}
		if(list&&list.length>0){
			pop_up_box.postWait();
			$.post("login/fileSync.do",{
				"list":"["+list.join(",")+"]" 
			},function(data){
				pop_up_box.loadWaitClose();
				if(data.success){
					pop_up_box.toast("同步完成",1000);
				}else{
					pop_up_box.showMsg("同步失败,"+data.msg);
				}
			});
		}else{
			pop_up_box.showMsg("获取同步数据信息失败!");
		}
	});
	$("#piliang").change(function(){
		$("#tongbulist").find("input").val($(this).val());
	});
});