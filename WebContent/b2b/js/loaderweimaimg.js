function getComId(){
	var url=common.replaceAll(window.location.search,"\\|_", "&");
	var com_id=common.getQueryString("com_id",url);
	if(!com_id){
		com_id="001Y124";
	}
	if($("#com_id").length>0){
		var comid=$.trim($("#com_id").html());
		if(comid!=""){
			com_id=comid;
		}
	}
	return com_id;
}
var com_id= getComId();
function phoneFooter(){
	if(!common.isPC()){
		document.getElementsByTagName('body')[0].addEventListener('touchmove',function(){
			$('input').blur();
		});
		$('input').bind('focus',function(){
			$('.footer').css('position','static');
			$('.footer').hide();
		}).bind('blur',function(){
			$('.footer').css({'position':'fixed','bottom':'0'});
			$('.footer').show();
		});
	}
}
phoneFooter();
var customer={
		/**
		 * 判断是否登录,返回较多数据,没有登录就跳转到登录界面
		 * @param func 回调函数
		 */
		getCustomerInfo:function(func){
			$.get("../customer/getCustomerSimpleInfo.do",{"com_id":com_id},function(data){
				if(!data){
					if (is_weixin() && weixinAutoLogin) {
						weixinAutoLogin.init("客户", getComId(),function(login){
							if(login){
								$.get("../customer/getCustomerInfo.do",function(data){
									if(func){
										func(data);
									}
								});
							}else{
								$.cookie("backurl",window.location.href,{ path: '/', expires: 1 });
								window.location.href="../pc/login.jsp?com_id="+com_id;
							}
						});
					}else{
						$.cookie("backurl",window.location.href,{ path: '/', expires: 1 });
						window.location.href="../pc/login.jsp?com_id="+com_id;
					}
				}else{
					if(func){
						func(data);
					}
				}
			});
		},
		/**
		 * 判断是否登录,返回少量数据,不自动到登录界面
		 * @param func 回调函数
		 */
		getCustomer:function(func){
			$.get("../customer/getCustomer.do",{"com_id":com_id},function(data){
				if(!data||!data.name){//&&data!=""
					if (is_weixin() && weixinAutoLogin) {
						weixinAutoLogin.init("客户", getComId(),function(login){
							if(func){
								func(login);
							}
						});
					}else{
						if(func){
							func(false);
						}
					}
				}else{
					if(func){
						func(data);
					}
				}
			});
		}
}