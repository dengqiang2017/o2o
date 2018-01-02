$(function(){
	var titleItem=$("#title_item");
	var popupItem=$("#popup_item");
	
	function addItem(data){
		if(data&&data.length>0){
			$(".body").html("");
			$.each(data,function(i,n){
				var item=$(titleItem.html());
				$(".body").append(item);
				item.find("a").attr("href",n.news.articles[0].url);
				item.find("a").attr("target","_blank");
				item.find("a").html(n.news.articles[0].title);
				item.find(".body_span_time").html(n.time);
				if(n.result.errmsg=="ok"){
					item.find(".body_span_result").html("成功");
				}else{
					item.find(".body_span_result").html("失败");
				}
				item.find('.body_a').click({"touser":n.touser,"sendRen":n.news.articles[0].sendRen},function(event){
					var t=$(this);
					if(t.next().length>0){
						t.next().toggle();
					}else{
						$.get("../weixin/getMembersInfo.do",{
							"touser":event.data.touser,
							"sendRen":event.data.sendRen,
						},function(datainfo){
							var popup=$(popupItem.html());
							item.append(popup);
							popup.find("li:eq(0)").html("接收人:"+datainfo.touser);
							popup.find("li:eq(1)").html("发送人:"+datainfo.sendRen);
//							popup.find("li:eq(2)").html("错误信息:"+datainfo.errmsg);
							t.next().toggle();
						});
					}
			    });
			});
		}else{
			$(".body").html("无数据");
		}
	}
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".Wdate:eq(0)").val(nowStr);
	$(".find").click(function(){
		$.get("../weixin/getWeixinMsglist.do",{
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			if (data.success) {
				$("#count").html("共:["+data.error_code+"]条消息");
				data=$.parseJSON(data.msg);
				addItem(data);
				$("#searchKey").change();
			}
		});
	});
	$(".find:eq(0)").click();
	filterList($("#list"));
});
//点击a标签链接的时候不执行点击事件
function stopP(d){
	d.stopPropagation();
}
//////////////////////////////////////
