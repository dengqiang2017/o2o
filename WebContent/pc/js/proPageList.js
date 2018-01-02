$(function() {
	///初始化表头
	var dropdown=$("#dropdown").html();
	function initth(name){
		$("th[data-name='"+name+"']").append(dropdown);
		$("th[data-name='"+name+"']").attr("width",100);
		$("th[data-name='"+name+"'] #dropdownMenu").attr("id",name);
		$("th[data-name='"+name+"'] .dropdown-menu").attr("aria-labelledby",name);
		$("th[data-name='"+name+"'] li").click(function(){
			$("th[data-name='"+name+"'] .glyphicon").removeClass("glyphicon-ok");
			$(this).find(".glyphicon").addClass("glyphicon-ok");
			$(".find").click();
		});
	}
	initth("cover_img");
	initth("main_img");
	initth("detail_cms");
	$(".form-inline input:text").val("");
	loadSelect();
	$("#findForm select").change(function(){
		$(".find").click();
	});
	/**
	 * 加载品牌,质量等级等内容到下拉框中
	 */
	function loadSelect(){
		getClassList("class_card","品牌");
		getClassList("item_struct","结构");
		getClassList("item_type","型号");
		getClassList("quality_class","质量等级");
		getClassList("item_color","颜色");
		getClassList("item_style","物料来源");
		/**
		 * @param index 位置
		 * @param name 查询字段名称
		 * @param type 字段对应中文
		 */
		function getClassList(name,type,typeid){
			$.get("/product/getOneProductFiledList.do",{
				"type":"add",
				"id":typeid,
				"name":name
			},function(data){
				$("#findForm #"+name).append("<option value=''>全部</option>");
				if (data.rows&&data.rows.length>0) {
					$.each(data.rows,function(i,n){
						if (n&&n.name) {
							$("#findForm #"+name).append("<option value='"+n.id+"'>"+n.name+"</option>");
						}
					});
				}
			});
		}
	}
$(".btn-opacity").click(function() {
	var page = parseInt($("#page").val());
	pop_up_box.loadWait();
	$.get("../product/prolist.do", {
		"page" : page + 1
	}, function(data) {
		pop_up_box.loadWaitClose();
		if (data.nowPage >= data.totalPage) {
			$(".btn-opacity").parent().hide();
		}
		var rows = data.rows;
		if (rows.length > 0) {
			$("#page").val(page + 1);
			$.each(rows, function(i, pro) {
				var product = $($(".product-ctn")[0]).clone()
						.prependTo("#proList");
				product.find("img").attr("src",
						"../phone/img/" + pro.item_id + ".png");
				product.find("li:eq(0) > .tips-content").html(
						pro.item_name);
				product.find("li:eq(1) > .tips-content").html(
						pro.item_type);
				product.find("li:eq(2) > .tips-content").html(
						pro.item_spec);
				product.find("li:eq(3) > .tips-content").html(
						pro.item_color);
				product.find("li:eq(4) > .tips-content").html(
						pro.class_card);
			});
		}
	});
});
	var count=0;
	function loadData(type_id){
		$("#page").val(editUtils.page+1);
		if(!type_id){
			type_id=$(".tree .activeT").find("input").val();
		}
		pop_up_box.loadWait();
		$.get("getProductList.do",{
			"searchKey":$.trim($("#searchKey").val()),
			"quality_class":$.trim($("#quality_class").val()) ,
			"item_style":$.trim($("#item_style").val()) ,
			"class_card":$.trim($("#class_card").val()),
			"item_spec":$.trim($("#item_spec").val()),
			"item_struct":$.trim($("#item_struct").val()),
			"item_type":$.trim($("#item_type").val()),
			"item_color":$.trim($("#item_color").val()),
			"page":editUtils.page,
			"cover_img":$("th[data-name='cover_img'] .glyphicon-ok").attr("data-val"),
			"main_img":$("th[data-name='main_img'] .glyphicon-ok").attr("data-val"),
			"detail_cms":$("th[data-name='detail_cms'] .glyphicon-ok").attr("data-val"),
			"count":count,
			"type_id":type_id
		},function(data){
			pop_up_box.loadWaitClose();
			$("#listpage tbody").html("");
			$.each(data.rows,function(i,n){
				var len=$("#listpage th").length;
				var tr=getTr(len);
				$("#listpage tbody").append(tr);
				for (var i = 0; i < len; i++) {
					var th=$($("#listpage th")[i]);
					var name=$.trim(th.attr("data-name"));
					var show=th.css("display");
					var j=$("#listpage th").index(th);
					if(show=="none"){
						tr.find("td:eq("+j+")").hide();
					}else{
						if(j>=0){
							if(name=="detail_cms"){
								var a=$("<a>编辑</a>");
								tr.find("td:eq("+j+")").html("<span>"+n.detail_cms
										+"</span>&ensp;");
								tr.find("td:eq("+j+")").append(a);
								a.click({
									"com_id":$.trim(n.com_id),
									"item_id":$.trim(n.item_id),
									"item_name":$.trim(n.item_name)
								},function(event){
									var t=$(this).prev();
									var detail_cms=t.html();
									edithtml.init(event.data.com_id,event.data.item_id,event.data.item_name,detail_cms,t,false);
									$("#listpage").hide();
									$("#editpage").hide();
								});
							}else if(name=="item_sim_name"){
								tr.find("td:eq("+j+")").html("<input type='hidden' value='"+ifnull(n.item_id)+"'>"+n[name]);
							}else if(name=="m_flag"){
								var m_flag="否";
								if (ifnull(n.m_flag)=="1") {
									m_flag="是";
								}							
								tr.find("td:eq("+j+")").html(m_flag);
							}else if(name=="item_zeroSell"){
								tr.find("td:eq("+j+")").html(numformat(n.item_zeroSell, 0));
							}else if(name=="if_O2O"){
								var o2o="线下ERP用户";
								if (ifnull(n.if_O2O)=="2") {
									o2o="线上后台管理用户";
								}
								tr.find("td:eq("+j+")").html(o2o);
							}else{
								tr.find("td:eq("+j+")").html(n[name]);
							}
						}
					}
				}
				tr.find("td:eq(0)").html(getbtn());
			});
			editUtils.totalPage=data.totalPage;
			$("#totalPage").html(data.totalPage+1);
			$("#totalRecord").html(data.totalRecord);
			count=data.totalRecord;
			selectTr();
		});
	}
	///////////////////响应树形相关/////////////
	$("#treeAll").click(function(){
		editUtils.page=0;
		count=0;
		loadData();
	});
	try {
		o2o.next_tree("productClass",function(n){
			return treeli(n.sort_name,n.sort_id);
		},undefined,function(treeId){
			editUtils.page=0;
			count=0;
			loadData(treeId);
 		});
		o2o.editClient("../manager/product.do?item_id=");
		o2o.delClient("product"); 
	} catch (e) {}
	$(".find").click(function(){
		editUtils.page=0;
		count=0;
		loadData();
	});
	////////////////////////////////
	editUtils.paging(function(){
		loadData();
	});
	/////////////////
	$("#addpro").click(function(){
		$.cookie("backshowfind",JSON.stringify(getParamsBack()));
//		window.location.href="product.do";
		loadPage('product.do');
	});
	loadData(); 
}); 
function loadPage(url){
	$.get(url,function(data){
		$("#editpage").html(data);
		$("#listpage").hide();
		productEdit.init();
	});
}
function getParamsBack(){
	var backshowfind={
			page:$("#page").val(),
			item_name:$("#item_name").val(),
			item_type:$("#item_type").val(),
			easy_id:$("#easy_id").val(),
			type_name:$("#type_name").val(),
			treeId:treeSelectId
	}
	return backshowfind;
}
function editProduct(t){
	var tr=$(t).parents("tr");
	var item_id=tr.find("input").val();
	editUtils.loadPage("product.do?item_id="+item_id,function(){
		productEdit.init();
	});
}
function delProduct(t){
	var tr=$(t).parents("tr");
	if (window.confirm("是否要删除该记录?")) {
		var item_id=tr.find("input").val();
		pop_up_box.postWait();
		$.post("delClient.do",{"treeId":item_id,"type":"product"},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				tr.remove();
			}else{
				pop_up_box.showMsg(data.msg);
			}
		});
	}
}
function getbtn(){
	var btn="";
	if($("#edit_hi").val()=="true"){
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='editProduct(this);'>修改</button>";
	}
	if($("#del_hi").val()=="true"){
		btn+="<button type='button' class='btn btn-danger btn-xs' style='margin-right:2px;' onclick='delProduct(this);'>删除</button>";
	}
	return btn;
}