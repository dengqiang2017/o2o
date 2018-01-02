<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@include file="../res.jsp" %>
<link rel="stylesheet" href="../switch/bootstrap-switch.min.css">
<link rel="stylesheet" href="../css/proinfo.css${requestScope.ver}">
<style type="text/css">
.infodiv{margin-left: 40px;}
.tabs-content{margin-bottom: 40px;}
</style>
</head>
<body>
	<div class="bg"></div>
<%@include file="../header.jsp" %>
    <%@include file="selClient.jsp" %>
    <div class="container">
      <div class="ctn-fff box-ctn">
        <div class="box-head">
<!--           客户信息 -->
          <%@include file="showSelectClient.jsp" %>
          <a id="upload-btn" class="btn btn-danger btn-sm m-t-b">导入
<input type="file" id="xlsquotationSheet" name="xlsquotationSheet" onchange="excelImport(this,'quotationSheet');"></a>
<button type="button" class="btn btn-danger btn-sm m-t-b excel" onclick="excelExport('quotationSheet');">导出</button>
<span>每页显示记录数:</span><select id="rows">
<option value="10">10</option>
<option value="20">20</option>
<option value="30">30</option>
<option value="50">50</option>
<option value="80">80</option>
<option value="100">100</option>
</select>
        </div> 
      </div>
    </div>
    <div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
        <%@include file="../find.jsp" %>
        <span id="headship" style="display: none;">${sessionScope.userInfo.headship}</span>
        <span id="clerk_id" style="display: none;">${sessionScope.userInfo.clerk_id}</span>
        <div class="box-body">
            <div class="tabs-content" style="display: block;">
          		<div class="ctn">
              <div id="list"></div>
              </div>
                 <div class="ctn">
          <button class="btn btn-add" type="button">点击加载更多</button>
          </div>
          </div>
            <div class="tabs-content" style="display: none;">
              		<div class="ctn">
              		<label>
              		<input type="radio" name="comfrim" value="" checked="checked">全部
              		</label>
              		<label>
              		<input type="radio" name="comfrim" value="0">未审核
              		</label>
              		<label>
              		<input type="radio" name="comfrim" value="1">已审核
              		</label>
              		<c:if test="${sessionScope.auth.add_del!=null}">
              		  <button type="button" class="btn btn-danger" id="deladd">删除</button>
              		</c:if>
              		<c:if test="${sessionScope.auth.add_confirm!=null}">
              		  <button type="button" class="btn btn-danger" id="confirmAll">审核全部</button>
              		  <button type="button" class="btn btn-danger" id="noticeAddedConfirmed">通知业务员报价单已审核</button>
              		  </c:if>
              		  <button type="button" class="btn btn-danger btn-sm m-t-b print">打印选中二维码</button>
              		  <button type="button" class="btn btn-danger btn-sm m-t-b" id="noticeComfirm">通知审核</button>
              		</div>
               <div id="list"></div>
          <div class="ctn">
            <button class="btn btn-add" type="button">点击加载更多</button>
          </div>
              </div>
          </div>
        </div>
      </div>
      <span id='urlPrefix' style="display: none;">${requestScope.urlPrefix}</span>
      <span id='com_id' style="display: none;">${requestScope.com_id}</span>
      <%@include file="printerweima.jsp" %>
    <div class="back-top" id="scroll"></div>
    <div class="cover" style="display: block;"></div>
    <div class="footer">员工:<a id="clerkName">${sessionScope.userInfo.personnel.clerk_name}</a>
      <span id="clerk_id" style="display: none;">${sessionScope.userInfo.clerk_id}</span><span class="glyphicon glyphicon-earphone"></span>
      <div class="btn-gp">
        <label><input type="checkbox" id="allcheck">全选</label>
        <button class="btn btn-info" id="add">提交</button>
        <a href="javascript:history.go(-1);" class="btn btn-primary">返回</a>
      </div>
    </div>
    <div id="item" style="display: none;">
              <div class="col-xs-12 col-sm-12 col-md-6 dataitem">
                <span id="item_id" style="display: none;"></span>
                <input type="hidden" id="sid">
                <%@include file="proinfo.jsp" %>
                <div style="border-bottom: 1px solid aqua;">
                    <div class="col-xs-12 col-sm-12 col-md-12">
                      <label for="">客户物料对应名称</label>
                      <input type="text" id="client_item_name" maxlength="25" style="width: 75%;">
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                      <label for="">客户物料对应编码</label>
                      <input type="text" id="peijian_id" maxlength="20" style="width: 75%;">
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12" style="display: none;">
                      <label for="">促销时间</label>
                      <input type="date" name="discount_time_begin" id="discount_time_begin" class="p-xs Wdate" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                      <span class="p-xs-m">~</span>
                      <input type="date" name="discount_time" id="discount_time" class="p-xs Wdate"  onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12" style="display: none;">
                      <label for="">促销时间</label>
                      <input type="date" name="discount_time_begin" id="discount_time_begin" class="p-xs Wdate" onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                      <span class="p-xs-m">~</span>
                      <input type="date" name="discount_time" id="discount_time" class="p-xs Wdate"  onFocus="WdatePicker({dateFmt:'yyyy-MM-dd'})">
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-12" style="display: none;">
                      <label for="">标价范围</label>
                      <input type="number" name="sd_unit_price_DOWN" maxlength="17" data-num="num2">
                      <span class="p-xs-m" style="margin-top:3px">~</span>
                      <input type="number" name="sd_unit_price_UP" maxlength="17" data-num="num2">
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-6">
                      <label for="">对外标价</label>
                      <input type="number" id="price_display" readonly="readonly" name="price_display" maxlength="17" data-number="n">
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-6">
                      <label for="">其它折扣</label>
                      <input type="number" id="price_otherDiscount" name="price_otherDiscount" maxlength="17" data-number="n">
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-6">
                      <label for="">现金折扣</label>
                      <input type="number" id="price_prefer" readonly="readonly" name="price_prefer" maxlength="17" data-number="n">
                    </div>
                    <div class="col-xs-12 col-sm-6 col-md-6">
                      <label for="" style="color: red;">*结算单价</label>
                      <input type="number" class="p-xs" id="sd_unit_price" readonly="readonly" name="sd_unit_price" maxlength="17" data-number="n">
                    </div> 
