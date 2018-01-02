	var page=0;
    var count=0;
    var totalPage=0;
    $("#jzlist").html("");
    loadData();
    $(".right-btn").click(function(){
    	page=0;
    	count=0;
    	$("#jzlist").html("");
    	$('.side-cover-phone').fadeOut();
        $('.product-check-phone').addClass('fadeOutLeft');
    	loadData();
    });
    $("#searchKey").change(function(){
    	page=0;
    	count=0;
    	$("#jzlist").html("");
    	loadData();
    });
    function loadData(){
    	var array=$(".ui_shaixuan>ul").find(".active");
    	var params=[];
		for (var i = 0; i < array.length; i++) {
			var arr=$(array[i]);
			var type= $(".ui_shaixuan>ul").index(arr.parent());
			var val=arr.find("input").val();
			if(!val){
				val=arr.find("span").html();
			}
			var filedId=arr.parents(".ui_shaixuan").find(".filedId").html();
			var param={};
			param.type=type;
			param.filedname=val;
			param.filedId=filedId;
			if (val.indexOf("全部")<0) {
				params.push(JSON.stringify(param));
			}
		}
	    pop_up_box.loadWait();
	    $.get("../product/getProductPageByTypeName.do",{
	    	"com_id":com_id,
	    	"params":"["+ params.join(",")+"]",
	    	"page":page,
	    	"searchKey":$.trim($("#searchKey").val()),
	    	"count":count,
	    	"name":"%家装%"
	    },function(data){
	    	pop_up_box.loadWaitClose();
	    	if(data&&data.rows&&data.rows.length>0){
	    		$.each(data.rows,function(i,n){
	    			var item=$($("#jzitem").html());
	    			$("#jzlist").append(item);
	    			if(n.proName){
		    			item.find("#proName").html(n.proName);
	    			}
	    			if (n.miaosu) {
		    			item.find("#miaosu").html(n.miaosu);
					}
	    			if(n.price>0){
		    			item.find("#price").html((n.price/10000)+"万元");
	    			}else{
		    			item.find("#price").html(n.price);
	    			}
	    			item.find("img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg");
	    			item.click({"com_id":$.trim(n.com_id),"item_id":$.trim(n.item_id)},function(event){
	    				window.location.href="spruce_case.jsp?com_id="+event.data.com_id+"&item_id="+event.data.item_id;
	    			});
	    		});
	    		count=data.totalRecord;
				totalPage=data.totalPage;
	    	}
	    });
    }
    pop_up_box.loadScrollPage(function(){
		if (page==totalPage) {
		}else{
			page+=1;
			loadData(); 
		}
	});
$('.screen').on('touchstart',function(){
    $('.side-cover').fadeIn();
    $('.product-check').fadeIn().removeClass('fadeOutLeft');
});
$('.side-cover').on('touchstart',function(){
    $('.side-cover').fadeOut();
    $('.product-check').addClass('fadeOutLeft');
});
$('.screen').click(function(){
    $('.side-cover-phone').fadeIn();
    $('.product-check-phone').fadeIn().removeClass('fadeOutLeft');
});
$('.side-cover-phone,.left-btn').click(function(event){
    $('.side-cover-phone').fadeOut();
    $('.product-check-phone').addClass('fadeOutLeft');
});
/////////////////
/**
 * 加载筛选子项
 */
function loadhtmlclass(id,name){
	if(!id){
		id=name;
	}
	return "<li><span>"+name+"</span><input type='hidden' value='"+id+"'><i class='glyphicon glyphicon-ok'></i></li>";
}
/**
 * @param index 位置
 * @param name 查询字段名称
 * @param type 字段对应中文
 */
function getClassList(index,name,type,typeid){
	if(typeid){
		$(".ui_shaixuan:eq("+index+")").find(".filedId").html(typeid);
	}else{
		$(".ui_shaixuan:eq("+index+")").find(".filedId").html(name);
	}
	$(".ui_shaixuan:eq("+index+")").find(".title").html(type);
	$.get("../product/getProductParam.do",{
		"com_id":com_id,
		"filedName":name,
		"name":"%家装%"
	},function(data){
		$(".ui_shaixuan:eq("+index+")").find("ul").html("");
		if (data&&data.length>0) {
			$.each(data,function(i,n){
				if (n&&n.name) {
					$(".ui_shaixuan:eq("+index+")").find("ul").append(loadhtmlclass(n.id,n.name));
				}
			});
			o2od.classselectclick();
		}
		$(".ui_shaixuan").find("ul>li").unbind("click");
		$(".ui_shaixuan").find("ul>li").click(function(){
			if (!$(this).hasClass("active")) {
				$(this).parent().find("li").removeClass("active");
				$(this).addClass("active");
				$(this).parent().parent().find(".checked").html($(this).find("span").text());
				$(this).parent().find("i").hide();
				$(this).find("i").show(); 
			}else{
				$(this).removeClass("active");
				$(this).parent().parent().find(".checked").html("");
				$(this).find("i").hide();
			}
			
		});
	});
}
getClassList(0,"item_spec","风格");
getClassList(1,"item_type","户型");
getClassList(2,"t2.sort_name","类别","type_id");
getClassList(3,"item_struct","面积");
// getClassList(3,"item_struct","店铺","store_struct_id");
$(function(){
	 var fs=$(".footer a");
	 for (var i = 0; i < fs.length; i++) {
		var f=$(fs[i]);
		f.attr("href",f.attr("href")+"?ver="+Math.random());
	}
});