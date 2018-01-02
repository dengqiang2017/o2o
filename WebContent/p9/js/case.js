var page=0;
var count=0;
var totalPage=0;
function right(){
    if(page<totalPage){
    	page=page+1;
    	loadItem(1);
    }
}
function left(){
    if(page>0){
    	page=page-1;
    	loadItem(1);
    }
}
$('.center>.pull-right').click(function(){
    $('.zz').slideToggle();
    $('.zz_box').toggle();
});
$('.zz_box').click(function(){
    $('.zz').hide();
    $('.zz_box').hide();
});
document.getElementsByTagName('body')[0].addEventListener('touchmove',function(){
    $('input').blur();
});

var type=1;
var ver=getQueryString("ver");
if(!ver){
	ver="001";
}
loadItem(1);
var imgitem=$("#caseitem");
function loadItem(type){
//		$.get(url+"/temp/getArticleList.do",{
	$.get(url+"/temp/getArticlePage.do",{
		"page":page,
		"count":count,
		"domainName":domainName,
		"type":type,
		"projectName":projectName,
		"rows":6,
		"path":projectName+"/article/"+type
	},function(data){
		if (data&&data.rows.length>0) {
			$(".xs").html("");
			$.each(data.rows,function(i,n){
				var item=$(imgitem.html());
				$(".xs").append(item);
				item.find(".articleedit_title").html(n.title);
				item.find(".articleedit_time").html(n.releaseTime);
				item.find(".articleedit_author").html(n.publisher);
				item.find(".articleedit_keywords").html(n.gjc);
				item.find(".content").html(n.gjc);
				item.find("#htmlname").html(n.htmlname);
				if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(n.img)){
					item.find("img").attr("src",n.img+"?ver="+ver);
					item.find("img").show();
					item.find("video").hide();
				}else{
					item.find("video").attr("src",n.img+"?ver="+ver);
					item.find("video").attr("poster",n.poster+"?ver="+ver);
					item.find("img").hide();
					item.find("video").show();
				}
				item.click({"htmlname":n.htmlname},function(event){
					window.location.href=url+"/"+projectName+"/case_detail.jsp?url="+projectName+"/article/"+type+"/"+event.data.htmlname;
				});
			});
		}
		count=data.totalRecord;
		totalPage=data.totalPage;
		$(".qh .center-block>span").html((page+1)+"/"+(totalPage+1));
	});
}
////提交留言
$(".btn-primary").click(function(){
    var name=$.trim($("#xm").val());
    var phone=$.trim($("#dh").val());
    var email=$.trim($("#yx").val());
    var miaos=$.trim($(".form-group textarea").val());
    if(name==""){
        pop_up_box.showMsg("请输入姓名!",function(){
            $("#xm").focus();
        });
    }else if(phone==""){
        pop_up_box.showMsg("请输入手机号!",function(){
            $("#dh").focus();
        });
    }else if(miaos==""){
        pop_up_box.showMsg("请填写简要说明!",function(){
            $(".form-group textarea").focus();
        });
    }else{
    	var imgs=$("#imglist img");
    	var imgUrl="";
    	if (imgs) {
        	for (var i = 0; i < imgs.length; i++) {
				imgUrl=$(imgs[i]).attr("src")+","+imgUrl;
			}
		}
    	pop_up_box.postWait();
        $.post(url+"/login/sendmail.do",{
        	"imgUrl":imgUrl,"domainName":domainName,
            "com_id":"001", 
            "subject":"客户留言",
            "text":"<h4>客户姓名:"+name+"<br>联系方式:"+phone+"<br>邮箱:"+email+"<br>说明:"+miaos+"<br></h4><div style='color:red;'>该邮件为系统通知邮件,请勿直接回复,<br>如果需要回复请按照邮件内容中联系方式进行回复</div>"
        },function(data){
        	pop_up_box.loadWaitClose();
            pop_up_box.showMsg("提交成功!",function(){
            $("#dh,#xm,#yx").val("");
            $(".form-group textarea").val("");
            $("#imglist").html("");
            }); 
        });
    }
});
//////加载 互联网+思维？ 20
function loadItem2(num,type,list){
	$.get(url+"/temp/getArticlePage.do",{
//		"filter":"json",
		"projectName":projectName,
		"type":type,
		"page":0,
		"domainName":domainName,
		"rows":num,
		"path":projectName+"/article/"+type
	},function(data){
		if (data&&data.rows.length>0) {
			list.html("");
			$.each(data.rows,function(i,n){
//				n=$.parseJSON(n);
				list.prev("p").html("发表时间:"+n.releaseTime);
				list.prev("p").prev("p").html("发表时间:"+n.releaseTime);
				var item=$("<li></li>");
				list.append(item);
				item.html(n.title);
		             item.click({"htmlname":n.htmlname},function(event){
							window.location.href=url+"/"+projectName+"/case_detail.jsp?url="+projectName+"/article/"+type+"/"+event.data.htmlname;
					  });
			});
		}
	});
}

loadItem2(2, 20, $("#list20"));
/////加载 为什么？21 
loadItem2(3, 21, $(".list21"));
loadItem2(3, 21, $(".list212"));
/////加载 怎么做？22
loadItem2(3, 22, $("#list22"));
$(".ui_more>a").click(function(){
	var title=$(this).parents(".col-lg-7").find(".ui_title").html();
	var type=$(this).parents(".col-lg-7").find(".ui_type").html();
	window.location.href="more.html?title="+title+"&type="+type;
});