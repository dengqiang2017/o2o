var index={
		init:function(){
			$.get("banner.json",function(data){
				if(data){
					var fade='<ul id="fade" class="gallery list-unstyled clearfix" style="margin-bottom: 0;height: 200px;"></ul>';
					$(".container").before(fade);
					$('#fade').html("");
					$.each(data,function(i,n){
						if(n.show&&n.imgurl){
							var li=$('<li><a data-lightbox="roadtrip"><img class="img-responsive"></a></li>');
							$('#fade').append(li);
							li.find("img").attr("src",n.imgurl);
							if(n.alink){
								li.find("a").attr("href",n.alink.replace("amp;", ""));
							}
						}
					});
					weixinShare.init($("title").html(),$("meta[name='description']").attr("content"),$('#fade img')[0].src);
					$('#fade li:eq(0)').addClass("active");
					$('#fade').lightSlider({
						minSlide: 1,
						maxSlide: 1,
						mode: 'fade'
					});
				}
			});
			liuyan.init();
		}
}
var liuyan={
		init:function(){
			common.initNumInput();
			$("#saveLiuYan").click(function(){
				var name=$.trim($("#liuyan input[name='name']").val());
				var tel=$.trim($("#liuyan input[name='tel']").val());
				var memo=$.trim($("#liuyan textarea[name='memo']").val());
				if(name==""){
					pop_up_box.showMsg("请输入您的名称或公司名称!");
				}else if(tel==""){
					pop_up_box.showMsg("请输入您的联系电话!");
				}else{
					pop_up_box.postWait();
					$.post("../login/saveLeavingMsg.do",{
						"com_id":header.getComId(),
						"name":name,
						"tel":tel,
						"memo":memo
					},function(data){
						if (data.success) {
							pop_up_box.toast("留言成功!",1000);
						}
					});
				}
			});
		}
}
header.init(function(){
	index.init();
});
