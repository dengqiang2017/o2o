$(function(){
	function getId(ids){
		var sort_id=ids[1].split("&");//console.debug(sort_id);
		var	idss=sort_id[0].split("=");//console.debug(idss);
		if (sort_id.length>2) {
			if (idss[0]=="sort_id") {
				return idss[1];
			}
		}
	}
    var corp_name=$("#fs");
    corp_name.bind("input propertychange blur",function(){
    	$("#jym").val(makePy(corp_name.val()));
    });
	var id=window.location.href;
	var ids=id.split("?");
	if (ids&&ids.length>1) {
		var sort_id=ids[1].split("&");//console.debug(sort_id);
		var	idss=sort_id[0].split("=");//console.debug(idss);
		if (sort_id.length<2) {
			if (idss[0]=="sort_id") {
				id=idss[1];
				$.get("getRegionalismInfo.do",{"sort_id":id},function(data){
					var ins=$("input");
					for (var i = 0; i < ins.length; i++) {
						var name=$(ins[i]).attr("name");
						var disabled=$(ins[i]).prop("disabled");
						$("input[name='"+name+"']").val(data[name]);
						if (disabled) {
							$("input[name='"+name+"']").prop("disabled",true);
						}
					}
					var sel=$("select");
					for (var i = 0; i < sel.length; i++) {
						var name=$(sel[i]).attr("name");
						if (data[name]) { 
							$("select[name='"+name+"']").val(data[name]);
						}
					}
				});
			}
		}else if (sort_id.length>2) {
			var info=sort_id[1].split("=");//console.debug();
			if (info[0]=="info") {
				$("input").prop("disabled",true);
				$("select").prop("disabled",true);
				$("textarea").prop("disabled",true);
			}else if (info[0]=="next") {
				 $("#regionalismId").val(getId(ids));
				 $("#regionalism_name_cn").val(decodeURI(sort_id[2].split("=")[1]));
			}
		}
	}
 $(".btn-success").click(function(){
	 var n = $(".btn-success").index(this);
	 if (n==0) {
		 $.get("getDeptTree.do",{"type":"regionalism"},function(data){
			 $("body").append(data);
			 $("#regionalism_name_cn").prop("disabled",true);
			 $("#dept_name").prop("disabled",true);
		 });
	}else{
		$.get("getDeptTree.do",function(data){
			$("body").append(data);
			dept.init(function(){
				$("#deptId").val(treeSelectId);
				$("#dept_name").html(treeSelectName);
			});
			$("#upper_settlement_name").prop("disabled",true);
			$("#dept_name").prop("disabled",true);
		});
	}
 });
	$(".btn-info").click(function(){
		var  jsss=$("#fs");
		if ($.trim(jsss.val())=="") {
			pop_up_box.showMsg("请输入行政区划名称!");
		}else{
			 $("#regionalism_name_cn").prop("disabled",true);
			 $("#dept_name").prop("disabled",true);
			$.post("saveRegionalism.do",$("#setForm").serialize(),function(data){
				if (data.success) {
					pop_up_box.showMsg("数据保存成功返回列表页面",function(){
						$("form>input").val("");history.go(-1);
//						window.location.href="regionalism.do"
					});
				}else{
					pop_up_box.showMsg("数据保存失败,错误:"+data.msg);
				}
			});
		}
	});
});