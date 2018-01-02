<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate"> 
<meta http-equiv="expires" content="0">
<title>订单跟踪流程参数设置-${requestScope.systemName}</title>
<!-- orderProcessSetup -->
<link rel="stylesheet" href="../pcxy/css/bootstrap.css">
<link rel="stylesheet" href="../pcxy/css/global.css${requestScope.ver}">
<link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
<style type="text/css">
 /*-----conmment-----*/
 *{font-family:'Microsoft YaHei',Arial,Helvetica,sans-serif;font-size: 18px;color: #000000;padding: 0;margin: 0}
 a{text-decoration: none}
 a:hover{text-decoration: none}
 ul{margin-bottom: 0}
 ul>li{list-style: none;}
 body{padding-top: 0 !important;}
 /*-----section-----*/
.ui_kuai{border: 2px solid blue;margin-bottom:10px}
.ui_item{border: 1px solid #518ab1;margin-top: 20px;border-radius:5px;position:relative;}
.ui_send{margin-right: 5px;}
.ctn-body{background-color:#ffffff;}
.copyright{margin-top:-19px}
 .one{border: 3px solid red;padding:10px}
 .marbot{margin-bottom:20px}
 .bg2{background-color: #083459;z-index:-1;position:fixed;left:0;top:0;bottom:0;right:0}
 .ctn-header{position: fixed;left: 0;top: 0;right: 0;z-index: 999;background-color: #fff;padding: 10px;border-bottom:1px solid #000000;padding-bottom:20px;}
 .header-right>button{width:100px;float: right;margin-right: 0;}
 .header-right{-moz-box-flex:3;-webkit-box-flex:3;box-flex:3;}
 .header-left{-moz-box-flex:1;-webkit-box-flex:1;box-flex:1;}
 .header-center{-moz-box-flex:3;-webkit-box-flex:3;box-flex:3;}
 .secition-header{display:-moz-box;display:-webkit-box;display:box;-moz-box-pack:justify;-webkit-box-pack:justify;-o-box-pack:justify;box-pack:justify;-moz-box-align:center;-webkit-box-align:center;-o-box-align:center;box-align:center;}
 .secition-header-left>span{color:#009899;font-size:16px;font-weight: 600;}
 .word{background-color:#009899;color:#ffffff;text-align:center;width:100px;height:29px;float:left;font-size: 15px;line-height: 29px;}
 .input{width:250px;height:29px;float:left}
 .input>input{height:29px;width:100%;text-align:center}
 .type{border:none;border-bottom: 1px solid #ddd;padding-bottom:10px;}
 .yy-box{margin-bottom: 20px;}
 .yg-box{margin-bottom: 20px;}
 .kh-box{margin-bottom: 20px;}
 .dd-box{margin-bottom: 20px;}
 .secition-body{padding:10px;display:none;z-index:999;position: fixed;left: 0;right: 0;top: 43px;background: #FFF;}
 .secition-body-yg{float:left}
 .secition-body-yg{margin-right:50px}
 .secition-body-kh{float:left}
 .secition-body-kh{margin-right:50px}
 .secition-body-dd{float:left}
 .secition-body-dd{margin-right:50px}
 .item-btn{position:absolute;right:-28px;top:41px;margin-right:0;-moz-border-radius-bottomleft:0;-moz-border-radius-bottomright:0;-webkit-border-radius-bottomright:0}
 .item-btnT{position:absolute;right:-28px;top:-1px;margin-right:0;-moz-border-radius-bottomleft:0;-moz-border-radius-bottomright:0}
 .ui_item_header{display:-moz-box;display:-webkit-box;display:box;-moz-box-pack:start;-webkit-box-pack:start;-o-box-pack:start;box-pack:start;-moz-box-align:center;-webkit-box-align:center;-o-box-align:center;box-align:center;padding:10px 0;border-bottom: 1px solid #dddddd;}
 .ui_input{width:133px;height:29px;float:left}
 .ui_input>input{width:100%;height:100%;text-align:center}
 .ui_word{float:left;margin-right:10px;font-size:14px;margin-top: 4px;}
 .konzh>div{float:left;margin-right:10px;}
 .konzh label{font-weight:100;font-size:14px;margin-bottom:0}
 .ui_down_ware label{font-weight:100;font-size:14px}
 .marked{padding:10px 0;background-color:#009899;color:#FFFFFF;width:111px}
 .ui_item_body{padding:5px;border-top:1px solid #dddddd;border-bottom:1px solid #dddddd}
 .ui_item_body_top{display:-moz-box;display:-webkit-box;display:box;-moz-box-pack:justify;-webkit-box-pack:justify;-o-box-pack:justify;box-pack:justify;-moz-box-align:center;-webkit-box-align:center;-o-box-align:center;box-align:center;margin-bottom:20px}
 .ui_item_body_bottom{display:-moz-box;display:-webkit-box;display:box;-moz-box-pack:justify;-webkit-box-pack:justify;-o-box-pack:justify;box-pack:justify;}
 .ui_send label{font-weight:100;font-size:14px;margin-bottom:0}
 .ui_salesperson label{font-weight:100;font-size:14px;margin-bottom:0}
 .ui_url label{font-weight:100;margin-bottom:0}
 .ui_content{}
 .ui_img{display:-moz-box;display:-webkit-box;display:box;-moz-box-orient:vertical;-webkit-box-orient:vertical;box-orient:vertical;}
 .ui_content>div{float:left;}
 .ui_content_word{margin-right:10px}
 .ui_img>label{font-weight:100;font-size:16px;color: #009899;}
 .ui_img>button>span{font-size:35px;}
 .ui_role label{font-weight:100;margin-bottom:0;font-size:14px;}
 .secition-right{cursor: pointer;position:fixed;right:14px;top:72px}
 .ctn-headerT{display:-moz-box;display:-webkit-box;display:box;-moz-box-pack:justify;-webkit-box-pack:justify;-o-box-pack:justify;box-pack:justify;-moz-box-align:center;-webkit-box-align:center;-o-box-align:center;box-align:center;}
 .two{position: fixed;left: 0;top: 50px;background: #fff;right: 0;z-index: 999;}
 .bg2{position:fixed;left:0;right:0;top:0;bottom:0;background-color:rgba(0,0,0,0.8);z-index:997;display:none}
 .btn-style{border-radius: 0;margin-bottom: 1px;border-left: none;}
 .btn-style>img{width:14px}
 .ui_down_ware{float: left;margin-left: 20px;}
 .konzh{margin-left:10px}
 .ui_img_word{margin-bottom:5px}
 .ui_url select{width:230px}
 .modal_ul>li{float: left;margin-right: 20px}
 .contont{min-height:50px}
 .list-group-item{margin-bottom:10px;position:relative}
 .list-group-item .pro-check{position: absolute;width: 30px;right: 0;top: 0;}
 .list-group-item h4{position: absolute;bottom: 0;background-color: rgba(0,0,0,0.7);color: #fff;right: 16px;left: 16px;padding: 10px 0;}
 .list-group-item img{margin: inherit;width: 100% !important;max-width: 100%;margin-bottom:0;height:200px}
    </style>
</head>
<body>
    <div class="bg2"></div>

        <div class="ctn-header">
          <div class="ctn-headerT">
             <div class="header-left"><a href="../employee.do">首页>订单流程自定义</a></div>
             <div class="header-center">
                <a class="btn btn-primary" href="../systemSet/headship.html">系统职务设置</a>
                <a class="btn btn-primary" href="../systemSet/weixinimg.html">消息图片上传</a>
                <a class="btn btn-primary" href="../systemSet/weixinnews.html">创建消息模板</a>
                <a class="btn btn-primary newtemp">同步微信服务号消息模板</a>
             </div>
             <div class="header-right">
                  <button type="button" class="btn btn-primary" id="save">保存</button>
             </div>
 </div>

   </div>
    <div class="secition-right">
    <img src="../images/check.png">
    </div>
    <div class="secition-body">
    <div class="secition-header-left" style="margin-bottom:10px">
    人员选择 ：<span>（消息中运营商，客户相关替代标准）</span>
    </div>
    <div class="yy-box">
    <div class="secition-body-yy">
    <div class="word">运营商</div>
    <div class="input"><input type="text" value="@comName" readonly="readonly"></div>
    <div class="clearfix"></div>
    </div>
    </div>
    <div class="yg-box">
    <div class="secition-body-yg">
    <div class="word">员工职务</div>
    <div class="input"><input type="text" value="@Eheadship" readonly="readonly"></div>
    <div class="clearfix"></div>
    </div>
    <div class="secition-body-yg">
    <div class="word">员工名称</div>
    <div class="input"><input type="text" value="@clerkName" readonly="readonly"></div>
    <div class="clearfix"></div>
    </div>
    <div class="clearfix"></div>
    </div>
    <div class="kh-box">
    <div class="secition-body-kh">
    <div class="word">客户职务</div>
    <div class="input"><input type="text" value="@headship" readonly="readonly"></div>
    <div class="clearfix"></div>
    </div>
    <div class="secition-body-kh">
    <div class="word">客户/供应商名称</div>
    <div class="input"><input type="text" value="@customerName" readonly="readonly"></div>
    <div class="clearfix"></div>
    </div>
    <div class="clearfix"></div>
    </div>
    <div class="dd-box">
    <div class="secition-body-dd">
    <div class="word">司机信息</div>
    <div class="input"><input type="text" value="@driver" readonly="readonly"></div>
    <div class="clearfix"></div>
    </div>
    <div class="secition-body-dd">
    <div class="word">订单编号</div>
    <div class="input"><input type="text" value="@orderNo" readonly="readonly"></div>
    <div class="clearfix"></div>
    </div>
    <div class="secition-body-dd">
    <div class="word">产品名称</div>
    <div class="input"><input type="text" value="@productName" readonly="readonly"></div>
    <div class="clearfix"></div>
    </div>
    <div class="secition-body-dd">
    <div class="input"><input type="text" value="点击进入查看详情" readonly="readonly"></div>
    <div class="clearfix"></div>
    </div>
    <div class="clearfix"></div>
    </div>
    </div>

 <div class="one marbot container" style="border:none;margin-top:73px">
      <div class="secition-header-left">
      流程制定 ：<span>（鼠标拖动变更流程顺序）</span>
      <label><input type="checkbox" id="usePurchase">启用采购订单</label>
      <label><input type="checkbox" id="usePPlan">启用生产计划</label>
      </div>
      <div id="list" class="ui_list">
            <div class="ui_item container" title="鼠标拖动进行位置交换">
                  <button type="button" onclick="$(this).parents('.ui_item').remove();" class="item-btn btn btn-danger" style="padding: 9px 5px;"><img src="../images/delete.png" style="width:15px;height:15px"></button>
                  <button type="button" class="item-btnT btn btn-primary" style="padding: 9px 5px;"><img src="../images/addT.png"></button>
                  <div class="ui_item_header">
                       <div class="ui_name">
                          <div class="ui_word">流程名称:</div>
                          <div class="ui_input"><input type="text" maxlength="20"><span style="display: none;"></span></div>
    <div class="ui_down_ware">
    <label><input type="radio" name="wareNum">减少库存数</label>
    </div>
                       </div>
                       <div title="页面控制部分" class="konzh">
                            <div class="ui_word">页面控制:</div>
                            <div class="ui_show">
                                 <label><input type="checkbox">下拉框中显示</label>
                            </div>
                            <div class="ui_operation" style="float: none;">
                                 <label><input type="checkbox">显示操作按钮</label>
                            </div>
                            <div class="ui_purchase_btn_show" >
                                 <label><input type="radio" name="purchase_btn_show">显示下采购订单</label>
                            </div>
                            <div class="ui_pPlan_btn_show">
                                 <label><input type="radio" name="pPlan_btn_show">显示下生产计划</label>
                            </div>
                            <div class="ui_comfirm_ware">
                                 <label><input type="radio" name="comfirm_ware">确认拉货库房</label>
                            </div>
                            <div class="ui_select_wuliu">
                                 <label><input type="radio" name="select_wuliu">选择物流方式</label>
                            </div>
                            <div class="ui_tihuoTime">
                                 <label><input type="radio" name="tihuoTime">预计提货时间</label>
                           </div>
                       </div>
                       <button type="button" class="btn btn-primary btn-sm updateOrder">更新订单</button>
                  </div>


<!--  员工部分 -->
               <div class="ui_employee ui_item_body">
                  <div class="ui_item_body_top">
                      <div class="marked">员工推送部分</div>
                    <div class="ui_send">
                         <label>
                              <input type="checkbox">发送
                         </label>
                    </div>
                    <div class="ui_salesperson">
                          <label>
                                 <input type="checkbox">通知业务员
                          </label>
                    </div>
                    <div class="ui_headship">
                         <div class="word">对应职务</div>
                         <div class="input">
                              <input type="text" maxlength="40" placeholder="最大长度40以“,”分割">
                         </div>
					    <button class="btn btn-default btn-sm btn-style" type="button">
					    <img src="../images/add.png">
					    </button>
                     </div>
	                <div class="ui_title">
                         <div class="word">消息标题</div>
                         <div class="input">
                              <input type="text" maxlength="100" placeholder="最大长度50">
                         </div>
                    </div>
    <button type="button" class="btn btn-primary btn-sm selectTemp">选择企业号模板</button>
 </div>
 <div class="ui_item_body_bottom">
    <div class="ui_url">
    <label>消息进入路径 ：</label>
    <select>
    <option value=""></option>
    <option value="/employee/collectionConfirm.do">客户收款确认界面</option>
    <option value="/employee/orderTracking.do">员工订单跟踪界面</option>
    <option value="/orderTrack/driverWaybillDetail.do?type=beihuo">库管备货界面</option>
    <option value="/orderTrack/driverWaybillDetail.do">库管装货界面</option>
    <option value="/saiyu/decompose.do">物流员打包界面</option>
    </select>
    </div>
    <div class="ui_content">
         <div class="ui_content_word">消息内容 ：</div>
         <div class="textarea">
         <textarea rows="2" cols="50" maxlength="200" placeholder="最大长度100"></textarea>
         </div>
    </div>

    <div class="ui_img">
         <div class="ui_img_word">消息图片 ：</div>
         <img style="width: 100px;height:47px" src="../weixinimg/msg.png">
         <%--<button class="btn btn-default btn-sm" type="button">--%>
                   <%--<img src="../images/add.png" style="width:38px">--%>
         <%--</button>--%>
     </div>

     </div>
      <div>
 <button type="button" class="btn btn-primary btn-sm selectServiceTemp">选择服务号消息模板</button>
 <span>已选择模板:<span class="ui_tempName"></span><span class="template_id" style="display: none;"></span></span>
 </div>
</div>
<!--  客户部分 -->
 <div class="ui_client ui_item_body">
          <div class="ui_item_body_top">
    <div class="marked">客户推送部分</div>
               <div class="ui_send">
                    <label>
                          <input type="checkbox" >发送
                    </label>
               </div>
               <div class="ui_role">
                    <label style="display:none">角色</label>
                          <select style="width:100px">
                               <option value="客户">客户</option>
                               <option value="司机">司机</option>
                               <option value="供应商">供应商</option>
                          </select>
               </div>
               <div class="ui_headship">
                    <div class="word">消息对应职务</div>
                    <div class="input">
                         <input type="text" maxlength="40" placeholder="最大长度40以“,”分割">
                    </div>
                    <button class="btn btn-default btn-sm btn-style" type="button">
                         <img src="../images/add.png">
                    </button>
               </div>
               <div class="ui_title">
                    <div class="word">消息标题</div>
                    <div class="input">
                         <input type="text" maxlength="100" placeholder="最大长度50">
                    </div>
               </div>
    <button type="button" class="btn btn-primary btn-sm selectTemp">选择企业号模板</button>
          </div>
 <div class="ui_item_body_bottom">
    <div class="ui_url">
    <label>消息进入路径</label>
    <select>
    <option value=""></option>
    <option value="/customer/myorder.do">客户订单跟踪界面</option>
    <option value="/saiyu/waybill.do">司机拉货界面</option>
    </select>
    </div>
 <div class="ui_content">
 <div class="ui_content_word">消息内容 ：</div>
 <div class="textarea">
 <textarea rows="2" cols="50" maxlength="200" placeholder="最大长度100"></textarea>
 </div>
 </div>
 <div class="ui_img">
 <div class="ui_img_word">消息图片 ：</div>
 <img style="width: 100px;height:47px" src="../weixinimg/msg.png">
 </div>
 </div>
 <div>
 <button type="button" class="btn btn-primary btn-sm selectServiceTemp">选择服务号消息模板</button>
 <span>已选择模板:<span class="ui_tempName"></span><span class="template_id" style="display: none;"></span></span>
 </div>
 </div>
 <div class="clearfix" style="float:none"></div>
 </div>
</div>
 </div> 
<!-- 职务选择 -->
<div id="modal_headship" style="display: none">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
 <div class="modal-dialog" id="zhiwuselectdialog">
     <div class="modal-content">
         <div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true" class="guanbizhiwu">&times;</span>
	<span class="sr-only">Close</span></button>
	<h4 class="modal-title">请选职务</h4>
</div>
<div class="modal-body" style="max-height:260px; overflow-y:scroll; padding: 10px;">
	<ul class="modal_ul">
	<li>
	<label>
	<input type="checkbox"><span class="ui_modal_headship">采购</span>
	</label>
	</li>
	</ul>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default guanbizhiwu" id="zhiwuClose">取消</button>
				<button type="button" class="btn btn-primary guanbizhiwu" id="zhiwuSelect">确定</button>
			</div>
		</div>
	</div>
</div>
</div>
<!-- 图片选择 -->
<div id="modal_imgSelect" style="display: none">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
 <div class="modal-dialog" id="zhiwuselectdialog">
     <div class="modal-content">
         <div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true" class="guanbizhiwu">&times;</span>
	<span class="sr-only">Close</span></button>
	<h4 class="modal-title">请选择订单跟踪中微信消息对应的图片</h4>
</div>
<div class="modal-body" style="max-height:260px; overflow-y:scroll; padding: 10px;">
	<ul class="modal_ul">
	<li>
	<label>
	<input type="radio" name="img">
	<span class="ui_modal_img_title">图片标题</span>
	<img src="" style="max-height: 100px;max-width: 100px;">
	</label>
	</li>
	</ul>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default guanbizhiwu" id="imgClose">取消</button>
				<button type="button" class="btn btn-primary guanbizhiwu" id="imgSelect">确定</button>
			</div>
		</div>
	</div>
</div>
</div>
<!-- 模板选择 -->
<div id="modal_tempSelect" style="display: none">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
 <div class="modal-dialog" id="zhiwuselectdialog">
     <div class="modal-content">
         <div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true" class="guanbizhiwu">&times;</span>
	<span class="sr-only">Close</span></button>
	<h4 class="modal-title">微信企业号消息模板选择</h4>
</div>
<div class="modal-body" style="max-height:474px; overflow-y:scroll; padding: 10px;">
    <ul class="list-group">
    <li class="list-group-item">
    <input type="radio" name="temp">
    <img src="../weixinimg/msg.png">
    <h4 class="ui_modal_title">123456</h4>
    <div>
    <label>消息进入路径</label>
    <span class='ui_modal_urlName'></span>
    <span class="ui_modal_url" style="display: none;"></span>
    </div>
    </li>
    </ul>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" id="tempClose">取消</button>
				<button type="button" class="btn btn-primary" id="tempSelect">确定</button>
			</div>
		</div>
	</div>
</div>
</div>
<div id="modal_selectServiceTemp" style="display: none">
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
 <div class="modal-dialog" id="zhiwuselectdialog">
     <div class="modal-content">
         <div class="modal-header">
	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true" class="guanbizhiwu">&times;</span>
	<span class="sr-only">Close</span></button>
	<h4 class="modal-title">微信服务号消息模板选择</h4>
</div>
<div class="modal-body" style="max-height:474px; overflow-y:scroll; padding: 10px;">
<div>
<input type="text" id="searchKey">
<button type="button" class="btn btn-info find">搜索</button>
<button type="button" class="btn btn-info newtemp">同步微信服务号消息模板</button>
</div>
	<div class="rows">
	     <div style="border: 1px solid #518ab1;" class="item">
		    <label><input type="radio" name="temp"><span class="ui_modal_title"></span>
		    <span class="template_id" style="display: none;"></span>
		    </label>
		    <div style="border: 1px solid #518ab1;">
		    <div>示例:</div>
		    <div class='ui_modal_example'></div>
		    </div>
	     </div>
	</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" id="tempClose">取消</button>
				<button type="button" class="btn btn-primary" id="selectServiceTemp">确定</button>
			</div>
		</div>
	</div>
</div>
</div>

<script type="text/javascript" src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
<script type="text/javascript" src="../js_lib/jquery-ui.js"></script>
<script type="text/javascript" src="../js/serializeJSON.js"></script>
<script type="text/javascript" src="../pcxy/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../js/common.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/popUpBox.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/fullTextSearch.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/manager/orderProcessSetup.js${requestScope.ver}"></script>
</body>
</html>