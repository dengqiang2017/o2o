$(function(){
	
	var params=window.location.href.split("?")[1];
	if(params){
		params=params.split("&");
		var seeds_id=params[0].split("=")[1];
		var wuliu=params[1].split("=")[1];
		$("#wuliuname").val(wuliu);
		$("#wuliuname").attr("disabled","disabled");
		var itemhtml=$("#item");
		$.get("../orderTrack/getOrderInfoByIds.do",{
			"seeds_id":seeds_id
		},function(data){
			$.each(data,function(i,n){
				var Status_OutStore=$.trim(n.Status_OutStore);
				if(Status_OutStore.indexOf("库管")>=0){
					$("#qrlah").hide();
					$('.xs').hide();
					$(".container").html("已安排物流!");
				}else{
					var item=$(itemhtml.html());
					$(".seciton").append(item);
					item.find("li:eq(0)>span").html(n.ivt_oper_listing);
					item.find("li:eq(1)>span").html(n.corp_name);
					item.find("li:eq(2)>span").html(n.c_memo);
					item.find("li:eq(3)>span").html(n.item_name);
					item.find("li:eq(4)>span").html(n.item_spec);
					item.find("li:eq(5)>span").html(n.item_type);
					item.find("li:eq(6)>span:eq(0)").html(numformat(n.sd_oq, 0));
					item.find("li:eq(6)>span:eq(1)").html(n.casing_unit);
					if(wuliu.indexOf("3")>=0||wuliu.indexOf("4")>=0){//第三方和供应商不显示客户信息
						item.find("li:eq(1)").hide();
					}
					if(n.Kar_paizhao&&n.Kar_paizhao!=""){
						$("#Kar_paizhao").val(n.Kar_paizhao);
					}
				}
			});
		});
		$("#qrlah").click(function(){
			var  Kar_paizhao=$.trim($("#Kar_paizhao").val());
			var  driveName=$.trim($("#driveName").val());
			var  drivePhone=$.trim($("#drivePhone").val());
			var  tihuoDate=$.trim($("#tihuoDate").val());
			if(Kar_paizhao==""){
				pop_up_box.showMsg("请输入车牌号");
			}else if(driveName==""){
				pop_up_box.showMsg("请输入司机名称");
			}else if(drivePhone==""){
				pop_up_box.showMsg("请输入司机手机号");
			}else if(tihuoDate==""){
				pop_up_box.showMsg("请选择提货时间");
			}else{
				$.post("../orderTrack/postWuliu.do",{
					"seeds_id":seeds_id,
					"Kar_paizhao":Kar_paizhao,
					"tihuoDate":tihuoDate,
					"m_flag":8,//已提交物流信息
					"wuliudx":"客户直接收货",
					"HYS":driveName+","+drivePhone,
					"wuliu":wuliu
				},function(data){
					if (data.success) {
						pop_up_box.showMsg("提交成功!",function(){
							window.location.href="../orderTrack/waybill.do?seeds_id="+seeds_id;
						});
					} else {
						if (data.msg) {
							pop_up_box.showMsg("保存错误!" + data.msg);
						} else {
							pop_up_box.showMsg("保存错误!");
						}
					}
				});
			}
		});
	}
	 $('.xs').click(function(){
	        $('.seciton').toggle();
	        var t = $('.xs').text();
	        if(t=="查看明细"){
	            $('.xs').text('关闭明细');
	        }
	        else{
	            $('.xs').text('查看明细');
	        }
	    });
});