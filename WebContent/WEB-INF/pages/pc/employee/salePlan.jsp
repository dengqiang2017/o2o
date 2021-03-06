<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
	<title>牵引O2O营销服务平台</title>
  <link rel="stylesheet" href="../pcxy/css/product.css">
   <%@include file="../res.jsp" %>
   <script src="../js/o2od.js"></script>
</head>
<body>
	<div class="bg"></div>
    <div class="header">
      <ol class="breadcrumb">
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="../employee.do">员工首页</a></li>
        <li><span class="glyphicon glyphicon-triangle-right"></span><a href="selectClient.do?type=3">选择客户</a></li>
        <li class="active"><span class="glyphicon glyphicon-triangle-right"></span>销售计划详细</li>
      </ol>
      <div class="header-title">员工-销售计划
        <a href="selectClient.do?type=3" class="header-back"><span class="glyphicon glyphicon-menu-left"></span></a>
      </div>
      <div class="header-logo"></div>  
    </div>
    
    <div class="container">
      <div class="ctn-fff box-ctn">
        <div class="box-head">
          客户信息
        </div>
        <div class="box-body">
          <ul class="sim-msg">
            <li>林氏木业家具有限公司（<span>13890149850</span>）</li>
          </ul> 
          <div class="ctn">
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">计划类型</label>
                <select class="form-control input-sm" name="${sessionScope.prefix}goods_origin" maxlength="20">
                  <option value="">日计划</option>
                  <option value="">3日计划</option>
                  <option value="">周计划</option>
                  <option value="">月计划</option>
                </select>
              </div> 
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">计划日期</label>
                <input type="text" class="form-control input-sm">
              </div> 
            </div>
          </div>
             
        </div>  
      </div>
    </div>



    <div class="container">
      <div class="ctn-fff box-ctn" style="min-height:500px;">
        <div class="box-head">
          <div class="folding-btn">
            <button type="button" class="btn btn-primary btn-folding">筛选</button>
          </div>
          <div class="side-cover"></div>
          <div class="folding-content">
            <div class="form folding">
              <div class="m-t-b">
                <div class="form-group">
                  <label for="item_name">品名</label>
                  <input type="text" class="form-control input-sm" name="${sessionScope.prefix}item_name" id="item_name" maxlength="50">
                </div>
              </div>
              <div class="m-t-b">
                <div class="form-group">
                  <label for="">规格</label>
                  <input type="text" class="form-control input-sm" name="${sessionScope.prefix}item_spec" maxlength="300">
                </div>
              </div>
              <div class="m-t-b">
                <div class="form-group">
                  <label for="">型号</label>
                  <input type="text" class="form-control input-sm" name="${sessionScope.prefix}item_type" maxlength="100">
                </div>
              </div>
              <div class="m-t-b">
                <div class="form-group">
                  <label for="">品牌</label>
                  <input type="text" class="form-control input-sm" name="${sessionScope.prefix}class_card" maxlength="30">
                </div>
              </div>
              <div class="m-t-b">
                <div class="form-group">
                  <label for="">颜色</label>
                  <input type="text" class="form-control input-sm" name="${sessionScope.prefix}item_color" maxlength="30">
                </div>
              </div>
              <div class="m-t-b">
                <div class="form-group">
                  <label for="">(质量)等级</label>
                  <input type="text" class="form-control input-sm" name="${sessionScope.prefix}quality_class" maxlength="20">
                </div>
              </div>
              <div class="m-t-b">
                <div class="form-group">
                  <label for="">类别</label>
                  <div class="input-group">
                    <input disabled="disabled" type="text" class="form-control input-sm" name="${sessionScope.prefix}type_name" maxlength="40">
                    <span class="input-group-btn">
                      <button class="btn btn-default btn-sm" type="button">X</button>
                      <button class="btn btn-success btn-sm" type="button">浏览</button>
                    </span>
                  </div>
                </div>
              </div>
              <div class="m-t-b">
                <div class="form-group">
                  <label for="">用途</label>
                  <select class="form-control input-sm" name="${sessionScope.prefix}goods_origin" maxlength="20">
                    <option value="">自制</option>
                    <option value="">采购</option>
                    <option value="">委托加工</option>
                  </select>
                </div>
              </div>
              <div class="m-t-b">
                <div class="form-group">
                  <label for="">来源</label>
                  <select class="form-control input-sm" name="${sessionScope.prefix}item_style" maxlength="20">
                    <option value="">主营产品</option>
                    <option value="">原料</option>
                    <option value="">辅料</option>
                    <option value="">包材</option>
                    <option value="">虚拟产品</option>
                    <option value="">半成品</option>
                    <option value="">通用件</option>
                    <option value="">板式家具包件</option>
                    <option value="">生产维修维护备品备件</option>
                    <option value="">非经营物资</option>
                  </select>
                </div>
              </div>
              <div class="m-t-b">
                <div class="form-group">
                  <label for="">供应商</label>
                  <div class="input-group">
                    <input disabled="disabled" type="text" class="form-control input-sm" name="${sessionScope.prefix}serve_name" maxlength="40">
                    <span class="input-group-btn">
                      <button class="btn btn-default btn-sm" type="button">X</button>
                      <button class="btn btn-success btn-sm" type="button">浏览</button>
                    </span>
                  </div>
                </div>
              </div>
              <div class="m-t-b">
                <div class="form-group">
                  <label for="">产品编码</label>
                  <input type="text" class="form-control input-sm" name="${sessionScope.prefix}peijian_id" maxlength="40" data-num="num">
                </div>
              </div>
              <div class="m-t-b">
                <div class="form-group">
                  <label for="">记忆码</label>
                  <input type="text" class="form-control input-sm" name="${sessionScope.prefix}easy_id" maxlength="20">
                </div>
              </div>
              <div class="col-xs-12" style="margin-bottom:10px;">
                <button type="button" class="btn btn-primary">搜索</button>
                <button type="button" class="btn btn-primary">取消</button>
              </div>
            </div>
          </div>
          <div class="form filter">
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">品名</label>
                <input type="text" class="form-control input-sm" name="${sessionScope.prefix}item_name" maxlength="50">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">规格</label>
                <input type="text" class="form-control input-sm" name="${sessionScope.prefix}item_spec" maxlength="300">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">型号</label>
                <input type="text" class="form-control input-sm" name="${sessionScope.prefix}item_type" maxlength="100">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">品牌</label>
                <input type="text" class="form-control input-sm" name="${sessionScope.prefix}class_card" maxlength="30">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">颜色</label>
                <input type="text" class="form-control input-sm" name="${sessionScope.prefix}item_color" maxlength="30">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">(质量)等级</label>
                <input type="text" class="form-control input-sm" name="${sessionScope.prefix}quality_class" maxlength="20">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">类别</label>
                <div class="input-group">
                  <input disabled="disabled" type="text" class="form-control input-sm" name="${sessionScope.prefix}type_name" maxlength="40">
                  <span class="input-group-btn">
                    <button class="btn btn-default btn-sm" type="button">X</button>
                    <button class="btn btn-success btn-sm" type="button">浏览</button>
                  </span>
                </div>
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">用途</label>
                <select class="form-control input-sm" name="${sessionScope.prefix}goods_origin" maxlength="20">
                  <option value="">自制</option>
                  <option value="">采购</option>
                  <option value="">委托加工</option>
                </select>
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">来源</label>
                <select class="form-control input-sm" name="${sessionScope.prefix}item_style" maxlength="20">
                  <option value="">主营产品</option>
                  <option value="">原料</option>
                  <option value="">辅料</option>
                  <option value="">包材</option>
                  <option value="">虚拟产品</option>
                  <option value="">半成品</option>
                  <option value="">通用件</option>
                  <option value="">板式家具包件</option>
                  <option value="">生产维修维护备品备件</option>
                  <option value="">非经营物资</option>
                </select>
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">供应商</label>
                <div class="input-group">
                  <input disabled="disabled" type="text" class="form-control input-sm" name="${sessionScope.prefix}serve_name" maxlength="40">
                  <span class="input-group-btn">
                    <button class="btn btn-default btn-sm" type="button">X</button>
                    <button class="btn btn-success btn-sm" type="button">浏览</button>
                  </span>
                </div>
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">产品编码</label>
                <input type="text" class="form-control input-sm" name="${sessionScope.prefix}peijian_id" maxlength="40" data-num="num">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">记忆码</label>
                <input type="text" class="form-control input-sm" name="${sessionScope.prefix}easy_id" maxlength="20">
              </div>
            </div>
            <div class="col-xs-12">
              <button type="button" class="btn btn-primary">搜索</button>
            </div>
          </div>
        </div>

        <div class="box-body">
          <div class="ctn">
            <div class="col-sm-6" id="item01">
              <div class="p-ctn" id="item">
                <input type="hidden" id="item_id">
                <div class="p-img">
                  <a href="product.html"><img class="pimg" src="pcxy/image/0.png.jpg" alt=""></a>
                </div>
                <div class="p-msg">
                  <div class="p-top">
                    <input type="checkbox" class="check">
                    <div class="pmsg-ctn">
                      <span class="p-name" name="${sessionScope.prefix}item_name" id="item_name">品名:中式实木床&nbsp;雕花实木床</span>
                      <div class="ctn">
                        <span class="p-class" name="${sessionScope.prefix}item_spec" id="item_spec">AAAAASDff</span>
                        <span class="p-class" name="${sessionScope.prefix}item_type" id="item_type">1.2m*1.5m</span>
                        <span class="p-class" name="${sessionScope.prefix}item_color" id="item_color">红色</span>
                        <span class="p-class" name="${sessionScope.prefix}class_card" id="class_card">全友家私</span>
                        <span class="p-class" name="${sessionScope.prefix}quality_class" id="quality_class" style="width:100%;">3级</span>
                      </div>
                    </div>
                  </div>
                  <div class="p-middle">
                    
                    <div class="p-form col-sm-6">
                      <label for="">数量</label>
                      <input type="text">
                    </div>
                  </div>
                </div> 
              </div>
            </div>
            <div class="col-sm-6" id="item02">
            </div>
          </div>
          
          <div class="ctn">
            <button class="btn btn-add" type="button">点击加载更多</button>
          </div>
        </div>
      </div>
    </div>

    <div class="back-top" id="scroll"></div>

    <div class="footer">
      员工:${sessionScope.userInfo.personnel.clerk_name}<span class="glyphicon glyphicon-earphone"></span>
      <div class="btn-gp">
        <button class="btn btn-info">全选</button>
        <button class="btn btn-info">提交</button>
        <a href="javascript:history.go(-1);" class="btn btn-primary">返回</a>
      </div>
    </div>
    
</body>
</html>