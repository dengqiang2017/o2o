var customer_id=common.getQueryString("customer_id");
var clerk_id=common.getQueryString("clerk_id");
if(!customer_id){
	customer_id="";
}else{
	$("#chat_left img").attr("src","images/portrait.png");
	$("#chat_right img").attr("src","images/service.png");
}
if(!clerk_id){
	clerk_id="";
}
var chat={
		len:0,
		init:function(){
    setInterval(function() {
      if ($(".chat").text() == '') {
          $('.footer img').show();
		  $('.head_portrait_amend').show();
          $('.footer button').hide();
      }else {
          $('.footer img').hide();
		  $('.head_portrait_amend').hide();
          $('.footer button').show();
      }
    },100);
    $.get("../login/getMsgCount.do",{
    	"com_id":com_id,
    	"clerk_id":clerk_id,
    	"customer_id":customer_id
    },function(data){
    	chat.len=data;
    });
    loadMsg();
    function loadMsg(){
    	$.get("../login/getNewMsg.do",{
    		"com_id":com_id,
    		"clerk_id":clerk_id,
    		"len":chat.len,"customer_id":customer_id
    	},function(data){
    		if(data){
    			$.each(data,function(i,n){
    				var item;
    				var msg;
    				if(customer_id){
    					if(n.kehu){
    						item=$($("#chat_left").html());
    						msg=n.kehu;
    					}else{
    						item=$($("#chat_right").html());
    						msg=n.kefu;
    					}
    				}else{
    					if(n.kehu){
    						item=$($("#chat_right").html());
    						msg=n.kehu;
    					}else{
    						item=$($("#chat_left").html());
    						msg=n.kefu;
    					}
    				}
    				$("#list").append(item);
    				if (/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(msg)){
    					item.find(".word").hide();
    					item.find(".tp_left").show();
    					var img="<a href='"+msg+"' data-lightbox='roadtrip'><img src='"+msg+"'></a>";
    					item.find(".tp_left").html(img);
    				}else{
    					if(msg.indexOf("http://")>=0||msg.indexOf("www")>=0){
    						item.find(".word").html("<a href='"+msg+"'>"+msg+"</a>");
    					}else{
    						item.find(".word").html(msg);
    					}
    				}
    			});
    			autodibu();
    		}
    	});
    }
	  setInterval(function(){
	    $.get("../login/getMsgCount.do",{
	    	"com_id":com_id,"clerk_id":clerk_id,
	    	"customer_id":customer_id
	    },function(data){
	    	if(chat.len<data){
	    		loadMsg();
	    		chat.len=data;
	    	}
	    });
	  }, 5000);
	  $(document).keydown(function(e) {
			if (e.keyCode == 13) {
				$("#send").click();
			}
		});
	  var jinru=0;
    $("#send").click(function(){
    	var item=$($("#chat_right").html());
		$("#list").append(item);
		var chatinfo=$.trim($(".chat").text());
		if(chatinfo&&chatinfo!="<br>"){
			if(chatinfo.indexOf("http://")>=0||chatinfo.indexOf("www")>=0){
				item.find(".word").html("<a href='"+chatinfo+"'>"+chatinfo+"</a>");
			}else{
				item.find(".word").html(chatinfo);
			}
		}
		$(".chat").html("");
		chat.len=chat.len+1;autodibu();
		$.post("../login/saveChartInfo.do",{
			"com_id":com_id,
			"jinru":jinru,
			"clerk_id":clerk_id,
			"chat":chatinfo,
			"customer_id":customer_id
		},function(data){
			if (data.success) {
//				pop_up_box.showMsg("成功!");
				jinru=1;
			} 
		});
    });
    if(is_weixin()){
    	$("#scxq").show();
    	$("#upload-btn").hide();
    	weixinfileup.init();
    	$("#scxq").click(function(){
    		var myDate=new Date().getTime();
    		var imgPath="/"+com_id+"/chart/img/"+myDate+".jpg";
    		weixinfileup.imguploadToWeixin(this, imgPath, imgitem.find("img"),function(){
    			addMsg(imgPath);
    		});
    	});
    }else{
    	$("#scxq").hide();
    	$("#upload-btn").show();
    }
   }
};
function autodibu(){
	var hid=document.getElementById('msg_end');//隐藏在消息框下面的元素
	hid.scrollIntoView(false);
}
function addMsg(imgurl){
	var item=$($("#chat_right").html());
	$("#list").append(item);
	item.find(".word").hide();
	item.find(".tp_left").show();
	var img="<img src='"+imgurl+"'>";
	item.find(".tp_left").html(img);
	$(".chat").html("");
	chat.len=chat.len+1;autodibu();
	$.post("../login/saveChartInfo.do",{
		"com_id":com_id,
		"clerk_id":clerk_id,
		"chat":imgurl,
		"customer_id":customer_id
	},function(data){
		if (data.success) {
//			pop_up_box.showMsg("成功!");
			jinru=1;
		} 
	});
}
function imgUpload(t){
	var myDate=new Date().getTime();
	var imgPath="/"+com_id+"/chart/img/"+myDate;
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImageZs.do?fileName=imgFile&imgPath="+imgPath,
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":50
	},t,function(imgUrl){
		pop_up_box.loadWaitClose();
		addMsg(imgUrl);
	});
}
lightbox.option({
	'resizeDuration': 200,
	'wrapAround': true
})
chat.init();