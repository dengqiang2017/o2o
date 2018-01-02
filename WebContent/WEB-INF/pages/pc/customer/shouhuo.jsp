<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
 <!DOCTYPE html>
<html>
<head lang="en">
<meta charset="UTF-8">
<meta http-equiv="U-XA-Compatible" content="IE-edge">
<meta http-equiv="Pragma" content="no-cache">
<!--[if lt IE 9]>
<script src="//cdn.bootcss.com/html5shiv/3.7.2/html5shiv.min.js"></script>
<script src="//cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
<![endif]-->
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title></title>
<%@include file="../res.jsp" %>
<link rel="stylesheet" href="../pc/css/huashen-shouhuo.css${requestScope.ver}">
 <script type="text/javascript" src="../jSignature/jSignature.min.js"></script>
 <script type="text/javascript" src="../pc/js/customer/shouhuo.js${requestScope.ver}"></script>
</head>
<style>
    @media(max-width: 770px){
        .margin{
            margin-top: 20px;
        }
        #signature{
    width: 100%;height: 300px;border: 1px solid #009805;text-align: center;
    }
    }
    @media(min-width: 770px){
        .margin{
            margin-top: 60px;
        }
    #signature{
    width: 100%;height: 230px;border: 1px solid #009805;text-align: center;
    }
    }
    .imgk>img{
      width:40px;
      height:40px;
    }
</style>
<body>
<!-------------------导航条---------------------->
<nav class="nav navbar-default navbar-fixed-top nav-out" role="navigation">
    <div class="navbar-header">
        <button type="button" class="collapsed navbar-toggle" data-toggle="collapse" data-target="#collapse" style="float: left;margin-top: 15px;margin-left: 22px">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href=""><img src="../pc/image/logo.png"  style="width: 46px;height: 45px;position: absolute;right: 30px;top:10px"></a>
    </div>
    <div class="collapse navbar-collapse" id="collapse">
        <ul class="nav navbar-nav navbar-left" style="margin-top: 15px;margin-bottom: 10px">
            <li class="dropdown" style="font-size: 16px">
                <span class="glyphicon glyphicon-triangle-right"></span>
                <a href="../customer.do" style="display: inline-block;padding: 10px 0">客户首页</a>
            </li>
            <li class="dropdown" style="font-size: 16px">
                <span class="glyphicon glyphicon-triangle-right"></span>
                <a href="../customer/myorder.do" style="display: inline-block;padding: 10px 0">我的订单</a>
            </li>
            <li class="dropdown" style="font-size: 16px">
                <span class="glyphicon glyphicon-triangle-right"></span>
                <a href="" style="display: inline-block;padding: 10px 0">确认收货</a>
            </li>
        </ul>
    </div>
</nav>
<!------------------------section-------------------->
<section class="section" style="margin-top:0">
    <div class="container">
        <div class="box-subject">
            <div class="box-subject-header">确认收货</div>
            <div class="box-subject-body">
            <input type="hidden" id="show" value="${requestScope.show}">
            <c:forEach items="${requestScope.listinfo}" var="item">
               <ul style="border: 1px solid #ddd;padding: 5px;">
               <li>订单号：${item.ivt_oper_listing}</li>
               <li>产品名称：<span class="itemname">${item.item_name}</span></li>
               <li>数量：<span class="itemname">${item.sd_oq}${item.casing_unit}</span></li>
               <li>型号：<span class="itemname">${item.item_type}</span></li>
               <li>规格：<span class="itemname">${item.item_spec}</span></li>
                    <li>
                            <div class="col-xs-2 col-sm-1 col-lg-1 imgk">
                                <img class="container-img" src="../pc/images/car.png">
                            </div>
                            <div class="col-xs-10 col-sm-11 col-lg-11 margin2"><span class="span-size">司机信息：<span class="hys">${item.HYS_SDd02021}</span>,车牌号:${item.Kar_paizhao_SDd02021}</span></div>
                        <div class="clear"></div>
                    </li>
               </ul>
            </c:forEach>
                    <ul>
                    <li>
                        <label>
                            <input type="checkbox" checked="checked">
                        </label>
                        <span>我已阅读<a style="color: #009805">客户收货确认须知</a></span>
                    </li>
                </ul>

<img src="${requestScope.img}" id="qianming" style="width: 100%;height: 230px;border: 1px solid #009805;text-align: center;line-height: 230px;margin-bottom: 30px;display: none;">
    <button type="button" class="btn btn-danger center-block btn-size qs_btn" style="margin-bottom: 20px">请签字验收</button>
        </div>
    </div>
</section>
    <div class="modal" id="mymodal2">
    <div class="modal-dialog" style="height:100%;margin:0;width:100%">
    <div class="modal-content" style="height:100%">
    <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
    <h4 class="modal-title">签字完成验收</h4>
    </div>
    <div class="modal-body">
    <div class="ys">
        <div id="qianshou">
    <div id="signature"></div>
    <button type="button" class="btn btn-default" onclick="$('#signature').jSignature('clear')" id="clear" style="margin-top: 20px">清除</button>
    </div>
    <button type="button" class="btn btn-danger center-block btn-size" style="margin-bottom: 20px" id="qrys">确认验收</button>
    </div>
    </div>
    <div class="modal-footer">
    <a class="btn btn-default gb2" data-dismiss="modal">关闭</a>
    </div>
    </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <div class="modal" id="mymodal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title">验收结果</h4>
            </div>
            <div class="modal-body">
                <h4 class="text-center">验收成功,您还可以继续</h4>
                <a href="pingjia.do" role="button" class="btn btn-success center-block" style="background-color: #009805;width: 50%">评价订单</a>
            </div>
            <div class="modal-footer">
                <a href="myorder.do" class="btn btn-default" >关闭</a>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
    <script type="text/javascript">
    <!--
    for (var i = 0; i < $(".hys").length; i++) {
		var hys=$($(".hys")[i]);
    var siji=$.trim(hys.html()).split(",");
	if(siji.length==2){
		var sijiphone=siji[1];
		sijiphone="<a href='tel:"+sijiphone+"'>"+sijiphone+"</a>"
		hys.html($.trim(siji[0]+","+sijiphone));
	}else{
		hys.html($.trim(n.HYS));
	}
	}
    $(".btn-default").unbind("click");
    $('.qs_btn').click(function(){
         $('#mymodal2').toggle();
    });
    var src=$("#qianming").attr("src");
    if(src){
    	$('.qs_btn').hide();
    }
    $('.close').click(function(){
    $('#mymodal2').hide();
    });
    $('.gb2').click(function(){
    $('#mymodal2').hide();
    });
    //-->
    </script>
</body>
</html>