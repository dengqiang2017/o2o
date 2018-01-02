 var appReport={
	 init:function(url,title){
     loadData();
     var datas=[];
	 function loadData(){
		 $.get(contextPath+url,{
			 beginTime:$("#beginTime").val(),
			 endTime:$("#endTime").val()
		 },function(data){
			 datas=data;
			 loadChartData(datas,'line');
		 });
	 }
	 //查询点击事件
//	 $("#fixed_position").bind("click",function(){
//		 loadData();
//	 });
	 //////图形选择/////
//	 $("#btnLine").bind("click",function(){
//		 loadChartData(datas,'line');
//	 });
//	 $("#btnColumn").bind("click",function(){
//		 loadChartData(datas,'column');
//	 });
//	 $("#btnPie").bind("click",function(){
//		 loadChartData(datas,'pie');
//	 });
	 ////////end/////////
	 function loadChartData(datas,type){
		 loadChart(datas,type,'chartdiv',title ,'渠道');
//		 loadChart(datas[0],type,'chartdiv', 'app下载统计','盒子');
//		 loadChart(datas[1],type,'connwifidiv', 'app下载统计--wifi','wifi');
		}
	 }
 };