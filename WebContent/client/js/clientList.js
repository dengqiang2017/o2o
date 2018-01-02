var lis=$(".location>ul>li");
for (var i = 0; i < lis.length; i++) {
	var item=$($("#item").html());
	var li=$(lis[i]).html();
	$(".secition_body").append(item);
	item.find(".secition_body_title").html(li);
}
$(".secition_body_list>ul").html("");
$(".location>ul>li").click(function(){
	 $(".location>ul>li").removeClass("active");
	$(this).addClass("active");
	window.location.hash="Z";
});
loadData();
$("#searchKey").change(function(){
	loadData();
});
var key=$(".secition_body_title").html();
var sbt=$(".secition_body_title");
for (var i = 0; i < $(".secition_body_title").length; i++) {
	var sbt=$($(".secition_body_title")[i]);
	sbt.attr("id",sbt.html());
}
function loadData(){
$(".secition_body_list>ul").html("");
	pop_up_box.loadWait();
	$.get("../client/getClientSimpleList.do",{
		"searchKey":$.trim($("#searchKey").val())
	},function(data){
		pop_up_box.loadWaitClose();
		if(data&&data.length>0){
			$.each(data,function(i,n){
				var name=n.corp_sim_name;
				if(name.indexOf("虚拟")>=0){
					return;
				}
				var begin=n.easy_id.substr(0,1);
				var secition_title=$(".secition_body_title:contains("+begin+")");
				var ul=secition_title.next().find("ul");
				if(!n.corp_sim_name){
					name=n.corp_name;
				}
				var item=$("<li>"+name+"</li>");
				ul.append(item);
				item.click({
					"customer_id":n.customer_id,
					"movtel":n.user_id,
					"weixinID":n.weixinID
				},function(event){
					pop_up_box.loadWait();
					window.location.href="relationship.jsp?customer_id="+event.data.customer_id;
				});
			});
			//隐藏没有数据的项
			var lis=$(".location>ul>li");
			for (var i = 0; i < lis.length; i++) {
				var li=$(lis[i]);
				var secition_title=$(".secition_body_title:contains("+li.html()+")");
				var ul=secition_title.next().find("ul");
				if($.trim(ul.html())==""){
					secition_title.parent().hide();
				}else{
					secition_title.parent().show();
				}
			}
		}
	});
}