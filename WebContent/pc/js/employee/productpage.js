var tabsIndex = 0;
var page = 0;
var totalPage = 0;
var count = 0;

var paged = 0;
var totalPaged = 0;
var counted = 0;
var productpage={
		/**
		 * 设置总页数等
		 * @param data
		 */
		setPageParam:function(data) {
				if (tabsIndex == 0) {
					page = data.page - 1;
					totalPage = data.totalPage;
					count = data.totalRecord;
				} else {
					paged = data.page - 1;
					totalPaged = data.totalPage;
					counted = data.totalRecord;
				}
				productpage.setPageShow(data);
			},
			/**
			 * 设置是否显示加载更多
			 * 
			 * @param data
			 */
			setPageShow:function(data){
				var pageing=0;
				if (tabsIndex==0) {
					pageing=page;
				}else{
					pageing=paged;
				}
//				if (data.totalPage <= data.page&&((pageing+1)*data.pageRecord)>=data.totalRecord) {
//					$(".btn-add:eq(" + tabsIndex + ")").parent().hide();
//				} else {
//					$(".btn-add:eq(" + tabsIndex + ")").parent().show();
//				}
			},
			/**
			 * 注册点击链接产品明细事件
			 * 
			 * @param b
			 *            是否对输入框进行数字化控制 默认调用
			 * @param func(t) 回调函数传入t对象
			 * @returns
			 */
			detailClick:function(b,func,num) {
				//默认调用
				if (b) {
					common.initNumInput();
				}
				if(num!=0){
					productpage.numToZsum();
				}
				$(".pro-check").unbind("click");
				$(".pro-check").click(function(){//注册图片选择框 选择或者取消功能
					var b=$(this).hasClass("pro-checked");
					if (b) {
						$(this).removeClass("pro-checked");
					}else{
						$(this).addClass("pro-checked");
						if (func) {
							func($(this));
						}
					}
					try {
						selectJe();
					} catch (e) {
					}
				});
				$(".add").unbind("click");
				$(".add").click(function(){
					var num=parseFloat($(this).parent().find(".num").val());
					if (!num) {
						num=0;
					}
					$(this).parent().find(".num").val(num+1);
					$(this).parent().find(".num").blur();
				});
				$(".sub").unbind("click");
				$(".sub").click(function(){
					var num=parseFloat($(this).parent().find(".num").val());
					if (!num) {
						$(this).parent().find(".num").val(0);
					}else{
						$(this).parent().find(".num").val(num-1);
					}
					$(this).parent().find(".num").blur();
				});
			},
			moreMemo:function(n,item){
				function moreMemoInit(t_parent){
					$(".moreMemo").find("input[name='c_memo']").val(t_parent.find("#c_memo").html());
					$(".moreMemo").find("input[name='memo_color']").val(t_parent.find("#memo_color").html());
					$(".moreMemo").find("input[name='memo_other']").val(t_parent.find("#memo_other").html());
					$("#moreMemosave").unbind("click");
					$("#moreMemosave").click(function(){
						t_parent.find("#c_memo").html($(".moreMemo").find("input[name='c_memo']").val());
						t_parent.find("#memo_color").html($(".moreMemo").find("input[name='memo_color']").val());
						t_parent.find("#memo_other").html($(".moreMemo").find("input[name='memo_other']").val());
						$(".moreMemo").hide();
					});
				}
				item.find("#c_memo").html(n.c_memo);
				item.find("#memo_color").html(n.memo_color);
				item.find("#memo_other").html(n.memo_other);
				item.find("#moreMemo").click(function(){
					var t_parent=$(this).parent();
					if ($(".moreMemo").length>0) {
						$(".moreMemo").show();
						moreMemoInit(t_parent);
					}else{
						pop_up_box.loadWait();
						$.get("../product/moreMemo.do",function(data){
							pop_up_box.loadWaitClose();
							$("body").append(data);
							$(".close,.btn-default").click(function(){
								$(".moreMemo").hide();
							});
							$("#moreMemoClear").click(function(){
								$(".moreMemo").find("input").val("");
							});
							moreMemoInit(t_parent);
						});
					}
				});
			},
			/**
			 * 限制只能输入数字
			 */
			numval:function(t){
				var reg = new RegExp("^[-?0-9.]*$");
				if (!reg.test(t.val().trim())) {
					t.val(t.val().substring(0, t.val().length - 1));
				}
			},
			numToZsum:function(){
				$(".num").bind("input propertychange blur",function(){
					productpage.numval($(this));
					var val=$.trim($(this).val());
					var item=$(this).parents(".dataitem");
					var pack_unit=item.find("#pack_unit").html();
					if (!pack_unit) {
						pack_unit="1";
					}
					var sd_oq=parseFloat(item.find("#sd_oq").html());
					if (val!=""&&val!="0"&&pack_unit!="0") {
						item.find(".zsum").val(numformat(parseFloat(val)/parseFloat(pack_unit),0));
					}else{
						item.find(".zsum").val(val);
					}
					var zsval=parseFloat(item.find(".zsum").val());
					if (sd_oq<parseFloat(zsval)) {
						item.find(".msg").html("超出总数量!");
					}else{
						item.find(".msg").html("");
					}
					///////////////
					var sd_unit_price=parseFloat(item.find("#sd_unit_price").val());
					var sum_si=item.find("#sum_si");
					var sumval=numformat2(val*sd_unit_price);
					sum_si.html(sumval);
					if(sumval>0){
						item.find("#check").prop("checked",true);
					}else{
						item.find("#check").prop("checked",false);
					}
					try {
						jisunje(item);
					} catch (e) {}
//					item.find(".zsum").attr("readonly","readonly");
				});
				$(".zsum").bind("input propertychange blur",function(){
					productpage.numval($(this));
					var val=$.trim($(this).val());
					var item=$(this).parents(".dataitem");
					var pack_unit=item.find("#pack_unit").html();
					if (!pack_unit) {
						pack_unit="1";
					}
					var sd_oq=parseFloat(item.find("#sd_oq").html());
					if (sd_oq<parseFloat(val)) {
						item.find(".msg").html("超出总数量!");
					}else{
						item.find(".msg").html("");
					}
					var num=numformat(parseFloat(val)*parseFloat(pack_unit),2);
					if (val!=""&&pack_unit!="0") {
						item.find(".num").val(num);
					}else{
						item.find(".num").val("0");
					}
					var sd_unit_price=parseFloat(item.find("#sd_unit_price").val());
					var sum_si=item.find("#sum_si");
					var sumval=numformat2(parseFloat(num)*sd_unit_price);
					sum_si.html(sumval);
					if(sumval>0){
						item.find("proinfo #check").prop("checked",true);
					}else{
						item.find(".proinfo #check").prop("checked",false);
					}
				});
			},
			allcheck:function(tabs){
				$("#allcheck").unbind("click");
				$("#allcheck").click(function() {
					if ($.trim(tabs.find("#item01").html())!="") {
						if ($(this).html()=="全选") {
							tabs.find(".pro-check").addClass("pro-checked");
							$(this).html("取消");
						}else{
							tabs.find(".pro-check").removeClass("pro-checked");
							$(this).html("全选");
						} 
					}
				});
			},
			itemInit:function(n,item){
				 var pack_unit=$.trim(n.pack_unit);
					if (pack_unit!=""&&pack_unit!="0") {
						item.find(".num").removeAttr("disabled");
					}else{
//						item.find(".num").attr("disabled","disabled");
					}
					var val=$.trim(item.find(".zsum").val());
					if (val!=""&&pack_unit&&pack_unit!="0") {
						item.find(".dataitem").find(".num").val(changeTwoDecimal(parseFloat(val)/parseFloat(pack_unit)));
					}else{
						item.find(".dataitem").find(".num").val(val);
					}
					productpage.moreMemo(n,item);
					return val;
			},
			itemDateInit:function(timename,item,idnme){
				if (timename&&$.trim(timename) != "") {
					var now = new Date(timename);
					var nowStr = now.Format("yyyy-MM-dd");
					item.find("#"+idnme).html(nowStr);
				}
			},
			/**
			 * 初始化查询按钮和全选按钮
			 */
			initBtnClick:function(func){
				$("#allcheck").prop("checked",false);
				$("#allcheck").click(function() {
					var lia = $(".nav li").index($(".nav .active"));
					var tabs= $(".tabs-content:eq("+lia+")");
					var b=$(this).prop("checked");
					tabs.find("#list #check").prop("checked",b);
				});
				$(".find").unbind("click");
				$(".find").click(function() {
					var lia = $(".nav li").index($(".nav .active"));
					$(".tabs-content").eq(lia).find("#list").html("");
					if(func){
						func(lia);
					}
				});
//				$("form select").change(function(){
//					var lia = $(".nav li").index($(".nav .active"));
//					$(".find").eq(lia).click();
//				});
				loadSelect();
				$("#findForm #item_spec").change(function(){
					var lia = $(".nav li").index($(".nav .active"));
					$(".find").eq(lia).click();
				});
			},clearSelect:function(){
				$(".clearSelect").click(function(){
					$(this).parent().find(".input-sm").html("");
					$(this).parent().find("input").html("");
				});
			},initNumIpt:function(item){
				function jisuanje(t){
					var item=$(t).parents(".dataitem");
					var sd_unit_price=parseFloat(item.find("#sd_unit_price").val());
					var discount_rate=parseFloat(item.find("#discount_rate").val());
					var num=parseFloat(item.find("#pronum").val());
					if(!discount_rate){
						discount_rate=100;
					}
					var sumsi=numformat2(sd_unit_price*num*discount_rate/100);
					if(discount_rate<=0){
						item.find("#sum_si").html((numformat2(num*sd_unit_price)));
					}else{
						item.find("#sum_si").html(sumsi);
					}
					if (num&&num>0) {
						item.find("#check").prop("checked",true);
					}else{
						item.find("#check").prop("checked",false);
					}
				}
				item.find(".zsum").bind("input propertychange blur",function(){
					var item=$(this).parents(".dataitem");
					var zsum=parseFloat($.trim($(this).val()));
					var pack_unit=item.find("#pack_unit").html();
					var num=zsum;
					if(pack_unit>1){
						num=zsum/pack_unit;
					}
					if (!num) {
						num=0;
					}
					item.find("#pronum").val(num);
					jisuanje(this);
				});
				item.find("#pronum").bind("input propertychange blur",function(){
					var item=$(this).parents(".dataitem");
					var num=$.trim($(this).val());
					var pack_unit=item.find("#pack_unit").html();
					var zsum=num;
					if(pack_unit>1){
						item.find(".zsum").val(num*n.pack_unit);
					}
					item.find(".zsum").val(zsum);
					jisuanje(this);
				});
				item.find("#sd_unit_price").bind("input propertychange blur", function(){
					jisuanje(this);
				});
				item.find("#discount_rate").bind("input propertychange blur", function(){
					jisuanje(this);
				});
			},navLiClick:function(func){
				$(".nav li").unbind("click");
				$(".nav li").click(function(){
					var lia = $(".nav li").index(this);
					$(".nav li").removeClass('active');
					$(this).addClass('active'); 
					$(".tabs-content").hide(); 
					var tabs= $(".tabs-content:eq("+lia+")");
					var item=$.trim(tabs.find("#list").html());
					tabs.show();
					$("#allcheck").prop("checked",false);
					if (item=="") {
						$(".find:eq("+lia+")").click();
					}
					$(".form").parent().hide();
					$(".form").eq(lia).parent().show();
					func(item,lia);
				});
			},btnAddClick:function(func){
				$(".btn-add").unbind("click");
				$(".btn-add").click(function(){
					var lia = $(".nav li").index($(".nav .active"));
					var page=0;
					var count=0;
					var totalPage=0;
					func(page,count,totalPage);
				});
			}
}
/**
 * 销售开单,采购入库等页面中颜色选择显示
 * @param item 块对象
 * @param item_color 字符串值
 * @param id 元素id值
 */
