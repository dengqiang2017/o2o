var background = {
         type: 'linearGradient',
 x0: 0,y0: 0,x1: 0,
 y1: 1,colorStops: [{ offset: 0, color: '#d2e6c9' },
 { offset: 1, color: 'white'}]
 };

/**
 * 加载折线图
 * @param data数据
 * @param type图表类型
 * @param name加载div的id
 * @param title图表标题
 * @param subtitle子标题
 */
function loadChart(data,type,name,title,subtitle){
	 var labelsJson={};
	 if(type=="Pie"){
		 labelsJson= {
				 stringFormat: '%.1f%%',
				 valueType: 'percentage',
				 font: '15px sans-serif',
				 fillStyle: 'black'
		 }
	 }
	 $('#'+name).jqChart({
 title: { text: title
//    , font: '22px sans-serif', // 字体大小
//     fillStyle: 'black',  // 字体颜色
//     strokeStyle : undefined,  //笔画风格
     ,margin: 8 // 文字与图表距离
 },
 border: { strokeStyle: '#6ba851'
//     strokeStyle: 'black', // 边框颜色
     ,lineWidth: 0, // 边框线粗细
     cornerRadius: 0 //边角弧度半径
//     padding: 4 // 内容距离边框距离 	 
 },//边线颜色 
 background: background,/*背景渐变色的调整*/
 animation: { duration: 1 },//动画效果
 legend: {     //说明
     title: {}, // 标题
     border: {}, //边框
     font: '12px sans-serif', //字体大小
     textFillStyle: 'black',  // 字体颜色
     textStrokeStyle : undefined,  // 笔画风格
     background: undefined, //背景颜色
     margin: 4, // 内容距离边框距离
     visible : true //是否显示
} ,
//axes: [/*此处是对轴线的一些优化*/
//       {
//           location: 'left',
//           minimum: 10,
//           maximum: 700,
//           interval: 100
//       }
//     ],
 shadows: {
     enabled: true
 }, 
 series: [
     {
    	 title:subtitle,
             type: type,
//             markers: null,//不用圆点标示
//             strokeStyle: 'green' ,
             fillStyles: ['#418CF0', '#FCB441', '#E0400A', '#056492', '#BFBFBF', '#1A3B69', '#FFE382'],
             labels:labelsJson,
             explodedRadius: 10,
             explodedSlices: [5],
             labelsPosition: 'outside', // inside, outside
             labelsAlign: 'circle', // circle, column
             labelsExtend: 20,
             leaderLineWidth: 1,
             leaderLineStrokeStyle: 'black',
             data: data
         }
//         ,{///
//    	 title:"两个数据合在一起",
//             type: "column",
////             markers: null,//不用圆点标示
////             strokeStyle: 'green' ,
//             data: data
//         }
     ]
 });
 $("#layout").hide();
}
/**
 * 以对话框形式加载显示图表
 * @param url 访问的接口
 * @param title 在图表中显示的标题
 */
function loadChartDialog(url,title){
	var appChartDiv=$("#win");
	appChartDiv.load(contextPath +"/html_jqchart/appReport.html",function(){
		appReport.init(url,title);
	});
	$("#win").show();
}
