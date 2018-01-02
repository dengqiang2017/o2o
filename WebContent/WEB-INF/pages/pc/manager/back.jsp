<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>系统提示</title>
<style>
	body{
		background-color: #eee;
	}

	h3{
		text-align: center;
		width: 240px;
		margin: 100px auto;
		line-height: 40px;
		color: #858585;
	}

	a{
		display: block;
		text-decoration: none;
		color: #296ddd;
		margin: auto;
		width: 100px;
		font-size: 14px;
		line-height: 30px;
		height: 30px;
		padding: 0 10px;
		border: 1px solid #296ddd;
		text-align: center;
		border-radius: 1.5em;
	}

	a:hover{
		background-color: #296ddd;
		color: #fff;
	}
</style>
</head>
<body>
<h4>您选择的数据项为系统默认数据,不能删除与修改!</h4>
<a href="javascript:history.go(-1);" >点击返回</a>
</body>
</html>