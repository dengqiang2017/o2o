var couponRelease={
		init:function(){
			common.initNumInput();
			$("#closedig,.close").click(function(){
				$(".modal-first").hide();
			});
			$(".add").click(function(){
				$(".modal-first").show();
				$("form input:not(input[type='radio'])").val("");
				$("form #sort_name").html("");
			});
			var page=0;
			var count=0;
			var totalPage=0;
			$("#searchKey").change(function(){
				 page=0;
				 count=0;
				 $("#list").html("");
			    loadData();
			 });
			$(".find").click(function(){
				$("#list").html("");
				page=0;
				count=0;
				loadData();
			});
		    pop_up_box.loadScrollPage(function(){
				if (page==totalPage) {
				}else{
					page+=1;
					loadData(); 
				}
			});
			function loadData(){
				pop_up_box.loadWait();
				$.get("../client/getCouponPage.do",{
					"searchKey":$.trim($("#searchKey").val()),
					"amount":$.trim($("#amount").val()),
					"beginDate":$.trim($("#d4311").val()),
					"endDate":$.trim($("#d4312").val()),
					"page":page,
					"count":count,
				},function(data){
					pop_up_box.loadWaitClose();
					if (data&&data.rows.length>0) {
						$.each(data.rows,function(i,n){
							var item=$($("#item").html());
							$("#list").append(item);
							item.find("#f_amount").html(n.f_amount);
							item.find("#up_amount").html(n.up_amount);
							item.find("#ivt_oper_listing").html(n.ivt_oper_listing);
							item.find("#type_id").html(n.type_id);
							if(n.type_name){
								item.find("#type_name").html("仅可购买【"+n.type_name+"】商品");
							}else{
								item.find("#type_name").html("全品类");
							}
							item.find("#begin_use_date").html(n.begin_use_date);
							item.find("#end_use_date").html(n.end_use_date);
							showdata(item,n.ivt_oper_listing);
						});
					}
				});
			}
			$("#list").html("");
			loadData();
			function showdata(item){
				item.find(".edit").click(function(){
					$("form input:not(input[type='radio'])").val("");
					$("form #sort_name").html("");
					var item1=$(this).parents(".item");
					var f_amount=item1.find("#f_amount").html();
					var up_amount=item1.find("#up_amount").html();
					var ivt_oper_listing=item1.find("#ivt_oper_listing").html();
					var type_name=item1.find("#type_name").html();
					var type_id=item1.find("#type_id").html();
					var begin_use_date=item1.find("#begin_use_date").html();
					var end_use_date=item1.find("#end_use_date").html();
					if(type_id.indexOf("CP")>=0){
						$("form input[name='typeid'][value='pro']").prop("checked",true);
					}else{
						$("form input[name='typeid'][value='cls']").prop("checked",true);
					}
					$("form input[name='f_amount']").val(f_amount);
					$("form input[name='up_amount']").val(up_amount);
					$("form input[name='ivt_oper_listing']").val(ivt_oper_listing);
					$("form input[name='begin_use_date']").val(begin_use_date);
					$("form input[name='end_use_date']").val(end_use_date);
					$("form input[name='type_id']").val(type_id);
					if(type_name.indexOf("【")>0){
						type_name=type_name.substring(type_name.indexOf("【")+1,type_name.indexOf("】"));
					}
					$("form #sort_name").html(type_name);
					$(".modal-first").show();
				});
				item.find(".del").click(function(){
					if(confirm("是否删除该优惠券?")){
						pop_up_box.postWait();
						var item=$(this).parents(".item");
						var ivt_oper_listing=item.find("#ivt_oper_listing").html();
						$.post("../client/delCoupon.do",{
							"ivt_oper_listing":ivt_oper_listing
						},function(data){
							pop_up_box.loadWaitClose();
							if (data.success) {
								pop_up_box.showMsg("删除成功!");
								item.remove();
							} else {
								if (data.msg) {
									pop_up_box.showMsg("删除错误!"+ data.msg);
								} else {
									pop_up_box.showMsg("删除错误!");
								}
							}
						});
					}
				});
			}
			////////////////////
			$("#cls").click(function(){
				 pop_up_box.loadWait();
				 var type= $("input[name='typeid']:checked").val();
				 if(type=="cls"){
					 $.get("../tree/getDeptTree.do",{"type":"cls"},function(data){
						 pop_up_box.loadWaitClose();
						 $("body").append(data);
						 procls.init(function(){
							 $(".modal-dialog #type_id").val(treeSelectId);
							 $(".modal-dialog #sort_name").html(treeSelectName);
						 }); 
					 });
				 }else{
					 $.get("../tree/productSelect.do",function(data){
						 pop_up_box.loadWaitClose();
						 $("body").append(data); 
						 product.init(function(){
							 var id=$(".modal").find(".activeTable").find("td:eq(0)").find("input").val();
							 var name=$(".modal").find(".activeTable").find("td:eq(1)").html();
							 $(".modal-dialog #type_id").val(id);
							 $(".modal-dialog #sort_name").html(name);
						 });
					 });
				 }
			});
			$("#cleartype").click(function(){
				$(".modal-dialog #type_id").val("");
				 $(".modal-dialog #sort_name").html("");
			});
			///////////////////
			$("#save").click(function(){
				var f_amount=$.trim($("form input[name='f_amount']").val());
				var up_amount=$.trim($("form input[name='up_amount']").val());
				var begin_use_date=$("form input[name='begin_use_date']").val();
				var end_use_date=$("form input[name='end_use_date']").val();
				if(f_amount==""||parseInt(f_amount)<=0){
					pop_up_box.showMsg("请输入优惠券金额!");
				}else if(up_amount==""||parseInt(up_amount)<0){
					pop_up_box.showMsg("请输入优惠券上限使用金额,输入0表示无限制!");
				}else if(begin_use_date==""){
					pop_up_box.showMsg("请输入优惠券开始使用日期!");
				}else if(end_use_date==""){
					pop_up_box.showMsg("请输入优惠券结束使用日期!");
				}else{
					var ivt_oper_listing=$.trim($("form input[name='ivt_oper_listing']").val());
					pop_up_box.postWait();
					$.post("../client/saveCouponRelease.do",$("form").serialize(),function(data){
						pop_up_box.loadWaitClose();
						$(".modal-first").hide();
						if (data.success) {
							pop_up_box.toast("保存成功!",1000);
							//数据更新或者增加到列表中
							var item;
							if(ivt_oper_listing==""){//增加
								ivt_oper_listing=data.msg;
								item=$($("#item").html());
								if($("#list .item:eq(0)").length==0){
									$("#list").append(item);
								}else{
									$("#list .item:eq(0)").before(item);
									
								}
								showdata(item,ivt_oper_listing);
							}else{//更新数据表
								item=$("#list .item:contains('"+ivt_oper_listing+"')");
							}
							item.find("#f_amount").html(f_amount);
							item.find("#up_amount").html(up_amount);
							item.find("#ivt_oper_listing").html(ivt_oper_listing);
							var sort_name=$.trim($("form #sort_name").html());
							var type_id=$.trim($("form #type_id").val());
							if(sort_name!=""){
								item.find("#type_name").html("仅可购买【"+sort_name+"】商品");
								item.find("#type_id").html(type_id);
							}else{
								item.find("#type_name").html("全品类");
							}
							item.find("#begin_use_date").html(begin_use_date);
							item.find("#end_use_date").html(end_use_date);
							//////
							$("form input:not(input[type='radio'])").val("");
							$("form #sort_name").html("");
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
couponRelease.init();