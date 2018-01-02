<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.qianying.controller.BaseController"%>
<%
	BaseController.checkEmployeeLogin(request,response);
	BaseController.getVer(request);
	BaseController.getPageNameByUrl(request,null);
%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>${sessionScope.systemName}</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../css/popUpBox.css${requestScope.ver}">
    <link rel="stylesheet" href="css/information.css${requestScope.ver}">
</head>
<body>
<div class="body">
<!--     body_left -->
<div class="col-md-2" role="complementary">
        <div class="bs-docs-sidebar hidden-print hidden-xs hidden-sm affix">
        	<div style="padding-top: 10px;padding-left: 10px;"><a href="../employee.do">${sessionScope.indexName}&gt;</a></div>
              <div class="title"><h4 style="padding: 5px;padding-top: 10px;">基础资料显示设置</h4></div>
              <div class="subnav">
                  <ul>
					<li class="active">产品维护<span style="display: none;">ctl03001</span><span
						style="display: none;">product</span>
						<span class="glyphicon glyphicon-chevron-right"></span></li>
					<li>产品类别<span style="display: none;">ctl03200</span><span
						style="display: none;">productClass</span>
						<span class="glyphicon glyphicon-chevron-right"></span></li>
					<li>部门维护<span style="display: none;">ctl00701</span><span
						style="display: none;">dept</span>
						<span class="glyphicon glyphicon-chevron-right"></span></li>
					<li>员工维护<span style="display: none;">ctl00801</span><span
						style="display: none;">employee</span>
						<span class="glyphicon glyphicon-chevron-right"></span></li>
					<li>客户维护<span style="display: none;">sdf00504</span><span
						style="display: none;">client</span>
						<span class="glyphicon glyphicon-chevron-right"></span></li>
					<li>供应商维护<span style="display: none;">ctl00504</span><span
						style="display: none;">gys</span>
						 <span class="glyphicon glyphicon-chevron-right"></span></li>
					<li>司机维护<span style="display: none;">sdf00504_saiyu</span><span
						style="display: none;">drive</span>
						<span class="glyphicon glyphicon-chevron-right"></span></li>
					<li>电工维护<span style="display: none;">sdf00504_saiyu</span><span
						style="display: none;">electrician</span>
						<span class="glyphicon glyphicon-chevron-right"></span></li>
					<li><button type="button" class="btn btn_styleP">保存</button>
						</li>
				</ul>
              </div>
        </div>
