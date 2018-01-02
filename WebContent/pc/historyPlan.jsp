<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
    <meta charset="UTF-8">
    <meta http-equiv="U-XA-Compatible" content="IE-edge">
    <meta http-equiv="Pragma" content="no-cache">
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1,maximum-scale=1.0,user-scalable=no">
    <title>历史计划</title>
    <link rel="stylesheet" href="../pcxy/css/bootstrap.css">
    <link rel="stylesheet" href="../css/popUpBox.css">
    <link rel="stylesheet" href="css/query.css">
    <link rel="stylesheet" href="css/lishi.css">
        <script type="text/javascript" src="../js_lib/jquery.11.js"></script>
    <script type="text/javascript" src="../js_lib/jquery.cookie.js"></script>
    <script src="../datepicker/WdatePicker.js?ver=001"></script>
    <script type="text/javascript" src="../js/common.js"></script>
    <script type="text/javascript" src="../js/popUpBox.js"></script>
</head>
<body>
<div id="listpage">
<div class="header">
    <a href="../customer/plan.do?ver=001" class="pull-left">返回</a>
    历史查询
</div>
<div class="body">
     <div class="body01">
           <button type="button" class="btn"><img src="images/ser.png">搜索</button>
     </div>
    <div class="body02 table-responsive" style="overflow: auto;">
        <table class="table table-bordered">
            <thead>
                 <tr>
                     <th data-name="at_term_datetime">日期</th>
                     <th data-name="item_name">产品名称</th>
                     <th data-name="planNum">计划数量</th>
                     <th data-name="kucun">库存</th>
                     <th data-name="item_unit">单位</th>
                     <th data-name="item_zeroSell">零售价</th>
                     <th data-name="item_cost">采购价</th>
                     <th data-name="je">金额</th>
                 </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>
</div>
<div id="findlistpage" style="display: none;">
    <div class="header2">
        查询 <a class="pull-left closed"
              style="color: #FFFFFF; font-size: 18px; margin-top: 3px; cursor: pointer"
            >取消</a> <a class="pull-right find"
                       style="color: #FFFFFF; font-size: 18px; margin-top: 3px; cursor: pointer">确认</a>
    </div>
    <div class="body">
        <ul>
            <li>
                <div class="col-xs-4" style="text-indent: 20px; margin-top: 6px">关键词</div>
                <div class="col-xs-8">
                    <input type="text" id="searchKey" maxlength="20" class="form-control" placeholder="输入查询关键词">
                </div>
                <div class="clearfix"></div>
            </li>
            <li>
                <div class="col-xs-4" style="text-indent: 20px; margin-top: 6px">起始日期</div>
                <div class="col-xs-8">
                    <input type="date" id="d4311"
                           class="form-control Wdate"
                           onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'d4312\')||\'2120-10-01\'}'})" name="beginDate">
                </div>
                <div class="clearfix"></div>
            </li>
            <li>
                <div class="col-xs-4" style="text-indent: 20px; margin-top: 6px">结束日期</div>
                <div class="col-xs-8">
                    <input type="date" id="d4312" class="form-control Wdate"
                           onfocus="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'d4311\')}',maxDate:'2120-10-01'})" name="endDate">
                </div>
                <div class="clearfix"></div>
            </li>
        </ul>
    </div>
</div>
<script type="text/javascript">
<!--
	////////////////
    $('.body01>button').click(function(){
        $('#findlistpage').show();
        $('#listpage').hide();
    });
    $('.closed').click(function(){
        $('#findlistpage').hide();
        $('#listpage').show();
    });
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".Wdate:eq(1)").val(nowStr);
	now =addDate(nowStr,-1);
	var nowStr = now.Format("yyyy-MM-dd");
	$(".Wdate:eq(0)").val(nowStr);
    $(".find").click(function(){
    	$('.closed').click();
    	var thlen=$("th").length;
    	pop_up_box.loadWait();$("tbody").html("");
    	$.get("../report/planReportDetail.do",{
    		"searchKey":$("#searchKey").val(),
    		"beginDate":$(".Wdate:eq(0)").val(),
    		"endDate":$(".Wdate:eq(1)").val()
    	},function(data){
    		pop_up_box.loadWaitClose();
    		if(data&&data.length>0){
			var len=data.length;
			$.each(data,function(i,n){
				var tr=getTr(thlen);
				$("tbody").append(tr);
				for (var i = 0; i < thlen; i++) {
					var th=$($("th")[i]);
					var name=th.attr("data-name");
					var j=$("th").index(th);
					if(j>=0){
						tr.find("td:eq("+j+")").html(n[name]);
					}
				}
			});
			////计算计划数量汇总 
			addCount(thlen, 0)
    		}
    	});
    });
    $(".find").click();
	/**
	 * 增加汇总行
	 */
	function addCount(thlen,index){
	////计算计划数量汇总
		if(!thlen){
			pop_up_box.showMsg("请输入表格列数!");
			return;
		}
		if(!index){
			index=0;
		}
		var tr=getTr(thlen);
		$(".table-responsive:eq("+index+") tbody").append(tr);
		tr.find("td:eq(0)").html("汇总");
		getSumNum(tr,0,"planNum",2);
		getSumNum(tr,0,"kucun",2);
// 		getSumNum(tr,0,"item_zeroSell",2);
		getSumNum(tr,0,"je",2);
	}
//->
</script>
</body>
</html>