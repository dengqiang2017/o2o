$(function(){
	var page=0;
	var totalPage=0;
	var count=0;
	$(".find").click(function(){
		page=0;
		count=0;
		loadData();
	});
	loadSelect();
	loadData();
	function getLi(len){
		var ul="<ul class='table-body'>";
		for (var i = 0; i < len; i++) {
			var li=$($(".table-head li")[i]);  
			ul+="<li style='"+li.attr("style")+"'></li>";
		}
		ul+="</ul>";
		return $(ul);
	}
	function loadData(){
		var searchKey=$("#searchKey").val();
		pop_up_box.loadWait();
		$.get("../maintenance/getWarePage.do",{
			"searchKey":searchKey,
			"type_id":$.trim($("#type_id").val()) ,
			"quality_class":$.trim($("#quality_class").val()) ,
			"item_style":$.trim($("#item_style").val()) ,
			"class_card":$.trim($("#class_card").val()),
			"item_spec":$.trim($("#item_spec").val()),
			"item_struct":$.trim($("#item_struct").val()),
			"item_type":$.trim($("#item_type").val()),
			"item_color":$.trim($("#item_color").val()),
			"count":count,
			"page":page
		},function(data){
			$("#tableBody").html("");
			pop_up_box.loadWaitClose();
			var len=$(".table-head li").length;
			$.each(data.rows,function(i,n){
				var item=getLi(len);
				$("#tableBody").append(item);
				for (var k = 0; k < len; k++) {
					var li=$($(".table-head li")[k]);
					var name=$.trim(li.attr("data-name"));
					var j=$(".table-head li").index(li);
					var show=li.css("display");
					if(show=="none"){
						tr.find("td:eq("+j+")").hide();
					}else{
						if($.trim(n.store_struct_id)=="WH000"){
							item.find("li:eq(0)").html("总库房");
							item.find("li").eq(0).attr("title","总库房");
						}
						item.find("li").eq(j).html(ifnull(n[name]));
						item.find("li").eq(j).attr("title",ifnull(n[name]));
					}
				}
			});
			totalPage=data.totalPage;
			count=data.totalRecord;
			$("#page").html("当前页:"+(page+1)+" 共:"+(data.totalPage+1)+"页;共"+count+"条");
//			$("#totalPage").html(data.totalPage);
//			$(".pull-left .form-control").val(data.totalRecord);
		});
	}
	//1.首页
	$("#beginpage").click(function(){
		page=0;
		loadData();
	});
	//2.尾页
	$("#endpage").click(function(){
		page=totalPage;
		loadData();
	});
	$("#uppage").click(function(){
		page=parseInt(page)-1;
		if (page>=0) {
			loadData();
		}else{
			pop_up_box.showMsg("已到第一页!");
		}
	});
	$("#nextpage").click(function(){
		  page=parseInt(page)+1;
		if (page<=totalPage) {
			loadData();
		}else{
			pop_up_box.showMsg("已到最后一页!");
		}
	});
	////////////////////////////////
});