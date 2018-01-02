<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>德阳通威小猪动车-我要${requestScope.type}</title>
    <link rel="stylesheet" href="../pc/css/bootstrap.css">
    <link rel="stylesheet" href="../pc/css/buy.css${requestScope.ver}">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
</head>
<body>
<div style="width: 1px;height: 1px;">
    <img class="img-responsive center" src="../pc/images/3.png">
</div>
<div class="header navbar-fixed-top">
    <a href="operate.do" class="pull-left">返回</a>我要${requestScope.type}
    <div class="pull-right">
    <img class="img-responsive center-block" src="../pc/images/phone2.png" style="width:20px;margin-top:3px">
    </div>
</div>
<div class="body01">
    <div class="body01_top">
        <ul>
            <li class="active"><label>内杂猪</label><span style="display: none;">TY001</span></li>
            <li><label>外杂猪</label><span style="display: none;">TY002</span></li>
            <li><label>土猪</label><span style="display: none;">TY003</span></li>
            <div class="clearfix"></div>
        </ul>
        <div class="clearfix"></div>
    </div>
    <div class="body01_bottom">
        <div class="box">
            <ul>
                 <li class="active2"><label>崽猪</label><span style="display: none;">TY001</span></li>
                 <li><label>商品猪</label><span style="display: none;">TY002</span></li>
            </ul>
            <div class="clearfix"></div>
        </div>
    </div>
