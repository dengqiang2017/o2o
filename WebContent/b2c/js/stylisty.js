$(function(){
	stylisty.init();
});
var stylisty={
		init:function(){
			if(!IsPC()){
				$(".footer").addClass("navbar-fixed-bottom");
				$(".header-phone").addClass("navbar-fixed-top");
				$(".contant").removeClass("contant");
			}
			var fs=$(".footer a");
			for (var i = 0; i < fs.length; i++) {
				var f=$(fs[i]);
				f.attr("href",f.attr("href")+"?ver="+Math.random());
			}
			//获取设计师列表
			var page=0;
			var count=0;
			var totalPage=0;
			$("#sjslist").html("");
			loadData();
			$("#searchKey").change(function() {
				page=0; 
				count=0;
				$("#sjslist").html("");
				loadData();
			});
			$(".search label:eq(0)").click(function(){
				page=0; 
				count=0;
				$("#sjslist").html("");
				loadData();
			});
			function loadData(){
				pop_up_box.loadWait();
				$.get("../user/getDesigner.do",{
					"com_id":com_id,
					"searchKey":$.trim($("#searchKey").val()),
					"page":page,
					"count":count,
					"name":"%设计师%"
				},function(data){
					pop_up_box.loadWaitClose();
					if(data&&data.rows.length>0){
						$.each(data.rows,function(i,n){
							var item=$($("#sjsitem").html());
							$("#sjslist").append(item);
							item.find("#clerkName").html(n.clerkName);
							item.find("#describe").html(n.describe);
							item.find("img").attr("src","../"+$.trim(n.com_id)+"/"+$.trim(n.clerk_id)+"/img"+"/sfz.jpg");
							item.click({"com_id":$.trim(n.com_id),"clerk_id":$.trim(n.clerk_id)},function(event){
								window.location.href="datum.jsp?com_id="+event.data.com_id+"&clerk_id="+event.data.clerk_id;
							});
						});
					}
					count=data.totalRecord;
					totalPage=data.totalPage;
				});
			}
		    pop_up_box.loadScrollPage(function(){
				if (page==totalPage) {
				}else{
					page+=1;
					loadData(); 
				}
			});
			if(!IsPC()){
				document.getElementsByTagName('body')[0].addEventListener('touchmove',function(){
					$('input').blur();
				});
				$('input').bind('focus',function(){
					$('.footer').css('position','static');
				}).bind('blur',function(){
					$('.footer').css({'position':'fixed','bottom':'0'});
				});
			}
		}
}