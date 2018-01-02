$(function(){
	
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	$(".Wdate:eq(0)").val(nowStr);
	$(".Wdate:eq(1)").val(nowStr);
	function loadData(){
		pop_up_box.loadWait();
		$.get("getItemOrderList.do",{
			"searchKey":$.trim($("#searchKey").val()),
			"beginDate":$(".Wdate:eq(0)").val(),
			"endDate":$(".Wdate:eq(1)").val()
		},function(data){
			pop_up_box.loadWaitClose();
			addItem(data);  
		});
	}
	$(".find").click(function(){
		page=0;
		count=0;
		loadData();
		 $('#findlistpage').hide();
	        $('#listpage').show();
	});
	loadData();
	function addItem(data){
		$(".body:eq(0)>ul").html("");
		if(data&&data.length>0){
			var zje=0;
			$.each(data,function(i,n){
				var item=$($("#item").html());
				$(".body:eq(0)>ul").append(item);
				item.find("#item_name").html(n.item_name);
				item.find("#item_unit").html(n.item_unit);
				item.find("#num").html(numformat2(n.num));
				item.find("#je").html(numformat2(n.je));
				zje+=n.je;
				item.find("a").click({"item_id":n.item_id},function(event){
					$("#listpage").hide();
					$("#mingxi").html("<iframe src='gather.do?item_id="+event.data.item_id+"&beginDate="+$(".Wdate:eq(0)").val()+"&endDate="+$(".Wdate:eq(1)").val()+"' style='width:100%; min-height:1000px; height:100%; position:fixed; top:0; left:0;z-index: 1031;'></iframe>");
				});
			});
			$("#zje").html(numformat2(zje));
		}
	}
    $('.check').click(function(){
        $('#findlistpage').show();
        $('#listpage').hide();
    });
    $('.closed').click(function(){
        $('#findlistpage').hide();
        $('#listpage').show();
    });
	
	
});