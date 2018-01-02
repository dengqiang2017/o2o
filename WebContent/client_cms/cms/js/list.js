topback();
function topback(){
	$("html,body",window.parent.document).animate({scrollTop:0},200);
	$("html,body").animate({scrollTop:0},200);
	index=0;
}
var index=0;
function loaditem(datainfo,type){///主要用于在现实的是时候
	try {
		datainfo=eval("("+datainfo+")");
		} catch (e) {
			try {
				datajson=eval(datajson);
				} catch (e) {}
		}
	if (datainfo.length>0) {
		if (datainfo[index]) {
			$.get("article/"+type+"/"+datainfo[index].url+"?math="+Math.random(),function(datajson){//获取json文件信息
				try {
				datajson=eval("("+datajson+")");
				} catch (e) {}
				if (type==4) {
					productList.loadWrodList(datainfo[index].url,datajson.imgurl,datajson.proName,datajson.proTips,datajson.proJe);
					++index;//
					if (datajson.length<=index) {
					}else{
						loaditem(datainfo,type);
					}
				}else{
					$.get("article/"+type+"/"+datajson.htmlname+"?math="+Math.random(),function(data){//获取html名称
						try {
							data=eval("("+data+")");
							} catch (e) {}
						if(type==1||type==3){
							articleList.loadWrodList(datajson,type,data);//将json文件和页面内容进行显示
						}else if (type==2) {
							caseList.loadWrodList(datajson,type,data);//将json文件和页面内容进行显示
						}
						++index;//
						if (datajson.length<=index) {
						}else{
							loaditem(datainfo,type);
						}
					});
				}
			});
		}else if(index<datainfo.length){
			++index;
			loaditem(datainfo,type);
		}
	}
}
function datasort(data){
	var data1;
	try {
		data1=eval("("+data+")");
	} catch (e) {
		data1=data;
	}
	data=data1;
	return data.sort(function(a,b){
		var urla=a.url.split("\.")[0];
		var urlb=b.url.split("\.")[0];
		return urlb-urla});
}
$(function(){
	var items = [];
	var item = [];
	var pageindex = 0;
	var type = $("#type").val();
	function setDisabled(id,t){
		id.prop("disabled",t);
		if (t) {
			id.addClass("disabled");
		}else{
			id.removeClass("disabled");
		}
	}
	var uppage=$("#uppage");
	var nextpage=$("#nextpage");	
	var endpage=$("#endpage");
	var onepage=$("#onepage");
	function oneup(t){
		setDisabled(uppage, t);
		setDisabled(onepage, t);
	}
	function endnext(t){
		setDisabled(endpage, t);
		setDisabled(nextpage, t);
	}
	onepage.click(function() {
		$(".row").html("");
		topback();
		pageindex = 0;
		loaditem(items[pageindex], type);
		oneup(true);
		endnext(false);
	});
	endpage.click(function() {
		$(".row").html("");
		topback();
		pageindex = items.length-1;
		loaditem(items[pageindex], type);
		oneup(false);
		endnext(true);
	});
	uppage.click(function() {
		if (pageindex>=0) {
			if (pageindex>0) {
				--pageindex;
			}
			$(".row").html("");
			topback();
			loaditem(items[pageindex], type);
			endnext(false);
		}else{
			oneup(true);
		}
	});
	nextpage.click(function() {
		if (pageindex<items.length-1) {
			$(".row").html("");
			topback();
			++pageindex;
			loaditem(items[pageindex], type);
			oneup(false);
		}else{
			endnext(true);
		}
	});
	if (!type) {
		return;
	}
	var pagerecord=parseInt($("#pagerecord").val());
	$.get("article/"+type+".json?math="+Math.random(),function(datainfo){
		datainfo=datasort(datainfo);
		var fenge=0;
		var fenindex=1;
		for (var i = 0; i < datainfo.length; i++) {
			if (i==(pagerecord*fenindex)) {
					item[fenge]=datainfo[i];
					items.push(item);
					item=[];
					fenge=0;
				++fenindex;
			}else if (i==datainfo.length-1) {
					item[fenge]=datainfo[i];
					items.push(item);
					item=[];
					fenge=0;
			}else{
					item[fenge]=datainfo[i];
			}
			++fenge;
		}
		if (items.length==1) {
			$(".paging_ctn").hide();
		}else{
			$(".paging_ctn").show();
		}
		if (datainfo.length>0) {
			$(".row").html("");
			loaditem(items[0],type);
		}
	});
});