<!--                     //////////////////// -->
<!--                     <div class="col-xs-12 col-sm-12 col-md-6" style="display: ;"> -->
<!--                       <label for="">是否促销</label> -->
<!-- 					  <input type="checkbox" name="discount_ornot" id="discount_ornot" data-on-text="是" data-off-text="否"> -->
<!--                     </div>  -->
                    <div class="col-xs-12 col-sm-12 col-md-6" style="display: ;">
                      <label><input type="checkbox" name="discount_ornot" id="discount_ornot">是否促销</label>
                    </div> 
                    <div class="col-xs-12 col-sm-12 col-md-6" style="display: ;">
                      <label for="">新品置顶排列顺序</label>
                      <input type="tel" maxlength="2" id="no" value="99" data-num="num" style="width: 40px;">
                    </div>
                    <div class="col-xs-12 col-sm-12 col-md-6" style="display: ;">
                      <label for="">状态</label>
                      <span id="m_flag"></span>
                    </div>
<!-- 			/////////////////////// -->
                    <c:if test="${requestScope.moreMemo}">
                    <div>
                   		<button type="button" class="btn btn-success" id="moreMemo">特殊工艺备注</button>
                   		<span id="c_memo"></span>
                   		<span id="memo_color"></span>
                   		<span id="memo_other"></span>
                    </div>
                    </c:if>
                    <div class="col-xs-12 col-sm-12 col-md-12">
                      <label for="">报价单号</label>
                      <span id="ivt_oper_listing"></span>
                      <c:if test="${sessionScope.auth.add_edit!=null}">
	                   	<button type="button" class="btn btn-success" id="editPrice" style="display: none;">保存修改</button>
                      </c:if>
                      <c:if test="${sessionScope.auth.add_confirm!=null}">
              		  <button type="button" class="btn btn-danger" id="confirm">审核</button>
              		</c:if>
              		<c:if test="${sessionScope.auth.add_not_confirm!=null}">
              		  <button type="button" class="btn btn-danger" id="noConfirm">弃审</button>
              		</c:if>
                    </div> 
                  </div>
              </div>
</div>
<!-- <script src="../switch/bootstrap-switch.min.js"></script> -->
<script src="../js/o2od.js${requestScope.ver}"></script>
<script src="../js/o2otree.js${requestScope.ver}"></script>
<script type="text/javascript" src="../js/ajaxfileupload.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/weixin/weixin.js${requestScope.ver}"></script>
<script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="../pc/js/basicDataImportExport.js"></script>
<script type="text/javascript" src="../js_lib/jquery.jqprint.js"></script>
<!-- <script type="text/javascript" src="../js_lib/jquery.PrintArea.js"></script> -->
<script type="text/javascript" src="../js_lib/jquery-migrate-1.1.0.js"></script>
<script type="text/javascript" src="../pc/js/employee/selClient.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/productpage.js${requestScope.ver}"></script>
<script type="text/javascript" src="../pc/js/employee/add.js${requestScope.ver}"></script>
<!-- <OBJECT ID="jatoolsPrinter" CLASSID="CLSID:B43D3361-D975-4BE2-87FE-057188254255" codebase="jatoolsP.cab#version=1,2,0,2"></OBJECT>    -->
<script type="text/javascript">
<!--
function doPrint(how) {
            //打印文档对象
            var myDoc = {
                documents: document,    // 打印页面(div)们在本文档中
                copyrights: '杰创软件拥有版权  www.jatools.com'         // 版权声明必须
            };
            // 调用打印方法
            if (how == '打印预览...')
                jatoolsPrinter.printPreview(myDoc);   // 打印预览

            else if (how == '打印...')
                jatoolsPrinter.print(myDoc, true);   // 打印前弹出打印设置对话框

            else
                jatoolsPrinter.print(myDoc, false);       // 不弹出对话框打印
        }
//-->
    </script>
</body>
</html>