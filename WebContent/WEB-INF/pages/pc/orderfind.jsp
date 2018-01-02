<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
      <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
 <div class="box-head">
 <ul class="nav nav-tabs" style="margin-top:10px;">
 <c:if test="${requestScope.order=='order'}">
            <li class="active"><a href="#">下订单</a></li>
            <li class=""><a href="#">已下订单</a></li>
 </c:if>
 <c:if test="${requestScope.order=='add'}">
            <li class="active"><a href="#">增加品种</a></li>
            <li class=""><a href="#">已增加品种</a></li>
 </c:if>
 <c:if test="${requestScope.order=='plan'}">
            <li class="active"><a href="#">下计划</a></li>
            <li><a href="#">已下计划</a></li>
 </c:if>
          </ul>
        <div class="folding-btn">
            <button type="button" class="btn btn-primary btn-folding">筛选</button>
          </div>
          <div class="side-cover"></div>
          
          <div class="folding-content">
            <div>
              <button type="button" class="btn btn-primary find">搜索</button>
              <button type="reset" class="btn btn-primary reset">重置</button>
              <button type="button" class="btn btn-primary" id="side-cover">取消</button>
            </div>
          <div class="form folding">
          <form>
            <div class="col-sm-3 col-lg-2 m-t-b">
              <div class="form-group">
                <label for="">品名</label>
                <input type="text" class="form-control input-sm"  id="item_name" maxlength="50">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 m-t-b">
              <div class="form-group">
                <label for="">规格</label>
                <input type="text" class="form-control input-sm" id="item_spec" maxlength="300">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 m-t-b">
              <div class="form-group">
                <label for="">型号</label>
                <input type="text" class="form-control input-sm" id="item_type" maxlength="100">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 m-t-b">
              <div class="form-group">
                <label for="">品牌</label>
                <input type="text" class="form-control input-sm" id="class_card" maxlength="30">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 m-t-b">
              <div class="form-group">
                <label for="">颜色</label>
                <input type="text" class="form-control input-sm" id="item_color" maxlength="30">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 m-t-b">
              <div class="form-group">
                <label for="">(质量)等级</label>
                <input type="text" class="form-control input-sm" id="quality_class" maxlength="20">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 m-t-b">
              <div class="form-group">
                <label for="">类别</label>
                <div class="input-group">
                  <span class="form-control input-sm" id="type_name" ></span>
                  <span class="input-group-btn">
                  	<input type="hidden" id="type_id">
                 	<button class="btn btn-default btn-sm" type="button">X</button>
                    <button class="btn btn-success btn-sm" type="button">浏览</button>
                  </span>
                </div>
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 m-t-b">
              <div class="form-group">
                <label for="">用途</label>
                <select class="form-control input-sm" id="goods_origin" maxlength="20">
                <option value=""></option>
                  <option value="自制">自制</option>
                  <option value="采购">采购</option>
                  <option value="委托加工">委托加工</option>
                </select>
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 m-t-b">
              <div class="form-group">
                <label for="">来源</label>
                <select class="form-control input-sm" id="item_style">
                <option value=""></option>
                  <option value="主营产品">主营产品</option>
                  <option value="原料">原料</option>
                  <option value="辅料">辅料</option>
                  <option value="辅料">辅料</option>
                  <option value="虚拟产品">虚拟产品</option>
                  <option value="半成品">半成品</option>
                  <option value="通用件">通用件</option>
                  <option value="板式家具包件">板式家具包件</option>
                  <option value="生产维修维护备品备件">生产维修维护备品备件</option>
                  <option value="非经营物资">非经营物资</option>
                </select>
              </div>
            </div>
             <div class="col-sm-3 col-lg-2 m-t-b">
              <div class="form-group">
                <label for="">供应商</label>
                <div class="input-group">
                  <span class="form-control input-sm" id="serve_name"></span>
                  <span class="input-group-btn">
                  	<input type="hidden" id="serve_id">
                 	<button class="btn btn-default btn-sm" type="button">X</button>
                    <button class="btn btn-success btn-sm" type="button">浏览</button>
                  </span>
                </div>
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 m-t-b">
              <div class="form-group">
                <label for="">产品编码</label>
                <input type="text" class="form-control input-sm" id="peijian_id" maxlength="40" data-num="num">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 m-t-b">
              <div class="form-group">
                <label for="">记忆码</label>
                <input type="text" class="form-control input-sm" id="easy_id" maxlength="20">
              </div>
            </div>
            </form>
          </div>
          </div>
          <div class="form filter">
          <form id="findForm">
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">品名</label>
                <input type="text" class="form-control input-sm" name="item_name" maxlength="50">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">规格</label>
                <input type="text" class="form-control input-sm" name="item_spec" maxlength="300">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">型号</label>
                <input type="text" class="form-control input-sm" name="item_type" maxlength="100">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">品牌</label>
                <input type="text" class="form-control input-sm" name="class_card" maxlength="30">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">颜色</label>
                <input type="text" class="form-control input-sm" name="item_color" maxlength="30">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">(质量)等级</label>
                <input type="text" class="form-control input-sm" name="quality_class" maxlength="20">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">类别</label>
                <div class="input-group">
                  <span class="form-control input-sm" id="clsname"></span>
                  <span class="input-group-btn">
                 	<input type="hidden" name="type_id" id="type_id">
                  	<button class="btn btn-default btn-sm" type="button">X</button>
                    <button class="btn btn-success btn-sm" type="button">浏览</button>
                  </span>
                </div>
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">用途</label>
                <select class="form-control input-sm" name="goods_origin" maxlength="20">
                <option value=""></option>
                  <option value="自制">自制</option>
                  <option value="采购">采购</option>
                  <option value="委托加工">委托加工</option>
                </select>
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">来源</label>
                <select class="form-control input-sm" name="item_style">
                <option value=""></option>
                  <option value="主营产品">主营产品</option>
                  <option value="原料">原料</option>
                  <option value="辅料">辅料</option>
                  <option value="辅料">辅料</option>
                  <option value="虚拟产品">虚拟产品</option>
                  <option value="半成品">半成品</option>
                  <option value="通用件">通用件</option>
                  <option value="板式家具包件">板式家具包件</option>
                  <option value="生产维修维护备品备件">生产维修维护备品备件</option>
                  <option value="非经营物资">非经营物资</option>
                </select>
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">供应商</label>
                <div class="input-group">
                  <span type="text" class="form-control input-sm" name="serve_name" id="serve_name" maxlength="40"></span>
                  <span class="input-group-btn">
                  	<input type="hidden" id="serve_id" name="serve_id">
                  	<button class="btn btn-default btn-sm" type="button">X</button>
                    <button class="btn btn-success btn-sm" type="button">浏览</button>
                  </span>
                </div>
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">产品编码</label>
                <input type="text" class="form-control input-sm" name="peijian_id" maxlength="40" data-num="num">
              </div>
            </div>
            <div class="col-sm-3 col-lg-2 col-xs-6 m-t-b">
              <div class="form-group">
                <label for="">记忆码</label>
                <input type="text" class="form-control input-sm" name="easy_id" maxlength="20">
              </div>
            </div>
            <div class="col-xs-12">
                 <input type="hidden" id="page" name="page" value="0">
          		 <input type="hidden" id="totalPage" value="0">
              <button type="button" class="btn btn-primary find">搜索</button>
              <button type="reset" class="btn btn-primary reset">重置</button>
            </div>
            </form>
          </div>
        </div>