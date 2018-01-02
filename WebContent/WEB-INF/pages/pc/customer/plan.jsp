<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>店面端-下计划</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
    <link rel="stylesheet" href="../pc/css/plan.css${requestScope.ver}">
</head>
<body>
     <div class="header">
     <a href="../pc/historyPlan.jsp${requestScope.ver}112" class="pull-left">历史</a>
         下计划
     <a href="../user/noticeInfoHistory.do" class="pull-right">公告
     <div class="dd"></div>
     </a>
     </div>
     <span id="planEndTime" style="display: none;">${requestScope.planEndTime}</span>
     <div id=item style="display: none;">
             <li>
             <p><span class="mc" id=item_name>白菜</span></p>
             <p><span class="dhl">订货量：<span id="dhNum"></span><span id=item_unit></span></span></p>
            <div class="gou_img">
            <span style="display: none;" id=item_id></span>
            <span style="display: none;" id=kucun></span>
                <img class="img-responsive" src="../pc/images/gou(1).png">
            </div>
        </li>
     </div>

     <div id=list></div>
      
     <div class="modal" id="mymodal">
         <div class="modal-dialog">
             <div class="modal-content">

                 <div class="modal-body">
                     <div class="tc center-block">
                         <div class="tc01">
                             <div class="col-xs-6">
                                 <img style="max-height: 150px;max-width: 150px;" class="img-responsive" onerror="this.src='../pc/images/shucai.jpg'">
                             </div>
                             <div class="col-xs-6">
                                 <button type="button" class="btn btn-success pull-right" >确认</button>
                                 <span id="msg"></span>
                                 <h3 style="text-align: center;margin-top: 37px" id=item_name>青菜</h3>
                                 <p id=item_detailspec_cn></p>
                             </div>
                             <div class="clearfix"></div>
                         </div>
                         <div class="tc03">
                             <p>建议零售价：<span id=lsj></span>元/<span class="casing_unit"></span></p>
							 <p>进价：<span id="item_cost"></span>元/<span class="casing_unit"></span></p>
                             <p>最大订货数：<span id=maxdhl></span><span class="item_unit"></span></p>
                         </div>
                         <div class="tc04">
                             <p>昨日订货量：<span id=zrdhl></span><span class="item_unit"></span></p>
                         </div>
                         <div class="tc05">
                             <div class="pull-left">
                                 <div class="nr">
                                     <div class="nr_left" style="font-size: 20px;width: 30%;padding: 18px 0;">库存</div>
                                     <div class="nr_right" style="width: 70%;padding: 18px 0;">
                                     <input type="number" pattern="^[0-9.]*$" data-num="num2" maxlength="10" id=kucun><span class="casing_unit">斤</span></div>
                                     <div class="clearfix"></div>
                                 </div>
                             </div>
                             <div class="pull-right">
                                 <div class="nr" style="height: 103px;width: 134px;">
                                     <div class="nr_left" style="padding: 0;">今<br>日<br>订<br>货<br>量</div>
                                     <div class="nr_right"><input type="number"  pattern="^[0-9.]*$" data-num="num2" maxlength="10" id=dhs><span class="item_unit">斤</span></div>
                                     <div class="clearfix"></div>
                                 </div>
                             </div>
                             <div class="clearfix"></div>
                         </div>
                     </div>
                 </div>
             </div>
         </div>
     </div> 
	 <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
	  <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
    <script type="text/javascript" src="../pc/js/customer/plan.js${requestScope.ver}"></script>
     <script type="text/javascript">
           $('.zz').click(function(){
               $('.zz').hide();
           }); 
     </script>
     <br>
</body>
</html>