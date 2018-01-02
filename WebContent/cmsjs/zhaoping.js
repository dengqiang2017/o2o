try {
	if(!projectName){
		project_Name=projectName;
	}
} catch (e) {
	project_Name=getQueryString("projectName");
}
var zhaoping={
		init:function(){
			$(".secition_box_bottomtop_y4").eq(0).show();
			$("input[type='color']").change(function(){
				$(".selectColor").css("color",$(this).val());
			});
			$("#fontsize").change(function(){
				$(".selectColor").css("font-size",$(this).val()+"px");
			});
			$(":radio").click(function(){
				$(".selectColor").css("font-weight",$(this).val());
			});
			$("#show").click(function(){
				window.location.href="zhaopin.html?project_Name="+project_Name;
			});
			$("#save").click(function(){
				var ls=$(".secition_box_bottomtop_y4");
				$(".secition_box_bottomtop_y4 .y-box-center").removeAttr("contenteditable");
				$(".y-box-center").removeClass("selectColor");
				for (var i = 0; i < ls.length; i++) {
					var title=$(".secition_box_bottomtop_y4").eq(i).find("h3:eq(0)").html();
					$(".secition_box_bottom_x02>div").eq(i).html(title);
				}
				$(".addDaiyu").hide();
				pop_up_box.postWait();
				$.post("../temp/saveFile.do",{
					"html":$("#zhaoping").html(),
					"path":project_Name+"/zhaopin"
				},function(data){
					$(".addDaiyu").show();
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.toast("保存成功!",1000);
					} else {
						if (data.msg) {
							pop_up_box.showMsg("保存错误!" + data.msg);
						} else {
							pop_up_box.showMsg("保存错误!");
						}
					}
				});
			});
//			zhaoping.getZhaopin();
			///增加招聘页面
			$("#addZhaopin").click(function(){
				var x1=$("<div class='x-1'><lable>新职位</lable></div>");
				$(".secition_box_bottom .secition_box_bottom_x02>.clearfix").before(x1);
				var len=$(".secition_box_bottom .secition_box_bottomtop_y4").length;
				var y4=$("<div class='secition_box_bottomtop_y4'>"+$(".secition_box_bottomtop_y4:eq(0)").html()+"</div>");
				$(".secition_box_bottom .secition_box_bottomtop_y4").eq(len-1).after(y4);
				var len=$(".secition_box_bottom .secition_box_bottom_x02>.x-1").length;
				$(".secition_box_bottom .secition_box_bottom_x02>.x-1").css("width",(1/len*100)+"%");
				y4.find("h3").html("请输入新职位");
				y4.find("p").html("");
				y4.find("p:eq(0)").html("岗位职责：");
				y4.find("p:eq(1)").html("任职要求：");
				zhaoping.titleclick();
				x1.click();
				zhaoping.centerP();
				zhaoping.addDaiyu();
				//div节点改变事件
				$(".y-box-center").bind('DOMNodeInserted', function(e) {
					zhaoping.centerP();
					$(".y-box-center p").removeClass("selectColor");
					$(e.target).addClass("selectColor");
				});
			});
			///删除招聘页面
			$("#delZhaopin").click(function(){
				var len=$(".secition_box_bottom .secition_box_bottom_x02>.x-1").length;
				if(len>1){
					var n=$(".x-1").index($(".x-active"));
					$(".x-active").remove();
					$(".secition_box_bottomtop_y4").eq(n).remove();
					$(".secition_box_bottom .secition_box_bottom_x02>.x-1").css("width",(1/len*100)+"%");
					$(".x-1").eq(n-1).click();
				}else{
					pop_up_box.showMsg("只剩余一个时不能删除!");
				}
			});
		},getZhaopin:function(){
			$.get("../temp/getFile.do",{
				"path":project_Name+"/zhaopin"
			},function(data){
				if(data.msg){
					$("#zhaoping").html(data.msg);
				}else{
					$(".secition_box_bottomtop_y4").show();
				}
				zhaoping.titleclick();
				zhaoping.centerP();
				zhaoping.addDaiyu();
				$(".bq_box>.bq").click();
				$(".y-box-center").bind('DOMNodeInserted', function(e) {
					zhaoping.centerP();
					$(".y-box-center p").removeClass("selectColor");
					$(e.target).addClass("selectColor");
				});
			});
		},addDaiyu:function(){
			$(".addDaiyu").show();
			$(".addDaiyu").unbind("click");
			$(".addDaiyu").click(function(){
				//.find(".clearfix")
				$(this).prev().append("<div class='bq'>福利待遇</div>");
				$(".panel-body input").attr("disabled","disabled");
			});
		},centerP:function(){
			$(".y-box-center p,h3,.bq").removeClass("selectColor");
			$(".y-box-center p,h3,.bq").unbind("click");
			$(".y-box-center p,h3,.bq").click(function(){
				$(".y-box-center p,h3,.bq").removeClass("selectColor");
				$(this).addClass("selectColor");
				
				$("input[type='color']").val(rgbToHex($(this).css("color")));
				$("#fontsize").val($(this).css("font-size").split("px")[0]);
				if($(this).css("font-weight")==700){
					$(":radio[value='bold']").prop("checked",true);
				}else{
					$(":radio[value='normal']").prop("checked",true);
				}
			});
		
		},titleclick:function(){
			$('.secition_box_bottom_x02>div').click(function() {
				$('.secition_box_bottom_x02>div').removeClass('x-active');
				$(this).addClass('x-active');
				$(".secition_box_bottomtop_y4").hide();
				$(".secition_box_bottomtop_y4").eq($('.secition_box_bottom_x02>div').index(this)).show();
			});
			$(".secition_box_bottomtop_y4 .y-box-center").attr("contenteditable",true);
		}
}
zhaoping.init();
var rgbToHex = function(rgb) {
	var color = rgb.toString().match(/\d+/g); // 把 x,y,z 推送到 color 数组里
	var hex = "#";
	for (var i = 0; i < 3; i++) {
		// 'Number.toString(16)' 是JS默认能实现转换成16进制数的方法.
		// 'color[i]' 是数组，要转换成字符串.
		// 如果结果是一位数，就在前面补零。例如： A变成0A
		hex += ("0" + Number(color[i]).toString(16)).slice(-2);
	}
	return hex;
}