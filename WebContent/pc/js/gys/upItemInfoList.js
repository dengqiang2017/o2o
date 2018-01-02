$(function(){
	var now = new Date();
	var nowStr = now.Format("yyyy-MM-dd"); 
	var itemhtml=$(".body:eq(0)>ul").html();
	$(".body:eq(0)>ul").html("");
	$(".find").click(function(){
		$('#findlistpage').hide();
		$('#listpage').show();
		loadData();
	});
	$(".Wdate:eq(0)").val(nowStr);
	loadData();
	function loadData(){
		$(".body:eq(0)>ul").html("");
		$.get("getGysUpItemInfoList.do",{
			"searchKey":$.trim($("#searchKey").val()),
			"beginDate":$(".Wdate:eq(0)").val()
		},function(data){
			if(data&&data.length>0){
				$.each(data,function(i,n){
					var item=$(itemhtml);
					$(".body:eq(0)>ul").append(item);
					item.find("#item_name").html(n.item_name+"-"+n.corp_name);
					item.find("#num").html(n.num);
					item.find("#price").html(n.price);
					item.find(".item_unit").html(n.item_unit);
					item.find(".date_box").html(n.at_time);
					if(n.imgs&&n.imgs.length>0){
						item.find(".img-responsive").attr("src",n.imgs[0]);
					}
					item.find(".btn_box button:eq(0)").click({
						"ivt_no":n.ivt_no,
						"corp_name":n.corp_name,
						"weixinID":n.weixinID,
						"movtel":n.movtel
					},function(event){//通过
						pop_up_box.postWait();
						$.post("../employee/updateGysProFlag.do",{
							"weixinID":event.data.weixinID,
							"movtel":event.data.movtel,
							"flag":1,
							"ivt_no":event.data.ivt_no,
							"title":"上报产品信息-确认通过通知",
							"description":"@comName-"+event.n.corp_name+":您上报的产品信息,@comName采购已经确认通过"
						},function(data){
							var t=$(this);
							pop_up_box.loadWaitClose();
							if (data.success) {
								pop_up_box.showMsg("提交成功!");
								t.hide();
								t.next().hide();
							} else {
								if (data.msg) {
									pop_up_box.showMsg("保存错误!" + data.msg);
								} else {
									pop_up_box.showMsg("保存错误!");
								}
							}
						});
					});
					item.find(".btn_box button:eq(1)").click({
						"ivt_no":n.ivt_no,
						"corp_name":n.corp_name,
						"weixinID":n.weixinID,
						"movtel":n.movtel
					},function(event){//不通过
						pop_up_box.postWait();
						var t=$(this);
						$.post("../employee/updateGysProFlag.do",{
							"weixinID":event.n.weixinID,
							"movtel":event.data.movtel,
							"flag":2,
							"ivt_no":event.data.ivt_no,
							"title":"上报产品信息-确认不通过通知",
							"description":"@comName-"+event.data.corp_name+":您上报的产品信息,@comName采购确认不通过"
						},function(data){
							pop_up_box.loadWaitClose();
							if (data.success) {
								pop_up_box.showMsg("提交成功!");
								t.hide();
								t.prev().hide();
							} else {
								if (data.msg) {
									pop_up_box.showMsg("保存错误!" + data.msg);
								} else {
									pop_up_box.showMsg("保存错误!");
								}
							}
						});
					});
					item.find(".btn_box button:eq(2)").click({"item_id":n.item_id,"price":n.price},function(event){//修改单价
						pop_up_box.postWait();
						$.post("../manager/updateProPrice.do",{
							"item_id":event.data.item_id,
							"price":event.data.price
						},function(){
							var t=$(this);
							pop_up_box.loadWaitClose();
							if (data.success) {
								pop_up_box.showMsg("提交成功!");
								t.hide();
							} else {
								if (data.msg) {
									pop_up_box.showMsg("保存错误!" + data.msg);
								} else {
									pop_up_box.showMsg("保存错误!");
								}
							}
						});
					});
				});
			}
		});
	}
	
	
    $('.box02>.pull-left,#mymodal>img').click(function(){
        $("#mymodal").modal("toggle");
    });
    $('.box02>.pull-left>img').click(function(){
        var s=$(this).attr("src");
        $('#mymodal img').attr('src',s);
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