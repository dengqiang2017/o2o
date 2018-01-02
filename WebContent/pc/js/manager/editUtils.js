var editUtils={
		page:0,
		totalPage:0,
		count:0,
		/**
		 * 初始化
		 * @param url 获取修改数据接口
		 * @param idname 内编码名称
		 * @param id 内编码值
		 */
		editinit:function(url,id,func){
			math=Math.random();
			$("#math").val(math);//上传图片时使用到的随机数
			if(id!=""){
				pop_up_box.loadWait();
				$.get("../manager/"+url+".do",{"id":id},function(data){
					var inps=$("#editpage").find(".form input");
					for (var i = 0; i < inps.length; i++) {
						var item=$(inps[i]);
						var name=item.attr("name");
						var val=$.trim(data[name]+"");
						if(val&&val.indexOf("-22")==0){
						}else{
							if(val&&val.indexOf("1")==0&&val.length==13){
								var now = new Date(data[name]);
								item.val(now.Format("yyyy-MM-dd"));
							}else{
								if(data[name]){
									item.val(data[name]);
								}
							}
						}
					}
					var inps=$("#editpage").find(".form textarea");
					for (var i = 0; i < inps.length; i++) {
						var item=$(inps[i]);
						var name=item.attr("name");
						var val=$.trim(data[name]+"");
						if(data[name]){
							item.val(val);
						}
					}
					var span=$("#editpage").find(".input-sm");
					for (var i = 0; i < span.length; i++) {
						var item=$(span[i]);
						var name=item.attr("id");
						var val=$.trim(data[name]+"");
						if(data[name]){
							$("#editpage").find("#"+name).html(val);
						}
					}
					var select=$("#editpage").find(".form select");
					for (var i = 0; i < select.length; i++) {
						var item=$(select[i]);
						var name=item.attr("name");
						var val=$.trim(data[name]+"");
						if(data[name]){
							item.val(val);
						}
					}
					if(func){
						func(data);
					}
					pop_up_box.loadWaitClose();
				});
			}else{
				if(func){
					func();
				}
			}
			$("#editpage").find("input[name='weixinID']").attr("placeholder","与登录账号相同并自动生成");
//			$("#editpage").find("input[name='weixinID']").attr("readonly","readonly");
			$("#editpage").find(".input-group-btn").find(".btn-default").unbind("click");
		    $("#editpage").find(".input-group-btn").find(".btn-default").click(function(){
		    	$(this).parent().prev().html("");
		    	$(this).parent().prev().prev().html("");
		    });
			$("#editpage").find(".tolistpage").unbind("click");
			$("#editpage").find(".tolistpage").click(function(){
				editUtils.closePage();
			});
		},
		loadPage:function(url,func){
			pop_up_box.loadWait();
			$.get(url,function(data){
				pop_up_box.loadWaitClose();
				$("#editpage").html(data);
				$("#listpage").hide();
				func();
			});
		},
		/**
		 * 关闭修改页面
		 */
		closePage:function(){
			$("#editpage").html("");
			$("#listpage").show();
			$("html,body").animate({
				scrollTop : 0
			}, 200);
		},
		/**
		 * 同步表格
		 * @param id 内编码
		 * @param type 0=增加,1-修改
		 * @param btn 修改删除按钮html
		 * @param func 回调函数tr,j,name
		 */
		tableShowSyn:function(type,btn,func){
			var len=$("#listpage").find("thead:eq(0)").find("th").length;
			var caozuo=0;
			function synVal(tr){
				for (var i = 0; i < len; i++) {
					  var th=$($("#listpage th")[i]);          
					  var name=$.trim(th.attr("data-name"));
					  var j=$("#listpage th").index(th);
					  if(name!="操作"&&name!="caozuo"){
						  var val=$("#editForm *[name='"+name+"']").val(); 
						  tr.find("td:eq("+j+")").html(val);
						  if(name=="working_status"){
								var val=$("#editForm select[name='working_status']").val(); 
								if($.trim(val)=="1"){
									tr.find("td:eq("+j+")").html("使用");
								}else if($.trim(val)=="0"){
									tr.find("td:eq("+j+")").html("停用");
								}
								func(tr,j,name);
							}else{
								func(tr,j,name);
							}
					  }else{
						  caozuo=j;
					  }
				  }
			}
			  if(type==1){//有id表示修改
				  var tr=$("#listpage").find(".activeTable");  
				  synVal(tr);
			  }else{//没有增加
					var tr=$(getTr(len));
					$("#listpage tbody").append(tr);
					synVal(tr);
					tr.find("td:eq("+caozuo+")").html(btn);
			  }
			  editUtils.closePage();
		},
		checkPhone:function(type){
			var user_id= $("#editpage input[name='user_id']");
			  user_id.change(function(){
			  	if ($.trim(user_id.val())!="") {
					pop_up_box.loadWait();   
					$.get("../manager/checkPhone.do",{"phone":user_id.val(),"type":type},function(data){
						pop_up_box.loadWaitClose();
						if (!data.success) {
//							pop_up_box.showMsg("手机号已经存在!",function(){
//								user_id.val("");
//							});
							$("#editpage input[name='tel_no']").val(user_id.val());
							$("#editpage input[name='movtel']").val(user_id.val());
						}else{
							if($.trim($("#editpage input[name='tel_no']").val())==""){
								$("#editpage input[name='tel_no']").val(user_id.val());
							}
							if($.trim($("#editpage input[name='movtel']").val())==""){
								$("#editpage input[name='movtel']").val(user_id.val());
							}
							if($.trim($("#editpage input[name='weixinID']").val())==""){
								$("#editpage input[name='weixinID']").val(user_id.val());
							}
						}
						$("#editpage").find("input[name='weixinID']").attr("readonly","readonly");
					});
				}
			});
		},getbtn:function(url,type,func){
			   var btn="";
			   var edit="";
			   var del="";
				if($("#edit_hi").val()=="true"){
					edit="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;'>修改</button>";
				}
				if($("#del_hi").val()=="true"){
					del="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;'>删除</button>";
				}
				if(edit!=""){
					btn+=edit;
					$(edit).click(function(){
						editUtils.editPage(this,url,func);
					});
				}
				if(del!=""){
					btn+=del;
					$(del).click(function(){
						editUtils.delTr(this,type);
					});
				}
			   return btn;
		},editPage:function(t,url,func){
			var id=$(t).parents("tr").find("input").val();
			editUtils.loadPage(url+id,func);
		},delTr:function(t,type){
			var tr=$(t).parents("tr");
			if (window.confirm("是否要删除该记录?")) {
				var id=tr.find("input").val();
				pop_up_box.postWait();
				$.post("delClient.do",{"treeId":id,"type":type},function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						tr.remove();
					}else{
						pop_up_box.showMsg(data.msg);
					}
				});
			}
		},paging:function(loadData){
			$("html,body").animate({
				scrollTop : 0
			}, 200);
			$("#totalRecord").removeClass("form-control");
			$("#page").change(function(){
				var p=parseInt($(this).val());
				if(p>0){
					editUtils.page=parseInt($(this).val())-1;
				}else{
					editUtils.page=0;
				}
				loadData();
			});
			//1.首页
			$("#beginpage").click(function(){
				editUtils.page=0;
				loadData();
			});
			//2.尾页
			$("#endpage").click(function(){
				editUtils.page=editUtils.totalPage;
				loadData();
			});
			$("#uppage").click(function(){
				editUtils.page=parseInt(editUtils.page)-1;
				if (editUtils.page>=0) {
					loadData();
				}else{
					pop_up_box.showMsg("已到第一页!");
				}
			});
			$("#nextpage").click(function(){
				  editUtils.page=parseInt(editUtils.page)+1;
				if (editUtils.page<=editUtils.totalPage) {
					loadData();
				}else{
					pop_up_box.showMsg("已到最后一页!");
				}
			});
			$("#page").change(function(){
				var pe=$.trim($(this).val());
				if(pe!=""){
					pe=parseInt(pe);
					if(pe){
						editUtils.page=pe-1;
						loadData();
					}
				}
			});
		},
		updateWeixinState:function(type){
			pop_up_box.loadWait();
			$.get("../weixin/updateWeixinState.do",{
				"type":type
			},function(data){
				pop_up_box.loadWaitClose();
				if (data.success) {
					pop_up_box.toast("更新成功!更新数量:"+data.msg,1500);
				}
			});
		}
}