</div>
<div class="col-md-10" role="main">
<!-- body_right -->
<div class="">
        <div id="list"></div>
        <div id="item" style="display: none;">
        <div class="panel">
                <div class="panel_top">
                    <table class="table table-bordered panel_table">
                        <thead>
                        <tr>
                            <th width="50px;">排序</th>
                            <th width="400px;">是否使用</th>
                            <th>输入类型</th>
                            <th>字段名称</th>
                            <th>字段别称</th>
                            <th>中文名称</th>
                            <th>文本模式</th>
                            <th>输入长度</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                        <td>
                        <input type="tel" placeholder="排列顺序" maxlength="2" name="order" data-num="num" style="width: 50px;">
                        </td>
                            <td>
                            <label><input type="checkbox">列表</label>
                            <label><input type="checkbox">编辑页面</label>
                            <label><input type="checkbox">必须输入项</label>
                            </td>
                            <td>
                                <div>
                                    <select name="type">
                                        <option value=""></option>
                                        <option value="text">文本模式</option>
                                        <option value="tel">电话模式</option>
                                        <option value="date">日期模式</option>
                                        <option value="datetime">日期+时间模式</option>
                                        <option value="textarea">文本域模式</option>
                                        <option value="select">下拉模式</option>
                                        <option value="liulan">浏览模式</option>
                                        <option value="fenge">分隔模式</option>
                                    </select>
                                </div>
                            </td>
                            <td>
                                <span id="filed"><input type="text" placeholder="字段名称" maxlength="30" name="filed"></span>
                                <span id="filedtype"></span>
                            </td>
                            <td><input type="text" placeholder="字段别名" maxlength="30" name="showName"></td>
                            <td><input type="text" placeholder="列表显示中文名称" maxlength="30" name="nameCh"></td>
                            <td>
                                    <select name="dataNumber">
                                        <option value="">文本</option>
                                        <option value="num">整数</option>
                                        <option value="fu">整数加负数</option>
                                        <option value="num2">带小数</option>
                                        <option value="zimu">字母加数字</option>
                                    </select>
                            </td>
                            <td><input type="tel" name="len" placeholder="长度" maxlength="4" data-num="num" style="width: 50px;"></td>
                        </tr>
                        </tbody>
                    </table>
                    <div class="pattern">
                        <div class="pattern_left">
                            <div class="box">
                                <div class="box_top">下拉模式</div>
                                <div id="selectList">
		                            <div class="box_center">
		                                <ul>
		                                    <li>
		                                        <label>下拉项中value值
		                                            <input type="text" maxlength="30" name="optionVal" placeholder="option中value值">
		                                        </label>
		                                    </li>
		                                    <li style="margin-bottom: 0">
		                                        <label>下拉项中显示值
		                                            <input type="text" maxlength="30" name="optionName" placeholder="option标签显示值">
		                                        </label>
		                                    </li>
		                                </ul>
		                            </div>
                                
                                <div class="box_bottom">
                                    <button type="button">上移</button>
                                    <button type="button">增加</button>
                                    <button type="button">删除</button>
                                    <div class="clearfix"></div>
                                </div>
                                </div>
                            </div>
                        </div>
                        <div class="pattern_right">
                            <div class="box">
                                <div class="box_top">浏览模式</div>
                                <div class="box_bottomL">
                                    <ul>
                                        <li>
                                                <span>显示名称的ID</span><input type="text" data-number="zimu" name="showNameId">
                                        </li>
                                        <li>
                                                <span>对应字段的ID</span><input type="text" data-number="zimu" name="filedId">
                                        </li> 
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="clearfix"></div>
                    </div>

                </div>
                <div class="panel_center"></div>
                <div class="panel_bottom">
                    <div class="button_center">
                    <button type="button" class="btn btn_styleK">新增</button>
                    <button type="button" class="btn btn_styleL up">上移</button>
                    <button type="button" class="btn btn_styleL down">下移</button>
                    <button type="button" class="btn btn_styleL del">删除</button>
                    <button type="button" class="btn btn_styleL yinc">隐藏</button>
                        <div class="clearfix"></div>
                    </div>
                </div>
            </div></div>
            <div class="copyright" id="cop" style="text-align: center">
          	  蜀ICP备15034477号-1 版权所有©1998～2030牵引软件
            </div>
        </div></div>
        
    </div>
    	<div style="display: none;" id="selectItem">
		<div class="select_item">
			<div class="box_center">
                <ul>
                    <li>
                        <label>下拉项中value值
                            <input type="text" maxlength="30" name="optionVal" placeholder="option中value值">
                        </label>
                    </li>
                    <li style="margin-bottom: 0">
                        <label>下拉项中显示值
                            <input type="text" maxlength="30" name="optionName" placeholder="option标签显示值">
                        </label>
                    </li>
                </ul>
            </div>
            <div class="box_bottom">
                <button type="button">上移</button>
                <button type="button">增加</button>
                <button type="button">删除</button>
                <div class="clearfix"></div>
            </div>
		</div>
	</div>
<script src="../js_lib/jquery.11.js"></script>
<script type="text/javascript" src="../js_lib/jquery-ui.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
<script type="text/javascript" src="../js/popUpBox.js"></script>
<script type="text/javascript" src="maintenance2.js?ver=001"></script>
</body>
</html>