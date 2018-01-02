$(function(){
	$("input").removeAttr("disabled");
});
var browser={
    versions:function(){
           var u = navigator.userAgent, app = navigator.appVersion;
           return {//移动终端浏览器版本信息
                trident: u.indexOf('Trident') > -1, //IE内核
                presto: u.indexOf('Presto') > -1, //opera内核
                webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
                gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
                mobile: !!u.match(/AppleWebKit.*Mobile.*/)||!!u.match(/AppleWebKit/), //是否为移动终端
                ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
                android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器
                iPhone: u.indexOf('iPhone') > -1 || u.indexOf('Mac') > -1, //是否为iPhone或者QQHD浏览器
                iPad: u.indexOf('iPad') > -1, //是否iPad
                webApp: u.indexOf('Safari') == -1 //是否web应该程序，没有头部与底部
            };
         }(),
         language:(navigator.browserLanguage || navigator.language).toLowerCase()
}
/**
 * 判断是否是微信浏览器  
 * @returns true为微信浏览器,false为其它浏览器
 */
function is_weixin(){
	var ua = navigator.userAgent.toLowerCase();
	if(ua.match(/MicroMessenger/i)=="micromessenger") {
		return true;
 	} else {
		return false;
	}
}
var pop_up_box={
		over:true,
		loadtime:0,
		prePop:function(){
			var url=window.location.href.split("/");
			var prep="";
			if (url.length>5) {///////////直接域名使用5
				prep="../";
			}else{
			///从common.js中获取到的上下文路径
				try {
					prep=pre+"/";
				} catch (e) {}
			}
			return "/";
		},
		/**
		 * 信息提示框
		 * @param msg 提示信息
		 * @param callback 点击确定后的操作-可选
		 */
		showMsg:function(msg,callback){
			function getMessageDiv(msg){
				var msgDiv="<div id='msgDiv'>"
					+"<div id='msgTitle'>"
					+"<span>系统提示</span><a class='anniuGbxx' id='closeMsgX'></a>"
					+"<div class='tanchukuangNDxx' id='msg'>"+msg+"</div>"
					+"<div class='tanchukuangNDNxx'><a id='closeMsg'>确定</a></div>"
					+"</div>"
					+"</div><div id='zhezhao' style='position:fixed;z-index:9991;width:100%;height:100%;background-color:silver;display:none;opacity:.5;  filter:Alpha(Opacity=50); top:0px;'></div>";
				return msgDiv;
			}
			var msgDiv=getMessageDiv(msg);
			$("body").append(msgDiv);
			$("#msgDiv,#zhezhao").show();
			$("#closeMsg,#closeMsgX").bind("click",function(){
//				$("input").removeAttr("disabled");
				$("#msgDiv,#zhezhao").remove();
				if (callback) {
					callback();
				}
			});
//			$("input").attr("disabled","disabled"); 
		},showDialog:function(title,msg,callback){
			function getMessageDiv(msg){
				var msgDiv="<div id='msgDiv'>"
				   +"<div id='msgTitle'><span>"+title+"</span><a id='closeMsgX'></a></div>"
				   +"<div id='msg'>"+msg+"</div>"
				   +"<div class='closeMsgDiv'><a id='closeMsg' class='btn btn-info'>确定</a></div></div>"
				   +"<div id='zhezhao'></div>";
				return msgDiv;
			}
			var msgDiv=getMessageDiv(msg);
			$("body").append(msgDiv);
			$("#msgDiv,#zhezhao").show();
			$("#closeMsg").bind("click",function(){
				if (callback) {
					callback();
				}
				$("#msgDiv,#zhezhao").remove();
			});
			$("#closeMsg,#closeMsgX").bind("click",function(){
				$("#msgDiv,#zhezhao").remove();
			});
		},
		/**
		 * 信息提示框
		 * @param msg 提示信息
		 * @param callback 点击确定后的操作-可选
		 */
		showmsg:function(msg,callback){
			pop_up_box.showMsg(msg, callback);
		},
		resultMsg:function(data,success,fail,func){
			if (data.success) {
				pop_up_box.showMsg(success+"!",function(){
					if (func) {
						func();
					}
				});
			}else{
				if (data.msg) {
					pop_up_box.showMsg(fail+"!");
				}else{
					pop_up_box.showMsg(fail+",错误:"+data.msg);
				}
			}
		},
		/**
		 * 数据提交等待
		 */
		postWait:function(){
			function getMessageDiv(){
				var msgDiv= "<div class='loading-ctn'>"+
				"<div class='loading-img'><img src='http://www.pulledup.cn/js/loading.gif'></div>"+
			      "<span>数据提交中……</span></div><div class='loading-cover'></div>";
				return msgDiv;
//				var msgDiv="<div id='msgDiv' class='modal_container'><p>数据提交中……</p><img src='"+pop_up_box.prePop()+"images/load_wait.gif'/></div><div class='coverP'></div>";
//				return msgDiv+"<div id='zhezhao' style='position:fixed;z-index:9991;width:100%;height:100%;background-color:silver;opacity:.5;  filter:Alpha(Opacity=50); top:0px;'></div>";
			}
			$("input").attr("readonly","readonly");
			$("body").append(getMessageDiv());
			pop_up_box.loadtime=window.setTimeout("pop_up_box.loadWaitClose()",15000);
		},
		/**
		 * 数据获取等待
		 */
		loadWait:function(){
			function getMessageDiv(){
				var msgDiv= "<div class='loading-ctn'>"+
				"<div class='loading-img'><img src='http://www.pulledup.cn/js/loading.gif'></div>"+
			      "<span>数据获取中……</span></div><div class='loading-cover'></div>";
				return msgDiv;
//				var msgDiv="<div id='msgDiv' class='modal_container'><p>数据获取中……</p><img src='"+pop_up_box.prePop()+"images/load_wait.gif'/></div><div class='coverP'></div>";
//				return msgDiv+"<div id='zhezhao' style='position:fixed;z-index:9991;width:100%;height:100%;background-color:silver;opacity:.5;  filter:Alpha(Opacity=50); top:0px;'></div>";
			}
			$("input").attr("readonly","readonly");
			$("body").append(getMessageDiv());
			
			if($(document).width()<=500){
				$(".modal_container").css("left","10%");
			}
			pop_up_box.over=false;
			pop_up_box.loadtime=window.setTimeout("pop_up_box.loadWaitClose()",15000);
		},
		/**
		 * 数据处理提示
		 */
		dataHandlingWait:function(){
			function getMessageDiv(){
				var msgDiv= "<div class='loading-ctn'>"+
				"<div class='loading-img'><img src='http://www.pulledup.cn/js/loading.gif'></div>"+
			      "<span>数据处理中……</span></div><div class='loading-cover'></div>";
				return msgDiv;
//				var msgDiv="<div id='msgDiv' class='modal_container'><p>数据处理中……</p><img src='"+pop_up_box.prePop()+"images/load_wait.gif'/></div><div class='coverP'></div>";
//				return msgDiv+"<div id='zhezhao' style='position:fixed;z-index:9991;width:100%;height:100%;background-color:silver;opacity:.5;  filter:Alpha(Opacity=50); top:0px;'></div>";
			}
			$("input").attr("readonly","readonly");
			$("body").append(getMessageDiv());
		},
		/**
		 * toast显示并自动
		 * @param msg 显示内容
		 * @param delay 显示时间 毫秒
		 */
		toast:function(msg,delay){
			function getMessageDiv(){
				var msgDiv= "" +
					"<div class='loading_bg' style='position: fixed;left: 0;bottom: 0;width: 100%;height: 100%;display:-moz-box;display:-webkit-box;display:box;-moz-box-align:center;-webkit-box-align:center;-o-box-align:center;box-align:center;-moz-box-pack:justify;-webkit-box-pack:justify;-o-box-pack:justify;box-pack:justify;'>"+"<div class='loading-ctn' style=' position: static;width: auto !important;height: auto !important;padding: 10px;left: initial;margin: auto'>"+
			      "<span style='margin-top: 0 !important;'>"+msg+"</span></div>"+"</div>";
				return msgDiv;
			}
			$("input").attr("readonly","readonly");
			$("body").append(getMessageDiv());
			if(!delay||delay==0){
				delay=500;
			}
			setTimeout(function(){
				pop_up_box.loadWaitClose();
			}, delay);
		},
		/**
		 * 数据处理提示
		 */
		dataHandling:function(msg){
			function getMessageDiv(){
				var msgDiv= "<div class='loading-ctn'>"+
				"<div class='loading-img'><img src='http://www.pulledup.cn/js/loading.gif'></div>"+
			      "<span>"+msg+"</span></div><div class='loading-cover'></div>";
				return msgDiv;
//				var msgDiv="<div id='msgDiv' class='modal_container'><p>"+msg+"</p><img src='"+pop_up_box.prePop()+"images/load_wait.gif'/></div><div class='coverP'></div>";
//				return msgDiv+"<div id='zhezhao' style='position:fixed;z-index:9991;width:100%;height:100%;background-color:silver;opacity:.5;  filter:Alpha(Opacity=50); top:0px;'></div>";
			}
			$("input").attr("readonly","readonly");
			$("body").append(getMessageDiv());
		},
		/**
		 * 关闭数据处理提示
		 */
		loadWaitClose:function(){
			$("input").removeAttr("readonly");
//			$("input").removeAttr("disabled");
//			 $("#msgDiv,#zhezhao").remove();
			 $(".loading-ctn,.loading_bg,.loading-cover").remove();
			 $(".coverP").remove();
			 clearTimeout(pop_up_box.loadtime);
			 pop_up_box.over=true;
		},
		/**
		 * 上传文件进度条
		 */
		showLoadImg:function(){
			function getMessageDiv(){
				var msgDiv="<div id='progress'  style='margin-left: -168px;HEIGHT:110px;WIDTH:336px; border:solid 2px #CCCCCC; position:fixed;  left:50%;top:25%; background:#fff; z-index:99999999;'>"
					+"<div id='msg'>"
					+"<span>上传文件：</span>"
					+"<div class='progress'>"
					+"<div class='progress-bar progress-bar-success progress-bar-striped' role='progressbar' aria-valuenow='40' aria-valuemin='0' aria-valuemax='100' style='width: 1%'>"
					+"<span id='shuzi'>0%</span></div></div>"
					+"<div id='info' style='position:absolute; top:70px; left:10px; z-index:1; width: 335px;'>等待上传中...</div>"
					+"</div>"
					+"</div><div id='zhezhao' style='position:fixed;z-index:9991;width:100%;height:100%;background-color:silver;display:none;opacity:0.5;  filter:Alpha(Opacity=50); top:0px;'></div>";
				return msgDiv;
			}
			$("body").append(getMessageDiv());
			showProgress();
		},
		/**
		 * 显示图片
		 * @param imgurl 图片路径
		 */
		showImg:function(imgurl){
			function phoneImg(imgurl){
				return "<div id='imgDiv' style='position:fixed;z-index:9991;background-color:rgba(0,0,0,0.5);display:none; top:0;left:0;right:0;bottom: 0'><img class='center-block' style='margin-top: 100px;' id='imgshow' src='"+imgurl+"'></div></div>";
			}
			var msgDiv=phoneImg(imgurl)
			$("body").append(msgDiv);
			$("#imgshow").css("max-height",$(window).height()-200);
			$("#imgshow").css("max-width",$(window).width()-20);
			$("#imgDiv").show();
			pop_up_box.moveDialog("imgDiv","msg");
			$("#closeMsg,#imgshow,#imgDiv").bind("click",function(){
				$("#imgDiv").remove();
			});
		},
		/**
		 * 行业树
		 * @param choice 可选,默认为多选,true为单选
		 */
		showTradeDiv:function(choice){
			function getTradeDiv(){
				var tradeDiv="<div id='tradeDiv'  style='max-HEIGHT:487px;min-height:240px; height:auto !important;  height:240px; WIDTH:345px; border:solid 2px #ec6941; position:fixed; display:none; left:723px;top:148px; background:#fff; z-index:99999999;'>"
					+"<div class='tanchukuangN' style=' width:100%; min-height:100px; height:auto !important;'>"
					+"<ul>"
					+"<li id='title' style='cursor: move;float:left; width:100%; background:url(/pc/images/tckt.jpg) repeat-x ;'><span class='tanchukuangNts'>行业树</span><a class='anniuGb' id='closeMsg' style='float:right; margin-top:-5px;'></a></li>"
					+"<li><a class='tckButS' id='findBtn'></a><input class='tckStext' type='text' id='tradeName' placeholder='关键字'/></li>"
					+"<li>"
					+"  <div style='clear:both;'></div>"
					+"  <div class='tanchukuangNDx'>"
					+"  <ul id='tree' class='ztree' ></ul>"
					+"  </div>"
					+"</li>"
					+"</ul>"
					+"<div style='clear:both;'></div>"
					+"<div class='tanchukuangNDN' style='margin-bottom:10px;'><a id='selectBtn'>确定</a></div>"
					+"<div style='clear:both;'></div>"
					+"</div>"
					+"</div><div id='zhezhao' style='position:fixed;z-index:9991;width:100%;height:100%;background-color:silver;display:none;opacity:0.5;  filter:Alpha(Opacity=50); top:0px;'></div>";
				return tradeDiv;
			}
			function onloadZTreeT(choice){
				var ztreeNodes; 
			       $.post("/industryAction/list.do",function(data){
			           ztreeNodes =eval(data);
			           if (choice) {
			        	   $.fn.zTree.init($("#tree"), settingRadio, ztreeNodes);
						}else{
							$.fn.zTree.init($("#tree"), setting, ztreeNodes);
						}
			           
			        	   onAsyncSuccess();
			       });
			       //设置默认选中
			  	 function onAsyncSuccess(){
						var zTree = $.fn.zTree.getZTreeObj("tree");
					    if (ids) {
					 	   $.each(ids,function(i,n){
					 		   var node = zTree.getNodeByParam("id",n);
					 		   if (node) {
					 			   zTree.selectNode(node,true);
					 			   node.checked = true;
					 			   zTree.updateNode(node);
					 			   zTree.expandNode(node, true, false, false);//展开节点
					 		   }
					 	   });
						}
					}
			}
			function seacr(){
				var nodeList =[];
				var lastValue = "";
				function searchNode(e){
					var zTree = $.fn.zTree.getZTreeObj("tree");
					var value = $.trim(key.get(0).value);
					var keyType = "name";
					if (key.hasClass("empty")) {
						value = "";
					}
					if (lastValue === value) return;
					lastValue = value;
					if (value === "") return;
					updateNodes(false);
					///关键//获取匹配项
					nodeList = zTree.getNodesByParamFuzzy(keyType, value);
					updateNodes(true);
				}
				function updateNodes(highlight){
					var zTree = $.fn.zTree.getZTreeObj("tree");
					for( var i=0, l=nodeList.length; i<l; i++) {
						nodeList[i].highlight = highlight;
						zTree.selectNode(nodeList[i],true);
						zTree.updateNode(nodeList[i]);
						zTree.expandNode(nodeList[i], true, false, false);//展开节点
					}
					$("#tradeName").focus();
				}
				function focusKey(){
					if (key.hasClass("empty")) {
						key.removeClass("empty");
					}
				}
				function blurKey(){
					if (key.get(0).value === "") {
						key.addClass("empty");
					}
				}
				var key = $("#tradeName");
				key.bind("focus",pop_up_box.focusKey)
				.bind("blur", pop_up_box.blurKey)
				.bind("propertychange", searchNode)
				.bind("input", searchNode); 
				$("#findBtn").bind("click",function(){
					searchNode();
				});
			}
			 if ($("#txtId").length>0) {
					var txt=$("#txtId");
					ids[0]=txt.val().split(",")[0];
			}
			var msgDiv=getTradeDiv();
//			$("input:text").attr("disabled","disabled");
			$("body").append(msgDiv);
			$("#closeMsg").bind("click",function(){
//				$("input").removeAttr("disabled");
				$("#tradeDiv,#zhezhao").remove();
			});
			$("#selectBtn").bind("click",function(){
//				$("input").removeAttr("disabled");
				$("#tradeDiv,#zhezhao").remove();
			});
			pop_up_box.moveDialog("tradeDiv","title");
			onloadZTreeT(choice);
			seacr();
			 $("#tradeDiv,#zhezhao").show();	
		},
		moveDialog:function(tradeDiv,title){
			var posX;
			var posY;
			var fdiv = document.getElementById(tradeDiv);
			$("#"+title).mousedown(function(e){
				if(!e) e = window.event; //如果是IE
				posX = e.clientX - parseInt(fdiv.style.left);
				posY = e.clientY - parseInt(fdiv.style.top);
				document.onmousemove = mousemove;
			});
			document.onmouseup = function(){
				document.onmousemove = null;
			};
			function mousemove(ev){
				if(ev==null) ev = window.event;//如果是IE
				fdiv.style.left = (ev.clientX - posX) + "px";
				fdiv.style.top = (ev.clientY - posY) + "px";
			}
		},
		loadScrollPage:function(func){
			$(window).scroll(function(){
				if ((0 + $(window).scrollTop()) >= ($(document).height() - $(window).height())) {
					if(pop_up_box.over){
						if(func){
							func();
						}
					}
				}
			});
		}
};
//行业树多选参数设置
//var setting={
//	        data:{
//	           simpleData:{
//	                  enable: true, 
//	                   idKey:"inid", 
//	                   pIdKey:"pId",
//	                   rootPid:"0"
//	        }
//	        },
//	        async: {
//	               enable: true
//	               },
//	             check:{
//	             enable:true,
//	            chkStyle:"checkbox",
//	            chkboxType: { "Y": "s", "N": "s" }
//	             },
//	        view:{
//	               showIcon:false,
//	               dblClickExpand: true
//	             },
//	        callback: {
//	        	onClick: function(e, treeId, treeNode){
//	    			var zTree = $.fn.zTree.getZTreeObj("tree");
//	    			zTree.checkNode(treeNode, !treeNode.checked, null, true);
//	    			return false;
//	    		},
//				onCheck:function(e, treeId, treeNode){
//					var zTree = $.fn.zTree.getZTreeObj("tree");
//					var nodes = zTree.getCheckedNodes(true);
//					var v = "";
//					var s =" ";
//					var ids=["1"];
//					var idi=1;
//					var count = 0;
//					for (var i=0;i<nodes.length; i++) {
//							if(nodes[i].level!=0){
//								if(!nodes[i].getParentNode().checked){
//									v += nodes[i].name + ",";
//									s += nodes[i].id + ",";
//									ids[idi++]=nodes[i].id;
//									count++;
//								}
//							}else{
//								v += nodes[i].name + ",";
//								s += nodes[i].id + ",";
//								ids[idi++]=nodes[i].id;
//								  count++;
//							}
//					}
//						if (v.length > 0 ){
//							v = v.substring(0, v.length-1);
//							$("#industry").val(v);}
//						
//						if(s.length >0){
//							s=s.substring(0, s.length-1);
//							$("#txtId").val(s);
//						}
//				}
//	                 }     
//	      }; 
////行业树单选参数设置
//var settingRadio={
//        data:{
//           simpleData:{
//                  enable: true, 
//                   idKey:"inid", 
//                   pIdKey:"pId",
//                   rootPid:"0"
//        }
//        },
//        async: {  
//               enable: true
//               },
//             check:{
//             enable:true,
//            chkStyle: "radio",
//            radioType:"all"
//             },
//        view:{
//               showIcon:false,
//               dblClickExpand: true
//             },
//        callback: {  
//        	onClick:function(e, treeId, treeNode) {
//        		var zTree = $.fn.zTree.getZTreeObj("tree");
//        		zTree.checkNode(treeNode, !treeNode.checked, null, true); 
//        		return false;
//        	},
//			onCheck: function(e, treeId, treeNode) {
//				 var zTree = $.fn.zTree.getZTreeObj("tree"); 
//				 var nodes = zTree.getCheckedNodes(true);
//				 $("#txtId").val(treeNode.id);//
//			     $("#industry").val(treeNode.name);//存放选择的名称
//			     $("#inidTree").val(treeNode.inid);//存放选择名称的id
////			     $("#messageorgCode").html("");//清空提示信息
//			}
//                 }     
//      };
