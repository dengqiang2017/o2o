var gather={
		adress_id:""
};
$(function(){
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
//	now=addDate(nowStr,1);
//	nowStr = now.Format("yyyy-MM-dd"); 
	$(".Wdate:eq(0)").val(nowStr);
	$(".Wdate:eq(1)").val(nowStr);
	var desc="adress_id";
	function loadData(){
		pop_up_box.loadWait();
		var rows="10";
		if($("#rows").length>0){
			rows=$("#rows").html();
		}
		$.get("getGysOrderList.do",{
			"searchKey":$.trim($("#searchKey").val()),
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val(),
			"type":$("#type").val(),
//			"st_auto_no":st_auto_no,
			"adress_id":$("#adress_id").html(),
			"item_id":$("#item_id").html(),
			"desc":desc,
			"rows":rows,
			"page":page,
			"count":count
		},function(data){
			pop_up_box.loadWaitClose();
			addItem(data); 
			totalPage = data.totalPage;
			count = data.totalRecord;
		});
	}
	function addItem(data){
		$("tbody").html("");
		if (data&&data.rows.length>0) {
			var thlen=$("thead:eq(0) th").length;
			$.each(data.rows,function(i,n){
				if(n.item_name){
					var tr=getTr(thlen);
					$("tbody").append(tr);
					for (var i = 0; i < thlen; i++) {
						var th=$($(".table-responsive:eq(0) th")[i]);
						var name=th.attr("data-name");
						var j=$(".table-responsive:eq(0) th").index(th);
						if(name=="je"){
							tr.find("td:eq("+j+")").html(numformat2(n.hav_rcv*n.price));
						}if(name=="m_flag"){
							if(n.m_flag==0){
								tr.find("td:eq("+j+")").html("未处理");
							}else if(n.m_flag==2){
								tr.find("td:eq("+j+")").html("已处理有货");
							}else if(n.m_flag==3){
								tr.find("td:eq("+j+")").html("已处理无货");
							}else if(n.m_flag==9){
								tr.find("td:eq("+j+")").html("已提交物流");
							}else if(n.m_flag==4){
								tr.find("td:eq("+j+")").html("已发货");
							}else if(n.m_flag==5){
								tr.find("td:eq("+j+")").html("已收货");
							}
						}else{
							tr.find("td:eq("+j+")").html(n[name]);
						}
					}
				}
			});
			var tr=getTr(thlen);
			tr.find("td:eq(0)").html("汇总");
			getSumNum(tr,0,"hav_rcv",2);
			getSumNum(tr,0,"je",2);
			$("tbody>tr:eq(0)").before(tr);
			$("tbody>tr").unbind("click");
			$("tbody>tr").click(function(){
				if($(this).hasClass("success")){
					$(this).removeClass("success");
				}else{
					$(this).addClass("success");
				}
			});
		}
	}
	
	$(".find").click(function(){
		page=0;
		count=0;
		loadData();
		 $('#findlistpage').hide();
	        $('#listpage').show();
	});
	var url=window.location.href.split("?")[1];
	if(url){
		$("#searchKey").val(getQueryString("st_auto_no"));
		if(getQueryString("adress_id")!=""){
			$("#adress_id").html(getQueryString("adress_id"));
		}
		if(getQueryString("item_id")!=""){
			$("#item_id").html(getQueryString("item_id"));
		}
		if(getQueryString("beginDate")!=""){
			$(".Wdate:eq(0)").val(getQueryString("beginDate"));
		}
		if(getQueryString("endDate")!=""){
			$(".Wdate:eq(1)").val(getQueryString("endDate"));
		}
	}
	loadData();
	var page=0;
	var count=0;
	var totalPage=0;
	$(".btn-add").click(function(){
		page+=1;
		if (page==totalPage) {}else{
			loadData();
		}
	});
	
	if($("#mingxi",window.parent.document).length>0){
		$(".header>.pull-left").unbind();
		$(".header>.pull-left").click(function(){
			$("#listpage",window.parent.document).show();
			$("#mingxi",window.parent.document).html("");
		});
	}else{
		$(".header>.pull-left").click(function(){
			 history.back(1);	
		});
	}
    $('.cut_box>ul>li').click(function(){
        $('.cut_box>ul>li').removeClass('active');
        $(this).addClass('active');
        var n=$('.cut_box>ul>li').index($('.cut_box>ul>li.active'));
        if(n==0){
        	desc="adress_id";
        }else{
        	desc="item_id";
        }
        page=0;
		count=0;
		loadData();
    });
    $('.check').click(function(){
        $('#findlistpage').show();
        $('#listpage').hide();
    });
    $('.closed').click(function(){
        $('#findlistpage').hide();
        $('#listpage').show();
    });
});