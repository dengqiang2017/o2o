$('.box>ul').html("");
$.get('../manager/getJSONArrayByFile.do', {
	"path" : "news.json"
}, function(data) {
	if (data && data.length > 0) {
		$.each(data, function(i, n) {
			var item = $($('#item').html());
			$('.box>ul').append(item);
			item.find(".ui_title").html(n.title);
			item.find(".content").html(n.content);
			item.find("img").attr("src", n.imgName);
			item.find(".urlName").html(n.urlName);
			item.find(".url").html(n.url);
		});
		$(".ui_edit").click(function() {
			editclick(this);
		});
	}
});
//获取系统预设微信消息图片
var imgItem=$("#modal_imgSelect .modal_ul").html();
$('#modal_imgSelect .modal_ul').html("");
 $.get('../manager/getJSONArrayByFile.do',{
	 "path":"weixinImg.json"
 },function(data){
	 if(data&&data.length>0){
		 $.each(data,function(i,n){
			 var item = $(imgItem);
			 $('#modal_imgSelect .modal_ul').append(item);
			 item.find(".ui_modal_img_title").html(n.title);
			 item.find("img").attr("src",".."+ n.imgName);
		 });
	 }else{
		 $('#modal_imgSelect .modal_ul').html("还没有设置消息图片!");
	 }
 });
 $("#imgClose,.close").click(function(){
		$("#modal_imgSelect").hide();
	});
//选择图片
function imgClick(t){
		var imgName=$(t).attr("src");
		$("#modal_imgSelect").show();
		$("#modal_imgSelect .modal_ul>li").find("input").prop("checked",false);
		for (var i = 0; i < $("#modal_imgSelect .modal_ul>li").length; i++) {
			var item_M=$($("#modal_imgSelect .modal_ul>li")[i]);
			if(imgName==item_M.find("img").attr("src")){
				item_M.find("input").prop("checked",true);
				break;
			}
		}
		$("#imgSelect").unbind("click");
		$("#imgSelect").click({"img":$(t)},function(event){
			var img=$("#modal_imgSelect").find("ul").find("input:checked");
			if(img){
				event.data.img.attr("src",img.parent().find("img").attr("src"));
				$("#modal_imgSelect").hide();
			}else {
				pop_up_box.showMsg("请选择图片!");
			}
		});
}
 //编辑
function editclick(t) {
	$('#mymodal').modal('toggle');
	$('.box>ul>li').removeClass('activet');
	$(t).parents('li').addClass('activet');
	var title =$.trim($(t).parents('li').find('.ui_title').html());
	var content =$.trim( $(t).parents('li').find('.content').html());
	var img = $(t).parents('li').find('img').attr("src");
	var url = $(t).parents('li').find('.url').html();
	$('.modal .ui_title').val(title);
	$('.modal .ui_content').val(content);
	$('.modal img').attr("src", img);
	$('.modal .ui_url').val(url);
}
$("#addItem").click(function() {
	$('.box>ul').append($('#item').html());
	$(".ui_edit").click(function() {
		editclick(this);
	});
});
$(".secition-body input").click(function(){
	$(this).select();
});
$('.save').click(function() {
	$('#mymodal').modal('hide');
	var title = $('#mymodal .ui_title').val();
	var content = $('#mymodal .ui_content').val();
	var url = $('#mymodal .ui_url').val();
	var urlName = $('#mymodal .ui_url').find("option:selected").text();
	var imgName = $('#mymodal img').attr("src");
	if(!title){
		pop_up_box.showMsg("请输入消息标题!",function(){
			$('#mymodal .ui_title').focus();
		});
	}else if(!content){
		pop_up_box.showMsg("请输入消息内容!",function(){
			$('#mymodal .ui_content').focus();
		});
	}else if(!url){
		pop_up_box.showMsg("请输入消息点击进入路径!",function(){
			$('#mymodal .ui_url').focus();
		});
	}else if(!imgName){
		pop_up_box.showMsg("请输入消息封面图片!");
	}else{
		var item = $(".activet");
		item.find(".ui_title").html(title);
		item.find(".content").html(content);
		item.find("img").attr("src", imgName);
		item.find(".urlName").html(urlName);
		item.find(".url").html(url);
	}
});

$("#save").click(function() {
	var news = $('.list-group .list-group-item');
	if (news && news.length > 0) {
		var jsons = [];
		for (var i = 0; i < news.length; i++) {
			var item = $(news[i]);
			var json = {};
			json.title = item.find(".ui_title").html();
			json.content = item.find(".content").html();
			json.urlName = item.find(".urlName").html();
			json.url = item.find(".url").html();
			json.imgName = item.find("img").attr("src");
			if(json.title&&json.content&&json.url&&json.imgName){
				jsons.push(JSON.stringify(json));
			}
		}
		if(jsons.length>0){
			pop_up_box.postWait();
			$.post("../manager/saveJSONArrayFile.do", {
				"path" : "news.json",
				"jsons" : "[" + jsons.join(",") + "]"
			}, function(data) {
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
		}else{
			pop_up_box.showMsg("消息不完整请填写完整!");
		}
	} else {
		pop_up_box.showMsg("请先增加模板消息!");
	}
});
