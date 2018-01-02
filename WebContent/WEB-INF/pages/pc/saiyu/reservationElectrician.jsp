<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <link rel="stylesheet" type="text/css" href="../pc/saiyu/repair-fujin.css${requestScope.ver}">
<div class="section-1">您好:<a href="javaScript:void(0);">${sessionScope.customerInfo.clerk_name}</a>&emsp;
用户中心-><span><a href="javaScript:backlist();">我的订单</a>-></span><span>预约电工</span></div>
<div class="container-header">
    <div class="container-header-center center-block">
        <label class="label-right">预约方式</label>
        <select class="select-border">
            <option value="0">提前预约</option>
            <option value="1">实时预约电工</option>
        </select>
    </div>
</div>
<div class="center-div">
    <h3 class="center-h3">完善个人信息</h3>
    <form id="diangongform">
    <input type="hidden" value="${requestScope.orderNo}" name="ivt_oper_listing">
    <input type="hidden" value="${requestScope.upper_customer_id}" name="customer_id">
    <div class="input-group">
        <label class="input-group-addon" style="background-color: #077FBC;color: #FFFFFF">联系人</label>
    <input type="text" class="form-control" placeholder="请输入您的姓名" maxlength="20" name="lxr" value="${requestScope.info.lxr}">
</div>
<div class="input-group fl">
    <label class="input-group-addon" style="background-color: #077FBC;color: #FFFFFF">联系电话</label>
    <input type="text" class="form-control" placeholder="请输入您的电话" maxlength="11" data-num="num" name="movtel" value="${requestScope.info.movtel}">
</div>
<h3 class="center-h3">预约电工</h3>
<div class="input-group fl">
    <label class="input-group-addon" style="background-color: #077FBC;color: #FFFFFF">安装时间</label>
  <input type="date" class="form-control Wdate" placeholder="请输入方便您服务的时间"  value="${requestScope.info.anz_datetime}"
  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'})" name="anz_datetime">
</div>
<div class="input-group fl">
    <label class="input-group-addon" style="background-color: #077FBC;color: #FFFFFF;">服务地点</label>
  <input type="text" class="form-control" placeholder="手动输入服务地点" value="${requestScope.info.address}" name="address">
    </div>
    </form>
    
    <h4 class="color-h4">提前预约信息之后请保证服务期间手机畅通，以便安装电工与您取得联系。</h4>
    <button type="button" class="btn btn-primary btn-block" id="tiqian">提交</button>
    <script type="text/javascript">
    $(".select-border").change(function(){
    	if ($(this).val()=='1') {
			pop_up_box.loadWait();
			$.get("electricianNear.do",{
				"orderNo":"${requestScope.orderNo}"
			},function(data){
				pop_up_box.loadWaitClose();
				$('a[data-title="title"]').html("实时预约电工");
				$("#orderlist").hide();
				$("#itempage").html(data);
			});
		}
    });
    $("#tiqian").click(function(){
		var anz_datetime=$("input[name='anz_datetime']").val();
		if(anz_datetime&&anz_datetime!=""){
		pop_up_box.loadWait();
		$.get("diangongpay.do",{
			"anz_datetime":anz_datetime,
			"orderNo":"${requestScope.orderNo}"
		},function(data){
			pop_up_box.loadWaitClose();
			$('a[data-title="title"]').html("我的订单-提前预约电工");
			$("#orderlist").hide();
			$("#itempage").html(data);
			$("a[data-head]").unbind("click");
			$("a[data-head]").click(backlist);
			diangongpay.init();
			initNumInput();
		});
		}else{
			pop_up_box.showMsg("请选择安装时间!");
		}
    });
    </script>
</div>