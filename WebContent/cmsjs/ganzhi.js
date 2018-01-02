///////////////
var clerk_id=getQueryString("clerk_id");
var com_id=getQueryString("com_id");
var code=getQueryString("code");
if(clerk_id){
	if(!com_id){
		com_id="001";
	}
	function stoptime(data){
		if (data&&data.msg) {
			console.log(data.msg);
			setInterval(function(){
				///提交停留时间
				$.post("../login/stopTime.do",{//每3秒钟向服务器提交一次当前时间
					"id":data.msg,
					"com_id":com_id
				});
			}, 3000);
		}
	}
	var url=common.getQueryString("url");
	if(!code){
		if(is_weixin()){
			window.location.href="../login/getCodeUrl.do?url="+window.location.href;
		}else{
			 $.post("../login/ganzhi.do",{
				 "id":url,
				 "name":$(".articleedit_title").html(),
				 "clerk_id":clerk_id,
				 "com_id":com_id,
				 "url":"/client/ganzhiRecord.html?id=",
				 "title":"客户浏览通知",
				 "desc":"有客户使用电脑浏览了【"+$(".articleedit_title").html()+"】,请注意后续跟进!"
			 },function(data){
				 stoptime(data);
			 });
		}
	}else{//
		var userid;
		var DeviceId;
		$.get("../login/getuserinfo.do",{
			"com_id":com_id,
			"code":code
		},function(data){
			if(data.UserId){
				userid=data.UserId;
				if(!userid){
					userid=data.OpenId;
				}
			}
			if(!userid){
				userid="";
			}
			if(data.DeviceId){
				DeviceId=data.DeviceId;
			}
			 $.post("../login/ganzhi.do",{
				 "id":url,
				 "name":$(".articleedit_title").html(),
				 "com_id":com_id,
				 "clerk_id":clerk_id,
				 "userid":userid,
				 "DeviceId":DeviceId,
				 "url":"/client/ganzhiRecord.html?id=",
				 "title":"客户浏览通知",
				 "desc":"@clerkName,客户【@customerName】浏览了【"+$(".articleedit_title").html()+"】,请注意后续跟进!"
			 },function(data){
				 stoptime(data);
			 });
		});
	}
}