var edithtml={
		init:function(com_id,item_id,item_name,detail_cms,t,xq){
		$("#detailpage").show();
		$("#item_name").html(item_name);
		/////////////////公共函数/////////
		/**
		 * 保存在线编辑的内容到html文件中
		 */
		function saveArticle(){
			if (!buedit.hasContent) {
				pop_up_box.showMsg("没有获取到编辑内容!");
				return;
			}
			//替换图片视频路径为当前应用下
			pop_up_box.postWait();
			$.post("../temp/saveArticle.do",{
				"text":buedit.getContent(),
				"item_id":item_id,
				"url":"/"+com_id+"/img/"+item_id+"/article.html"
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					///更新产品表中detail_cms为1
					pop_up_box.toast("保存成功!", 1500);
					if (confirm("保存成功,是否关闭编辑页面?")) {
						$("body").css("overflow","auto");
						$("#detailpage").hide();
						if(xq){
							$("#editpage").show();
						}else{
							$("#listpage").show();
						}
						t.html(1);
					}
				}else{
					pop_up_box.showMsg(data.msg);
				}
			});
		}
		////////////////公共函数结束/////////
		$("#detailpage #save").unbind("click");
		$("#detailpage #save").click(function(){
			saveArticle();
		});
		$("#detailpage .header_left").unbind("click");
		$("#detailpage .header_left").click(function(){
			$("body").css("overflow","auto");
			$("#detailpage").hide();
			if(xq){
				$("#editpage").show();
			}else{
				$("#listpage").show();
			}
		});
			//增加新文章
		edithtml.type=0;//新增
		buedit.setContent("");
		if(detail_cms!=0){
			pop_up_box.loadWait();
			$.get("/"+com_id+"/img/"+item_id+"/article.html",function(data){
				edithtml.type=1;//编辑
				buedit.setContent(data);
			});
		}
		//TODO 公共函数结束
//		$("body").css("overflow","hidden");
	}
}