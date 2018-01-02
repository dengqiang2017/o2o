var  tijian={
		page:0,
		totalPage:0,
		count:0,
		itemhtml:"",
		loadData:function(page,func){
			var searchKey=$("#searchKey").val();
			pop_up_box.loadWait();
			$.get("../manager/getCustomerTijian.do",{
				"searchKey":searchKey,
				"position_big":$("#position_big").val(),
				"item_name":$("#item_name").val(),
				"workState":$("#workState").val(),
				"spNo":$("#spNo").val(),
				"page":page
			},function(data){
				$("tbody").html("");
				$.each(data.rows,function(i,n){
					var item=$(tijian.itemhtml);
					$("tbody").append(item);
					item.find("td").html("");
					var tdname=item.find("td[data-name]");
					for (var i = 0; i < tdname.length; i++) {
						var itemtd=$(tdname[i]);
						var key=itemtd.attr("data-name");
						if(n[key]&&n[key]!='undefined'){
							itemtd.html(n[key]);
						}
					}
					var tdids=item.find("td[data-id]");
					for (var i = 0; i < tdids.length; i++) {
						var tdid=$(tdids[i]);
						var key=tdid.attr("data-id");
						tdid.html(n[key]);
					}
					var tduses=item.find("td[data-use]");
					for (var i = 0; i < tduses.length; i++) {
						var tduse=$(tduses[i]);
						var key=tduse.attr("data-use");
						tduse.html(n[key]);
					}
					var tduses=item.find("td[data-select]");
					for (var i = 0; i < tduses.length; i++) {
						var tduse=$(tduses[i]);
						var key=tduse.attr("data-select");
						if(n[key]&&n[key]!='undefined'){
							var item_id="";
							if(key){
								item_id=key.replace("name","id");
							}
							tduse.html("<span>"+n[key]
							+"</span><br><button type='button' class='btn btn-primary' onclick='tijian.showImg(\""+n[item_id]+"\")'>看图</button>");
						}
					}
					var tduses=item.find("td[data-name-num]");
					for (var i = 0; i < tduses.length; i++) {
						var tduse=$(tduses[i]);
						var key=tduse.attr("data-name-num");
						tduse.html(n[key]);
					}
					item.find("td[data-client='corp_sim_name']").html(n.corp_sim_name);
					var tdimg=item.find("td[data-imge]");
					for (var i = 0; i < tdimg.length; i++) {
						var itemtd=$(tdimg[i]);
						var key=itemtd.attr("data-imge");
						if(n.imgs){
							$.each(n.imgs,function(i,nimg){
								if (nimg.indexOf(key)>0) {
//									if (itemtd.parent().find("td[data-imge='"+key+"']>img").length>0) {
//										itemtd.find("img").attr("src",nimg);
//									}else{
//										itemtd.html("<img src='"+nimg+"'>");
//									}
//									itemtd.find("img").click(function(){
//										$(".image-zhezhao").show();
//										$("#imshow").html("");
//										$("#imshow").append("<img style='display: none;' src='../"+$(this).attr("src")+"'>");
//										$("#imshow").find("img:eq(0)").show();
//									});
									if(itemtd.parent().find("td[data-imge='"+key+"']").find(".kantu").length>0){
										itemtd.parent().find("td[data-imge='"+key+"']").find(".kantu").remove();
										itemtd.append("<button type='button' class='btn btn-primary kantu' onclick='tijian.showImg(\""+nimg+"\",1)'>看图</button>");
									}else{
										itemtd.append("<button type='button' class='btn btn-primary kantu' onclick='tijian.showImg(\""+nimg+"\",1)'>看图</button>");
									}
								}
							});
						}
					}
					if($('a[data-title="title"]').html()=="我的协同-采购审批"){
						item.find("td:eq(0)").html('<div class="pro-check"></div>');
					}else{
						item.find("td:eq(0)").hide();
					}
					if(n.work_state){
						item.find("td[data-readonly='work_state']").html(n.work_state);
					}else{
						item.find("td[data-readonly='work_state']").html("运行中");
					}
				}); 
				pop_up_box.loadWaitClose();
				$("#totalPage").html(data.totalPage);
				tijian.totalPage=data.totalPage;
				tijian.count=data.totalRecord;
				$(".pull-left .form-control").val(data.totalRecord);
				tijian.tdinit();
				if (func) {
					func();
				}
			});
		},
		init:function(){
			if($('a[data-title="title"]').html()!="我的协同-采购审批"){
				$("thead").find("tr:eq(0)").find("th:eq(0)").remove();
			} 
			$(" .btn0").click(function(){
			    $("#mymodal").modal("toggle");
			});
			$.get("../saiyu/tijiantbody.do",{"autr":$("#autr").val()},function(data){
				tijian.itemhtml=data;
			});
			$.get("../saiyu/tijiantbody.do",function(data){
				tijian.itemhtml=data;
			});
			$(".find").click(function(){
				tijian.page=0;
				tijian.loadData();
				$("#mymodal").modal("toggle");
			});
			$("#mymodal").modal("toggle");
			$(".find:eq(0)").click();
			tijian.scroll("tab","box",2); 
			//1.首页
			$("#beginpage").click(function(){
				$("#page").val("1");
				tijian.page=0;
				tijian.loadData();
			});
			//2.尾页
			$("#endpage").click(function(){
				$("#page").val($("#totalPage").html());
				tjian.page=tijian.totalPage;
				tijian.loadData();
			});
			$("#uppage").click(function(){
				var page=tijian.page;//$("#page").val();
				page=parseInt(page)-1;
				if (page>0) {
					$("#page").val(page);
					tijian.page=page;
					tijian.loadData();
				}else{
					pop_up_box.showMsg("已到第一页!");
				}
			});
			$("#nextpage").click(function(){
				var  totalPage=tijian.totalPage;//$("#totalPage").html();
				var  page=tijian.page;//$("#page").val();
				  page=parseInt(page)+1;
				if (page<=totalPage) {
					$("#page").val(page);
					tijian.page=page;
					tijian.loadData();
				}else{
					pop_up_box.showMsg("已到最后一页!");
				}
			});
			$("#closeimgshow").click(function(){
				$(".image-zhezhao").hide();
			});
		},
		tdinit:function(){
			   var th2= $("th");
		       $("td").css("max-height","30px");
		        th2.css("max-width","200px");
		        $("td").css("max-width","200px");
		        th2.css("min-width","200px");
		        $("td").css("min-width","200px");
		        $("td").css("white-space","pre-wrap");
		        $("#box div").attr("height",$("#box").find("thead").attr("height"));
			$(".pro-check").unbind("click");
			$(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
				var b=$(this).hasClass("pro-checked");
				if (b) {
					$(this).removeClass("pro-checked");
				}else{
					$(this).addClass("pro-checked");
				}
			});
		},showImg:function(id,type){
			var len=0;
			$("#imshow").html("");
			if(id&&type==1){
					$(".image-zhezhao").show();
					$("#imshow").append("<img style='display: none;' src='"+id+"?"+Math.random()+"'>");
					$("#imshow").find("img:eq(0)").show();
					$(".img-left").parent().hide();
					$(".img-right").parent().hide();
			}else{
				pop_up_box.loadWait();
			$.get("../manager/getItemIdImgPath.do",{
				"item_id":id
				},function(data){
				pop_up_box.loadWaitClose();
				if(data&&data.length>0){
					$(".image-zhezhao").show();
					$.each(data,function(i,n){
						$("#imshow").append("<img style='display: none;' src='../"+n+"?"+Math.random()+"'>");
					});
					$("#imshow").find("img:eq(0)").show();
					len=data.length;
				}else{
					pop_up_box.toast("没有图片！"); 
				}
			});
			}
			var index=0;
			$(".img-left").unbind("click");
			$(".img-left").click(function(){
				index=index-1;
				if(index<0){
					index=len-1;
				}
				$("#imshow").find("img").hide();
				$("#imshow").find("img:eq("+index+")").show();
			});
			$(".img-right").unbind("click");
			$(".img-right").click(function(){
				index=index+1;
				if(index>=len){
					index=0;
				}
				$("#imshow").find("img").hide();
				$("#imshow").find("img:eq("+index+")").show();
			});
			$("#closeimgshow").click(function(){
				$(".image-zhezhao").hide();
			});
		},scroll:function (viewid,scrollid,size){
			/**  
			 * 功能：固定表头  
			 * 参数   viewid     表格的id  
			 *       scrollid   滚动条所在容器的id  
			 *       size       表头的行数（复杂表头可能不止一行）  
			 */  
		        // 获取滚动条容器  
		    var scroll = document.getElementById(scrollid);  
		        // 将表格拷贝一份  
		    var tb2 = document.getElementById(viewid).cloneNode(true);  
		        // 获取表格的行数  
		    var len = tb2.rows.length;
		        // 将拷贝得到的表格中非表头行删除  
		        $(tb2).find("tbody").remove();
		        // 创建一个div  
		    var bak = document.createElement("div");
		        // 将div添加到滚动条容器中  
//		    scroll.appendChild(bak);  
		    $("#"+scrollid).before(bak);
		        // 将拷贝得到的表格在删除数据行后添加到创建的div中  
		    bak.appendChild(tb2);  
		        // 设置创建的div的position属性为absolute，即绝对定于滚动条容器（滚动条容器的position属性必须为relative）  
		    bak.style.position = "relative";  
		        // 设置创建的div的背景色与原表头的背景色相同（貌似不是必须）  
		    bak.style.backgroundColor = "#cfc";  
		        // 设置div的display属性为block，即显示div（貌似也不是必须，但如果你不希望总是显示拷贝得来的表头，这个属性还是有用处的）  
		    bak.style.display = "block";  
		        // 设置创建的div的left属性为0，即该div与滚动条容器紧贴  
		    bak.style.left = 0;  
		        // 设置div的top属性为0，初期时滚动条位置为0，此属性与left属性协作达到遮盖原表头  
//		    bak.style.top = "0px";  
		    bak.style.height = "80px";  
		    bak.style.width =$("tbody:eq(0)").width()+"px";  
		        // 给滚动条容器绑定滚动条滚动事件，在滚动条滚动事件发生时，调整拷贝得来的表头的top值，保持其在可视范围内，且在滚动条容器的顶端  
		    scroll.onscroll = function(){  
		                // 设置div的top值为滚动条距离滚动条容器顶部的距离值  
		        bak.style.left = this.scrollLeft+"px";  
		    }
		    $("#"+scrollid).scroll(function(){
		    	bak.style.left = (this.scrollLeft*-1)+"px";
		    });
		    bak.style.left = (scroll.scrollLeft*-1)+"px";
	        var th2= $("th");
	        th2.css("max-width","200px");
	        $("td").css("max-width","200px");
	        $("td").css("max-height","30px");
	        $("td").css("white-space","pre-wrap");
	        th2.css("min-width","200px");
	        $("td").css("min-width","200px");
	        $("#box div").attr("height",$("#box").find("thead").attr("height"));
	        $("td").css("white-space","normal");
	        $("#box").find("#"+viewid).find("thead").hide();
		}
		
} 