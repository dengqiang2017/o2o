var buedit={
	init:function(){
		var ue = UE.getEditor('editor');
//		var ipf="/"+projectName+"/article/"+edithtml.projectType+"/img/{time}{rand:6}";
//		ue.setOpt("imagePathFormat",ipf);
//		alert(ue.getOpt("imagePathFormat"));
		setTimeout(function(){
			UE.getEditor('editor').setHeight(600);
		}, 1500);
	},
	/**
	 * 获得编辑器中的内容
	 * @rturns 编辑器html内容
	 */
	getContent:function(){
		return UE.getEditor('editor').getContent();
	},
	/**
	 * 判断编辑器里是否有内容
	 * @returns true或者false
	 */
	hasContent:function(){
		return UE.getEditor('editor').hasContents();
	},
	/**
	 * 清空编辑内容
	 */
	clearLocalData:function(){
		UE.getEditor('editor').execCommand( "clearlocaldata" );
	    pop_up_box.shoMsg("已清空草稿箱")
	},
	/**
	 * 编辑内容回显
	 * @param 回显内容
	 */
	setContent:function(html){
		html=common.replaceAll(html, "<!Doctype html><html>","");
		html=common.replaceAll(html, "</html>","");
		pop_up_box.loadWait();
		setTimeout(function(){
			UE.getEditor('editor').setContent(html,false);
			pop_up_box.loadWaitClose();
		}, 1500);
	}
}
buedit.init();