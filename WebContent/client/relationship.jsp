<%@page import="com.qianying.controller.BaseController"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	BaseController.checkEmployeeLogin(request,response);
	BaseController.getVer(request);
	BaseController.getPageNameByUrl(request,"clientList.jsp");
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <meta name="keywords" content="客户拜访跟踪记录查询">
    <title>客户拜访-${sessionScope.systemName}</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="css/font-awesome.min.css">
    <link rel="stylesheet" href="css/contant.css${requestScope.ver}">
    <link rel="stylesheet" href="css/relationship.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <style type="text/css">
    .text-overflow {
		display:block;/*内联对象需加*/
		width:80px;
		word-break:keep-all;/* 不换行 */
		white-space:nowrap;/* 不换行 */
		overflow:hidden;/* 内容超出宽度时隐藏超出部分的内容 */
		text-overflow:ellipsis;/* 当对象内文本溢出时显示省略标记(...) ；需与overflow:hidden;一起使用。*/
		}
    </style>
</head>
<body>
      <div class="bgT"></div>
      <div class="container" style="margin-bottom: 20px">
          <div class="secition">
              <div class="secition_top">
                  <div class="clearfix">
                      <div class="pull-left">   
	                      <div class="secition-top" style="margin-bottom: 20px;font-size: 16px">
	                          <a href="../employee.do">${sessionScope.indexName}</a>&gt;
	                          <a href="clientList.jsp">${requestScope.pageName}</a>&gt;
	                          <span>客户拜访</span>
	                      </div>
                      </div>
                  </div>
                  <div class="secition_title clearfix">
                      <div class="pull-left">
                          <div class="head_portrait">
                        <img id="user_logo">
                    </div>
                          <div class="word clearfix">
                              <div class="col-md-12 col-xs-12 font26" id="clerk_name" style="text-overflow: ellipsis;white-space: nowrap;"></div>
                              <div class="col-md-12 col-xs-12 font14" style="margin-bottom: 0;padding-top: 14px" id="movtel"><a></a></div>
                              <div class="col-md-12 col-xs-12 font14" id="memo" style="display: none;">这里是客户信息，也可以记录一些客户的偏好，以及一些重要的客户信息</div>
                          </div>
                      </div>
                      <div class="pull-right">
                        	<select class="form-control" id="visitResult">
                                 <option value=""></option>
                                 <option value="意向">意向</option>
                                 <option value="强意向">强意向</option>
                             </select>
                      </div>
                  </div>
              </div>
                  <div class="secition_body">
                      <div class="secition_header clearfix">
                          <div class="pull-left">客户跟进记录<i class="fa fa-pencil-square-o" aria-hidden="true" style="margin-left: 50px">新建记录</i></div>
                          <div class="pull-right">
                              <div class="input-group" style="position: relative">
                                  <div class="input-group-addon">
                                      <i class="fa fa-search" aria-hidden="true" style="color: #9D9D9D;margin-right: 0"></i>
                                  </div>
                                  <input type="text" class="form-control" id="searchKey" maxlength="20" placeholder="请输入关键词" style="z-index: auto">
                                  <div class="checked"></div>
                                  <div class="data_box">
                                      <span class="demospan">开始日期</span>~<span class="demospanT">结束日期</span>
                                  </div>
                              </div>
                          </div>
                      </div>
                      <div class="secition_list">
                     <table class="table table-striped table-condensed">
		            <thead>
		            <tr>
		            <th data-name="xuhao">序号</th>
		            <th data-name="visitTime">拜访时间</th>
		            <th data-name="visitContent">拜访内容</th>
