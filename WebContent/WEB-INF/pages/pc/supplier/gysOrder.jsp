<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <link rel="stylesheet" type="text/css" href="../pc/gys/diangong-daian.css${requestScope.ver}">
    <style>
    @media(max-width:770px){
       .ul_height{
    height:auto;
    }
    }
    @media(min-width:770px){
    .ul_height{
    height:auto;
    }
    }
    .check{width: 20px;height: 20px;margin-top: 5px;float: left;margin-left: 5px !important;}
    </style>
     <script type="text/javascript" src="../pc/js/gys/gysOrder.js${requestScope.ver}"></script> 
        <div class="container-one" id="listorder" style="margin-top:40px;margin-bottom:80px">
            <div class="form-group">
                <div class="row">
                    <div class="col-lg-3">
                        <label>发起开始日期</label>
                        <input type="date" class="form-control Wdate" name="beginTime"
                         onFocus="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false})">
                    </div>
                    <div class="col-lg-3">
                        <label>发起结束日期</label>
                        <input type="date" class="form-control Wdate" name="endTime"
                         onFocus="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false})">
                    </div>
                    <div class="col-lg-3">
                        <label>订单状态<span style="font-size: 14px;color: red;">选择后进行操作</span></label>
                        <select class="form-control" id="type">
                            <option></option>
                            <option value="0">待处理</option>
                            <option value="2">已处理有货</option>
                            <option value="3">已处理无货</option>
                            <option value="9">已提交物流</option>
                            <option value="4">已发货</option>
                            <option value="5">已收货</option>
                        </select>
                    </div>
                    <div class="col-lg-3">
                        <label>输入关键字</label>
                        <input type="text" class="form-control" id="searchKey" name="searchKey" placeholder="输入关键字">
                    </div>
                    <div class="col-lg-3">
                        <button type="button" class="btn btn-primary btn-position find">查询</button>
                    </div>
                </div>
            </div>
    <div class="row">
            <div id="itemlist">
            
            </div>
    </div>
            <div id="item" style="display: none;">

            <div class="col-lg-4 col-sm-3">
<!--     			<div class="pro-check" style="float:left;margin-top:5px"></div> -->
    			<input type="checkbox" class="check">
    			<input type="hidden" id="item_id">
    			<input type="hidden" id="seeds_id">
               <ul class="ul_height" style="background-color:#fff;padding-left:20px;">
                <li id="no">采购编号:<span></span></li>
                <li id="item_name"></li>
                <li id="hav_rcv">数量:</li>
                <li id="zsum">折算数量:</li>
                <li id="date">下单时间:</li>
                <li id="flag">状态:</li>
                <li id="c_memo">配送信息:</li>
			    <li>
<!-- 			    <button type="button" class="btn btn-primary btn-size">有货并准备发货</button> -->
<!-- 			    <button type="button" class="btn btn-primary btn-size">无货</button> -->
<!-- 			    <button type="button" class="btn btn-primary btn-size">已发货</button> -->
			    </li>
			    </ul>
<!--                 <div class="col-lg-4" style="display: none;"> -->
<!--                     <button type="button" class="btn btn-primary center-block btn-size">查看详情</button> -->
<!--                 </div> -->
            </div>
    </div>

         </div>
         <div id="itempage">
         
         </div>
<div class="col-lg-4">
    <button type="button" class="btn btn-primary center-block btn-add">加载更多</button>
</div>
    <div class="xfooter" style="width:100%;height:60px;background-color:#F4F0F0;position:fixed;bottom:0;margin-left:-15px">
<!--     <div class="pro-check" id="allcheck" style="margin-top:18px;margin-left:25px;margin-right:10px;width:30px;float:left"></div> -->
    <div style="margin-top:23px;margin-left:10px;"><label><input type="checkbox" id="allcheck" style="width: 20px;height: 20px;margin-right: 5px;">全选</label></div>
    <button type="button" class="btn btn-primary btn-size" style="margin-top:15px;margin-right: 10px;">有货</button>
    <button type="button" class="btn btn-primary btn-size" style="margin-top:15px;margin-right: 10px;">无货</button>
    <button type="button" class="btn btn-primary btn-size" style="margin-top:15px;margin-right: 10px;">已发货</button>
    </div>