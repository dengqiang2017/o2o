var treeSelectId="";
var treeSelectName="";
var treeSelId="";
var treeGetPrex="";
var o2o={
		init:function(){
			$('.tree li:has(ul)').addClass('parent_li').find(' > span').attr('title', '');
			  $('.tree li.parent_li > span').on('click', function (e) {
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
//			  $(".nav li").removeClass('active');
//			  $(".nav li").unbind('click');
//			  $(".nav li").bind("click",function(){
//			  	var n = $(".nav li").index(this);
//			  	$(".nav li").removeClass('active');
//			  	$(this).addClass('active');
//			  });
			  selectTr();
			  $("#page").val("1");
		},
		initTree:function(data,func){
			var ul="<ul>";
			for (var i = 0; i < data.length; i++) {
				var n=data[i];
				if (func) {
					ul+=func(n);
				}
			}
			$("#treeAll").parent().after(ul+"</ul>");
		},
		treeAll:function(type,func){
			$("#treeAll").click(function(){
				$.get(treeGetPrex+"getTree.do",{"type":type,"ver":Math.random()},function(data){
					$("tbody").html("");
					$.each(data,function(i,n){
						$("tbody").append(func(n));
					});
					selectTr();
					try {
						$("#page").val("1");
						$("#totalPage").val(data.totalPage);
						$("#totalPage").html(data.totalPage);
						$(".pull-left .form-control").val(data.totalRecord);
					} catch (e) {}
				});
			});
		},
		clickGetTable:function(url,treeId,func){ 
			$.get(url,{"ver":Math.random(),"type_id":treeId},function(data){
				$("tbody").html("");
				$.each(data.rows,function(i,n){
					if (func) {
						$("tbody").append(func(n));
					}
				});
				 selectTr();
					try {
						var backparams=$.cookie("backshowfind");
						if (!backparams) {
							$("#page").val("1");
						}
						$("#totalPage").val(data.totalPage);
						$("#totalPage").html(data.totalPage);
						$(".pull-left .form-control").val(data.totalRecord);
					} catch (e) {}
			});
		},
		nextTable:function(url,treeId,func){
				$.get(url,{"ver":Math.random(),"type_id":treeId},function(data){
					$("tbody").html("");
					$.each(data.rows,function(i,n){
						if (func) {
							$("tbody").append(func(n));
						}
					});
					 selectTr();
						try {
							$("#page").val("1");
							$("#totalPage").val(data.totalPage);
							$("#totalPage").html(data.totalPage);
							$(".pull-left .form-control").val(data.totalRecord);
						} catch (e) {}
			});
		},nextTree:function(t,type,treeli,getTr,getTable){
			var treeId=t.find("input").val();
 			if(t.next("ul").length>0){
				t.next("ul").remove();
			}else{
				pop_up_box.loadWait();
				$.get(treeGetPrex+"getTree.do",{"treeId":treeId,"type":type,"ver":Math.random()},function(data){
					var ulli="";
					if (data.length>0) {
						ulli="<ul>";
					}
					if (getTr) {
					$("tbody").html("");
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
							$("tbody").append(getTr(n));
						}
					}
					if (data.length>0) {
						ulli+="</ul>";
						t.after(ulli);
						$(".next_tree").unbind("click");
						$(".next_tree").bind("click",function(e){
							$(".tree li span").removeClass('activeT');
						  	$(this).addClass('activeT');
							var treeId=$(this).find("input").val();
							if (getTable) {
								$("tbody").html("");
								getTable(treeId);
								selectTr(); 
							}
							o2o.nextTree($(this), type, treeli,getTr, getTable);
						});
					}
					selectTr();
					treeSelect(t);
					try {
						$("#page").val("1");
						$("#totalPage").val(data.totalPage);
						$("#totalPage").html(data.totalPage);
						$(".pull-left .form-control").val(data.totalRecord);
					} catch (e) {}
					pop_up_box.loadWaitClose();
				});
			}
		},
		next_tree:function(type,treeli,getTr,getTable){
			$("#findtree").click(function(){
				findtree(type,treeli,getTr,getTable);
			});
			$(".client_tree").on("click",function(e){
				var treeId=$(this).find("input").val();
				var t=$(this);
				if (getTable) {
					$("tbody").html("");
					getTable(treeId);
					selectTr();
				}
				treeSelectId=treeId;
				treeSelectName=$(this).text();
				$("#clientfindshow>#corpName").html(treeSelectName);
				$("#clientfindshow>#customer_id").html(treeSelectId);
				if(t.next("ul").length>0){
					t.next("ul").remove();
				}else{
					pop_up_box.loadWait();
					$.get(treeGetPrex+"getTree.do",{
						"treeId":treeId,
//						"searchKey":$("#searchKey").val(),
						"type":type
						},function(data){
						var ulli="";
						if (data.length>0) {
							ulli="<ul>";
						}
						if (getTr) {
							$("tbody").html("");
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
								$("tbody").append(getTr(n));
							}
						}
						if (data.length>0) {
							ulli+="</ul>";
							t.after(ulli);
							$(".next_tree").unbind("click");
							$(".next_tree").bind("click",function(e){
								$(".tree li span").removeClass('activeT');
							  	$(this).addClass('activeT');
								var treeId=$(this).find("input").val();
								treeSelectId=treeId;
								treeSelectName=$(this).text();
								$("#clientfindshow>#corpName").html(treeSelectName);
								$("#clientfindshow>#customer_id").html(treeSelectId);
								$("tbody").html("");
								if (getTable) {
									getTable(treeId);
									selectTr();
								}
								o2o.nextTree($(this), type, treeli,getTr, getTable);
							});
						}
						selectTr();treeSelect(t);
						pop_up_box.loadWaitClose();
					});
				}
				
			});
		},
		editClient:function(url){
			$("#editClient").click(function(){
				var select_treeId=$("#select_treeId").val();
				if (select_treeId=="") {
					pop_up_box.showMsg("请选择一个记录!");
				}else{
//					window.open(url+select_treeId);
					try {
						$.cookie("backshowfind",JSON.stringify(getParamsBack()));
					} catch (e) {}
					$("#select_treeId").val("");
//					window.open(url+select_treeId);
					window.location.href=url+select_treeId;
				}
			});
			$("#addNextClient").click(function(){
				var select_treeId=$("#select_treeId").val();
				if (select_treeId=="") {
					pop_up_box.showMsg("请选择一个记录!");
				}else{
					try {
						$.cookie("backshowfind",JSON.stringify(getParamsBack()));
					} catch (e) {}
					$("#select_treeId").val("");
				window.location.href=url+select_treeId+"&next=add&item_name="+$("tbody>.activeTable").find("a").text();
				}
			});
		},
		delClient:function(type){
			$("#delClient").click(function(){
				var select_treeId=$("#select_treeId").val();
				if (select_treeId=="") {
					pop_uo_box.showMsg("没有选择一个记录!");
				}else{
					if (window.confirm("是否要删除该记录?")) {
						pop_up_box.postWait();
						$.post("delClient.do",{"treeId":select_treeId,"type":type},function(data){
							pop_up_box.loadWaitClose();
							$("#select_treeId").val("");
							if (data.success) {
								try {
									$.cookie("backshowfind",JSON.stringify(getParamsBack()));
								} catch (e) {}
								$("tbody>.activeTable").remove();
								$(".parent_li input[value='"+select_treeId+"']").parent().parent().remove();
//								window.location.reload();
							}else{
								pop_up_box.showMsg(data.msg);
							}
						});
					}
				}
			});
		},
		slectTreeVal:function(name,func){
			$("#selectClient").click(function(){
				if(treeSelectId==""){
					alert("请选择一个"+name);
				}else{
					if (func) {
						func();
					}
					$(".modal,.modal-cover").remove();
				}
			});
		},
		treeSelectInit:function(){
			$(".nav-tabs li").removeClass("active");
			$(".nav-tabs li:eq(0)").addClass("active");
			$(".tabs-content").hide();
			$(".tabs-content:eq(0)").show();
			$(".nav-tabs li").click(function() {
			  var n = $(".nav-tabs li").index(this);
			  $(".nav-tabs li").removeClass("active");
			  $(".nav-tabs li:eq("+n+")").addClass("active");
			  $(".tabs-content").hide();
			  $(".tabs-content:eq("+n+")").show();
			});
			$("#closeTree,.close").click(function(){
				$(".modal,.modal-cover").remove();
			});
		},
		loadTree:function(type,func,id){
			pop_up_box.loadWait();
			$.get(treeGetPrex+"getDeptTree.do",{"type":type,"id":id},function(data){
				$("body").append(data);
				pop_up_box.loadWaitClose();
				if (func) {
					func();
				}
			});
		}
}

