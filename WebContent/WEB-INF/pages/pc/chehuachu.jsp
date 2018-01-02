<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-------------侧边弹出-------------->
    <link rel="stylesheet" href="../pc/css/chehuachu.css">
    <div class="tc">
        <div class="tc_top">详情
        <button type="button" class="btn btn-default">关闭</button>
        </div>
        <div class="panel-body">
        <ul style="line-height: 30px;">
        <li>客户名称:<span id="corp_sim_name"></span></li>
        <li>联系人:<span id="lxr"></span></li>
        <li>收货地址:<span id="shdz"></span></li>
        </ul>
        </div>
        <div class="tc_body">
        <h4>订单跟踪详情:</h4>
            <ul></ul>
        </div>
    </div>
    <div class="zhezhao" style="position: fixed;left: 0;right: 0;top: 0;bottom: 0;background-color: #000;opacity: 0.6;z-index: 990;display: none;"></div>
<!--------------------------->
<script type="text/javascript">
<!-- 
    $('.tc_top>button,.zhezhao').click(function(){
       $('.tc,.zhezhao').hide();
    });
//-->
</script>