function headerCheckbox(t){
	 var b=$(t).prop("checked");
	 $(t).parents(".item").find(".next").find("input[type='checkbox']").prop("checked",b);
}
function nextCheckbox(t){
	 var b=$(t).prop("checked");
	 if(b==true){
	 $(t).parents(".item").find(".box-header").find("input[type='checkbox']").prop("checked",b);
	 } 
}
function addNext(t){
	 var nextItem=$($("#nextItem").html());
	 if($(t).parents(".item").find(".nextItem:eq(0)").length>0){
	 $(t).parents(".item").find(".nextItem:eq(0)").before(nextItem);
	 }else{
	 $(t).parents(".item").find(".next").append(nextItem);
	 }
	 $(t).parents('.item').find('.next').show();
	 nextItem.find("input[name='name']").focus();
}
//选择图标
///1.加载图片列表到侧滑栏
//2.注册图标选择按钮事件
//3.注册图标选择
var logoitem;
function logobtnselect(t){
	$('.tc,.zhezhao').show();
	logoitem=$(t).next();
}
$('.tc_top>button,.zhezhao').click(function(){
    $('.tc,.zhezhao').hide();
 });
var path="/pcxy/logo_images/";
$("#reloadimg").click(function(){
	loadimg($("#imgpath").val());
});
function loadimg(path){
	$(".panel-body:eq(1)").html("");
	$.get("../manager/getFileList.do",{"path":path},function(data){
		$.each(data,function(i,n){
			$(".panel-body:eq(1)").append("<img src='"+path+n+"'><span>"+(i+1)+"</span>")
		});
		$(".panel-body:eq(1) img").click(function(){
			logoitem.attr("src",$(this).attr("src"));
			$('.tc,.zhezhao').hide();
		});
	});
}
loadimg(path);
/////////////////
var itemhtml=$("#item");
 $.get("../manager/getFiledList.do",{"type":"auth"},function(data){
	 $.each(data,function(i,n){
	 var item=$(itemhtml.html());
	 $("#list").append(item);
	 item.find(".box-header input[name='name']").val(n.name);
	 item.find(".box-header input[name='name_ch']").val(n.name_ch);
	 item.find(".box-header input[name='checked']").prop("checked",n.checked);
	 if(n.nextClass&&n.nextClass.length>0){
		 $.each(n.nextClass,function(j,m){
			var nextItem=$($("#nextItem").html());
			item.find(".next").append(nextItem);
			nextItem.find("input[name='name']").val(m.name);
			nextItem.find("input[name='name_ch']").val(m.name_ch);
			nextItem.find("input[name='url']").val(m.url);
			nextItem.find("img").attr("src",m.logo);
			nextItem.find("input[name='checked']").prop("checked",m.checked);
		 });
	 }
	 });
	 $("#list,.next").sortable({axis:"y"});
//	 $("#list").disableSelection();//加入后页面输入框不能编辑
//	 $("img").resizable ({ghost: true});//图片在线缩放
 });
$(".add").click(function(){
	 var item=$(itemhtml.html());
	 $("#list").append(item);
	 item.find("input[name='name']").focus();
	 item.find('.next').show();
});
$(".save").click(function(){
	//获取
	var items=$(".item");
	if(items.length>0){
		var list=[];
		for (var i = 0; i < items.length; i++) {
			var item=$(items[i]);
			var name=item.find("input[name='name']").val();
			var name_ch=item.find("input[name='name_ch']").val();
			if(name_ch){
				var checked=item.find("input[name='checked']").prop("checked");
				var nextItems=item.find(".nextItem");
				var nextClass=[];
				if(nextItems.length>0){
					for (var j = 0; j < nextItems.length; j++) {
						var nextItem=$(nextItems[j]);
						var nextname=$.trim(nextItem.find("input[name='name']").val());
						var nextname_ch=$.trim(nextItem.find("input[name='name_ch']").val());
						var nexturl=$.trim(nextItem.find("input[name='url']").val());
						var nextlogo=$.trim(nextItem.find("img").attr("src"));
						var nextchecked=nextItem.find("input[name='checked']").prop("checked");
						nextClass.push({"name":nextname,"name_ch":nextname_ch,"url":nexturl,"logo":nextlogo,"checked":nextchecked});
					}
				}
				var json={"name":name,"name_ch":name_ch,"checked":checked,"nextClass":nextClass};
				list.push(JSON.stringify(json));
			}
		}
		pop_up_box.postWait();
		$.post("../manager/saveFiled.do",{"type":"auth","filedlist":"["+list+"]"},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("保存成功!");
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
	}
});
function upmove(t){
	var divtop=$(t).parents("#list");
	var index=divtop.find(".up").index(t);
	if (index>0) {
		console.debug(divtop.find(".up:eq("+(index-1)+")").parents(".item"));
		 $(t).parents(".item").insertBefore(divtop.find(".up:eq("+(index-1)+")").parents(".item"));
	}
}
function nextmove(t){
	var divtop=$(t).parents("#list");
	var index=divtop.find(".down").index(t);
	var len=divtop.find(".down").length-1;
	if (len>index) {
		$(t).parents(".item").insertAfter(divtop.find(".down:eq("+(index+1)+")").parents(".item"));
	}
}

