//var now = new Date();
//var nowStr = now.Format("yyyy-MM-dd"); 
//$("#d12").html(nowStr);
$("#d12").html("");
var customer_id=getQueryString("customer_id");
if(!customer_id){
	pop_up_box.showMsg("请先选择客户!", function(){
		window.location.href="clientList.html";
	});
}
//1.获取客户基本信息
$.get("../manager/getCustomerInfo.do",{
	"id":customer_id
},function(data){
	$("#clerk_name").html(data.corp_sim_name);
	$("#movtel").html(data.movtel);
	$("#memo").html(data.c_memo);
	$("#memoTx").val(data.c_memo);
	imgPath="001/userpic/"+data.customer_id+"/Pic_You.png";
	if(data.weixin_img){
		$("#user_logo").attr("src",data.weixin_img);
	}else{
		$("#user_logo").attr("src","../"+imgPath+"?ver="+Math.random());
	}
	if(data.isSale_Whole){
		$("#clientType>span:contains('"+$.trim(data.isSale_Whole)+"')").addClass("activesp");
	}
	try {
		if(!data.corp_sim_name||parseInt(data.corp_sim_name)>0){
			$("#corp_sim_name").val(data.weixin_name);
			$("#clerk_name").html(data.weixin_name);
		}
	} catch (e) {}
	$("#clientType>span").click(function(){
		var isSale_Whole=$(this).html();
		saveInfo(isSale_Whole,"");
	});
	$("#memoTx").change(function(){
		saveInfo("",$(this).val());
	});
	function saveInfo(isSale_Whole,memo){
		var param={};
		if(isSale_Whole){
			param.isSale_Whole=isSale_Whole;
		}
		if(memo){
			param.c_memo=memo;
		}
		param.customer_id=customer_id;
		$.post("../client/saveUserInfo.do",param,function(data){
			if (data.success) {
				pop_up_box.toast("已保存!",1000);
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
	}
});
//2.获取客户最近一天的足迹
//3.显示在列表中
loadData();
function loadData(){
	$(".secition_list").html("");
	$.get("../client/getFootmark.do",{
		"id":customer_id,
		"date":$("#d12").html()
	},function(data){
		if(data.success&&data.msg&&data.msg.length>0){
			var ns=data.msg.split(";"); 
			$.each(ns,function(i,n){
				if(n!=""){
					var ls=n.split(","); 
					var item=$($("#item").html());
					$(".secition_list").append(item);
					item.find("#content").html(ls[1]+"->"+ls[4]+"->"+ls[5].substr(0,17));
					item.find("#time").html(ls[3]);
				}
			});
		}
	});
}
$('.right_top span').click(function(){
    $('.right_top span').removeClass('activesp');
    $(this).addClass('activesp');
});