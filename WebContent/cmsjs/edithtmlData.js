//业务员文章编辑
function editModalContent(modalName){
	$(".modal_"+modalName).show();
	$(".modal_cover").show();
}
var edithtml={
		type:0,
		selectImg:"",
		htmlname:"",
		init:function(){
			/**
			 * 加载编辑对话框
			 * @param url 文件地址
			 */
			function loadEditDig(id,fun){
				if ($("#"+id).length<=0) {
					$("body").append("<iframe id='"+id+"' src='article_dialog.jsp?ver="+Math.random()+"' style='width:100%; min-height:1000px; height:100%; border:none; position:fixed; top:0; left:0;z-index: 1031;'></iframe>");
					$("#"+id).bind("load",function(){
						if (fun) {
							fun();
						}
					});
				}
			}
////////////////////////////////模块编辑开始/////////////////////////
		/////////////////公共函数/////////
		/**
		 * 保存在线编辑的内容到html文件中
		 */
		function saveArticle(htmltxt,url,saveType,func){
			if (htmltxt=="") {
				alert("没有获取到编辑内容!");
				return;
			}
			pop_up_box.postWait();
			$.post("../temp/saveArticle.do",{
				"text":htmltxt,
				"projectName":projectName,
				"url":url,
				"type":edithtml.projectType
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
		function postArtical(htmlname,img,poster){
			if (!img) {
				img="";
			}
			pop_up_box.postWait();
			$.post("../temp/saveArtical.do",{
				"title":$("#title").val(),//文章标题
				"zhiding":$("#zhiding").prop("checked"), 
				"show":$("#show").prop("checked"), 
				"releaseTime":$(".Wdate").val(),//发布时间
				"publisher":$("#publisher").val(),//发布人
				"htmlname":htmlname,
				"gjc":$("#gjc").val(),
				"filetype":$("input[name='filetype']:checked").val(),
				"projectName":projectName,
				"type":edithtml.projectType,
				"img":img,//图片路径
				"poster":poster//视频封面图片路径
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.showMsg("保存成功!",function(){
//						history.go(-1);
						window.location.href="manage.jsp?projectType="+edithtml.projectType;
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
					"projectName":projectName,
					"projectType":edithtml.projectType,
					"type":"clerk"
				},function(data){//返回json格式文章信息
						///文章信息回显
						$("#title").val(data.title);
						$(".Wdate").val(data.releaseTime);
						$("#publisher").val(data.publisher);
						$("#gjc").val(data.gjc);
						if(!data.filetype){
							data.filetype=0;
						}
						$("input[name='filetype'][value="+data.filetype+"]").prop("checked",true);
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
						filetypeclick(data.filetype);
						if(data.filetype=="0"){
							if(data.img){
								$("#imgUr").attr("src",data.img);
								$("#filepath").val(data.img);
							}
						}else{
							if(data.img){
								$("#videoaddress").val(data.img);
							}
							if(data.poster){
								$("#videofilepath").val(data.poster);
								$("#videoimgUr").attr("src",data.poster);
							}
						}
						///获取html内容
						if(data.htmlname.indexOf("html")<0){
							data.htmlname=data.htmlname+".html"
						}
						$.get("/"+projectName+"/article/"+edithtml.projectType+"/"+data.htmlname,function(data){
							$(".nicEdit-main").html(data);
						});
				});
			}
			//1.2 图片视频切换
			function filetypeclick(val){
				if (val=="0") {
					$("#imgdiv").show();
					$("#videodiv").hide();
				}else{
					$("#videodiv").show();
					$("#imgdiv").hide();
				}
			}
			$("input[name='filetype']").unbind("click");
			$("input[name='filetype']").click(function(){
				filetypeclick($(this).val());
			});
				//2注册保存按钮事件
				//TODO 文章编辑保存按钮
				$("#save").unbind("click");
				$("#save").click(function(){
					//2.7设置显示到界面中的内容, window.parent.document
					var filetype=$("input[name='filetype']:checked").val();
					saveArticle($(".nicEdit-main").html(),edithtml.htmlname,edithtml.type,function(data){
						var path;
						if(filetype=="0"){
							path=$("#imgUr").attr("src");
						}else{
							path=$("#videoaddress").val();
						}
						var poster=$("#videofilepath").val();
						postArtical(data.msg,path,poster);
					});
				});
		}
		//TODO 公共函数结束
		$("#edithtml").height(window.screen.height-200);
	}
}
edithtml.htmlname=getQueryString("htmlname");
edithtml.projectType=getQueryString("projectType");
edithtml.type=1;//编辑
if(!edithtml.htmlname){
	edithtml.htmlname=new Date().getTime();
	edithtml.type=0;//新增
}
$(function(){
	edithtml.init();
	$(".fa-close,#closedig").click(function(){
		window.location.href="manage.jsp?projectType="+edithtml.projectType;
	});
});