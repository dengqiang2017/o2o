<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.checkEmployeeLogin(request,response);
	BaseController.getVer(request);
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>营销文案编辑</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<style type="text/css">
.img_style {
    background-position: center center;
    background-repeat: no-repeat;
    background-size: 35px auto;
    border: 1px solid #ddd;
    height: 80px;
    margin-left: 25px;
    position: relative;
    width: 80px;
}
.form_group .form_input_lg {
    margin-left: 10px;
    padding: 2px 10px;
    width: 400px;
}
.form_label {
    display: inline-block;
    margin-top: 7px;
    text-align: right;
    width: 80px;
}
.form_group {
    overflow: hidden;
    padding: 5px;
    position: relative;
}
</style>
</head>

<body>
<div class="col-lg-4 form-horizontal">
<div class="form_group">
    <div class="col-lg-2">
    <label class="form_label" id="titlel">文章标题</label>
    </div>
    <div class="col-lg-10">
    <input type="text" class="form_input_lg form-control" style="" id="title" maxlength="60">
            </div>
    </div><div class="form_group">
    <div class="col-lg-2">
    <label class="form_label" id="gjcl">关键词</label>
        </div>
    <div class="col-lg-10">
    <input type="text" class="form_input_lg form-control" id="gjc">
        </div>
</div><div class="form_group">
    <div class="col-lg-2">
        <label class="form_label" id="timel">发布时间</label>
        </div>
    <div class="col-lg-10">
        <input type="text" class="form_input_lg form-control Wdate" onfocus="WdatePicker();">
        </div>
    </div>
    <div class="form_group">
        <div class="col-lg-2">
        <label class="form_label" id="publisherl">发布人</label>
            </div>
        <div class="col-lg-10">
        <input type="text" class="form_input_lg form-control" id="publisher" maxlength="20">
            </div>
    </div>
    <div class="form_group">
        <div class="col-lg-6">
        <label class="form_label">
       	 <input type="checkbox" id="zhiding">置顶                        
        </label>
            </div>
        <div class="col-lg-6">
        <label>
        	<input type="checkbox" id="show" checked="checked">是否对外显示
        </label>
        </div>
    </div>
    <div class="form_group">
    <div class="col-lg-2">
        <label class="form_label">封面图片</label>
    </div>
        <div class="col-lg-10">
            <div class="img_style">
                <input class="" type="file"  accept="image/*" name="imgFile" 
                id="imgFile" onchange="imgonlyUpload(this);" 
                style="position: absolute;width: 100%;height: 100%;opacity: 0;cursor: pointer;z-index: 199">
                <img id="imgUr" src="/images/sxt.png" style="z-index: 1;width: 100%;height: 100%;">
                <input type="hidden" id="filepath">
			</div>
      <span class="form_tips_gray">图片尺寸为：318*230</span>
          </div>
  </div>
  <div class="form_group">
    <div style="color: red;font-size: 12px;text-align: left;margin-left: 30px;">注意事项:
       <div style="color: red;font-size: 12px;">请编辑部分内容后先保存然后再操作,防止网络连接失败或其它情况导致编辑内容丢失!</div></div>
       <div style="text-align: center;">
	    <button type="button" id="save" class="btn btn-info">确定</button>
	    <button type="button" id="closedig" class="btn btn-default">取消</button>
    </div>
</div>
</div>
<div class="col-lg-8"> 
<script id="editor" type="text/plain" style="width:100%;height:600px;"></script>
</div>

 <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/public.js${requestScope.ver}"></script>
<script type="text/javascript" src='../js/ajaxfileupload.js${requestScope.ver}'></script>
<script type="text/javascript" src='../cmsjs/fileUpload.js${requestScope.ver}'></script>
<script type="text/javascript" src='js/edithtml.js${requestScope.ver}'></script>

<script type="text/javascript" charset="utf-8" src="/baidu/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="/baidu/ueditor.all.min.js"> </script>
<!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->
<!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->
<script type="text/javascript" charset="utf-8" src="/baidu/lang/zh-cn/zh-cn.js"></script>
<script type="text/javascript" src="/baidu/baiduedit.js${requestScope.ver}"></script>
</body>
</html>