function colorShowSelect(item,item_color,id,selectColor,type){
	if(!id){
		id="item_color";
	}
	if(!selectColor){
		selectColor="colorActive";
	}
	if(!type){
		type="one";
	}
	item.find("#"+id).html("");
	if(item_color){
		var cs=item_color.split(";");
		if(cs&&cs.length>0){
			for (var j = 0; j < cs.length; j++) {
				item.find("#"+id).append("<label>"+cs[j]+"</label>");
			}
			if(cs.length==1){
				item.find("#"+id+" label").addClass(selectColor);
			}else{
				item.find("#"+id+" label").click(function(){
					if($(this).hasClass(selectColor)){
						$(this).removeClass(selectColor);
					}else{
						if(type=="one"){
							$(this).parent().find("label").removeClass(selectColor);
						}
						$(this).addClass(selectColor);
					}
				});
			}
		}
	}
}
/**
 * 收起展开产品基础信息
 * @param t
 */
function upDownProInfo(t){
	var b=$(t).hasClass("glyphicon-chevron-up");
	var p=$(t).parents(".infodiv");
	if(b){
		$(t).removeClass("glyphicon-chevron-up");
		$(t).addClass("glyphicon-chevron-down");
		p.find("ul>li").show();
	}else{
		$(t).removeClass("glyphicon-chevron-down");
		$(t).addClass("glyphicon-chevron-up");
		p.find("ul>li").hide();
		p.find("ul>li:eq(0)").show();
	}
}
/**
 * 加载产品基础信息到页面上
 */