</div>
<div class="qh">
    <ul>
        <!--------------- 0------------------>
        <li>
             <div class="body2">
                 <ul>
                     <li>
                         <label>重量：</label>
                         <div class="right">
                             <div class="right01" style="width:100%">
                                 <select class="form-control"></select>
                             </div>
                         </div>
                         <div class="clearfix"></div>
                     </li>
                     <li>
                         <label>数量：</label>
                         <div class="right">
                             <div class="right01" style="margin-top:3px">
                                 <input type="number" value="80" class="form-control" maxlength="3" data-number="num">
                             </div>
                             <div class="right02"><span>头</span></div>
                         </div>
                         <div class="clearfix"></div>
                     </li>
                     <li style="position:relative">
                         <label>挂价：</label>
                             <div class="recommend">（建议挂价:<span>10.00</span>元）</div>
                         <div class="right">
                             <div class="right01">
                                 <input type="number" value="80" class="form-control" maxlength="7" data-number="num2">
                             </div>
                             <div class="right02"><span>元</span></div>
                         </div>
                         <div class="clearfix"></div>
                     </li>
                     <li class="show_date" style="border-bottom:1px solid #ddd;">
                         <label class="tb_label" style="margin-top:5px">挂价日期：</label>
                         <div class="right2">
                             <input type="date" class="Wdate form-control pos"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                         </div>
                         <div class="clearfix"></div>
                     </li>
                 </ul>
		<span style="display: none;" class="address"></span>
    <span style="display: none;" class="latlng"></span>
             </div>
    <div class="imglist"></div>
        </li>


        <!--------------- 1------------------>
        <li>
            <div class="body2">
                <ul>
                    <li>
                        <label>重量：</label>
                        <div class="right">
                            <div class="right01" style="width: 100%">
                                <select class="form-control">
                                    <option>90Kg~95Kg</option>
                                    <option>95Kg~100Kg</option>
                                    <option>105Kg~110Kg</option>
                                    <option>115Kg~120Kg</option>
                                </select>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li>
                        <label>数量：</label>
                        <div class="right">
                            <div class="right01" style="margin-top: 3px;">
                                <input type="number" value="80" class="form-control" maxlength="3" data-number="num">
                            </div>
                            <div class="right02"><span>头</span></div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li style="position:relative">
                        <label>挂价：</label>
    <div class="recommend">（建议挂价:<span>10.00</span>元）</div>
                        <div class="right">
                            <div class="right01">
                                <input type="number" value="80" class="form-control" maxlength="7" data-number="num2">
                            </div>
                            <div class="right02"><span>元</span></div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li class="show_date" style="border-bottom:1px solid #ddd;">
                        <label class="tb_label">挂价日期：</label>
                        <div class="right2">
                            <input type="date" class="Wdate form-control pos"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                        </div>
                        <div class="clearfix"></div>
                    </li>
                </ul>
		<span style="display: none;" class="address"></span>
    <span style="display: none;" class="latlng"></span>
            </div>
    <div class="imglist"></div>
        </li>


        <!--------------- 2------------------>
        <li>
            <div class="body2">
                <ul>
                    <li>
                        <label>重量：</label>
                        <div class="right">
                            <div class="right01" style="width: 100%">
                                <select class="form-control">
                                    <option>5Kg~10Kg</option>
                                    <option>10Kg~15Kg</option>
                                    <option>15Kg~20Kg</option>
                                    <option>20Kg~25Kg</option>
                                </select>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li>
                        <label>数量：</label>
                        <div class="right">
                            <div class="right01" style="margin-top: 3px;">
                                <input type="number" value="80" class="form-control" maxlength="3" data-number="num">
                            </div>
                            <div class="right02"><span>头</span></div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li style="position:relative">
                        <label>挂价：</label>
    <div class="recommend">（建议挂价:<span>10.00</span>元）</div>
                        <div class="right">
                            <div class="right01">
                                <input type="number" value="80" class="form-control" maxlength="7" data-number="num2">
                            </div>
                            <div class="right02"><span>元</span></div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li class="show_date" style="border-bottom:1px solid #ddd;">
                        <label class="tb_label">挂价日期：</label>
                        <div class="right2">
                            <input type="date" class="Wdate form-control pos"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                        </div>
                        <div class="clearfix"></div>
                    </li>
                </ul>
		<span style="display: none;" class="address"></span>
    <span style="display: none;" class="latlng"></span>
            </div>
    <div class="imglist"></div>
        </li>


        <!--------------- 3------------------>
        <li>
            <div class="body2">
                <ul>
                    <li>
                        <label>重量：</label>
                        <div class="right">
                            <div class="right01" style="width: 100%">
                                <select class="form-control">
                                    <option>90Kg~95Kg</option>
                                    <option>95Kg~100Kg</option>
                                    <option>105Kg~110Kg</option>
                                    <option>115Kg~120Kg</option>
                                </select>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li>
                        <label>数量：</label>
                        <div class="right">
                            <div class="right01">
                                <input type="number" value="80" class="form-control" maxlength="3" data-number="num">
                            </div>
                            <div class="right02"><span>头</span></div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li style="position:relative">
                        <label>挂价：</label>
    <div class="recommend">（建议挂价:<span>10.00</span>元）</div>
                        <div class="right">
                            <div class="right01">
                                <input type="number" value="80" class="form-control" maxlength="7" data-number="num2">
                            </div>
                            <div class="right02"><span>元</span></div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li class="show_date" style="border-bottom:1px solid #ddd;">
                        <label class="tb_label">挂价日期：</label>
                        <div class="right2">
                            <input type="date" class="Wdate form-control pos"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                        </div>
                        <div class="clearfix"></div>
                    </li>
                </ul>
		<span style="display: none;" class="address"></span>
    <span style="display: none;" class="latlng"></span>
            </div>
    <div class="imglist"></div>
        </li>
        <!----------------- 4------------------->
        <li>
            <div class="body2">
                <ul>
                    <li>
                        <label>重量：</label>
                        <div class="right">
                            <div class="right01" style="width: 100%">
                                <select class="form-control">
                                    <option>5Kg~10Kg</option>
                                    <option>10Kg~15Kg</option>
                                    <option>15Kg~20Kg</option>
                                    <option>20Kg~25Kg</option>
                                </select>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li>
                        <label>数量：</label>
                        <div class="right">
                            <div class="right01" style="margin-top: 3px;">
                                <input type="number" value="80" class="form-control" maxlength="3">
                            </div>
                            <div class="right02"><span>头</span></div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li style="position:relative">
                        <label>挂价：</label>
    <div class="recommend">（建议挂价:<span>10.00</span>元）</div>
                        <div class="right">
                            <div class="right01">
                                <input type="number" value="80" class="form-control" maxlength="7" data-number="num2">
                            </div>
                            <div class="right02"><span>元</span></div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li class="show_date" style="border-bottom:1px solid #ddd;">
                        <label class="tb_label">挂价日期：</label>
                        <div class="right2">
                            <input type="date" class="Wdate form-control pos"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                        </div>
                        <div class="clearfix"></div>
                    </li>
                </ul>
		<span style="display: none;" class="address"></span>
    <span style="display: none;" class="latlng"></span>
            </div>
    <div class="imglist"></div>
        </li>
        <!----------------- 5------------------->
        <li>
            <div class="body2">
                <ul>
                    <li>
                        <label>重量：</label>
                        <div class="right">
                            <div class="right01" style="width: 100%">
                                <select class="form-control">
                                    <option>90Kg~95Kg</option>
                                    <option>95Kg~100Kg</option>
                                    <option>105Kg~110Kg</option>
                                    <option>115Kg~120Kg</option>
                                </select>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li>
                        <label>数量：</label>
                        <div class="right">
                            <div class="right01" style="margin-top: 3px;">
                                <input type="number" value="80" class="form-control" maxlength="3" data-number="num">
                            </div>
                            <div class="right02"><span>头</span></div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li style="position:relative">
                        <label>挂价：</label>
    <div class="recommend">（建议挂价:<span>10.00</span>元）</div>
                        <div class="right">
                            <div class="right01">
                                <input type="number" value="80" class="form-control" maxlength="7" data-number="num2">
                            </div>
                            <div class="right02"><span>元</span></div>
                        </div>
                        <div class="clearfix"></div>
                    </li>
                    <li class="show_date" style="border-bottom:1px solid #ddd;">
                        <label class="tb_label">挂价日期：</label>
                        <div class="right2">
                            <input type="date" class="Wdate form-control pos"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                        </div>
                        <div class="clearfix"></div>
                    </li>
                </ul>
	<span style="display: none;" class="address"></span>
    <span style="display: none;" class="latlng"></span>
            </div>
    <div class="imglist"></div>
        </li>
    </ul>
    <c:if test="${requestScope.type=='预售'}">
	    <div class="filek">
	    <div class="file_box">
	    <a class="head_portrait_amend" style="display: none;" id="scxq"></a>
	    <a class="head_portrait_amend" id="upload-btn">
	    <input type="hidden" name="typeImg" id="filePath">
	    <input type="file" class="ct input-upload" name="imgFile" id="imgFile" onchange="imgUpload(this);">
	    </a>
	    </div>
	    <div class="clearfix"></div>
	    </div>
    </c:if>
