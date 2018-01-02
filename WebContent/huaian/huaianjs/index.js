//			 $(".li_share").click(function(){
//			        if($("#show_share").length<=0){//判断分析页面是否存在,小于0不存在就获取页面加载到body中
//			            $.get("share.html",function(data){
//			                $("#hide_index").after(data);
//			                $("#hide_index").hide();
//			            });
//			        }else{//存在就直接显示
//			            $("#show_share").show();
//			            $("#hide_index").hide();
//			        }
//			    });
$.removeCookie("backurl", { path: '/' });
$.removeCookie("backurl");
function jisunje(t){
	var sd_unit_price=parseFloat($.trim(t.find("#sd_unit_price").html()));
var num=parseFloat($.trim(t.find(".num").val()));
var sum_si=numformat2(productOrder.productNum(t)*sd_unit_price);
t.find("#sum_si").html(sum_si);
	selectJe(); 
}

function selectUnit(item){
	item.find('.xs_btn button').click(function(){
var c=$(this).hasClass('btn_style');
$(this).parents(".pro-msg").find('.xs_btn button').removeClass("btn_style");
$(this).addClass("btn_style");
jisunje($(this).parents(".pro-msg"));
});
item.find('input').bind('focus',function(){
  $('.home_footer').css('position','static');
  $('#copy_bottom').css({'padding-bottom':'10px'})
  }).bind('blur',function(){
  $('.home_footer').css({'position':'fixed','bottom':'0'});
  $('#copy_bottom').css({'padding-bottom':'80px'});
      });
}

function selectJe(){
	var chekcs=$(".pro-checked");
if (chekcs&&chekcs.length>0) {
var orderje=0;
for (var i = 0; i < chekcs.length; i++) {
	var item=$(chekcs[i]).parents(".product");
var sum_si=item.find("#sum_si").html();
	if (!sum_si) {
		sum_si=0;
	}
	orderje+=parseFloat(sum_si);
}
$("#orderzje").html(numformat2(orderje));
}else{
	$("#orderzje").html("0");
	}
}
$("#orderpay").click(function(){
 //1.1获取产品id,报价单号,下单数量,放入cookie中
 var chekcs=$(".pro-checked");
if (chekcs&&chekcs.length>0) {
	var productList=[];
	var zsl=0;
	for (var i = 0; i < chekcs.length; i++) {
		var item=$(chekcs[i]).parents(".product");
var num=parseFloat($.trim(item.find(".num").val()));
var zsnum=num;
var sd_unit_price=item.find("#sd_unit_price_UP>strong").html();
var index=item.find('.xs_btn button').index(item.find(".btn_style"));
var pack_unit=item.find("#pack_unit").html();
if (!pack_unit) {
	pack_unit=1;
}
if(index==0){//表示是件单位需要计算折算数量
	zsnum=num*pack_unit;
//							sd_unit_price=numformat2((1/pack_unit)*sd_unit_price);
}
zsl=zsl+parseFloat(zsnum);
 var json={
		"com_id":item.find("#com_id").html(),
		"item_id":item.find("#item_id").val(),
		"item_name":item.find("#item_name").html(),
		"pack_unit":item.find("#pack_unit").html(),
		"sd_unit_price":sd_unit_price,
		"orderNo":item.find("#ivt_oper_listing").html(),
		"zsum":num
	 };
	 productList.push(JSON.stringify(json));
}
if (zsl<=0) {
	pop_up_box.showMsg("请输入购买数量!");
		return;
	}
 //放入cookie中
 $.cookie("productList","["+productList.join(",")+"]",{ path: '/', expires: 1 });
 //1.2判断是否登录
 $.get("../customer/getCustomer.do",function(data){
	 if(data){
 //1.4已经登录就直接到支付页面
 window.location.href="pay.html";
	 }else{
 //1.3没有登录就去登录,登录后到支付页面
 $.cookie("backurl","../pc/pay.html",{ path: '/', expires: 1 });
 window.location.href="login.html";
	 }
 });
}else{
	pop_up_box.showMsg("请选择一个产品!");
	}
});
document.getElementsByTagName('body')[0].addEventListener('touchmove',function(){
//  $('input').blur();
 //$('.home_footer').css('position','static');
});
$('input').bind('focus',function(){
    $('.home_footer').css('position','static');
    $('#copy_bottom').css({'padding-bottom':'10px'})
}).bind('blur',function(){
    $('.home_footer').css({'position':'fixed','bottom':'0'});
    $('#copy_bottom').css({'padding-bottom':'80px'})
});
