$(".pager a").click(function(){
	var n=$(".pager a").index(this);
	count=0;
	var b=true;
	if(n==0){//首页
		page=0;
	}else if(n==1){//上一页
		if(page>0){
			page=page-1;
		}else{
			b=false;
		}
	}else if(n==2){//下一页
		if(page<totalPage){
			page=page+1;
		}else{
			b=false;
		}
	}else if(n==3){//末页
		page=totalPage;
	}
	if(b){
		loadData();
	}
});
$("#searchKey").change(function(){
	page=0;
	count=0;
	loadData();
});
$(".find").click(function(){
	page=0;
	count=0;
	loadData();
});
function pageShow(totalPage){
	if(totalPage>1){
		$(".pager").show();
	}else{
		$(".pager").hide();
	}
	$("tbody tr").click(function(){
		$("tbody tr").removeClass("info");
		$(this).addClass("info");
	});
}
function addFujianItem(imgUrl,name){
	var item=$($("#fujianItem").html());
	$("#fujian").append(item);
	item.find("#fujianName").html(name);
	item.find("#fujianPath").html(imgUrl);
	item.find(".pic").click(function(){
		$(".popup").hide();
		$(this).parents(".libox").find(".popup").show();
	});
	item.find('.popup').click(function(){
	    $(this).hide();
	});
	item.find(".btn-info").click(function(){
		var url=$(this).parents(".libox").find("#fujianPath").html();
		window.open(url,"_blank");
	});
	item.find(".btn-default").click(function(){
		$(this).parents(".popup").hide();
	});
	item.find(".btn-danger").click(function(){
		//是否删除
		if (confirm("是否要删除该附件,删除后将不能恢复!")) {
			var t=$(this).parents(".libox");
			var url=t.find("#fujianPath").html();
			$.post("../upload/removeTemp.do",{
				"imgUrl":url
			},function(data){
				if (data.success) {
					pop_up_box.toast("删除成功!",2000);
					t.remove();
					xuhao();
				} else {
					if (data.msg) {
						pop_up_box.showMsg("删除错误!" + data.msg);
					} else {
						pop_up_box.showMsg("删除错误!");
					}
				}
			});
		}
	});
}

function getFujian(){
	var fujianList=[];
	var fs=$("#fujian .libox");
	if(fs&&fs.length>0){
		for (var i = 0; i < fs.length; i++) {
			var fujian=$(fs[i]);
			fujianList.push(JSON.stringify({"url":fujian.find("#fujianPath").html()}));
		}
		fujianList="["+fujianList.join(",")+"]";
	}else{
		fujianList="[]";
	}
	return fujianList;
}


function huixianData(type,len,ivt,func){
	var tr;
	if(type==0){//增加
		tr=getTr(len);
		if($.trim($("tbody").html())==""){
			$("tbody").append(tr);
		}else{
			$("tbody tr:eq(0)").before(tr);
		}
	}else{
		tr=$("tbody").find("td:contains("+ivt+")").parents("tr");
	}
	for (var i = 0; i < len; i++) {
		var th=$($("thead th")[i]);
		var name=$.trim(th.attr("data-name"));
		var show=th.css("display");
		var j=$("thead th").index(th);
		var show=th.css("display");
		if(show=="none"){
			tr.find("td:eq("+j+")").hide();
		}
		if(type==0){
			if(name=="xuhao"){
				tr.find("td:eq("+j+")").html($("tbody tr").length+1);
			}
			if(name=="caozuo"){
				tr.find("td:eq("+j+")").html('<i class="fa fa-times-circle" aria-hidden="true"></i>');
			}
		}
		if(func){
			func(tr,name,j);
		}
		
	}
}
/**
 * 给表格增加序号
 */
function xuhao(){
	var trs=$("tbody tr");
	 for (var i = 0; i < trs.length; i++) {
		var tr=$(trs[i]);
		tr.find("td:eq(0)").html(i+1);
	}
}