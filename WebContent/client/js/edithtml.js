//业务员文章编辑
function editModalContent(modalName){
	$(".modal_"+modalName).show();
	$(".modal_cover").show();
}
var edithtml={
		type:0,
		projectType:0,
		selectImg:"",
		htmlname:"",
		datatype:"",//数据类型,clerk-业务员文章,""-非业务员
		init:function(){
        ////////////////////////模块编辑开始////////// 
		/////////////////公共函数/////////
		/**
		 * 保存在线编辑的内容到html文件中
		 */
		function saveArticle(url,saveType,func){
			if (!buedit.hasContent) {
				pop_up_box.showMsg("没有获取到编辑内容!");
				return;
			}
			//替换图片视频路径为当前应用下
			pop_up_box.postWait();
			$.post("../temp/saveArticleHtml.do",{
				"text":buedit.getContent(),
				"url":url,
				"saveType":edithtml.type,
				"type":"clerk"//保存文件类型,
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					if (func) {
						func(data);
					}
				}else{
					pop_up_box.showMsg(data.msg);
				}
			});
		}
		/**
		 * 将文章信息存储为json文件
		 */
		function postArtical(htmlname,img){
			if (!img) {
				img="";
			}
			pop_up_box.postWait();
			$.post("../temp/saveArticalJson.do",{
				"title":$("#title").val(),//文章标题
				"zhiding":$("#zhiding").prop("checked"), 
				"show":$("#show").prop("checked"), 
				"releaseTime":$(".Wdate").val(),//发布时间
				"publisher":$("#publisher").val(),//发布人
				"htmlname":htmlname,
				"gjc":$("#gjc").val(),
				"filetype":"0",
//				"projectName":projectName,
				"projectType":edithtml.projectType,
				"img":img//图片路径
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("保存成功!",function(){
						window.location.href="articleHistory.jsp";
					});
				} else {
					if (data.msg) {
						pop_up_box.showMsg("保存错误!" + data.msg);
					} else {
						pop_up_box.showMsg("保存错误!");
					}
				}
			});
		}
		////////////////公共函数结束/////////
			//增加新文章
		addArticle();
		function addArticle(){
			//1.1获取文件名
			if(edithtml.type==1){
				//回显
				$.get("../temp/getArticleInfoData.do",{
					"htmlname":edithtml.htmlname,
					"clerk_id":"clerk"
				},function(data){//返回json格式文章信息
					if(data){
						///文章信息回显
						$("#title").val(data.title);
						$(".Wdate").val(data.releaseTime);
						$("#publisher").val(data.publisher);
						$("#gjc").val(data.gjc);
						if(data.zhiding=="1"||data.zhiding=="true"){
							$("#zhiding").prop("checked",true);
						}else{
							$("#zhiding").prop("checked",false);
						}
						if(data.show=="1"||data.show=="true"){
							$("#show").prop("checked",true);
						}else{
							$("#show").prop("checked",false);
						}
						if(data.img){
							$("#imgUr").attr("src",data.img);
							$("#filepath").val(data.img);
						}
						///获取html内容
						if(data.htmlname.indexOf("html")<0){
							data.htmlname=data.htmlname+".html"
						}
						$.get(data.htmlname,function(data){
							buedit.setContent(data);
						});
					}
				});
			}
				//2注册保存按钮事件
				//TODO 文章编辑保存按钮
				$("#save").unbind("click");
				$("#save").click(function(){
					//2.7设置显示到界面中的内容, window.parent.document
					saveArticle(edithtml.htmlname,edithtml.type,function(data){
						var path=$("#imgUr").attr("src");
						postArtical(data.msg,path);
					});
				});
		}
		//TODO 公共函数结束
		$("#edithtml").height(window.screen.height-200);
	}
}
edithtml.htmlname=common.getQueryString("htmlname");
edithtml.projectType=common.getQueryString("projectType");
if(edithtml.projectType==null){
	edithtml.projectType=1;
}
edithtml.type=1;//编辑
if(!edithtml.htmlname){
	edithtml.htmlname=new Date().getTime();
	edithtml.type=0;//新增
}
$(function(){
	edithtml.init();
	$(".fa-close,#closedig").click(function(){
		window.location.href="articleHistory.jsp";
	});
});
function imgonlyUpload(t){
	var imgurl="";
	if (imgurl&&imgurl.indexOf("advantage")<0) {
	}else{
		imgurl="";
	}imgurl="";
	ajaxUploadFile({
		"uploadUrl" :"../upload/uploadImage.do?fileName=imgFile"+imgurl,
		"msgId" : "msg",
		"fileId" : "imgFile",//
		"msg" : "图片",
		"fid" : "filepath",
		"uploadFileSize" :1,
		"type":"img"
	}, t, function(imgUrl) {
		if(imgUrl){
			$("#filepath").val(imgUrl);
			$("#imgUr").attr("src",".."+imgUrl+"?ver="+Math.random());
		}
	});
}