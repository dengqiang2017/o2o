$(function(){
	var url=window.location.href;
	url=url.split("?")[1];
	if (!url) {
		pop_up_box.showMsg("不能直接访问该页面!",function(){
			 history.go(-1);
		});
	}
	var params=url.split("&");
	var type;
	var item_id;
	 
	var b=false;
	if (params.length>1) {
		type=params[0].split("=")[1];
		item_id=params[1].split("=")[1];
		b=true;
	}
    var cps="";
    if (params[2]&&params[2].split("=").length>0) {
    	cps=params[2].split("=")[1];
	}
    if (b&&"product"==type) {
		$.get("../product/getImgUrl.do",{"item_id":item_id},function(data){
			if (cps=="cp") {
				$.each(data.cps,function(i,name){
					if (/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(name)) {
						$(".arrow-left1").after("<img src='"+name+"' onerror='this.remove();'>");
						$(".arrow-left2").after("<img src='"+name+"' onerror='this.remove();'>");
					}
				});
			}else{
				$.each(data.xjs,function(i,name){
					if (/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(name)) {
						$(".arrow-left1").after("<img src='"+name+"' onerror='this.remove();'>");
						$(".arrow-left2").after("<img src='"+name+"' onerror='this.remove();'>");
					}
				});
			}
			imginit();
//			$("body").append('<script type="text/javascript" src="../js/o2od.js"></script>');
			$(".img-ctn img").click(function(){
				var n = $(".img-ctn img").index(this);
				  $(".img-lg img").hide();
				  $(".img-lg img:eq("+n+")").show();
			});
		});
	}else if (b&&"user"==type) {
		$(".arrow-left1").after("<img src='../userpic/"+item_id+"/IDcard.png'>");
		$(".arrow-left1").after("<img src='../userpic/"+item_id+"/You.png'>");
		$(".arrow-left1").after("<img src='../userpic/"+item_id+"/Inc.png'>");
		$(".arrow-left1").after("<img src='../userpic/"+item_id+"/BusinessLicense.png'>");
		$(".arrow-left1").after("<img src='../userpic/"+item_id+"/OrganizationCode.png'>");
		$(".arrow-left1").after("<img src='../userpic/"+item_id+"/TaxRegistration.png'>");
		$(".arrow-left2").after("<img src='../userpic/"+item_id+"/IDcard.png'>");
		$(".arrow-left2").after("<img src='../userpic/"+item_id+"/You.png'>");
		$(".arrow-left2").after("<img src='../userpic/"+item_id+"/Inc.png'>");
		$(".arrow-left2").after("<img src='../userpic/"+item_id+"/BusinessLicense.png'>");
		$(".arrow-left2").after("<img src='../userpic/"+item_id+"/OrganizationCode.png'>");
		$(".arrow-left2").after("<img src='../userpic/"+item_id+"/TaxRegistration.png'>");
		imginit();
	}else{
		$(".arrow-left1").after("<img src='"+url+"'>");
		$(".arrow-left2").after("<img src='"+url+"'>");
		$(".img-ctn,.arrow-right1,.arrow-left1").hide();
		imginit();
	}
    
    $(".delete-img").click(function(){
    	history.go(-1);
    });
   var index=0;
   function imginit(){
	   $(".img-lg").find("img").hide();
	   $(".img-lg").find("img:eq(0)").show();
	   $(".arrow-left1").click(function(){
		   if (index>0) {
			   index=index-1;
			   $(".img-lg").find("img").hide();
			   $(".img-lg").find("img:eq("+index+")").show();
		   }else{
			   var len=$(".img-lg").find("img").length-1;
			   index=len;
			   $(".img-lg").find("img").hide();
			   $(".img-lg").find("img:eq("+index+")").show();
		   }
	   });
	   $(".arrow-right1").click(function(){
		   var len=$(".img-lg").find("img").length-1;
		   if (index<len) {
			   index=index+1;
			   $(".img-lg").find("img").hide();
			   $(".img-lg").find("img:eq("+index+")").show();
		   }else{
			   index=0;
			   $(".img-lg").find("img").hide();
			   $(".img-lg").find("img:eq("+index+")").show();
		   }
	   });
   }
    
});