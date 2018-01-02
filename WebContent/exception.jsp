<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>资源异常页面</title>
</head>
<body>
<div class="content clearfix" id="error_default" style="display: block; ">
        <div class="error-box clearfix">
            <p id="h_default"><strong class="txt2">糟糕！你的资源无法访问。</strong>（错误类型：<span id="error_type">资源错误</span>）</p>
            <p id="h_notfound" style="display: none; "><strong class="txt1">您访问的网页不存在。</strong>（错误类型：<span>505</span>）</p>
            <p>
                <a class="refresh-btn" id="button_refresh">刷新网页</a>
            </p>
        </div>
  </div>
</body>
</html>