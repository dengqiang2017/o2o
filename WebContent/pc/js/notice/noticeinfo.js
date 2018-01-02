//客户端获取公告js
$(function(){
	var page=0;
	var count=0;
	var totalPage=0;
	$(".find").click(function(){
		page=0;
		count=0;
		loadData();
	});
	$(".del,.edit").hide(); 
	if($("#delAllNotice").length>0){
		$(".del").show();
	}
	if($("#editAllNotice").length>0){
		$(".edit").show();
	}
	var clerkId=$.trim($("#clerkId").html());
	function addItem(data){
		if (data&&data.rows.length>0) {
			$.each(data.rows,function(i,n){
				var item=$($("#item").html());
				$("#list").append(item);
				item.find("#notice_title").html(n.notice_title);
				item.find("#notice_content").html(n.notice_content);
				item.find("#clerk_name").html("发布人:"+n.clerk_name);
				item.find("#notice_time").html(n.notice_time);
				if(clerkId==$.trim(n.clerk_id)){
					if($("#delNotice").length>0){
						$(".del").show();
					}
					if($("#editNotice").length>0){
						$(".edit").show();
					}
				}
				item.find(".del").click({"seeds_id":n.seeds_id},function(event){
					var t=this;
					$.get("../user/saveNoticeInfo.do",{
						"seeds_id":event.data.seeds_id,
						"m_flag":"1"
					},function(data){
						if (data.success) {
							$(t).parents(".body01").remove();
							pop_up_box.toast("删除成功!", 500);
						} else {
							if (data.msg) {
								pop_up_box.showMsg("删除错误!" + data.msg);
							} else {
								pop_up_box.showMsg("删除错误!");
							}
						}
					});
				});
				item.find(".edit").click({"seeds_id":n.seeds_id,"notice_title":n.notice_title,"notice_content":n.notice_content},function(event){
					$("#listpage").hide();
					$("#pushpage").show();
					$("#pushpage input").val(event.data.notice_title);
					$("#pushpage textarea").val(event.data.notice_content);
					$("#pushpage #seeds_id").html(event.data.seeds_id);
				});
			});
			
		}
		count=data.totalRecord;
		totalPage=data.totalPage;
	}
	function loadData(){
		pop_up_box.loadWait();
		$.get("../user/noticeInfoPage.do",{
			"count":count,
			"page":page,
			"searchKey":$("#searchKey").val(),
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			pop_up_box.loadWaitClose();
			addItem(data);
		});
	}
	loadData();
	$(window).scroll(function(){
        if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
        	if(page<totalPage){
        		page+=1;
        		loadData();
        	}
        }
  });
});