<!-- 		            <th data-name="visitDescribe">备注</th> -->
		            <th data-name="visitResult">拜访结果</th>
		            <th data-name="ivt_oper_listing" style="display: none;"></th>
		            <th data-name="caozuo">操作</th>
		            </tr>
		            </thead>
		            <tbody></tbody>
		            </table>
		             <nav aria-label="分页">
					  <div style="float: left;margin-top: -6px;" id="page">
					  第1页/共3页
					  </div>
					  <ul class="pager" style="cursor: pointer;">
					    <li><a><span class="glyphicon glyphicon-step-backward"></span>首页</a></li>
					    <li><a><span class="glyphicon glyphicon-backward"></span>上一页</a></li>
					    <li><a>下一页<span class="glyphicon glyphicon-forward"></span></a></li>
					    <li><a>末页<span class="glyphicon glyphicon-step-forward"></span></a></li>
					  </ul>
					</nav>
                      </div>
                   </div>
          </div>
      </div>
      <div class="modal fade" id="editModal">
          <div class="modal-dialog">
              <div class="modal-content">
                  <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                      <h4 class="modal-title">新建跟进记录</h4>
                  </div>
                  <div class="modal-body">
                      <div class="record_box">
                              <div class="box clearfix">
                                  <ul>
                                      <li><input id="visitTime" type="datetime" class="Wdate" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'});" style="width: 100%;height: 100%">
                                      </li>
                                      <li>
                                          <select class="form-control" id="visitResult">
                                              <option value="意向">意向</option>
                                              <option value="强意向">强意向</option>
                                          </select>
                                          <div id="ivt_oper_listing" style="display: none;"></div>
                                      </li>
                                      <li>
                                      <div id="fujian">
                                      </div>
                                      <div id="fujianItem" style="display: none;">
                                            <div class="libox">
                                               <div class="pic">
                                                   <img src="images/fujian.png" class="center-block">
                                               </div>
                                               <div class="character text-overflow" id="fujianName"></div>
                                               <div id="fujianPath" style="display: none;"></div>
                                               <div class="popup">
                                             <button type="button" class="btn btn-info" style="height: 30px;">查看</button>
                                     	  <button type="button" class="btn btn-danger" style="height: 30px;">删除</button>
                                     	  <button type="button" class="btn btn-default" style="height: 30px;">关闭</button>
                                           		</div>
                                            </div>
                                      </div>
                           <div class="libox">
                               <div class="pic">
                                   <img src="images/add (2).png" class="center-block">
                                   <a class="head_portrait_amend" style="display: none;" id="scxq"></a>
                                   <a class="head_portrait_amend" id="upload-btn">
                                       <input type="hidden" name="typeImg" id="filePath">
                                       <input type="file" class="ct input-upload" name="imgFile" id="imgFile" onchange="imgUpload(this);">
                                   </a>
                               </div>
                                   <div class="character">
                                       添加附件
                                   </div>
                          </div>
                                      </li>
                                  </ul>
                              </div>
                          <div class="box_second">
                              拜访记录 ：(请简要描述,详细内容请在外部文件编辑后上传附件)
                          </div>
                          <div class="box_bottom">
                              <textarea class="form-control" id="visitContent" maxlength="80"></textarea>
                          </div>
                      </div>
                      <button type="button" id="save" class="btn btn-primary center-block" style="width: 200px;margin-top: 50px">保存</button>
                  </div>
              </div><!-- /.modal-content -->
          </div><!-- /.modal-dialog -->
      </div><!-- /.modal -->
      <div class="modal fade" id="mymodalT">
          <div class="modal-dialog">
              <div class="modal-content">
                  <div class="modal-body clearfix">
                      <div class="col-lg-6" style="height: 310px;">
                          <div class="word">
                              开始日期<span class="demospan" id="beginDate"></span>
                          </div>
                          <div id="databoxF" style="width: 280px;height: 300px;"></div>
                      </div>
                      <div class="col-lg-6">
                          <div class="word">
                              结束日期<span class="demospanT" id="endDate"></span>
                          </div>
                          <div id="databoxT" style="width: 280px;height: 300px;"></div>
                      </div>
                  </div>
                  <div class="modal-footer">
                      <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                      <button type="button" class="btn btn-primary find">确定</button>
                  </div>
              </div><!-- /.modal-content -->
          </div><!-- /.modal-dialog -->
      </div><!-- /.modal -->
<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript">
<!--
var bwdate=true;
//-->
</script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/page.js${requestScope.ver}"></script>
<script type="text/javascript" src="js/relationship.js"${requestScope.ver}></script>
</body>
</html>