//设置html页面的title标签显示内容
if(window.location.href.indexOf("html")>0){
	var com_id=getQueryString("com_id");
	if(!com_id){
		com_id=$.cookie("com_id");
		if(!com_id||com_id.indexOf("com")>=0){
			com_id="";
		}
	}
	$.get("../login/getSystemName.do",{
		"com_id":com_id
	},function(data){
		if(data.success){
			$("title").html(data.msg);
			sharePrex=data.msg;
		}
	});
}