</div>
<div id="itemimg" style="display: none;">
<div class="upload-img">
    <img class="img-responsive" src="../pc/images/pig.png" onclick="showuploadImg(this);">
    <div class="closebox">
    <img class="img-responsive" src="../pc/images/clos.png" onclick="$(this).parent().parent().remove();">
    </div>
    </div>
</div>
     <p class="p_style">（本次挂价3日内有效，逾期请重新填写）</p>

        <button class="guajia btn btn-danger center-block" id="save" style="width:200px;font-size:20px">立即挂价</button>

    <div class="modal fade" id="mymodal">
    <div class="modal-dialog" style="margin: 150px auto;width: 85%">
    <div class="modal-content">
    <div class="modal-header" style="display: none">
    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
    <h4 class="modal-title">模态弹出窗标题</h4>
    </div>
    <div class="modal-body" style="padding: 0">
    <div class="kefu" id="kefulist" style="opacity:1;">
    <input type="hidden" id="platformsHeadship" value="业务员">
    <h3>联系业务员</h3>
    <ul>
    <li><a href="tel:18224052021">业务员:邓强18224052021</a><div class="clear"></div></li>
    </ul>
    </div>
    </div>
    <div class="modal-footer" style="display: none">
    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
    <button type="button" class="btn btn-primary">保存</button>
    </div>
    </div>
    </div>
    </div>
    <div class="image-zhezhao" id="mymodal2" style="display:none;">
    <img class="center-block margin2" src="" style="max-width:80%;">
    </div>
    <div id="container" style="display:none; width: 500px;height: 500px;"></div>
    <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/o2od.js${requestScope.ver}"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script charset="utf-8" src="http://map.qq.com/api/js?v=2.exp&key=KDPBZ-MLJCV-A4TP2-UF7RY-NEU2E-MDF34"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/fileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/twysjs/buy.js${requestScope.ver}"></script>
<c:if test="${requestScope.type!='预售'}">
<script type="text/javascript">
<!--
$('.imglist').remove();
//-->
</script>
</c:if>
</body>
</html>