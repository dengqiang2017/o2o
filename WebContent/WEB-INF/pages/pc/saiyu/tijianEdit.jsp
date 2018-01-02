<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- <!DOCTYPE html> -->
<!-- <html lang="zh-CN"> -->
<!-- <head lang="en"> -->
<!--     <meta charset="UTF-8"> -->
<!--     <title>客户体检表维护</title> -->
<!--     <meta http-equiv="Pragma" content="no-cache" > -->
<!--     <meta http-equiv="X-UA-Compatible" content="IE=edge"> -->
<!--     <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no"> -->
<%-- 	<%@include file="../pcxy_res.jsp" %> --%>
    <script type="text/javascript" src="../datepicker/WdatePicker.js"></script>
    <script type="text/javascript" src="../pc/js/saiyu/tijianEdit.js?ver=${requestScope.ver}"></script>
    <style type="text/css">
  @media(max-width: 770px){
.zz3{
        width: 270px;
        height: 435px;
        background-color: rgba(16,131,189,0.8);
        position: fixed;
        right: 0;
        top: 13%;
        z-index: 999;
        display: none;
    }
    .zz3>ul{
        width: 95%;
        margin: auto;
        padding-left: 0;
    }
    .zz3>ul>li{
        text-align: center;
        width: 100%;
        border: 1px solid #FFFFFF;
        padding:5px 0;
        color: #FFFFFF;
        margin-top:10px ;
    }
    .zz3>ul>li:hover{
        background-color: #055E8A;
    }
}

.cover{
    width: 100%;
    height: 100%;
    position: fixed;
    left: 0;
    top: 0;
    z-index: 100;
    background-color: rgba(0,0,0,0.7);
    display: none;
}
@media(min-width: 770px){
.zz3{
        width: 20%;
        background: #f3f5f7;
        position: fixed;
        top: 60px;
        right: 0;
        bottom: 60px;
        display: none;
        z-index: 999;
        overflow-y: scroll;
        box-shadow: 0 0 10px rgba(0,0,0,0.3);
    }
    .zz3>ul{
        width: 95%;
        margin: auto;
        padding-left: 0;
    }
    .zz3>ul>li{
        text-align: center;
        width: 100%;
        border: 1px solid #FFFFFF;
        padding:5px 0;
        color: #FFFFFF;
        margin-top:10px ;
    }
    .zz3>ul>li:hover{
        background-color: #055E8A;
    }
}
    </style>
