var treeSelectId="";
var treeSelectName="";
var o2otree={
		selectType:0,//0-单选,1-多选
		init:function(){
			$(".modal").find('.tree li:has(ul)').addClass('parent_li').find(' > span').attr('title', '');
			$(".modal").find('.tree li.parent_li > span').on('click', function (e) {
				var children = $(this).parent('li.parent_li').find(' > ul > li');
				if (children.is(":visible")) {
					children.hide();
					$(this).attr('title', 'Expand this branch').find(' > i').addClass('icon-plus-sign').removeClass('icon-minus-sign');
				} else {
					children.show();
					$(this).attr('title', 'Collapse this branch').find(' > i').addClass('icon-minus-sign').removeClass('icon-plus-sign');
				}
				e.stopPropagation();
			});
			$(".modal").find(".nav li").removeClass('active');
			$(".modal").find(".nav li").unbind('click');
			$(".modal").find(".nav li").bind("click",function(){
				var n = $(".modal").find(".nav li").index(this);
				$(".modal").find(".nav li").removeClass('active');
				$(this).addClass('active');
			});
			o2otree.selectTr();
			$(".modal").find("#page").val("0");
		},
		initTree:function(data,func){
			var ul="<ul>";
			for (var i = 0; i < data.length; i++) {
				var n=data[i];
				if (func) {
					ul+=func(n);
				}
			}
			$(".modal").find("#treeAll").parent().after(ul+"</ul>");
		},
		treeAll:function(type,func){
			$("#treeAll").click(function(){
				$.get("../tree/getTree.do",{"type":type,"employeeId":$("#employeeId").val(),"ver":Math.random()},function(data){
					$(".modal").find("tbody").html("");
					$.each(data,function(i,n){
						$(".modal").find("tbody").append(func(n));
					});
					o2otree.selectTr();
				});
			});
		},
		clickGetTable:function(url,treeId,func){
			$.get(url,{"ver":Math.random(),"type_id":treeId,"employeeId":$("#employeeId").val()},function(data){
				$(".modal").find("tbody").html("");
				$.each(data.rows,function(i,n){
					if (func) {
						$(".modal").find("tbody").append(func(n));
					}
				});
				o2otree.selectTr();
				try {
					$("#page").val("0");
					$("#totalPage").val(data.totalPage);
					$(".pull-left .form-control").val(data.totalRecord);
				} catch (e) {}
			});
		},
		nextTable:function(url,treeId,func){
			$.get(url,{"ver":Math.random(),"type_id":treeId,"employeeId":$("#employeeId").val()},function(data){
				$(".modal").find("tbody").html("");
				$.each(data.rows,function(i,n){
					if (func) {
						$(".modal").find("tbody").append(func(n));
					}
				});
				o2otree.selectTr();
			});
		}
		,nextTree:function(t,type,treeli,getTr,getTable,endFunc){
			var treeId=t.find("input").val();
			if(t.next("ul").length>0){
				t.next("ul").remove();
			}else{
				pop_up_box.loadWait();
				$.get("../tree/getTree.do",{"treeId":treeId,"employeeId":$("#employeeId").val(),"type":type,"ver":Math.random()},function(data){
					if (data.length>0) {
						var ulli="<ul>";
						if (getTr) {
							$(".modal").find("tbody").html("");
						}
						for (var i = 0; i < data.length; i++) {
							var n=data[i];
							var b=false;
							if(n.sort_id){
								b=$.trim(n.sort_id)==treeId;
							}else if(n.customer_id){
								b=$.trim(n.customer_id)==treeId;
							}else if(n.corp_id){
								b=$.trim(n.corp_id)==treeId;
							}
							if (!b) {
								ulli+=treeli(n);
							}
							if (getTr) {
								$(".modal").find("tbody").append(getTr(n));
							}
						}
						ulli+="</ul>";
						t.after(ulli);
						$(".modal").find(".next_tree").unbind("click");
						$(".modal").find(".next_tree").bind("click",function(e){
							var treeId=$(this).find("input").val();
							if (getTable) {
								$(".modal").find("tbody").html("");
								getTable(treeId);
								o2otree.selectTr(); 
							}
							o2otree.nextTree($(this), type, treeli,getTr, getTable,endFunc);
						});
						o2otree.selectTr();
						treeSelect(t);
						if (endFunc) {
							endFunc();
						}
					}
					pop_up_box.loadWaitClose();
				});
			}
		},
		next_tree:function(type,treeli,getTr,getTable,endFunc){
			$(".modal").find("#findtree").click(function(){
				findtree(type,treeli,getTr,getTable,endFunc);
			});
			$(".modal").find(".client_tree").bind("click",function(e){
				var treeId=$(this).find("input").val();
				if(o2otree.selectType==0){//单选
					$(".modal").find(".client_tree").removeClass("treeActive");
					$(".modal").find(".next_tree").removeClass("treeActive");
				}
				$(this).addClass("treeActive");
				var t=$(this);
				if (getTable) {
					$(".modal").find("tbody").html("");
					getTable(treeId);
					o2otree.selectTr();
				}
				treeSelectId=treeId;
				treeSelectName=$(this).text();
				if(t.next("ul").length>0){
					t.next("ul").remove();
				}else{
					if (getTr) {
						$(".modal").find("tbody").html("");
					}
					pop_up_box.loadWait();
					$.get("../tree/getTree.do",{
						"treeId":treeId,
						"weixintype":$("input[name='weixintype']:checked").val(),
						"employeeId":$("#employeeId").val(),
						"type":type
						},function(data){
						if (data.length>0) {
							var ulli="<ul>";
							for (var i = 0; i < data.length; i++) {
								var n=data[i];
								var b=false;
								if(n.sort_id){
									b=$.trim(n.sort_id)==treeId;
								}else if(n.customer_id){
									b=$.trim(n.customer_id)==treeId;
								}else if(n.corp_id){
									b=$.trim(n.corp_id)==treeId;
								}
								if (!b) {
									ulli+=treeli(n);
								}
								if (getTr) {
									$(".modal").find("tbody").append(getTr(n));
								}
							}
							ulli+="</ul>";
							t.after(ulli);
							$(".modal").find(".next_tree").unbind("click");
							$(".modal").find(".next_tree").bind("click",function(e){
								var treeId=$(this).find("input").val();
								if(o2otree.selectType==0){//单选
									$(".modal").find(".next_tree").removeClass("treeActive");
									$(".modal").find(".client_tree").removeClass("treeActive");
								}
								$(this).addClass("treeActive");
								treeSelectId=treeId;
								treeSelectName=$(this).text();
								if (getTable) {
									$(".modal").find("tbody").html("");
									getTable(treeId);
									o2otree.selectTr();
								}
								o2otree.nextTree($(this), type, treeli,getTr, getTable,endFunc);
							});
							o2otree.selectTr();
							treeSelect(t);
							if (endFunc) {
								endFunc();
							}
						}
						pop_up_box.loadWaitClose();
					});
				}
			});
		},
		slectTreeVal:function(name,func){
			$(".modal").find("#selectClient").bind("click");
			$(".modal").find("#selectClient").click(function(){
				if(treeSelectId==""){
					alert("请选择一个"+name);
				}else{
					if (func) {
						func();
					}
					$(".modal,.modal-cover").remove();
				}
			});
			$(".modal").find("tbody>tr").bind("dblclick");
			$(".modal").find("tbody>tr").dblclick(function(){
				if(treeSelectId==""&&o2otree.selectType==0){
					alert("请选择一个"+name);
				}else{
					if (func) {
						func();
					}
					$(".modal,.modal-cover").remove();
				}
			});
		},
		loadTree:function(type,fun){
			pop_up_box.loadWait();
			$.get("../tree/getDeptTree.do",{"type":type,"employeeId":$("#employeeId").val()},function(data){
				$("body").append(data);
				pop_up_box.loadWaitClose();
				if (func) {
					func();
				}
			});
		},
		treeSelectInit:function(){
			$(".modal").find(".nav-tabs li").removeClass("active");
			$(".modal").find(".nav-tabs li:eq(0)").addClass("active");
			$(".modal").find(".tabs-content").hide();
			$(".modal").find(".tabs-content:eq(0)").show();
			$(".modal").find(".nav-tabs li").click(function() {
			  var n = $(".modal").find(".nav-tabs li").index(this);
			  $(".modal").find(".nav-tabs li").removeClass("active");
			  $(".modal").find(".nav-tabs li:eq("+n+")").addClass("active");
			  $(".modal").find(".tabs-content").hide();
			  $(".modal").find(".tabs-content:eq("+n+")").show();
			});
			$(".modal").find("#closeTree,.close").click(function(){
				$(".modal,.modal-cover").remove();
				treeSelectId="";
			});
			$(".modal").find("tbody>tr").bind("click");
			$(".modal").find("tbody>tr").click(function(){
				var b=$(this).find("input[type='checkbox']").prop("checked");
				if(b){
					$(this).find("input[type='checkbox']").prop("checked",false);
				}else{
					$(this).find("input[type='checkbox']").prop("checked",true);
				}
			});
		},
		selectTr:function(){
			$(".modal").find("tbody tr").removeClass('activeTable');
			if(o2otree.selectType==0){//单选
				$(".modal").find("tbody tr").unbind("click");
				$(".modal").find("tbody tr").click(function(){
					$(".modal").find("tbody tr").removeClass('activeTable');
					$(this).addClass('activeTable');
					$("#select_customer_id").val($(this).find("input").val());
					$("#select_treeId").val($(this).find("input").val());
					if ($(".modal").length>0) {
						treeSelectId=$(this).find("input").val();
						treeSelectName=$(this).find("a").text();
						if (treeSelectName=="") {
							treeSelectName=$(this).find("td:eq(0)").text();
						}
					}
				});
			}else{//多选
				$(".modal").find("tbody tr").unbind("click");
				$(".modal").find("tbody tr").click(function(){
					var b=$(this).hasClass("activeTable");
					if(b){
						$(this).removeClass('activeTable');
					}else{
						$(this).addClass('activeTable');
					}
					$("#select_customer_id").val($(this).find("input").val());
					$("#select_treeId").val($(this).find("input").val());
					if ($(".modal").length>0) {
						treeSelectId=$(this).find("input").val();
						treeSelectName=$(this).find("a").text();
						if (treeSelectName=="") {
							treeSelectName=$(this).find("td:eq(0)").text();
						}
					}
				});
			}
			$(".modal").find("td:nth-child(1)").click(function(){
				if (!$(this).find("input:checkbox").prop("checked")) {
					$(this).find("input:checkbox").prop("checked",false);
				}else{
					$(this).find("input:checkbox").prop("checked",true);
				}
			});
			$(".modal").find(".checkbox input").click(function(){
				  if ($(this).prop("checked")) {
				    $(this).parent().addClass("checkedbox");
				  }else{
				    $(this).parent().removeClass("checkedbox");
				  }
				});
			treeClick();
		},
		 /**
		  * 浏览选择,支持单选或者多选,
		  * 支持列表选择或者表格选择,表格选择优先
		  * @param id 选择数据id在页面id名称
		  * @param name 选择数据中文名称在页面id名称
		  */
		selectInfo :function(id,name,func){
				var ids=$(".modal-body .treeActive");
				if(ids&&ids.length>0){
					for (var i = 0; i < ids.length; i++) {
						var idval=$.trim($(ids[i]).find("input").val());
						var nameval=$.trim($(ids[i]).text());
						if(idval!=""&&nameval!=""){
							if ($("#"+id).val().indexOf(idval)<0) {
								if ($("#"+id).val()=="") {
									$("#"+id).val(idval);
									$("#"+name).html(nameval);
								}else{
									$("#"+id).val($("#"+id).val()+","+idval);
									$("#"+name).html($("#"+name).html()+","+nameval);
								}
								if(func){
									func(idval,nameval);
								}
							}
						}
					}
				}else{
					ids=$(".modal-body .activeTable");
					if(ids&&ids.length>0){
						for (var i = 0; i < ids.length; i++) {
							var idval=$(ids[i]).find("input").val();
							var nameval=$(ids[i]).find("td:eq(0)").text();
							if(idval!=""&&nameval!=""){
								if ($("#"+id).val().indexOf(idval)<0) {
									if ($("#"+id).val()=="") {
										$("#"+id).val(idval);
										$("#"+name).html(nameval);
									}else{
										$("#"+id).val($("#"+id).val()+","+idval);
										$("#"+name).html($("#"+name).html()+","+nameval);
									}
								}
							}
						}
					}
				}
			}
}
$(function(){
  o2otree.init();
});
function select_Tree(){
	$(".modal").find("tbody tr").removeClass('activeTable');
	$(".modal").find("tbody tr").click(function(){
		if(o2otree.selectType==0){//单选
			$(".modal").find("tbody tr").removeClass('activeTable');
			$(this).addClass('activeTable');
		}else{
			var b=$(this).hasClass("activeTable");
			if(b){
				$(this).removeClass('activeTable');
			}else{
				$(this).addClass('activeTable');
			}
		}
		$("#select_customer_id").val($(this).find("input").val());
		$("#select_treeId").val($(this).find("input").val());
		treeSelectId=$(this).find("input").val();
		treeSelectName=$(this).find("a").text();
//		$(this).find("input[type='checkbox']").prop("checked",!$(this).find("input[type='checkbox']").prop("checked"));
	});
	$(".modal").find("td:nth-child(1)").click(function(){
		if (!$(this).find("input:checkbox").prop("checked")) {
			$(this).find("input:checkbox").prop("checked",false);
		}else{
			$(this).find("input:checkbox").prop("checked",true);
		}
	});
	treeClick();
}
function treeClick(){
//	  $(".modal").find(".tree li span").removeClass('activeT');
//	  $(".modal").find(".tree li span").click(function(){
//	  	var n = $(".tree li span").index(this);
//	  	$(".modal").find(".tree li span").removeClass('activeT');
//	  	$(".modal").find(".tree li span:eq("+n+")").addClass('activeT');
//	  });
}
function treeSelect(t){
	 $(".modal").find(".tree li span").removeClass('activeT');
	  	var n = $(".modal").find(".tree li span").index(t);
	  	$(".modal").find(".tree li span").removeClass('activeT');
	  	$(".modal").find(".tree li span:eq("+n+")").addClass('activeT');
	  	treeSelectId=$(t).find("input").val();
		treeSelectName=$(t).find("i").text();
		if (treeSelectName=="") {
			treeSelectName=$(t).text();
		}
}
function treeli(sort_name,treeId){
	if (sort_name&&treeId) {
	return "<li class='parent_li'><span class='next_tree'><i class='glyphicon glyphicon-leaf'>"+
	sort_name+"</i><input type='hidden' value='"+treeId+"'></span></li>";
	}else{
		return "";
	}
}
function treeliinit(sort_name,treeId){
	if (sort_name&&treeId) {
	return "<li class='parent_li'><span class='client_tree'><i class='glyphicon glyphicon-leaf'>"+
	sort_name+"</i><input type='hidden' value='"+treeId+"'></span></li>";
	}else{
		return "";
	}
}
function findtree(type,treeli,getTr,getTable,endFunc){
	pop_up_box.loadWait();
	$.get("../tree/getTree.do",{
		"type":type,
		"name":$("#recipient-name").val()
	},function(data){
		$(".modal").find("#treeAll").parents("ul").find("ul").remove();
		var	ulli="<ul>";
		if (getTr) {
			$(".modal").find("tbody").html("");
		}
		for (var i = 0; i < data.length; i++) {
			var n=data[i];
			ulli+=treeli(n);
			if (getTr) {
				$(".modal").find("tbody").append(getTr(n));
			}
		}
			ulli+="</ul>";
			$(".modal").find("#treeAll").parent().after(ulli);
			$(".modal").find(".next_tree").unbind("click");
			$(".modal").find(".next_tree").bind("click",function(e){
				var treeId=$(this).find("input").val();
				if (getTable) {
					$(".modal").find("tbody").html("");
					getTable(treeId);
					select_Tree(); 
				}
				o2otree.nextTree($(this), type, treeli,getTr);
			});
		select_Tree();
		treeSelect($(".modal").find("#treeAll").parent());
		if (endFunc) {
			endFunc();
		}
		pop_up_box.loadWaitClose();
	});
}

var selectTree={
		settlement:function(){
			$("#settlement").click(function(){
				pop_up_box.loadWait(); 
				 $.get("../tree/getDeptTree.do",{"type":"settlement"},function(data){
					   pop_up_box.loadWaitClose();
					 $("body").append(data);
					 settlement.init(function(){
						 $("#settlement_name").html(treeSelectName);
						 $("#settlement_id").val(treeSelectId);
				     });
			   });
			});
			selectTree.clearSelect();
		},
		clearSelect:function(){
			$(".btn-default").click(function(){
				$(this).parents(".input-group").find("span.input-sm").html("");
				$(this).parents(".input-group").find("input.input-sm").val("");
			});
		}
}
