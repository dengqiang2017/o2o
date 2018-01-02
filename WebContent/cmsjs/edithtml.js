function editModalContent(modalName){
	$(".modal_"+modalName).show();
	$(".modal_cover").show();
}
var edithtml={
		type:0,
		selectImg:"",
		init:function(parentHtml){
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
                "<button class='btn_url ' style='font-size: 16px;'>短链接</button>"+
                "</div>";
			}
////////////////////////////////模块编辑开始/////////////////////////
		$(".articleedit").bind("mouseenter",function(){
			var ahtml=$(this);
			ahtml.find(".edit_article").remove();
			ahtml.append(showArticleEdit());//1.3不存在就增加编辑按钮代码
			ahtml.find(".edit_article").show();
			//2.按钮事件注册
			//2.1注册编辑按钮点击事件
			ahtml.find(".btn_edit").bind("click",function(){
				var htmlname=$(this).parents(".articleedit").find("#htmlname").html();
				window.location.href="articleDialog.jsp?htmlname="+htmlname+"&projectType="+getType();
			});
			ahtml.find(".btn_add").bind("click",function(){
				window.location.href="articleDialog.jsp?projectType="+getType();
			});
			if(!parentHtml){
				parentHtml=".col-lg-3";
			}
			ahtml.find(".btn_del").bind("click",function(){
				if (confirm("是否要删除该文档内容!")) {
					var par=$(this).parents(parentHtml);
					var htmlname=$.trim(par.find("#htmlname").html());
					var type=getType();
					if(htmlname!=""){
						pop_up_box.postWait();
					    $.post("../temp/delArticle.do",{
					    	"projectName":projectName,
					    	"projectType":type,
					    	"htmlname":htmlname
					    },function(data){
					    	pop_up_box.loadWaitClose();
					    	if (data.success) {
								pop_up_box.toast("删除成功!",1000);
								par.remove();
							} else {
								if (data.msg) {
									pop_up_box.showMsg("保存错误!" + data.msg);
								} else {
									pop_up_box.showMsg("保存错误!");
								}
							}
					    });
					}
				}
			});
			ahtml.find(".btn_url").click(function(){
				var par=$(this).parents(parentHtml);
				var htmlname=$.trim(par.find("#htmlname").html());
				var type=getType();
				if(htmlname!=""){
					pop_up_box.loadWait();
					$.get("../temp/getShortUrl.do",{
				    	"projectName":projectName,
				    	"projectType":type,
				    	"htmlname":htmlname
					},function(data){
						pop_up_box.loadWaitClose();
						if(data.success){
							pop_up_box.showDialog("请复制该链接到信息中", "<input style='width:100%' value='"+data.msg+"'><a class='btn btn-info btn-sm' href='"+data.msg+"' target='_blank'>打开</a>");
						}
					});
				}
				
			});
		});
		////////////////////////////////////////////
		$("#edithtml",window.parent.document).height(window.screen.height-200);
		} 
}