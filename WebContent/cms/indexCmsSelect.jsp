<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.checkEmployeeLogin(request,response);
%>
<!DOCTYPE html>
<html>
<head lang="en">
<meta charset="utf-8">
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>细分行业模板选择</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../css/popUpBox.css">
</head>
<body>
<div class="container">
<h2>细分行业模板选择
<button type="button" class="btn btn-info" id="save">保存模板信息</button>
<a href="../employee.do" class="btn btn-info">返回运营管理平台</a>
</h2>
<table class="table table-bordered table-hover">
<thead>
<tr><th>模板名称</th><th>对应文件夹</th><th>操作</th></tr>
</thead>
<tbody>

</tbody>
</table>
</div>



<script type="text/javascript" src="/js_lib/jquery.11.js"></script>
<script type="text/javascript" src="/js/popUpBox.js"></script>
<script type="text/javascript">
<!--
$("tbody").html("");
$.get("../temp/getNewTemp.do",function(data){
	if(data&&data.length){
		$.each(data,function(i,n){
			var tr=$('<tr><td><input type="text" style="width: 100%;"></td><td><a id="tempName"></a></td><td><button type="button" class="btn btn-info" id="use">使用</button></td></tr>');
			$("tbody").append(tr);
			tr.find("td:eq(0)>input").val(n.name);
			tr.find("td:eq(1)>a").html(n.tempName);
			tr.find("td:eq(1)>a").attr("href","/cms/"+n.tempName);
			tr.find("td:eq(2)>#use").click({"tempName":n.tempName},function(event){
				pop_up_box.postWait();
				$.post("../temp/useTempIndex.do",{
					"tempName":event.data.tempName
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.toast("页面跳转中!");
						window.location.href=data.msg;
					} else {
						pop_up_box.showMsg("错误!" + data.msg);
					}
			});
		});
		});
	}
});
$("#save").click(function(){
	var trs=$("tbody tr");
	if(trs&&trs.length>0){
		var jsons=[];
		for (var i = 0; i < trs.length; i++) {
			var tr=$(trs[i]);
			var name=tr.find("td:eq(0)>input").val();
			var tempName=tr.find("td:eq(1)>a").html();
			var json={"name":name,"tempName":tempName};
			jsons.push(JSON.stringify(json));
		}
		pop_up_box.postWait();
		$.post("../temp/saveTempList.do",{
			"jsons":"["+jsons.join(",")+"]"
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("保存成功!");
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
	}else{
		pop_up_box.showMsg("没有获取到数据!");
	}
});
//-->
</script>
</body>
</html>