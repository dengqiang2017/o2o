$(function(){
	function getId(ids){
		var sort_id=ids[1].split("&");//console.debug(sort_id);
		var	idss=sort_id[0].split("=");//console.debug(idss);
		if (sort_id.length<2) {
			if (idss[0]=="sort_id") {
				return idss[1];
			}
		}
	}
    var corp_name=$("#fs");
    corp_name.bind("input propertychange blur",function(){
    	$("#jym").val(makePy(corp_name.val()));
    });
	var sort_id=getQueryString("sort_id");
	$.get("getSettlementInfo.do",{"sort_id":sort_id},function(data){
		pop_up_box.loadWaitClose(); 
		var ins=$("input");
		for (var i = 0; i < ins.length; i++) {
			var name=$(ins[i]).attr("name");
			var disabled=$(ins[i]).prop("disabled");
			$("input[name='"+name+"']").val(data[name]);
			if (disabled) {
				$("input[name='"+name+"']").prop("disabled",true);
			}
		}
		$("#dept_name").html(data.dept_name);
		$("#upper_settlement_name").html(data.upper_settlement_name);
		var sel=$("select");
		for (var i = 0; i < sel.length; i++) {
			var name=$(sel[i]).attr("name");
			if (data[name]) { 
				$("select[name='"+name+"']").val(data[name]);
			}
		}
	});
//	var ids=id.split("?");
//	if (ids&&ids.length>1) {
//		var sort_id=ids[1].split("&");//console.debug(sort_id);
//		var	idss=sort_id[0].split("=");//console.debug(idss);
//		if (sort_id.length<2) {
//			if (idss[0]=="sort_id") {
//				id=idss[1];
//				pop_up_box.loadWait(); 
//			}
//		}else if (sort_id.length>2) {
//			var info=sort_id[1].split("=");
//			if (info[0]=="info") {
//				$("input").prop("disabled",true);
//				$("select").prop("disabled",true);
//				$("textarea").prop("disabled",true);
//			}else if (info[0]=="next") {
//				 $("#upper_settlement_id").val(getId(ids));
//				 $("#upper_settlement_name").val(decodeURI(sort_id[2].split("=")[1]));
//				 $("#upper_settlement_name").prop("disabled",true);
//				 $("#dept_name").prop("disabled",true);
//			}
//		}
//	}
 $(".btn-success").click(function(){
	 var n = $(".btn-success").index(this);
	 var txt=$(this).parents(".form-group").find("label:eq(0)").text();
	 if (txt.indexOf("结算")>=0) {
		 $.get("getDeptTree.do",{"type":"settlement"},function(data){
			 $("body").append(data);
			 settlement.init(function(){
				 o2otree.selectInfo("upper_settlement_id", "upper_settlement_name");
				 $("#upper_settlement_name").prop("disabled",true);
				 $("#dept_name").prop("disabled",true);
			 });
		 });
	}else if(txt.indexOf("部门")>=0){
		pop_up_box.loadWait(); 
		$.get("getDeptTree.do",function(data){
			pop_up_box.loadWaitClose();
			$("body").append(data);
			dept.init(function(){
				o2otree.selectInfo("deptId", "dept_name");
			});
			$("#upper_settlement_name").prop("disabled",true);
			$("#dept_name").prop("disabled",true);
		});
	}
 });
	$(".btn-info").click(function(){
		var  jsss=$("#fs");
		if ($.trim(jsss.val())=="") {
			pop_up_box.showMsg("请输入结算方式名称!");
		}else{
//			$("#upper_settlement_name").prop("disabled",true);
//			$("#dept_name").prop("disabled",true);
			pop_up_box.postWait(); 
			$.post("saveSettlement.do",$("#editForm").serialize(),function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("数据保存成功返回列表页面",function(){
						$("form>input").val("");
						window.location.href="settlement.do"
					});
				}else{
					pop_up_box.showMsg("数据保存失败,错误:"+data.msg);
				}
			});
		}
	});
});