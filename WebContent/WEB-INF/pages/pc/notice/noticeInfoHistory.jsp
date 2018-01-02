<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>公告列表</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
    <link rel="stylesheet" href="../pc/css/notice.css">
    <link rel="stylesheet" href="../pc/css/issue.css">
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
    <script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/popUpBox.js"></script>
    <script type="text/javascript" src="../pc/js/notice/noticeinfo.js${requestScope.ver}"></script>
    <c:if test="${sessionScope.userInfo!=null}">
    <c:if test="${sessionScope.auth.addNotice!=null}">
    <script type="text/javascript" src="../pc/js/notice/saveNotice.js${requestScope.ver}"></script>
    </c:if>
    </c:if>
</head>
<body>
<div id=listpage>
     <div class="header">
         <a class="pull-left" href="javascript:history.back(1)">返回</a>
         公告列表
         <c:if test="${sessionScope.userInfo!=null}">
         <c:if test="${sessionScope.auth.addNotice!=null}">
         <a class="pull-right" id=issue>发布</a>
         </c:if>
         </c:if>
     </div>
         <span style="display: none;" id=clerkId>${sessionScope.userInfo.clerk_id}</span>
     <c:if test="${sessionScope.userInfo!=null}">
         <c:if test="${sessionScope.auth.delNotice!=null}">
         <span style="display: none;" id=delNotice></span>
         </c:if></c:if>
     <c:if test="${sessionScope.userInfo!=null}">
         <c:if test="${sessionScope.auth.delAllNotice!=null}">
         <span style="display: none;" id=delAllNotice></span>
         </c:if></c:if>
     <c:if test="${sessionScope.userInfo!=null}">
         <c:if test="${sessionScope.auth.editNotice!=null}">
         <span style="display: none;" id=editNotice></span>
         </c:if></c:if>
     <c:if test="${sessionScope.userInfo!=null}">
         <c:if test="${sessionScope.auth.editAllNotice!=null}">
         <span style="display: none;" id=editAllNotice></span>
         </c:if></c:if>
     
     <div class="body" id=list>
     </div>
     <div id=item style="display: none;">
     <div class="body01">
            <div class="body01_top" id=notice_title></div>
            <div class="body01_bottom">
                <p style="text-align: right" id=notice_time></p>
                <p id=notice_content> </p>
                <p style="text-align: right" id=clerk_name></p>
                <p style="text-align: right" id=d_e><button type="button"  class="del btn btn-primary">删除</button>
                <button type="button" class="edit btn btn-primary">修改</button>
                </p>
            </div>
        </div>
     </div>
</div>

<div id=pushpage style="display: none;">
     <div class="header">
         <a class="pull-left">取消</a>
         公告发布
         <a class="pull-right" id=save>确认</a>
     </div>
     <div class="body">
         <div class="body_top"><span id=seeds_id style="display: none;"></span>
               <label>标题：</label>
              <input type="text" placeholder="" class="form-control">
             <div class="clearfix"></div>
         </div>
         <div class="body_bottom">
             <textarea rows="8" class="form-control" placeholder="输入内容...."></textarea>
         </div>
     </div>
</div>
<br>
</body>
</html>