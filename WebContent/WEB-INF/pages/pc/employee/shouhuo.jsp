<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!--  <!DOCTYPE html> -->
<!-- <html> -->
<!-- <head lang="en"> -->
<!-- <meta charset="UTF-8"> -->
<!-- <meta http-equiv="U-XA-Compatible" content="IE-edge"> -->
<!-- <meta http-equiv="Pragma" content="no-cache"> --> 
<!-- <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"> -->
<!-- <title></title> -->
<%-- <%@include file="../res.jsp" %> --%>
<body>
<!-------------------导航条---------------------->
<link rel="stylesheet" href="../pc/css/huashen-shouhuo.css${requestScope.ver}">
</head>
<style>
    @media(max-width: 770px){
        .margin{
            margin-top: 20px;
        }
        #signature{
    width: 100%;height: 300px;border: 1px solid #009805;text-align: center;line-height: 500px;margin-bottom: 30px
    }
    }
    @media(min-width: 770px){
        .margin{
            margin-top: 60px;
        }
    #signature{
    width: 100%;height: 230px;border: 1px solid #009805;text-align: center;line-height: 230px;margin-bottom: 30px
    }
    }
    .imgk>img{
      width:40px;
      height:40px;
    }
</style>

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
                <a href="../employee.do" style="display: inline-block;padding: 10px 0">员工首页</a>
            </li>
            <li class="dropdown" style="font-size: 16px">
                <span class="glyphicon glyphicon-triangle-right"></span>
                <a href="../employee/orderTracking.do" id="ddlist" style="display: inline-block;padding: 10px 0">我的订单</a>
            </li>
            <li class="dropdown" style="font-size: 16px">
                <span class="glyphicon glyphicon-triangle-right"></span>
                <a href="" style="display: inline-block;padding: 10px 0">客户收货确认</a>
            </li>
        </ul>
    </div>
</nav>
<script type="text/javascript">
<!--
$("#ddlist").click(function(){
	$("#orderinfo").html("");
	$("#orderlist").show();
	return false;
});
//-->
</script>
<!------------------------section-------------------->
<section class="section" style="margin-top:0">
    <div class="container">
        <div class="box-subject">
            <div class="box-subject-header">已确认收货</div>
            <div class="box-subject-body">
            <c:forEach items="${requestScope.listinfo}" var="item">
               <ul style="border: 1px solid #ddd;padding: 5px;">
               <li>订单号：${item.ivt_oper_listing}</li>
               <li>产品名称：<span class="itemname">${item.item_name}</span></li>
               <li>数量：<span class="itemname">${item.sd_oq}${item.item_unit}</span></li>
               <li>型号：<span class="itemname">${item.item_type}</span></li>
               <li>规格：<span class="itemname">${item.item_spec}</span></li>
                    <li>
                            <div class="col-xs-2 col-sm-1 col-lg-1 imgk">
                                <img class="container-img" src="../pc/images/car.png">
                            </div>
                            <div class="col-xs-10 col-sm-11 col-lg-11 margin2"><span class="span-size">司机信息：${item.HYS_SDd02021},${item.Kar_paizhao_SDd02021}</span></div>
                        <div class="clear"></div>
                    </li>
               </ul>
            </c:forEach>
                <div>验收签字</div>
                <img src="${requestScope.img}" id="qianming" style="width: 100%;height: 230px;border: 1px solid #009805;text-align: center;line-height: 230px;margin-bottom: 30px;">
            </div>
        </div>
    </div>
</section>
<!-- </body> -->
<!-- </html> -->