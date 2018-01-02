var customer_id="";
var customer_name="";
var spNo="";
var math;
$(function(){
	math=Math.random();
	$("#math").val(math);
//	selectClient.init(function(customerId) {
//		if(customerId){
//			customer_id=customerId;
//		}
//		$(".find:eq(0)").click();
//		$(".center-block").attr("src","");
//	},"../employee/","upper");
	tijian.init();
    $('.btn-folding').click(function(){
        $('.box-head').css({'display':'block'});
     });
     $("#expand").click(function(){
     $("#mymodal").modal("toggle");
     });
	$("#c-msg").click();
	spNo=$("#spNo").val();
	$("#qrtjProduct").click(function(){
		var pros=$(".pro-checked");
		if (pros&&pros.length>0) {
			var infolist=[];
			for (var i = 0; i < pros.length; i++) {
				var tr=$(pros[i]).parents("tr");
				infolist.push(JSON.stringify(tijian.getJson(tr,"imgno")));
			}
			pop_up_box.postWait();
				$.post("../saiyu/qrtjProduct.do",{
					"infolist":infolist,
					"approval_step":$("#approval_step").val(),
					"spNo":spNo
				},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("提交成功!",function(){
							window.location.href="../employee/myOA.do";
						});
					} else {
						if (data.msg) {
							pop_up_box.showMsg("提交错误!" + data.msg);
						} else {
							pop_up_box.showMsg("提交错误!");
						}
					}
				});
		} else {
			pop_up_box.showMsg("请至少选择一个产品!");
		}
	}); 
});
var  tijian={
		page:0,
		totalPage:0,
		count:0,
		itemhtml:"",
		loadData:function(func){
			var searchKey=$("#searchKey").val();
			pop_up_box.loadWait();
//			var tijian.itemhtml=$("#tbodyItem");
			if(!customer_id){
				customer_id=$("#customer_id").val();
			}
			$.get("getCustomerTijian.do",{
				"searchKey":searchKey,
				"page":tijian.page,
				"count":tijian.count,
				"position_big":$("#position_big").val(),
				"position":$("#position").val(),
				"item_name":$("#item_name").val(),
				"workState":$("#workState").val(),
				"spNo":$("#spNo").val(),
				"customer_id": customer_id
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
						if(n[key]){
							tdid.html("<span>"+n[key]+"</span>");
							if(key.indexOf("item_id")>=0){
								tdid.append("<br><button type='button' class='btn btn-primary' onclick='tijian.quxiao(\""+
										n[key]+"\",\""+key+"\",\""+n.ivt_oper_listing+"\",this)'>取消推荐</button>");
							}
						}
					}
					var tduses=item.find("td[data-use]");
					for (var i = 0; i < tduses.length; i++) {
						var tduse=$(tduses[i]);
						var key=tduse.attr("data-use");
						tduse.html(n[key]);
					}
					var tduses=item.find("td[data-name-num]");
					for (var i = 0; i < tduses.length; i++) {
						var tduse=$(tduses[i]);
						var key=tduse.attr("data-name-num");
						tduse.html(n[key]);
					}
					var tduses=item.find("td[data-select]");
					for (var i = 0; i < tduses.length; i++) {
						var tduse=$(tduses[i]);
						var key=tduse.attr("data-select");
						var item_id="";
						if(key){
							item_id=key.replace("name","id");
						}
						if(n[key]&&n[key]!='undefined'){
						    tduse.html("<span>"+n[key]+"</span><br><button type='button' class='btn btn-primary' onclick='tijian.showImg(\""
						    		+n[item_id]+"\")'>看图</button>");
						}else{
							tduse.html("<span></span>");
						}
					}
					var tdimg=item.find("td[data-imge]");
					for (var i = 0; i < tdimg.length; i++) {
						var itemtd=$(tdimg[i]);
						var key=itemtd.attr("data-imge");
						itemtd.html(fileimghtml(key));
						if(n.imgs){
							$.each(n.imgs,function(i,nimg){
								if (nimg.indexOf(key)>0) {
//									if (itemtd.parent().find("td[data-imge='"+key+"']>img").length>0) {
//										itemtd.find("img").attr("src",nimg);
//									}else{
//										itemtd.find("div").before("<img src='"+nimg+"'>");
//									}
//									itemtd.find("img").click(function(){
//										$(".image-zhezhao").show();
//										$("#imshow").html("");
//										$("#imshow").append("<img style='display: none;' src='../"+$(this).attr("src")+"'>");
//										$("#imshow").find("img:eq(0)").show();
//									});
									if(itemtd.parent().find("td[data-imge='"+key+"']").find(".kantu").length>0){
										itemtd.parent().find("td[data-imge='"+key+"']").find(".kantu").parent().remove();
									}
									itemtd.find(".hoverdiv").before("<div style='display: inline-block;'><button type='button' class='btn btn-primary kantu' onclick='tijian.showImg(\""+nimg+"\",1)'>看图</button></div>");
								}
							});
						}
					}
					if(spNo!=""){
						item.find("td:eq(0)").html('<div class="pro-check"></div>');
						item.find("td:eq(0)").append('<button type="button" class="btn btn-primary" style="display: none;">保存</button>');
					}else{
						item.find("td:eq(0)").html('<button type="button" class="btn btn-primary">保存</button><button type="button" class="btn btn-primary">删除</button>');
					}
					item.find("td[data-select]").append('<button type="button" class="btn btn-primary" onclick="selectproduct(this);">推荐产品</button>');
					item.find("td[data-name-num]").css("color","red");//.html('<input data-num="num">');
					if(n.corp_sim_name){
						item.find("td[data-client='corp_sim_name']").html(n.corp_sim_name);
					}else{
						item.find("td[data-client]").html('<span></span>');
						//<button type="button" class="btn btn-primary" onclick="selectclient(this);" style="position:absolute;bottom:0;left:7px">选择客户</button>');
					}
					if(n.work_state){
						item.find("td[data-readonly='work_state']").html(n.work_state);
					}else{
						item.find("td[data-readonly='work_state']").html("运行中");
					}
				}); 
				pop_up_box.loadWaitClose();
				$("#totalPage").html(data.totalPage);
				$(".pull-left .form-control").val(data.totalRecord);
				tijian.totalPage=data.totalPage;
				tijian.count=data.totalRecord;
				tijian.tdinit();
				if (func) {
					func(data.totalPage,data.totalRecord);
				}
			});
			
		},
		addTdHtml:function(){
			if(!customer_id||customer_id==""){
				$("#seekh").click();
				return;
			}
			var tr=$(tijian.itemhtml) ;
			if($("tbody>tr:eq(0)").length>0){
				$("tbody>tr:eq(0)").before(tr);
			}else{
				$("tbody").append(tr);
			}
			tr.find("td").html("");
			tr.find("td:eq(0)").html('<button type="button" class="btn btn-primary">保存</button><button type="button" class="btn btn-primary">删除</button>');
			tr.find("td[data-client]").html('<span></span>');
			//<button type="button" class="btn btn-primary" onclick="selectclient(this);" style="position:absolute;bottom:0;left:7px">选择客户</button>');
			tr.find("td[data-select]").html('<span></span><button type="button" class="btn btn-primary" onclick="selectproduct(this);" style="position:absolute;bottom:0;left:7px">推荐产品</button>');
//			tr.find("td[data-name-num]").html('<input data-num="num">');
			tr.find("td[data-id='customer_id']").html("<span>"+customer_id+"</span>")
			tr.find("td[data-client='corp_sim_name']").html(customer_name);
			for (var i = 0; i < tr.find("td[data-imge]").length; i++) {
				var item=$(tr.find("td[data-imge]")[i]);
				var imgkey=item.attr("data-imge");
				item.html(fileimghtml(imgkey));
			}
			tijian.tdinit();
			tr.find("td:eq(0)").find("button:eq(0)").click();
	        var th2= $("th");
	        th2.css("max-width","200px");
	        $("td").css("max-width","200px");
	        th2.css("min-width","200px");
	        $("td").css("min-width","200px");
	        $("td").css("white-space","pre-wrap");
//	        $("td").css("white-space","normal");
		},
		init:function(){
			$.get("../saiyu/tijiantbody.do",{"autr":10},function(data){
				tijian.itemhtml=data;
				$(".find:eq(0)").click();
				tijian.scroll("tab","box",2); 
			});
			try {
				$.mobile.hidePageLoadingMsg(); 
			} catch (e) {}
			$(".find").click(function(){
				$("#page").val("1");
				tijian.page=0;
				tijian.count=0;
				tijian.loadData();
			});
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
			////////////
			var weixin=0;///用于在保存图片的时候判断上传类型
			if (is_weixin()) {
				$("#scpz").show();
				$("#upload-btn").hide();
				weixinfileup.init();
			}else{
				$("#scpz").hide();
				$("#upload-btn").show();
			}
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
			$("tr>td[data-name]").unbind("dblclick");
			$("tr>td[data-name]").click(function(){
				var nm=$(this).attr("data-name");
				var inp=$(this).html();
				if(nm=="sd_order_id"){
					return;
				}
				if(inp.indexOf("input")<0){
					if(nm.indexOf("sd_unit")==0){
						$(this).html("<input value='"+$(this).html()+"' data-number='num2'>");
					}else if(nm.indexOf("sd_oq")==0){
						$(this).html("<input value='"+$(this).html()+"' data-number='num'>");
					}else{
						$(this).html("<input value='"+$(this).html()+"'>");
					}
				}else{
					$(this).find("input").blur();
				}
				var t=$(this);
				$(this).find("input").unbind("blur");
				$(this).find("input").blur(function(){
					var b=true;
					$(".box-body").find("#box").css("overflow-x","auto");
					if($.trim(inp)==$.trim($(this).val())){
						b=false;
					}
					t.html($(this).val());
					if(b){
						if($.trim(t.html())!=""){
							t.parents("tr").find("td:eq(0)").find("button:eq(0)").click();
						}else{
							var key=t.attr("data-name");
							var val=t.html();
							var ivt_oper_listing=t.parents("tr").find("td[data-name='ivt_oper_listing']").html();
							$.post("../manager/updateTijian.do",{
								"ivt_oper_listing":ivt_oper_listing,
								"namekey":key								
							},function(data){
							
							});
						}
					}
				});
				initNumInput();
				$(this).find("input").focus().val($(this).find("input").val());//.select();
				$(".box-body").find("#box").css("overflow-x","hidden");
			});
			$(".pro-check").unbind("click");
			$(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
				var b=$(this).hasClass("pro-checked");
				if (b) {
					$(this).removeClass("pro-checked");
				}else{
					$(this).addClass("pro-checked");
				}
			});
			tijian.delData();
			tijian.saveData();
			initNumInput();
		},delData:function(){
			$("tr").find("td:eq(0)").find("button:eq(1)").unbind("click");
			$("tr").find("td:eq(0)").find("button:eq(1)").click(function(){
				if (confirm("是否删除当前记录!")) {
					var ivt_oper_listing=$.trim($(this).parent().next().html());
					var t=$(this);
					if (ivt_oper_listing) {
						$.get("deltijian.do",{
							"ivt_oper_listing":ivt_oper_listing
						},function(data){
							if (data.success) {
								pop_up_box.showMsg("删除成功!",function(){
									t.parents("tr").remove();
								});
							} else {
								if (data.msg) {
									pop_up_box.showMsg("删除错误!" + data.msg);
								} else {
									pop_up_box.showMsg("删除错误!");
								}
							}
						});
					}else{
						if(confirm("该记录没有保存过是否删除!")){
							$(this).parents("tr").remove();
						}
					}
				}
			});
		},getJson:function(tr,imgno){
			var json={};
//			json.math=math;
			if(!imgno){
				var tdimg=tr.find("td[data-imge]");
				for (var i = 0; i < tdimg.length; i++) {
					var img=$(tdimg[i]);
					var imgkey=img.attr("data-imge");
					if(imgkey){
						var imgpath=$.trim(img.find("img").attr("src"));
						imgpath=$.trim(img.find("input[type='hidden']").val());
						imgpath=imgpath.replace("..","");
						if (imgpath&&imgpath!="") {
							json[imgkey]=imgpath;
						}
					}
				}
			}
			var tdnum=tr.find("td[data-name-num]");
			for (var i = 0; i < tdnum.length; i++) {
				var num=$(tdnum[i]);
				var numkey=num.attr("data-name-num");
				if(numkey){
					var numval=$.trim(tr.find("td[data-name-num]>input").val());
					if (numval&&numval!="") {
						json[numkey]=numval;
					}
				}
			}
			tijian.getJsonToHtml(tr,"data-name",function(bkey,bval){
				json[bkey]=bval;
			});
//			tijian.getJsonToHtml(tr,"data-id",function(bkey,bval){
//				json[bkey]=bval;
//			});
			var tdnum=tr.find("td[data-id]");
			for (var i = 0; i < tdnum.length; i++) {
				var num=$(tdnum[i]);
				var numkey=num.attr("data-id");
				if(numkey){
					var numval=$.trim(num.find("span").html());
					if (numval&&numval!="") {
						json[numkey]=numval;
					}
				}
			}
			if(!json.customer_id){
				json.customer_id=customer_id;
			}
			tijian.getJsonToHtml(tr,"data-use",function(bkey,bval){
				json[bkey]=bval;
			});
			var tduse=tr.find("td[data-select]");
			for (var i = 0; i < tduse.length; i++) {
				var use=$(tduse[i]);
				var usekey=use.attr("data-select");
				if(usekey){
					var useval=$.trim(use.find("span").html());
					if (useval&&useval!="") {
						json[usekey]=useval;
					}
				}
			}
			return json;
		},getJsonToHtml:function(tr,key,func){
			var tduse=tr.find("td["+key+"]");
			for (var i = 0; i < tduse.length; i++) {
				var use=$(tduse[i]);
				var usekey=use.attr(key);
				if(usekey){
					var useval=$.trim(use.html());
					if (useval!="") {
						if(func&&useval){
							func(usekey,useval);
						}
					}
				}
			}
			
		},saveData:function(){
			///行基本数据保存于推荐数据保存
			$("tr").find("td:eq(0)").find("button:eq(0)").unbind("click");
			$("tr").find("td:eq(0)").find("button:eq(0)").click(function(){
				var tr=$(this).parents("tr");
				var position_big=$.trim(tr.find("td[data-name='position_big']").html());
				var position=$.trim(tr.find("td[data-name='position']").html());
				var item_name=$.trim(tr.find("td[data-name='item_name']").html());
//				if (position_big=="") {
//					pop_up_box.showMsg("请输入位置大类!");
//				} else if (position=="") {
//					pop_up_box.showMsg("请输入位置小类!");
//				}else{
				var t=$(this);
					pop_up_box.postWait();
					$.post("saveTijian.do",tijian.getJson(tr),function(data){
						pop_up_box.loadWaitClose();
						if (data.success) {
//							pop_up_box.showMsg("保存成功!");
							var json=$.parseJSON(data.msg);
							tr.find("td[data-name='ivt_oper_listing']").html(json.no);
							tr.find("td[data-name='sd_order_id']").html(json.no);
							tr.find("td[data-readonly='work_state']").html("运行中");
							pop_up_box.dataHandling("操作已保存!");
							setTimeout("pop_up_box.loadWaitClose()", 500);
							////////图片按钮数据显示///////////
							var tdimg=t.parents("tr").find("td[data-imge]");
							for (var i = 0; i < tdimg.length; i++) {
								var itemtd=$(tdimg[i]);
								var key=itemtd.attr("data-imge");
								if(json.list){
									$.each(json.list,function(i,imgs){
										if (imgs.indexOf(key)>0){
											itemtd.html(fileimghtml(key));
											if(itemtd.parent().find("td[data-imge='"+key+"']").find(".kantu").length>0){
												itemtd.parent().find("td[data-imge='"+key+"']").find(".kantu").parent().remove();
											}
						itemtd.find(".hoverdiv").before("<div style='display: inline-block;'><button type='button' class='btn btn-primary kantu' onclick='tijian.showImg(\".."+imgs+"\",1)'>看图</button><div>");
										}
									});
								}
							}
							/////////图片按钮数据结束显示/////////////
						} else {
							if (data.msg) {
								pop_up_box.showMsg("保存错误!" + data.msg);
							} else {
								pop_up_box.showMsg("保存错误!");
							}
						}
					});
//				}
			});
		},showImg:function(id,type){
			var len=0;
			if(id&&type==1){
				pop_up_box.showImg(id+"?ver="+Math.random());
//				$(".image-zhezhao").show();
//				$("#imshow").html("");
//				$("#imshow").append("<img style='display: none;' src='"+id+"?"+Math.random()+"'>");
//				$("#imshow").find("img:eq(0)").show();
//				$(".img-left").parent().hide();
//				$(".img-right").parent().hide();
			}else{
				pop_up_box.loadWait();
				$.get("../manager/getItemIdImgPath.do",{
					"item_id":id
				},function(data){
					pop_up_box.loadWaitClose();
					if(data&&data.length>0){
						$(".image-zhezhao").show();
						$("#imshow").html("");
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
		},quxiao:function(id,item_id_name,ivt_oper_listing,t){
			pop_up_box.loadWait();
			$.get("../saiyu/quxiaoProduct.do",{
				"item_id":id,
				"ivt_oper_listing":ivt_oper_listing,
				"item_id_name":item_id_name
				},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					var pt=$(t).parent();
					pt.html("");
					pt.next().html("<span></span><button type='button' class='btn btn-primary' onclick='selectproduct(this);'>推荐产品</button>");
					pt.next().next().html("");
					pt.next().next().next().html("");
					pt.next().next().next().next().html("");
				}
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
		    $(".box-head").append(bak);
		    $("#"+viewid).find("thead").hide();
//		    $("#"+viewid).before(bak);
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
//		        bak.style.top = this.scrollTop+"px";
		        bak.style.left = (this.scrollLeft*-1)+"px";
//		        $("td").find("input").blur();
		    }
		    bak.style.left = (scroll.scrollLeft*-1)+"px";
		    scroll.addEventListener('touchmove', function(event) {
		    	$("td").find("input").blur();
//		    	$(".btn0").html("查询,"+ touch.pageX);
//		        // 如果这个元素的位置内只有一个手指的话
//		       if (event.targetTouches.length == 1) {
////		           event.preventDefault();// 阻止浏览器默认事件，重要 
		           var touch = event.targetTouches[0];
//		           // 把元素放在手指所在的位置
//		           scroll.style.left = (touch.pageX) + 'px';
////		           scroll.style.top = touch.pageY-50 + 'px';
//		           bak.style.left =((touch.pageX+50)*-1) + 'px';
//		           }
		   }, false);
		    scroll.addEventListener('touchstart', function(event) {
//		    	// 如果这个元素的位置内只有一个手指的话
//		    	if (event.targetTouches.length == 1) {
////		           event.preventDefault();// 阻止浏览器默认事件，重要 
//		    		var touch = event.targetTouches[0];
//		    		// 把元素放在手指所在的位置
//		           scroll.style.left = (touch.pageX) + 'px';
////		           scroll.style.top = touch.pageY-50 + 'px';
//		    		bak.style.left =((touch.pageX+50)*-1) + 'px';
//		    		$(".btn0").html("查询,"+((touch.pageX+50)*-1));
//		    	}
		    	$("td").find("input").blur();
//		    	$(".btn0").html("查询,"+ touch.pageX);
		    }, false);
		    
	       var th2= $("th");
	       $("td").css("max-height","30px");
	        th2.css("max-width","200px");
	        $("td").css("max-width","200px");
	        $("td").css("white-space","pre-wrap");
	        th2.css("min-width","200px");
	        $("td").css("min-width","200px");
	        $("#box div").attr("height",$("#box").find("thead").attr("height"));
		}  
} 
function delClient(t){
	var tr=$(t).parents("tr");
	if (window.confirm("是否要删除该记录?")) {
		var ivt_oper_listing=tr.find("input:eq(0)").val();
		$.post("tijiandel.do",{"customer_id":customer_id,"ivt_oper_listing":ivt_oper_listing},function(data){
			if (data.success) {
				tr.remove();
			}else{
				pop_up_box.showMsg(data.msg);
			}
		});
	}
}
//////////上传图片部分开始/////////////
function fileimghtml(imgkey){//onchange='imgUpload(this,$(this).parent(),\""+imgkey+"\",\""+imgkey+"\")'<div style='display: inline-block;'>
	 var hm="<div  class=\"hoverdiv\" style='display: inline-block;'>"+
     "<input type='text'  id='"+imgkey+"' name='"+imgkey+"' onclick='imgUpload(this,$(this).parent(),\""+imgkey+"\",\""+imgkey+"\")' style='opacity:0;left: 0;top: 0;width: 100%;height: 100%;position: absolute;cursor: pointer;'>"+
   "上传图片</div>";
	 return hm;
}
function tijianimgupload(t,tjno,key){
	var imgPath="@com_id/tijianimg/"+tjno+"/"+key+".jpg";
	if(tjno==""){
		alert("没有体检编号!");
		imgPath="temp/tijianimg/"+new Date().getTime()+".jpg";
	}
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImageZs.do?fileName=imgFile&newWidth=1200&imgPath="+imgPath,
		"msgId":"msg",
		"fileId":"imgFile",
		"msg":"图片",
		"fid":"",
		"uploadFileSize":50
	},t,function(imgurl){
		$("#filepath").val(imgurl);
		$(".modal-first:eq(1)").find(".btn-primary:eq(1)").click();
//		$(".showimg>img").attr("src",".."+imgurl+"?"+Math.random());
//		$(".modal-first").find("img").show();
	});
}
function imgUpload(t,tp,key,img){
	t=$(t);
	var tjno=$.trim(t.parents("tr").find("td[data-name='sd_order_id']").html());
	$(".modal-cover-first:eq(1),.modal-first:eq(1)").show();
	$(".modal-first:eq(1)").find("a").html("<input type='file' name='imgFile' id='imgFile' onchange='tijianimgupload(this,\""+tjno+"\",\""+img+"\");'>上传图片");
	$(".modal-first:eq(1)").find("img").attr("src","");
	$(".modal-first:eq(1)").find("img").hide();
	$(".modal-first:eq(1)").find(".btn-primary:eq(1)").click(function(){
		var td=tp.parent();
		if(td.find("td[data-imge='"+key+"']>.kantu").length>0){
			td.find("td[data-imge='"+key+"']>.kantu").remove();
		}
		if(td.find(".hoverdiv").length>0){
			td.find(".hoverdiv").before("<input type='hidden' value='"+$("#filepath").val()+"'>");
			td.find(".hoverdiv").before("<div style='display: inline-block;'><button type='button' class='btn btn-primary' onclick='tijian.showImg(\"/"+$("#filepath").val()+"\",1)'>看图</button></div>");
		}else{
			td.append("<input type='hidden' value='"+$("#filepath").val()+"'>");
			td.append(".hoverdiv").before("<div style='display: inline-block;'><button type='button' class='btn btn-primary' onclick='tijian.showImg(\"/"+$("#filepath").val()+"\",1)'>看图</button></div>");
		}
		if($.trim($(tp).parents("tr").find("td[data-id='customer_id']").html())!=""){
			tp.parents("tr").find("td:eq(0)").find("button:eq(0)").click();
		}
		$(".modal-cover-first:eq(1),.modal-first:eq(1)").hide();
	});
	$(".modal-first").find(".btn-default,.close").click(function(){
		$(".modal-cover-first,.modal-first").hide();
	});
	//////////////////////////////////////////////
	if (is_weixin()) {
		//微信上传按钮
		$("#scpz").unbind("click");
		$("#scpz").click({"t":t,"key":key},function(event){
			var key=event.data.key;
			var imgPath="001/tijianimg/"+tjno+"/"+key+"_img.jpg";
			if(tjno==""){
				imgPath="temp/tijianimg/"+new Date().getTime()+".jpg";
			}
			weixinfileup.chooseImage(this,function(imgurl){
				weixinfileup.uploadImage(imgurl,function(url){
					$.get("../weixin/getImageToWeixin.do",{"url":url,"imgPath":imgPath},function(data){
						if (data.success) {
							$("#filepath").val(imgPath);
							$(".showimg>img").attr("src",imgurl);
							$(".modal-first").find("img").show();
							pop_up_box.toast("上传成功!",1000);
						} else {
							if (data.msg) {
								pop_up_box.showMsg("上传错误!" + data.msg);
							} else {
								pop_up_box.showMsg("上传错误!");
							}
						}
					});
					
				});
				$(".modal-body").find("img").attr("src",imgurl);
				$("#imgFile").val(imgurl);
			});
		});
	}
}
///////////////上传图片部分结束////////////////
function imgImport(t,key){
	pop_up_box.postWait();
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImg.do?fileName="+key,
		"msgId":"msg",
		"fileId":key,
		"msg":"",
		"fid":"",
		"uploadFileSize":1000
	},t,function(imgurl){
		pop_up_box.loadWaitClose(); 
		$.get("saveTijianImg.do",{"path":imgurl},function(data){ 
			if (data.success) {
				pop_up_box.showMsg("图片导入成功!");
			} else {
				if (data.msg) {
					pop_up_box.showMsg("图片导入错误!" + data.msg);
				} else {
					pop_up_box.showMsg("图片导入错误!");
				}
			}
		});
	});
}
function selectclient(t){
	pop_up_box.loadWait(); 
	   $.get("../manager/getClientTree.do",{"ver":Math.random()},function(data){
		   pop_up_box.loadWaitClose();
		   $("body").append(data);
		   client.init(function(id,name){
			   $("body").css("overflow","");
			   customer_id=id;
			   customer_name=name;
			   $(".sim-msg").find("li:eq(0)").html(name);
			   $(".sim-msg").find("li:eq(1)").html(name);
			   $(".find:eq(0)").click();
			   $("#expand").unbind("click");
			   $("#expand").click(function(){
				     $("#mymodal").modal("toggle");
				});
//			   $(t).parent().prev().html("<span>"+id+"</span>");
//			   $(t).prev().html(name);
//			   $(t).parents("tr").find("td:eq(0)").find("button:eq(0)").click();
		   });
	   });
}
function clearProduct(t){
	$(t).parent().prev().html("");
	$(t).prev().html("");
	$(t).parent().next().html("");
	$(t).parent().next().next().html("");
	$(t).parent().next().next().next().html("");
}
function selectproduct(t){
	if($.trim($(".modal").find("tbody").html())==""){
		$.get("../tree/productSelect.do",function(data){
			pop_up_box.loadWaitClose();
			$("body").append(data);
			product.init(function(){
				var item_id=$(".modal").find("tr.activeTable").find("td:eq(0)>input").val();
				$(t).parent().prev().html("<span>"+item_id+"</span>");
				var pingpai=$(".modal").find("tr.activeTable").find("td:eq(0)").text();
				var key=$(t).parent().prev().attr("data-id");
				if(!pingpai){
					pingpai="";
				}else{
					 pingpai=pingpai+"";
				 }
				$(t).prev("span").html(pingpai+"-"+$(".modal").find("tr.activeTable").find("td:eq(1)").text());//显示产品名称
				$(t).parent().find(":contains('看图')").parent().remove();
				$(t).before("<br><div style='display: inline-block;'><button type='button' class='btn btn-primary' onclick='tijian.showImg(\""+item_id+"\")'>看图</button></div>");
				$(t).parent().next().html($(".modal").find("tr.activeTable").find("td:eq(6)").text());//单价
				$(t).parent().next().next().html(1);//推荐采购数量
				$(t).parent().next().next().next().html($(".modal").find("tr.activeTable").find("td:eq(2)").text());//库存数
				var ivt_oper_listing=$(t).parents("tr").find("td:eq(1)").html();
				$(t).parent().prev().append("<br><button type='button' class='btn btn-primary' onclick='tijian.quxiao(\""+
						item_id+"\",\""+key+"\",\""+ivt_oper_listing+"\",this)'>取消推荐</button>");//产品编码
				if($.trim($(t).parents("tr").find("td[data-id='customer_id']").html())!=""){
					$(t).parents("tr").find("td:eq(0)").find("button:eq(0)").click();
				}
			});
		});
	}else{
		 $(".modal,.modal-cover").show();
		 product.init(function(){
			 var item_id=$(".modal").find("tr.activeTable").find("td:eq(0)>input").val();
				$(t).parent().prev().html("<span>"+item_id+"</span>");
			 var pingpai=$(".modal").find("tr.activeTable").find("td:eq(0)").text();
			 var key=$(t).parent().prev().attr("data-id");
			 if(!pingpai){
				pingpai="";
			 }else{
				 pingpai=pingpai+"";
			 }
			 $(t).prev("span").html(pingpai+$(".modal").find("tr.activeTable").find("td:eq(1)").text());//显示产品名称
			 $(t).parent().find(":contains('看图')").parent().remove();
			 $(t).before("<br><div style='display: inline-block;'><button type='button' class='btn btn-primary' onclick='tijian.showImg(\""+item_id+"\")'>看图</button></div>");
			 $(t).parent().next().html($(".modal").find("tr.activeTable").find("td:eq(6)").text());//单价
			 $(t).parent().next().next().html(1);//推荐采购数量
			 $(t).parent().next().next().next().html($(".modal").find("tr.activeTable").find("td:eq(2)").text());//库存数
			var ivt_oper_listing=$(t).parents("tr").find("td:eq(1)").html();
			$(t).parent().prev().append("<br><button type='button' class='btn btn-primary' onclick='tijian.quxiao(\""+
					item_id+"\",\""+key+"\",\""+ivt_oper_listing+"\",this)'>取消推荐</button>");//产品编码
			if($.trim($(t).parents("tr").find("td[data-id='customer_id']").html())!=""){
				$(t).parents("tr").find("td:eq(0)").find("button:eq(0)").click();
			}
		 });
	}
}