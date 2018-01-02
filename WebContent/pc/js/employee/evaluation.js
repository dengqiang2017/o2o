$(function(){});
var evaluation={
		imageUrl:"",
		init:function(orderNo,item_id,com_id){
//			var params=window.location.href.split("?")[1];
//			if(params){
//				params=params.split("&");
//				orderNo=params[0].split("=")[1];//orderNo
//				item_id=params[1].split("=")[1];//item_id
//				com_id=params[2].split("=")[1];//item_id
//			}
			$("#ddlist").click(function(){
				$("#orderinfo").html("");
				$("#orderlist").show();
				return false;
			});
			$.get("../orderTrack/getOrderEvalInfo.do",{
				"type":$("#type").val(),
				"orderNo":orderNo,
				"com_id":com_id,
				"item_id":item_id
			},function(data){
				for (var i = 0; i < parseInt(data.spzl); i++) {
					$("#spzl").find("img").eq(i).removeClass("endranslate");
					$("#spzl").find("img").eq(i).addClass("startranslate");
					$("#spzl").find("img").eq(i).attr("src","../pc/images/xing.png");
				}
				for (var i = 0; i < parseInt(data.fwtd); i++) {
					$("#fwtd").find("img").eq(i).removeClass("endranslate");
					$("#fwtd").find("img").eq(i).addClass("startranslate");
					$("#fwtd").find("img").eq(i).attr("src","../pc/images/xing.png");
				}
				for (var i = 0; i < parseInt(data.wlsd); i++) {
					$("#wlsd").find("img").eq(i).removeClass("endranslate");
					$("#wlsd").find("img").eq(i).addClass("startranslate");
					$("#wlsd").find("img").eq(i).attr("src","../pc/images/xing.png");
				}
				$("#yijian").html(data.yijian);
				if (data.imgs) {
					var imgs=data.imgs;//.split(",");
//					if (imgs) {
						for (var i = 0; i < imgs.length; i++) {
							if (imgs[i]&&imgs[i]!="") {
								$("#showpingjia").append('<img src="../'+imgs[i]+'" onclick="javascript:evaluation.showImg(this)">');
							}
						}
//					}
				}
			});
		},showImg:function(t){
			$(".image-zhezhao").show();
			$("#imshow").html("");
			var index=$("#showpingjia img").index(t);
			 for (var i = 0; i < $("#showpingjia img").length; i++) {
				var img=$($("#showpingjia img")[i]);
				$("#imshow").append("<img style='display: none;' src='"+img.attr("src")+"'>");
			}
			$("#imshow").find("img:eq("+index+")").show();
		}
}