function loadProInfo(item,n){
	item.find("#item_id").html($.trim(n.item_id));
	item.find("#item_name").html(n.item_name);
	item.find("#item_name").attr("title",n.item_name);
	item.find("#item_unit").html(n.item_unit);
	item.find(".item_unit").html(n.item_unit);
	if(!n.pack_unit){
		item.find("#pack_unit").html(1);
	}else{
		item.find("#pack_unit").html(n.pack_unit);
	}
	item.find("#casing_unit").html(n.casing_unit);
	item.find(".casing_unit").html(n.casing_unit);
	item.find("#item_type").html(n.item_type);
	item.find("#item_color").html(n.item_color);
	item.find("#class_card").html(n.class_card);
	item.find("#quality_class").html(n.quality_class);
	if(n.qz_days){
		item.find("#qz_days").html(n.qz_days);
	}else{
		item.find("#qz_days").html(3);
	}
	item.find("#item_spec").html(n.item_spec);
	if (item.find("img").length>0) {
		item.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg");
	}
	if (!n.item_color) {
		n.item_color=n.p_item_color;
	}
	colorShowSelect(item,n.item_color,"item_color","colorActive","more");
	colorShowSelect(item,n.item_type,"item_type","specActive","more");
 }
function initAllcheck(){
	$("#allcheck").prop("checked",false);
	$("#allcheck").click(function() {
		var lia = $(".nav li").index($(".nav .active"));
		var tabs= $(".tabs-content:eq("+lia+")");
		var b=$(this).prop("checked");
		tabs.find("#list #check").prop("checked",b);
	});
}
function initFindBtn(func){
	$(".find").unbind("click");
	$(".find").click(function() {
		var lia = $(".nav li").index($(".nav .active"));
		var n=$(".find").index(this);
		$(".tabs-content").eq(lia).find("#list").html("");
		if(func){
			func();
		}
	});
}
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
//	getClassList("sort_name","类别","type_id");
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
	/////
	$("#findForm .clear").click(function(){
		$("#type_id").val("");
		$("#sort_name").html("");
	});
	$("#findForm .cls").click(function(){
		 pop_up_box.loadWait();
	 	   $.get("../tree/getDeptTree.do",{"type":"cls"},function(data){
	 		   pop_up_box.loadWaitClose();
	 		   $("body").append(data);
 			   procls.init();
	 	   });
	});
}