<!-- </head> -->
<!-- <body> -->
     <div class="bg"></div>
	<div class="header">
		<ol class="breadcrumb">
		  <li><a href="../employee.do">员工首页</a></li>
		  <li><a href="javascript:showlistpage();"><span class="glyphicon glyphicon-triangle-right"></span>客户体检表维护</a></li>
		  <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>客户体检表维护详细</li>
		</ol>
		<input type="hidden" id="info" value="${requestScope.info}">
	</div>
     <!-------------------secition------------>
     <input type="reset" id="resetForm" style="display: none;">
     <input type="hidden"  value="${requestScope.com_id}" id="com_id">
   <div class="container" style="margin-top:10px;">
     <form class="secition" id="tijianForm">
     <c:if test="${requestScope.tijian.customer_id!=null}">
         <input type="hidden" id="customerId" name="${sessionScope.prefix}customer_id" value="${requestScope.tijian.customer_id}">
     </c:if>
     <c:if test="${requestScope.customer_id!=null}">
         <input type="hidden" id="customerId" name="${sessionScope.prefix}customer_id" value="${requestScope.customer_id}">
     </c:if>    
         <input type="hidden" id="ivt_oper_listing" name="${sessionScope.prefix}ivt_oper_listing" value="${requestScope.tijian.ivt_oper_listing}">
             <div class="ctn-fff box-ctn">
			<div class="box-head">
                     <h4 class="pull-left">基本信息</h4>
                 </div>
                 <div class="secition-one-body">
                     <div class="form">
                     <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>位置大类</label>
                                 <div class="input-group">
                                     <input class="form-control input-sm" id="position_big" name="${sessionScope.prefix}position_big" value="${requestScope.tijian.position_big}"> 
                                     <span class="input-group-btn">
                                         <button class="btn btn-success btn-sm" type="button">浏览</button>
                                     </span>
                                 </div>
                             </div>
                         </div>
                     <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>位置小类(默认单位:楼层)</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}position" value="${requestScope.tijian.position}" data-num="num">
                             </div>
                        </div>
                          <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>关联产品名称</label>
                                 <div class="input-group">
                                     <span class="form-control input-sm" id="item_id_name" aria-describedby="basic-addon2" >${requestScope.tijian.item_id_name}</span>
                                     <span class="input-group-btn">
                                         <input type="hidden" name="${sessionScope.prefix}item_id" value="${requestScope.tijian.item_id}" id="item_id">
                                         <button class="btn btn-default btn-sm dd" type="button">X</button>
                                         <button class="btn btn-success btn-sm" type="button">浏览</button>
                                     </span>
                                 </div>
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>原配产品品牌</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}item_brand" value="${requestScope.tijian.item_brand}">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>原配产品名称</label>
                                 <input type="text" class="form-control input-sm" id="item_name" name="${sessionScope.prefix}item_name" value="${requestScope.tijian.item_name}">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>原配产品规格</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}item_standard" value="${requestScope.tijian.item_standard}">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>原配产品颜色</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}item_color" value="${requestScope.tijian.item_color}">
                             </div>
                         </div>
                         <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>原配数量(套)</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}item_num" value="${requestScope.tijian.item_num}" data-num="num">
                             </div>
                         </div>
                          <div class="col-lg-3 col-sm-4 mtb">
                             <div class="form-group">
                                 <label>体检表外码</label>
                                 <input type="text" class="form-control input-sm" name="${sessionScope.prefix}sd_order_id" value="${requestScope.tijian.sd_order_id}" >
                             </div>
                        </div>
                         <div class="col-lg-12 mtb">
                             <div class="form-group">
                                 <label>备注</label>
                                 <textarea class="form-control" rows="2" maxlength="100" name="${sessionScope.prefix}c_memo">${requestScope.tijian.c_memo}</textarea>
                             </div>
                         </div>
                     </div>
                 </div>
             </div>
             <input type="hidden" id="position_big_img" name="position_big_img">
             <input type="hidden" id="position_img" name="position_img">
             <input type="hidden" id="itemName" name="itemName">
     	</form>
             <div class="ctn-fff box-ctn">
			<div class="box-head">
                <h4 class="pull-left">附件上传</h4>
            </div>
            <div class="box-body">
                <div class="container">
                    <div class="col-lg-4 col-sm-4 m-t-b">
                        <div class="form-group">
                            <label>位置大类照片</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"
                                                              name="Pic_position_big" id="Pic_position_big" onchange="tijianImgUpload(this,'Pic_position_big','position_big_img');"></span>
                            <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
                        </div>
                        <div class="upload-img">
                            <img src="${requestScope.position_big_img}" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
                        </div>
                    </div>
                    
                    <div class="col-lg-4 col-sm-4 m-t-b">
                        <div class="form-group">
                            <label>位置小类照片</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"
                                                              name="Pic_position" id="Pic_position" onchange="tijianImgUpload(this,'Pic_position','position_img');"></span>
                            <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
                        </div>
                        <div class="upload-img">
                            <img src="${requestScope.position_img}" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
                        </div>
                    </div>
                    
                    <div class="col-lg-4 col-sm-4 m-t-b">
                        <div class="form-group">
                            <label>原配产品照片</label>
					<span class="btn upload-btn">点击上传图像<input type="file" class="input-upload"
                                                              name="Pic_itemName" id="Pic_itemName" onchange="tijianImgUpload(this,'Pic_itemName','itemName');"></span>
                            <p class="help-block">图片格式支持JPG/JPEG/PNG,小于500K</p>
                        </div>
                        <div class="upload-img">
                            <img src="${requestScope.itemName}" alt="" onerror="this.src='../pcxy/image/upload-img.png'">
                        </div>
                    </div>
                </div>
            </div>
        </div>
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
        <div class="cover" style="display: none;"></div>
         </div>
<!-----------------------------------footer---------------------------->
<div class="footer">
    员工：${sessionScope.userInfo.personnel.clerk_name}
    <div class="btn-gp">
        <button class="btn btn-info xg" id="save">保存</button>
        <button class="btn btn-primary xg" onclick="showlistpage();">返回</button>
    </div>
    <a id="clearcache" class="ss" style="float: right;">微信清缓存</a>
</div>
<!-- </body> -->
<!-- </html> -->