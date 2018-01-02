<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="../pc/saiyu/repair.css${requestScope.ver}">
<script type="text/javascript" src="../js/ajaxfileupload.js"></script>
<script src="../pc/js/saiyu/repair.js${requestScope.ver}"></script>
<div class="section-1">您好:<a href="javaScript:window.reload();">${sessionScope.customerInfo.clerk_name}</a></div>
<form class="fl">
    <input type="hidden" value="${requestScope.ivt_oper_listing}" name="ivt_oper_listing">
<div id="item">
<div class="item">
<div class="row">
<div class="col-xs-6 col-md-3 col-md-offset-1">
    <div class="bhk">
        <div class="section-rowa">
            <img src="../pc/repair-images/weizhi.png" class="img0 ct">
        </div>
        <h6 class="h6-1">损坏位置</h6>
    </div>
    <div class="bhk">
        <div class="section-img">
            <img alt="" src="../pc/repair-images/camero.png" class="img0">
            <input type="hidden" id="filePath" name="positionImg">
            <div class="form-group">
                <input type="file" onchange="imgUpload(this,'bigImg');" id="bigImg" name="bigImg" class="ct input-upload">
            </div>
        </div>
        <h6 class="h6-1">上传照片</h6>
    </div>
</div>
<div style="margin-top: 20px" class="col-xs-6 col-md-6">
                   <div class="form-group">
                       <div class="input-group">
                           <input type="text" value="" placeholder="必须输入或者选择" name="position_big" class="form-control input-sm text-center">
<span class="input-group-btn">
       <button type="button" class="btn btn-primary btn-sm dj" id="a">浏览</button>
   </span>
                       </div>
                   </div>
               </div>
           </div>

           <div class="row lie1">
               <div class="col-md-1 hidden-xs"></div>
               <div class="col-xs-6 col-md-3">
                   <div class="bhk">
                       <div class="section-rowa">
                           <img src="../pc/repair-images/leixing.png" class="img0 ct">
                       </div>
                       <h6 class="h6-1">损坏类型</h6>
                   </div>
                   <div class="bhk">
                       <div class="section-img">
                           <img alt="" src="../pc/repair-images/camero.png" class=" img0">
                           <input type="hidden" id="filePath" name="typeImg">
                           <div class="form-group">
                               <input type="file" onchange="imgUpload(this,'itemnameImg');" id="itemnameImg" name="itemnameImg" class="ct input-upload">
                           </div>
                       </div>
                       <h6 class="h6-1">上传照片</h6>
                   </div>
               </div>
               <div style="margin-top: 20px" class="col-xs-6">
                   <div class="form-group">
                       <div class="input-group">
                           <input type="text" name="item_name" class="form-control input-sm text-center">
						<span class="input-group-btn">
						       <button type="button" class="btn btn-primary btn-sm dj3" id="a">浏览</button>
						   </span>
                       </div>
                   </div>
               </div>
           </div>
                       <div class="row lie1">
                           <div class="col-md-1 hidden-xs"></div>
                           <div class="col-xs-3 col-md-1 ">
                               <div class="bhk">
                                   <div class="section-rowa">
                                       <img src="../pc/repair-images/louceng.png" class="img0 ct">
                                   </div>
                                   <h6 class="h6-1">损坏楼层</h6>
                               </div>
                           </div>
                           <div class="col-xs-3 col-md-2"></div>
                           <div style="text-align: center;margin-left: -15px;" class="col-xs-6 col-md-6">
                    <div class="pro-num-I"><span class="sub">-</span><input type="text"  data-num="n" name="position"  placeholder="必须输入或者选择" id="pronum"><span class="add">+</span></div>
                </div>
            </div>
<div class="row lie2">
    <div class="col-md-1 hidden-xs"></div>
    <div class="col-xs-6 col-md-1">
        <div class="bhk">
            <div class="section-rowa">
                <img src="../pc/repair-images/shuliang.png" class="img0 ct">
            </div>
            <h6 class="h6-1">损坏数量</h6>
        </div>
    </div>
    <div class="col-md-2 hidden-xs"></div>
    <div style="text-align: center;margin-left: -15px;" class="col-xs-6 col-md-6">
        <div class="pro-num-I"><span class="sub">-</span><input type="text"  data-num="n" name="num" id="pronum"><span class="add">+</span></div>
    </div>
</div>
<button id="add" class="btn btn-lg btn-primary center-block additem" type="button"><span class="glyphicon glyphicon glyphicon-plus"></span></button>
<div class="fg"></div>
        </div>
        </div>
</form>
                   <a><button type="button" id="save" class="section-zj2">提交</button></a>
               <div class="zz3">
           <div class="form-group">
               <div class="input-group">
                   <input type="text" class="form-control input-sm" maxlength="50" id="clientkeyname" placeholder="请输入搜索关键词"> <span class="input-group-btn">
				<button class="btn btn-danger btn-sm" type="button" id="findclient">搜索</button>
			</span>
               </div>
           </div>
           <div class="hide-table" style="margin-top: 30px;">
               <ul class="hide-title">
                   <li class="col-xs-12">损坏位置</li>
               </ul>
               <div id="positem">
               
               </div>
           </div>
           <div style="display: none;">
               <button type="button">点击加载更多</button>
           </div>
       </div>
       <div class="zz5">
           <div class="form-group">
               <div class="input-group">
                   <input type="text" class="form-control input-sm" maxlength="50" id="clientkeyname" placeholder="请输入搜索关键词"> <span class="input-group-btn">
				<button class="btn btn-danger btn-sm" type="button" id="findclient">搜索</button>
			</span>
               </div>
           </div>
           <div class="hide-table" style="margin-top: 30px;">
               <ul class="hide-title">
                   <li class="col-xs-12">损坏类型</li>
               </ul>
               <div id="itemnameitem">
              
               </div>
           </div>
           <div style="display: none;">
               <button type="button">点击加载更多</button>
           </div>
       </div>
       <div class="cover"></div>