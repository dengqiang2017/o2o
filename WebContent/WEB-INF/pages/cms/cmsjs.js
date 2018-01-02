var cmsjs={
		init:function(){
			$.get("/cms/cms.html?ver=0001",function(data){
				$("nav").after(data);
				$(".text").attr("contenteditable","true");
				$(".text").click(function(){
					$(".text").removeClass("selectColor");
					$(this).addClass("selectColor");
					$("input[type='color']").val(rgbToHex($(this).css("color")));
					$("#fontsize").val($(this).css("font-size").split("px")[0]);
					if($(this).css("font-weight")==700){
						$(":radio[value='bold']").prop("checked",true);
					}else{
						$(":radio[value='normal']").prop("checked",true);
					}
				});
				$("input[type='color']").change(function(){
					$(".selectColor").css("color",$(this).val());
				});
				$("#fontsize").change(function(){
					$(".selectColor").css("font-size",$(this).val()+"px");
				});
				$(":radio").click(function(){
					$(".selectColor").css("font-weight",$(this).val());
				});
				$("#deltemp").click(function(){
					if(confirm("是否确认注销该套官网?")){
						$.get("/temp/delTemp.do",function(data){
							if (data.success) {
								pop_up_box.showMsg("注销成功,即将返回运营管理后台!",function(){
									window.location.href="/employee.do";
								});
							} else {
								pop_up_box.showMsg("注销失败,请联系管理员!");
							}
						});
					}
				});
			});
			function showBigimgEdit(){
				return "<div class='edit_article img_border_top'></div>"+
				"<div class='edit_article img_border_right'></div>"+
				"<div class='edit_article img_border_bottom'></div>"+
				"<div class='edit_article img_border_left'></div>"+
				"<div class='edit_article edit_btn'>"+
				"<button class='btn btn-info'>编辑</button><input type='file' name='imgFile' id='imgFile' onchange='imgUpload(this);'>"+
				"</div>";
			}
			$(".imgonly").bind("mouseenter",function(){
				var ahtml=$(this).parent();
				$(".edit_article").remove();
				ahtml.append(showBigimgEdit());
				ahtml.find(".edit_article").show();
				$(".imgonly").removeClass("imgedit");
				$(this).addClass("imgedit");
			});
			cmsjs.iframeclick();
			var rgbToHex = function(rgb) {
				var color = rgb.toString().match(/\d+/g);
				var hex = "#";
				for (var i = 0; i < 3; i++) {
					hex += ("0" + Number(color[i]).toString(16)).slice(-2);
				}
				return hex;
			};
		},iframeclick:function(){
			if ($("iframe").length>0) {
				$("iframe").before("<button class='btn btn-info iframeedit'>编辑地图</button>");
				$("iframe").prev().click(function(){
					var content=$("iframe").attr("src");
					pop_up_box.showDialog("编辑地图名片","<a href='http://api.map.baidu.com/mapCard/setInformation.html' target='_blank'>" +
							"百度地图名片编辑,请点击!</a><p>请将生成后的链接复制到输入框中.</p><input type='url' data-num='zimu' maxlength='100'" +
							" id='desc' style='width:300px;' value='"+content+"'>",function(){
						$("iframe").attr("src",$("#msgDiv #desc").val());
					});
					common.initNumInput();
				});
			}
		},savehtml:function(){
			$(".text").removeAttr("contenteditable");
			var xuanxian=$("#xuanxian");
			var nav=$("nav");
			var copyright=$("#copyright");
			var eavingMsg=$("#eavingMsg");
			var eavingHtml="";
			if(eavingMsg.length>0){
				eavingHtml ="<div id='eavingMsg'>"+eavingMsg.html()+"</div>"
			}
			var fade=$(".csSlideOuter").html();
			$("#xuanxian").remove();
			$("#copyright").remove();
			$("nav").remove();
			$(".edit_article").remove();
			$(".csSlideOuter").remove();
			$(".iframeedit").remove();
			if($("iframe").length>0){
				var iframesrc=$("iframe").attr("src");
				$("iframe").remove();
				$("#web").html("<iframe height='900' frameborder='0' scrolling='no' marginheight='0' marginwidth='0' src='"+iframesrc+"'></iframe>");
			}
			var host=window.location.host;
			var url=window.location.href.split("?")[0];
			url=url.split("#")[0];
			var htmlname=url.split(host)[1];
			if(htmlname.indexOf("html")<0){
				htmlname=htmlname+"index.html";
			}
			$.post("/temp/saveHtml.do",{
				"htmlname":htmlname,
				"eavingHtml":eavingHtml,
				"header":'<nav class="navbar navbar-default navbar-fixed-top">'+nav.html()+"</nav>",
				"copyright":"<div id='copyright'>"+copyright.html()+"</div>",
				"html":$("html").html()
			},function(data){
				$("div:eq(0)").before(nav);
				$("nav").after(xuanxian);
				if(fade){
					$(".container").before("<div class='csSlideOuter'>"+fade+"</div>");
				}
				$(".container").append(copyright);
				$(".text").attr("contenteditable","true");
				cmsjs.iframeclick();
				if(data.success){
					pop_up_box.toast(data.msg,1000);
				}else{
					pop_up_box.showMsg(data.msg);
				}
			});
		},setDesc:function(){
			var content=$("meta[name='description']").attr("content");
			pop_up_box.showDialog("编辑页面描述","<textarea rows='5' cols='30' id='desc'>"+content+"</textarea>",function(){
				$("meta[name='description']").attr("content",$("#msgDiv #desc").val());
			});
		},setGjc:function(){
			var content=$("meta[name='keywords']").attr("content");
			pop_up_box.showDialog("编辑页面关键词","<textarea rows='5' cols='30' id='desc'>"+content+"</textarea>",function(){
				$("meta[name='keywords']").attr("content",$("#msgDiv #desc").val());
			});
		},setTitle:function(){
			var content=$("title").html();
			pop_up_box.showDialog("编辑页面标题","<input maxlength='20' id='desc' style='width:300px;' value='"+content+"'>",function(){
				$("title").html($("#msgDiv #desc").val());
			});
		},setComId:function(){
			var content=$("#comId").html();
			pop_up_box.showDialog("编辑运营商编码","<p>请输入运营商编码,忘记请联系管理员!</p><input maxlength='10' id='desc' style='width:200px;' value='"+content+"'>",function(){
				$("#comId").html($("#msgDiv #desc").val());
			});
		},setBanner:function(){
			if(confirm("请先保存当前页面内容编辑,否则数据将丢失,是否已经保存?")){
				window.location.href="/cms/bannerpush.jsp";
			}
		}
};
function imgUpload(t){
	var imgname=$(".e_border_top").prev().attr("src");
	if(imgname){
    	var ims=imgname.split("/");
    	imgname=ims[ims.length-1];
	}
	var imgPath="/@com_id/pageimg/"+imgname;
	ajaxUploadFile({
		"uploadUrl":"/upload/uploadImageZs.do?fileName=imgFile&imgPath="+imgPath,
		"msgId":"",
		"fileId":"imgFile",
		"msg":"",
		"fid":"",
		"uploadFileSize":0.5
	},t,function(imgurl){
		pop_up_box.loadWaitClose();
		$(".e_border_top").prev().attr("src",imgurl);
	});
}