function editModalContent(modalName){
	$(".modal_"+modalName).show();
	$(".modal_cover").show();
}
var edithtml={
		type:0,
		selectImg:"",
		init:function(){
			/**
			 * 显示编辑虚线框
			 */
			function showEdit(){
				return "<div class='edit_default e_border_top'></div>"+
                "<div class='edit_default e_border_right'></div>"+
                "<div class='edit_default e_border_bottom'></div>"+
                "<div class='edit_default e_border_left'></div>"+
                "<div class='edit_default edit_btn'>"+
                    "<button class='btn_edit' style='font-size: 16px;'>编辑</button>"+ 
//                    "<button class='btn_color' style='font-size: 16px;'>设置颜色</button>"+ 
                "</div>";
			}
			/**
			 * 显示编辑虚线框
			 */
			function showArticleEdit(){
				return "<div class='edit_article e_border_top'></div>"+
                "<div class='edit_article e_border_right'></div>"+
                "<div class='edit_article e_border_bottom'></div>"+
                "<div class='edit_article e_border_left'></div>"+
                "<div class='edit_article edit_btn'>"+
                "<button class='btn_edit' style='font-size: 16px;'>编辑</button>"+
                "<button class='btn_add' style='font-size: 16px;'>新增</button>"+
                "<button class='btn_del' style='font-size: 16px;'>删除</button>"+
                "</div>";
			}
			/**
			 * 显示编辑虚线框
			 */
			function showAEdit(){
				return  '<div class="edit_article"><div class="edit_btn">'
				+'<button class="btn_edit" style="font-size: 16px;">编辑</button><button class="btn_add" style="font-size: 16px;">添加</button><button class="btn_del" style="font-size: 16px;">删除</button>'
				+'</div></div>';
			}
			/**
			 * 加载编辑对话框
			 * @param url 文件地址
			 */
			function loadEditDig(id,url,fun){///wordedit/artical_dialog.html
				if ($("#"+id,window.parent.document).length<=0) {
					$("body",window.parent.document).append("<iframe id='"+id+"' src='"+url+"' style='width:100%; min-height:1000px; height:100%; border:none; position:fixed; top:0; left:0;z-index: 1031;'></iframe>");
					$("#"+id,window.parent.document).bind("load",function(){
						if (fun) {
							fun();
						}
						$(".btn-primary").unbind("click");
						$(".btn-info").unbind("click");
					});
				}
			}
			function loadArtical(fun){
				$.get("artical_dialog.html?ver="+Math.random(),function(data){
					$("body > #dig",window.parent.document).append(data);
					if (fun) {
						fun();
					}
					$(".btn-primary").unbind("click");
					$(".btn-info").unbind("click");
				});
			}
			var login_url="../pc/login-yuangong.html";
			$.ajaxSetup({
				contentType : "application/x-www-form-urlencoded;charset=utf-8",
				complete : function(XMLHttpRequest, textStatus) {
					var responseText = XMLHttpRequest.responseText;
					if (responseText.indexOf("<title>登录</title>") > 0) {
						window.location.href = login_url;
					}
					if (responseText) {
						try {
							var sessionstatus = eval('(' + responseText + ')');
							if (sessionstatus
									&& sessionstatus.sessionstatus == "timeout") {
								alert("会话超时,重新登录!");
								// 这里怎么处理在你，这里跳转的登录页面
								window.location.href = login_url;
							}
						} catch (e) {
						}
					}
				}
			});
			// TODO 模块编辑开始/////////////////////////
			var projectName=$("#projectName").html();
			var delWordList=[];
			 function aAddTarget(leidt){
				//addTarget();
				parent.editstate=1;
				leidt.remove();
				$(".cover").remove();
			 }
			 // TODO 文字编辑//////////
		function htmlbackcolor(ahtml){
			ahtml.unbind("dblclick");
			ahtml.dblclick(function(){
				loadEditDig("aedit","dialog/backcolor_dialog.html?ver="+Math.random(),function(data){
					var aedit=$("#aedit",window.parent.document);
 					$("body").append(data);//2.4添加到body中
					var iframeContent=aedit.contents();
					aedit.show();
					iframeContent.find("#backcolor").val(ahtml.css("background-color"));
					iframeContent.find("#fontcolor").hide();
					iframeContent.find("#fontcolor").prev().hide();
					//////
					//2.5注册关闭对话框事件
					iframeContent.find(".fa-close,#closedig").click(function(){
						aedit.remove();
					});
					//TODO 文字背景颜色保存按钮
					$("#save").unbind("click");
					iframeContent.find("#save").click(function(){
						var backcolor=$.trim(iframeContent.find("#backcolor").val());
						ahtml.css("background-color",backcolor);
						var fontcolor=$.trim(iframeContent.find("#fontcolor").val());
						ahtml.css("color",fontcolor);
						ahtml.find(".product").css("background-color",backcolor);
						aedit.remove();
					});
				});
				
			});
		}
		$(".htmlbackcolor").bind("mouseenter",function(){
			var ahtml=$(this);
			htmlbackcolor(ahtml);
		});
		
		$(".textonly").bind("mouseenter",function(){
			var ahtml=$(this);
				ahtml.find(".edit_default").remove();
				ahtml.append(showEdit());//1.3不存在就增加编辑按钮代码
				if (ahtml.css("width").replace("px","")<100) {
					var editbtn=ahtml.find(".edit_btn");
					editbtn.removeClass("edit_btn");
					editbtn.addClass("edit_btnS");
				}
				//2.按钮事件注册
				//2.1注册编辑按钮点击事件
				ahtml.bind("dblclick",function(){
					ahtml.find(".btn_edit").click();
				});
				
				ahtml.find(".btn_color").bind("click",function(){
					ahtml.find(".edit_default").remove();
					loadEditDig("aedit","dialog/backcolor_dialog.html?ver="+Math.random(),function(data){
						ahtml.find(".edit_default").remove();
						var aedit=$("#aedit",window.parent.document);
						var iframeContent=aedit.contents();
						aedit.show();
						///////////////////
						iframeContent.find("#backcolor").val(ahtml.css("background-color"));
						iframeContent.find("#fontcolor").val(ahtml.css("color"));
						//////
						//2.5注册关闭对话框事件
						iframeContent.find(".fa-close,#closedig").click(function(){
							aedit.remove();
						});
						////TODO 文字保存按钮
						$("#save").unbind("click");
						iframeContent.find("#save").click(function(){
							var backcolor=$.trim(iframeContent.find("#backcolor").val());
							ahtml.css("background-color",backcolor);
							var fontcolor=$.trim(iframeContent.find("#fontcolor").val());
							ahtml.css("color",fontcolor);
							aedit.remove();
						});
					});
				});
				ahtml.find(".btn_edit").bind("click",function(){
					//2.2判断对话框是否存在
						//2.3不存在就获取对话框html代码
					ahtml.find(".edit_default").remove();
						loadEditDig("aedit","dialog/text_dialog.html?ver="+Math.random(),function(data){
							ahtml.find(".edit_default").remove();
							var aedit=$("#aedit",window.parent.document);
							var iframeContent=aedit.contents();
							aedit.show();
							///文字回显begin///// 
							if (!ahtml.find("a").html()||ahtml.find("a").html()=="") {
								iframeContent.find("#text").val($.trim(ahtml.text()));
							}else{
								iframeContent.find("#text").val(ahtml.find("a").text());
								iframeContent.find("#address").val(ahtml.find("a").attr("href"));
							}
							iframeContent.find("#backcolor").val(ahtml.css("background-color"));
							iframeContent.find("#textcolor").val(ahtml.css("color"));
							iframeContent.find("#fontsize").val(ahtml.css("font-size"));
							iframeContent.find("#phonefontsize").val(ahtml.attr("data-phone-font"));
							
							iframeContent.find("#font").val(ahtml.css("font-family"));
							////文字回显end//////
							//2.5注册关闭对话框事件
							iframeContent.find(".fa-close,#closedig").click(function(){
								aedit.remove();
							});
							///换行按钮
							iframeContent.find(".modal_br").click(function(){
								 var text=iframeContent.find("#text");
								 var textval=text.val().toString();
								 var begin=textval.substr(0,text.getCurPos());
								 var end=textval.substr(text.getCurPos(),text.val().length-1);
								 text.val(begin+"<br>"+end);
							});
							////空格按钮
							iframeContent.find("#transparent").click(function(){
								iframeContent.find("#backcolor").val("transparent");
							});
							iframeContent.find("#backcolor").bind("input propertychange blur",function(){
								iframeContent.find("#transparent").prop("checked",false);
							});
							iframeContent.find(".modal_space").click(function(){
								var text=iframeContent.find("#text");
								var textval=text.val().toString();
								var begin=textval.substr(0,text.getCurPos());
								var end=textval.substr(text.getCurPos(),text.val().length-1);
								text.val(begin+"&ensp;"+end);
							});
							//TODO 文字保存按钮2
							$("#save").unbind("click");
							iframeContent.find("#save").click(function(){
								//2.7设置显示到界面中的内容, window.parent.document
								var text=iframeContent.find("#text").val();
								var address=iframeContent.find("#address").val();
								var i=ahtml.find("i");
								if (i.length>=0) {
									ahtml.html(i);
								}else{
									ahtml.html("");
								}
								if (address!="") {
									if (ahtml.find("a").length<=0) {
										ahtml.append("<a href=''>"+text+"</a>");
									}
									ahtml.find("a").attr("href",address);
								}else{
									ahtml.append(text);
								}
								ahtml.css("background-color",iframeContent.find("#backcolor").val());
								ahtml.css("color",iframeContent.find("#textcolor").val());
								ahtml.css("font-size",iframeContent.find("#fontsize").val());
								ahtml.attr("data-phone-font",iframeContent.find("#phonefontsize").val());
								ahtml.attr("data-pc-font",iframeContent.find("#fontsize").val());
								ahtml.css("font-famiCly","'"+iframeContent.find("#font").val()+"'");
								
								saveText(ahtml,".logo_container","head");
								saveText(ahtml,".footer","footer");
								saveText(ahtml,".main_title_ctn","main_title_ctn");
								saveText(ahtml,".top_icon","top_icon");
								aAddTarget(aedit);
							});
						});
				});
		});
		function saveText(ahtml,paretName,name){
			if (ahtml.parents(paretName).length>0) {
				if (name=="main_title_ctn"||name=="top_icon") {
					$("title").html(ahtml.text());
				}else{
					ahtml.parents(paretName).find(".edit_default").remove();
					$.post("temp/saveFragmentHtml.do",{
						"content":ahtml.parents(paretName).html(),
						"name":name
					},function(data){
					});
				}
			}
		}
///////////////////背景选择开始///////////////
		// TODO 文章编辑开始/////////////////////////////
		/////////////////公共函数/////////
		/**
		 * 保存在线编辑的内容到html文件中
		 */
		function saveArticle(text,url,type,article,articleaddress,func){
			if (article=="1"&&articleaddress=="") {
				alert("请上传word文件!");
				return;
			}
			var htmltxt=$.trim(text.html());
			if (article=="0"&&htmltxt=="") {
				alert("没有获取到编辑内容,请将编辑中的内容备份到外部word等地方,然后重启浏览器再次进行操作!");
				return;
			}
			if (article=="1"){
				htmltxt="";
			}else{
				articleaddress="";
			}
			pop_up_box.postWait();
			$.post("../temp/saveArticle.do",{
				"text":htmltxt,
				"projectName":projectName,
				"url":url,
				"utf":"utf-8",
				"articletype":article,
				"articleaddress":articleaddress,
				"type":type
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
		function postArtical(type,typeName,title,wdate,publisher,htmlname,gjc,img,poster,articleedit_content,zhiding,func){
			if (!img) {
				img="";
			}
			$.post("../temp/saveArtical.do",{
				"type":type,
				"projectName":projectName,
				"typeName":typeName,//类型名称
				"title":title.val(),//文章标题
				"releaseTime":wdate.val(),//发布时间
				"publisher":publisher.val(),//发布人
				"htmlname":htmlname,
				"content":articleedit_content,
				"img":img,//图片路径
				"zhiding":zhiding,
				"poster":poster,//视频封面图片路径
				"gjc":gjc
			},function(data){
				if (!data.success) {
					alert(data.msg);
				}else{
					if (func) {
						func(data.msg);
					}
				}
			});
		}
		function closeIframe(iframeContent,articaledit){
			iframeContent.find(".fa-close,#closedig").click(function(){
				articaledit.remove();
			});
		}
		////////////////公共函数结束/////////
		//TODO 公共函数结束
		var wordurl="article_dialog.html?ver="+Math.random();
		$(".articleedit").bind("mouseenter",function(){
			var ahtml=$(this);
			ahtml.find(".edit_article").remove();
			ahtml.append(showArticleEdit());//1.3不存在就增加编辑按钮代码
			//2.按钮事件注册
			//2.1注册编辑按钮点击事件
			function addLi(href,title,content){
				return '<li class="articleedit"><a target="_blank" class="file_list_title articleedit_title" href="'+href
				+'"><i class="fa fa-angle-right fa-fw"></i>'+title+'</a>'+
				'<a class="file_list_content articleedit_content">'+content+'</a></li>';
			}
			var type=getType();
			edithtml.type=type;
			function showArticalDig(params){
					//2.3不存在就获取对话框html代码
					loadEditDig("articaledit",wordurl,function(data){
						$("body").append(data);//2.4添加到body中
						ahtml.find(".edit_default").remove();
						var articaledit=$("#articaledit",window.parent.document);
						var iframeContent=articaledit.contents();
						iframeContent.find("#type").html(type);
						//TODO 数据回显
						var text=iframeContent.find(".nicEdit-main");
						var title=iframeContent.find("#title");
						var wdate=iframeContent.find(".Wdate");
						var publisher=iframeContent.find("#publisher");
						var gjc=iframeContent.find("#gjc");
						var imgUr=iframeContent.find("#imgUr");
						var videoimgUr=iframeContent.find("#videoimgUr");
						var zhiding=iframeContent.find("#zhiding");
						var url="";
						///////////////////////////
						function filetypeclick(val){
							if (val=="0") {
								iframeContent.find("#imgdiv").show();
								iframeContent.find("#videodiv").hide();
							}else{
								iframeContent.find("#videodiv").show();
								iframeContent.find("#imgdiv").hide();
							}
						}
						iframeContent.find("input[name='filetype']").unbind("click");
						iframeContent.find("input[name='filetype']").click(function(){
							filetypeclick($(this).val());
						});
						var imgurl=iframeContent.find("#filepath");
						var imgvideo=ahtml.parent().find("img");
						if (imgvideo.length>0) {
							if(imgvideo.length>1){
								imgvideo=ahtml.find("img"); 
							}
						}else{
							imgvideo=ahtml.parent().find("video");
							if (imgvideo.length>1) {
								imgvideo=ahtml.find("video");
							}
							if (imgvideo.length<0) {
								imgvideo=ahtml.parent().find("embed");
								if (imgvideo.length>1) {
									imgvideo=ahtml.find("embed");
								}
							}
						}
						/////////////////////////////////////////////////////
						if (params) {
							url=ahtml.find("#htmlname").html();
							title.val(ahtml.find(".articleedit_title").text());
							wdate.val(ahtml.find(".articleedit_time").text());
							publisher.val(ahtml.find(".articleedit_author").text());
							gjc.val(ahtml.find(".articleedit_keywords").text());
							var azd="";
							if($.trim(ahtml.find("#zhiding").html())!=""){
								zhiding.prop("checked",true);
								azd="a";
							}
							if (url&&url!=""&&url!="#") {
								$.get("article/"+type+"/"+url+"?math="+Math.random(),function(data){
									text.html(data);
									if(!browser.versions.gecko){
										text.find("img").bind("click",function(){
											edithtml.selectImg=$(this);
											 var wid=$(this).css("width")
											 if(!wid){
												 wid=this.width;
											 }else{
												 wid=wid.replace("px","");
											 }
											 var hei=$(this).css("height")
											 if(!hei){
												 hei=this.height;
											 }else{
												 hei=hei.replace("px","");
											 }
											 iframeContent.find("#imgwidth").val(wid);
											 iframeContent.find("#imgheight").val(hei);
										});
									}
								});
							}else{
								url="";
							}
							if(type==1||type==2||type==4){
								$.get("article/"+type+"/"+azd+url.split(".")[0]+".json?math="+Math.random(),function(data){
									wdate.val(data.releaseTime);
									publisher.val(data.publisher);
									gjc.val(data.gjc);
									if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(data.img)){
										imgUr.attr("src",data.img);
									}else{
										iframeContent.find("#videoaddress").val(data.img);
										iframeContent.find("input[name='filetype']:eq(1)").attr("checked","checked");
										filetypeclick("1");
									}
									if(type==4){
										imgUr.attr("src",imgvideo.attr("src"));
										imgurl.val(imgvideo.attr("src"));
										iframeContent.find("input[name='filetype']:eq(0)").attr("checked","checked");
										filetypeclick("0");
									}
									if (data.poster) {
										videoimgUr.attr("src",data.poster);
									}
								});
							}
						}
						if (ahtml.attr("data-title")!="") {
							iframeContent.find(".form_tips_gray").html(ahtml.attr("data-title"));
						}
						if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test(imgUr.attr("src"))){
							//图片格式
							try {
								imgurl.val(imgvideo.attr("src"));
								iframeContent.find("img").attr("src",imgurl.val()+"?ver="+Math.random());
								iframeContent.find("input[name='filetype']:eq(0)").attr("checked","checked");
								filetypeclick("0");
							} catch (e) {}
							if (ahtml.attr("data-title")!="") {
								iframeContent.find(".form_tips_gray").html(ahtml.parent().attr("data-title"));
							}
						}else{
							try {
								var embedsrc=imgvideo.attr("src"); 
								if (!embedsrc) {
									embedsrc=imgvideo.attr("src");
								}
								iframeContent.find("#videoaddress").val(embedsrc);
 								iframeContent.find("input[name='filetype']:eq(1)").attr("checked","checked");
								filetypeclick("1");
							} catch (e) {}
						}
						/////////////////////////////////////////////////////////
						iframeContent.find(".modal_space").click(function(){
							var textval=title.val().toString();
							var begin=textval.substr(0,title.getCurPos());
							var end=textval.substr(title.getCurPos(),title.val().length-1);
							title.val(begin+"&ensp;"+end);
						});
						//2.5注册关闭对话框事件
						closeIframe(iframeContent,articaledit);
						/////////
						//2.6注册保存按钮事件
						//TODO 文章编辑保存按钮
						$("#save").unbind("click");
						iframeContent.find("#save").click(function(){
							//2.7设置显示到界面中的内容, window.parent.document
							var article=iframeContent.find("input[name='article']:checked").val();
							var articleaddress=$.trim(iframeContent.find("#articleaddress").html());
							ahtml.find(".edit_article,.cover").remove();
							saveArticle(text,url,type,article,articleaddress,function(data){
								var  imgitem=ahtml.parent();
								 if(imgitem.find("li").length>0){
									 imgitem=ahtml;
								 }
								imgitem.find(".articleedit_title").html(title.val());
								imgitem.find(".articleedit_time").html(wdate.val());
								imgitem.find(".articleedit_author").html(publisher.val());
								var articleedit_content=text.text().substr(0,70);
								imgitem.find(".articleedit_content").html(articleedit_content);
								imgitem.find(".articleedit_keywords").html(gjc.val());
								var htmlname=data.msg;
								imgitem.find("#htmlname").html(htmlname);
								if (!params&&(!url||url=="")) {
									edithtml.init();
								}
								var typeName=ahtml.parents(".file_group").find(".file_title > .textonly").text();
								////////////////////////////////
								var path;
								var poster=iframeContent.find("#videofilepath").val();
								if(iframeContent.find("input[name='filetype']:checked").val()=="0"){
									imgvideo=ahtml.parent().find("img");
									var address=iframeContent.find("#address").val();
									path=iframeContent.find("#filepath").val();
									if (address!="") {
										ahtml.parent().find("a").attr("href",address);
									}
									imgvideo.attr("src",path);
									imgvideo.show();
								}else{
									imgvideo=ahtml.parent().find("video");
									var videoaddress=iframeContent.find("#videoaddress").val();
									path=videoaddress;
									imgvideo.attr("src",videoaddress);
									imgvideo.show();
									var ahtmlimga=ahtml.parent().find("a");
									if (ahtmlimga.length>1) {
										ahtmlimga=ahtml.find("a");
									}
									ahtmlimga.hide();
								}
								imgitem.find("a").show();
								/////////////////////////////
								var zhiding=iframeContent.find("#zhiding").prop("checked");
								if(zhiding){
									ahtml.find("#zhiding").html("置顶");
								}else{
									ahtml.find("#zhiding").html("");
								}
								postArtical(type,typeName,title,wdate,publisher,htmlname,gjc.val(),
										path,poster,articleedit_content,zhiding,function(returl){
//									if(type!=4){
//										if(iframeContent.find("input[name='filetype']:checked").val()=="0"){
//											imgvideo.attr("src","article/"+type+"/"+returl);
//										}else{
//											imgvideo.attr("src","article/"+type+"/"+returl);
//										}
//									}
								});
								aAddTarget(articaledit);
							});
						});
					});
			}
			ahtml.find(".btn_edit").bind("click",function(){
				showArticalDig({"edit":"edit"});
			});
			ahtml.find(".btn_add").bind("click",function(){
				var imgitem=$(getimgitem().html());
				 var list=getlist();
				 if(list.find("li:eq(0)").length>0){
					 list.find("li:eq(0)").before(imgitem);
				 }else{
					 list.find(".col-lg-3:eq(0)").before(imgitem);
				 }
				edithtml.init();
			});
			ahtml.find(".btn_del").bind("click",function(){
				if (confirm("是否要删除该文档内容!")) {
					var par=$(this).parents(".col-lg-3");
					var htmlname=par.find("#htmlname").html();
					if(par.length==0){
						par=$(this).parents("li");
						htmlname=par.find("#htmlname").html();
						$.get("../upload/removeTemp.do",{
							 "imgUrl":projectName+"/article/"+type+"/"+htmlname.split(".")[0]+".jpg"
						 });
						 $.get("../upload/removeTemp.do",{
							 "imgUrl":projectName+"/article/"+type+"/"+htmlname.split(".")[0]+".png"
						 });
						 $.get("../upload/removeTemp.do",{
							 "imgUrl":projectName+"/article/"+type+"/"+htmlname.split(".")[0]+".mp4"
						 });
					}
					 $.get("../upload/removeTemp.do",{
						 "imgUrl":projectName+"/article/"+type+"/"+htmlname
					 });
					 $.get("../upload/removeTemp.do",{
						 "imgUrl":projectName+"/article/"+type+"/"+htmlname.split(".")[0]+".json"
					 });
					 var imgUrl=par.find("img").attr("src");
					 if (imgUrl&&imgUrl!="") {
						 $.get("../upload/removeTemp.do",{
							 "imgUrl":projectName+"/"+imgUrl
						 });
					 }else{
						 
					 }
					 var imgUrl=par.find("video").attr("src");
					 if (imgUrl&&imgUrl!="") {
						 $.get("../upload/removeTemp.do",{
							 "imgUrl":projectName+imgUrl
						 });
					}
					 par.remove();
				}
			});
		});
		////////////////////////////////////////////
		$("#edithtml",window.parent.document).height(window.screen.height-200);
		}
}