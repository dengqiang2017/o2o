<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <form class="form-inline" style="margin-top: 10px;">
      <div class="form-group">
<!--       <label>日期范围</label> -->
      <input type="date" class="form-control Wdate" name="beginTime" style="width: 150px;display: inline-block;"
       onFocus="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false})">
	    <input type="date" class="form-control Wdate" name="endTime" style="width: 150px;display: inline-block;"
	     onFocus="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false})">
	    <button type="button" class="btn btn-primary btn-position find">查询</button>
	</div>
<!-- 	<div class="form-group"> -->
<!-- 	    <label>状态</label> -->
<!-- 	    <select id="type"> -->
<!-- 	    <option value="">全部</option> -->
<!-- 	    <option value="0">未确认</option> -->
<!-- 	    <option value="1">已确认</option> -->
<!-- 	    </select> -->
<!-- 	</div> -->
	<div class="form-group">
	</div>
</form>
<div id="list" style="margin-top: 10px;">

</div>
<div style="text-align: center;"><button type="button" class="btn btn-info add">加载更多</button></div>
<div id="item" style="display: none;">
<div class="col-xs-12 col-sm-6 col-md-3" style="border: 1px solid aqua;background-color: white;padding:5px; ">
<!-- <span><input type="checkbox" id="check" style="width: 25px;height: 25px;"></span> -->
<span>时间:<span id="time"></span></span>
<div>付款单号:<span id="no"></span></div>
<div>金额:￥<span id="je"></span>&ensp;付款方式:<span id="sum_si_origin"></span>
<!-- 是否确认:<span id="flag"></span> -->
</div>
<div><button type="button" class="btn btn-info payimg">支付凭证图</button>
<!-- <button type="button" class="btn btn-info qianming">确认签字图</button> -->
</div>
</div>
</div>
<script type="text/javascript">
<!--
var now = new Date();
var nowStr = now.Format("yyyy-MM-01"); 
$(".Wdate:eq(0)").val(nowStr);
var nowStr = now.Format("yyyy-MM-dd"); 
$(".Wdate:eq(1)").val(nowStr);
var page=0;
var count=0;
var totalPage=0;
$(".find").click(function(){
	page=0;
	count=0;
	$(".add").show();
});
loadData();
function loadData(){
	pop_up_box.loadWait();
	$.get("getReceiptPage.do",{
		"page":page,
		"count":count,
		"beginDate":$(".Wdate:eq(0)").val(),
		"endDate":$(".Wdate:eq(1)").val()
	},function(data){
		pop_up_box.loadWaitClose();
		if(data&&data.rows){
			$.each(data.rows,function(i,n){
				var item =$($("#item").html());
				$("#list").append(item);
				if(n.qianming==""){
					item.find("#check").remove();
					item.find("#qianming").remove();
					item.find("#flag").html("未确认");
				}else{
					item.find("#flag").html("已签字确认");
				}
				item.find("#time").html(n.time);
				item.find("#no").html(n.no);
				item.find("#je").html(n.je);
				item.find("#sum_si_origin").html(n.sum_si_origin);
				if(n.imgpath){
					item.find(".payimg").click({"imgpath":n.imgpath},function(event){
						pop_up_box.showImg(event.data.imgpath);
					});
				}else{
					item.find(".payimg").html("未上传凭证");
				}
			});
		}
		count=data.totalRecord;
		totalPage=data.totalPage;
		if(page>=totalPage){
			$(".add").hide();
		}
	});
}
//更多
$(".add").click(function(){
	page=page+1;
	if(page<totalPage){
		loadData();
	}
});
pop_up_box.loadScrollPage(function(){
	page=page+1;
	if(page<totalPage){
		loadData();
	}
});
//-->
</script>