$(function(){
  o2o.init();
});
function selectTr(){
	$("tbody tr").removeClass('activeTable');
	$("tbody tr").click(function(){
		$("tbody tr").removeClass('activeTable');
		$(this).addClass('activeTable');
		$("#select_customer_id").val($(this).find("input").val());
		$("#select_treeId").val($(this).find("input").val());
		if ($(".modal").length>0) {
			treeSelectId=$(this).find("input").val();
			treeSelectName=$(this).find("a").text();
		}
	});
	$(".checkbox input").click(function(){
		  if ($(this).prop("checked")) {
		    $(this).parent().addClass("checkedbox");
		  }else{
		    $(this).parent().removeClass("checkedbox");
		  }
		});
	treeClick();
}
function selectTree(){
	$("tbody tr").removeClass('activeTable');
	$("tbody tr").click(function(){
		$("tbody tr").removeClass('activeTable');
		$(this).addClass('activeTable');
		$("#select_customer_id").val($(this).find("input").val());
		$("#select_treeId").val($(this).find("input").val());
		treeSelectId=$(this).find("input").val();
		treeSelectName=$(this).find("a").text();
	});
	treeClick();
}
function treeClick(){
	  $(".tree li span").removeClass('activeT');
	  $(".tree li span").unbind("click");
	  $(".tree li span").click(function(){
	  	//var n = $(".tree li span").index(this);
	  	$(".tree li span").removeClass('activeT');
	  	$(this).addClass('activeT');
	  });
}
function treeSelect(t){
	 $(".tree li span").removeClass('activeT');
	  	var n = $(".tree li span").index(t);
	  	$(".tree li span").removeClass('activeT');
	  	$(".tree li span:eq("+n+")").addClass('activeT');
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
function findtree(type,treeli,getTr,getTable){
	pop_up_box.loadWait();
	$.get("getTree.do",{
		"type":type,
		"name":$("#recipient-name").val()
	},function(data){
		$("#treeAll").parents("ul").find("ul").remove();
		var ulli="<ul>";
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
			$("#treeAll").parent().after(ulli);
			$(".next_tree").unbind("click");
			$(".next_tree").bind("click",function(e){
				var treeId=$(this).find("input").val();
				if (getTable) {
					$(".modal").find("tbody").html("");
					getTable(treeId);
					selectTree(); 
				}
				o2o.nextTree($(this), type, treeli,getTr);
			});
		selectTree();
		treeSelect(t);
		pop_up_box.loadWaitClose();
	});
}