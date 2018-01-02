authority={
		init:function(clerk_id,clerkName){
			$(".footer>div:eq(0)").hide();
			var r="<div class='btn-gp'><button class='btn btn-info allcheck'>全选</button><button class='btn btn-info savequanxian'>保存</button><a class='btn btn-primary closeinfo'>返回</a></div>";
			$(".footer>div:eq(1)").html(r);
			//1.注册手机端返回按钮
			var authority=$("#authority");
			function closeAuthority(){
				authority.remove();
				$("#listpage").show();
				$(".footer>div:eq(0)").html("");
				$(".footer .btn-gp").remove(); 
			}
			$(".allcheck").click(function(){
				var alltxt=$(this).text();
				if(alltxt=="全选"){
					$(".pro-check").addClass("pro-checked");
					$(this).text("取消");
				}else{
					$(".pro-check").removeClass("pro-checked");
					$(this).text("全选");
				}
			});
			$("#authority_a,#authority_li,.closeinfo:eq(1)").click(function(){//点击手机端返回或者pc端上一级按钮回到员工信息界面
				closeAuthority();
			});
			$(".closeinfo").click(function(){
				closeAuthority();
			}); 
			$("#personnel_li").click(function(){//回到员工维护列表界面
				authority.remove(); 
				$(".footer>div").html("");
				$("#listpage").show();
			});
			pop_up_box.loadWait();
			$.get("getAuth.do",{"clerk_id":clerk_id},function(data){
				pop_up_box.loadWaitClose();
				if (data&&data!="") {
					var auths=$(".auth");
					for (var i = 0; i < auths.length; i++) {
						var auth=$(auths[i]);
						var id=$.trim(auth.attr("id"))+"";
						if(data[id]){
							auth.addClass("pro-checked");
						}
					}
				}
				$(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
					var b=$(this).hasClass("pro-checked");//判断当前项是否是选择状态
					var dt=$(this).parents("dt");///获取当前项是否是dt
					var dd=dt.parents("dl").find("dd");//根据dt获取dl中的所有dd
					////////////
					var dd_dd=$(this).parents("dd");//获取当前项是否是dd
					var dt_dd=dd_dd.parents("dl").find("dt");//根据dd获取其上级项
					var dd_dt=dt_dd.parents("dl").find("dd");//根据dt获取所有的dd,用于判断是否将dt设置为不选择
					////////////
					if (b) {
						$(this).removeClass("pro-checked");
						if (dt) {//当前选择项是dt时,将dl下的所有dd全部取消选择
							dd.find(".pro-check").removeClass("pro-checked");
						}
						if (dd_dt.find(".pro-checked").length==0) {//当dd都没有被选择的时候将dt设置为不选择
							dt_dd.find(".pro-check").removeClass("pro-checked");
						}
					}else{
						$(this).addClass("pro-checked");
						if (dt) {
							dd.find(".pro-check").addClass("pro-checked");
						}
						if (dd_dd) {
							dt_dd.find(".pro-check").addClass("pro-checked");
						}
					}
					/////////
				});
			});
			
			/////
			//////////////
			authority.find("ul:eq(0)").find("span").html(clerkName);
			$(".savequanxian").unbind("click");
			$(".savequanxian").click(function() {
				var qxlist=authority.find(".pro-checked");
				var len=0;
				if (!qxlist) {
					qxlist="";
				}else{
					var qxs="";
					for (var i = 0; i < qxlist.length; i++) {
						var item=qxlist[i];
						var txt=$(item).find("span").text();
						qxs=txt+","+qxs;
					}
					len=qxlist.length;
					qxlist=qxs;
				}
//				if ($("#editpage").length>0) {
//					$("#qxfpcontent").val(qxs);
//					$("#qxfp").html("权限分配,选择权限:"+len+"项");
//				}else{
					$.post("saveAuthority.do",{
						"qxlist":qxlist,
						"clerk_id":clerk_id
					},function(data){
						if (data.success) {
							$("#listpage").show();
							$(".footer>div:eq(0)").html("");
							var tr=$("#listpage").find(".activeTable");
							var fenpei=tr.find("td:eq(4)>button:eq(0)").text();
							if (fenpei.indexOf("分配")>=0) {
								tr.find("td:eq(4)>button:eq(0)").text("分配("+len+"项)");
							}
							pop_up_box.toast("权限保存成功!",500);
							closeAuthority();
						}else{
							pop_up_box.showMsg("权限保存失败!"+data.msg);
						}
					});
//				}
			});
		}
}