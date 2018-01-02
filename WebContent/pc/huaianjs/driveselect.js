////获取客户司机信息
var driveselect={
		//params{订单编号,产品id},用于选择司机后隐藏司机按钮,显示司机信息
		init:function(params,t){
			var driveitem=$("#driveitem");
			$("#drivelist").html("");
			if ($.trim($("#drivelist").html())=="") {
				$.get("../user/getClientDriver.do",function(data){
					$.each(data,function(i,n){
						var item=$(driveitem.html());
						$("#drivelist").append(item);
						item.find("#corp_sim_name").html(n.corp_sim_name+"("+n.corp_working_lisence+")");
						item.find("#movtel").html($.trim(n.movtel));
						item.find("#weixinID").html($.trim(n.weixinID));
						item.find("#driveId").html($.trim(n.customer_id));
						item.find("#tel").attr("href","tel:"+$.trim(n.movtel));
						item.find("img:eq(0)").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg?ver="+Math.random());
						item.find("img:eq(0)").error(function(){
							$(this).remove();
						});
					});
					$(".list04_left_img:eq(0)").addClass("list03_left_img");//默认选中第一个
					$(".list04_left_img").unbind("click");
					$(".list04_left_img").click(function(){//注册图片选择框 选择或者取消功能
						$(".list04_left_img").removeClass("list03_left_img");
						$(this).addClass("list03_left_img");
					});
				});
			}
			//获取司机拉货订单清单
			var driveorderitem=$("#driveorderitem");
			var seeds="";
			var c_memo="";
			$.get("../product/getOrderProductList.do",params,function(data){
				$("#driveorderlist").html("");
				$.each(data,function(i,n){
					var item=$(driveorderitem.html());
					$("#driveorderlist").append(item);
					item.find("#item_name>span").html($.trim(n.item_name));
					item.find("#c_memo>span").html($.trim(n.c_memo));
    				item.find("#sum_si>span").html(numformat2(n.sum_si));
    				item.find("#sd_oq>span").html(n.sd_oq+"/"+n.item_unit);
    				item.find("#orderNo").html($.trim(n.ivt_oper_listing));
    				seeds=n.seeds_id+","+seeds;
    				c_memo=$.trim(n.c_memo);
    				item.find(".list_a_img>img").attr("src","../"+$.trim(n.com_id)+"/img/"+$.trim(n.item_id)+"/sl.jpg?ver="+Math.random());
				});
				seeds=seeds.substring(0,seeds.length-1);
			});
			///确认选择司机
			$(".driver_footer").unbind("click");
			$(".driver_footer").click(function(){
				if ($.trim($("#drivelist").html())=="") {
					pop_up_box.showMsg("没有找到司机,请联系内勤增加司机");
				}else{
				var item=$(".list03_left_img").parents("li");
				var weixinID=item.find("#weixinID").html();
				var movtel=item.find("#movtel").html();
				var customer_id=item.find("#driveId").html();
				var corp_sim_name=item.find("#corp_sim_name").html();
				params.weixinID=weixinID;
				params.movtel=movtel;
				params.customer_id=customer_id;
				params.corp_sim_name=corp_sim_name;
				params.seeds=seeds;
				params.c_memo=c_memo;
				params.orderlist="";
				params.processName="客户安排司机";
				pop_up_box.postWait();
				$.post("../customer/noticeDrive.do",params,function(data){
					pop_up_box.loadWaitClose();
					if (data.success) {
						pop_up_box.showMsg("提交成功!",function(){
							for (var i = 0; i < t.length; i++) {
								$(t[i]).parents(".all_order_list").remove();
// 								$(t[i]).parent().html("司机姓名:"+corp_sim_name+",电话:<a href='tel:"+movtel+"'>"+movtel+"</a>");
// 								$(t[i]).parents(".all_order_list").find(".indent-check").remove();
// 								$(t[i]).parents(".all_order_list").find("#Status_OutStore").html("已通知");
							}///check_driver_success.html
							$('#orderList').show();$('#show_check_driver').hide();
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
}