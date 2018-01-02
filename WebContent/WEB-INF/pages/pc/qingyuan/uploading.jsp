<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
<meta charset="UTF-8">
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<meta name="viewport"
	content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
<title>供应商-上传资料</title>
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../pc/css/uploading.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript"
	src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/gys/uploading.js${requestScope.ver}"></script>
<style type="text/css">
#upload-btn{
  position: relative;
  display: inline-block;
}

#upload-btn>input{
  display: block;
  position: absolute;
  z-index: 2;
  width: 100%;
  height: 100%;
  left: 0;
  top: 0;
  opacity: 0;
  filter: alpha(opacity=0);
  cursor: pointer;
}
.showimg img{
max-height: 300px;
max-width: 300px;
}
</style>
</head>
<body>
	<div class="header">
		<a href="javascript:history.back(1)" class="pull-left">返回</a> <a
			href="detail.do" class="pull-right">订单</a> 上传资料
	</div>
	<div class="body">
		<div id="item" style="display: none">
			<li>
				<div class="box">
					<div class="box01">
						<span
							style="font-weight: bold; font-size: 20px; margin-right: 10px"
							id="item_name">青菜</span> 昨日订货量：<span style="color: #BDBDBD;"
							id="num">100</span><span class="item_unit"></span>
					</div>
					<div class="box02">
						<div class="pull-left" style="width: 97px; position: relative" id="upload-btn">
							<img class="img-responsive" src="../pc/images/addimg.png" onerror="this.src='../pc/images/addimg.png'">
							<p>上传图片</p>
							<a class="head_portrait_amend"> 
							<span id="filepath" style="display: none;"></span>
							</a>
						</div>
						<div class="pull-right">
							<div class="blue">
								<div class="blue_left">
									库<br> 存
								</div>
								<div class="blue_center">
									<input type="number" maxlength="3" data-num="num2">
								</div>
								<div class="blue_right item_unit"></div>
								<div class="clearfix"></div>
							</div>
							<div class="blue" style="margin-top: 10px">
								<div class="blue_left">
									单<br> 价
								</div>
								<div class="blue_center">
									<input type="number" maxlength="3" data-num="num2">
								</div>
								<div class="blue_right"
									style="line-height: inherit; font-size: 12px;">
									元<br>/<br>
									<span class="item_unit"  style="color: #ffffff"></span>
								</div>
								<div class="clearfix"></div>
							</div>
						</div>
						<a class="btn btn_a">确认并上传</a>
						<div class="clearfix"></div>
					</div>
					<div class="date_box">
						<span>2016.08.06</span>
					</div>
					<div class="po_img" id="mflag"></div>
				</div>
			</li>
		</div>
		<ul>
		</ul>
	</div>
	
	<div class="modal-cover-first" style="display:none;"></div>
<div class="modal-first" style="display:none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span>
				<span class="sr-only">Close</span></button>
				<h4 class="modal-title">请上传产品图片</h4>
			</div>
			<div class="modal-body" style="overflow-y:scroll; padding: 10px;">
			<a id="upload-btn" class="btn btn-primary">上传图片
			<input type="file" name="imgFile" id="imgFile" onchange="imgUpload(this);">
			<span id="filepath" style="display: none;"></span>
			</a>
			<button type="button" id="sctx"  class="btn btn-primary" style="height: 40px;width: 200px;">上传图片</button>
			<div class="showimg" style="text-align: center; ">
			<img src="">
			</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
				<button type="button" class="btn btn-primary" id="scpzpc">确定</button>
			</div>
		</div>
	</div>
</div>
	
</body>
</html>