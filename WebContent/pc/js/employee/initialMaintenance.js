$(function(){
	initialMaintenance.init();
});
var initialMaintenance={
		init:function(){
			var receivable=$(".tabs-content:eq(0)");//应收初始化
			var payable=$(".tabs-content:eq(1)");   //应付初始化
			var wareinit=$(".tabs-content:eq(2)");  //库存初始化
			var receivablePage={
					page:0,
					totalPage:0,
					count:0
			};
			var payablePage={
					page:0,
					totalPage:0,
					count:0
			};
			var wareinitpage={
					page:0,
					totalPage:0,
					count:0
			};
			$(".excel").click(function(){
				var lia = $(".nav li").index($(".nav .active"));
				if (lia==0) {
					$.get("../maintenance/initialReceivableExcel.do",{
						"searchKey":$.trim($("#searchKey").val())
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.msg) {
							window.location.href=data.msg;
						}
					});
				}else if (lia==1) {
					$.get("../maintenance/payableExport.do",{
						"searchKey":$.trim($("#searchKey").val())
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.msg) {
							window.location.href=data.msg;
						}
					});
				}else{
					$.get("../maintenance/wareinitExport.do",{
						"searchKey":$.trim($("#searchKey").val())
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.msg) {
							window.location.href=data.msg;
						}
					});
				}
			});
			$(".find").click(function(){
				var lia = $(".nav li").index($(".nav .active"));
				pop_up_box.loadWait();
				if (lia==0) {
					$.get("initialReceivablePage.do",{
						"searchKey":$.trim($("#searchKey").val())
					},function(data){
						pop_up_box.loadWaitClose();
						receivable.find("#tableReceivable").html("");
						$.each(data.rows,function(i,n){
							var ul=getReceivableUl(n);
							receivable.find("#tableReceivable").append(ul);
						});
						$(".table-body").removeClass('active_table');
						$(".table-body").click(function(){
							$(".table-body").removeClass('active_table');
//							if($(this).hasClass('active_table')){
//								$(this).removeClass('active_table');
//							}else{
								$(this).addClass('active_table');
//							}
						});
					});
				}else if (lia==1) {
					$.get("initialPayablePage.do",{
						"searchKey":$.trim($("#searchKey").val())
					},function(data){
						pop_up_box.loadWaitClose();
						payable.find("#tableHandle").html("");
						$.each(data.rows,function(i,n){
							var ul=getInitialHandle(n);
							payable.find("#tableHandle").append(ul);
						});
						$(".table-body").removeClass('active_table');
						$(".table-body").click(function(){
							$(".table-body").removeClass('active_table');
							$(this).addClass('active_table');
						});
					});
				}else{
					$.get("initialMaintenancePage.do",{
						"searchKey":$.trim($("#searchKey").val())
					},function(data){
						pop_up_box.loadWaitClose();
						wareinit.find("#tableBody").html("");
						$.each(data.rows,function(i,n){
							var ul=getInitWareUl(n);
							wareinit.find("#tableBody").append(ul);
						});
						$(".table-body").removeClass('active_table');
						$(".table-body").click(function(){
							$(".table-body").removeClass('active_table');
							$(this).addClass('active_table');
						});
					});
				}
			});
			
			$(".find:eq(0)").click();
			$(".nav li").click(function(){
				var lia = $(".nav li").index($(".nav .active"));
				var n="";
				if(lia==0){
					n=$.trim($("#tableReceivable").html());
				}else if(lia==1){
					n=$.trim($("#tableHandle").html());
				}else{
					n=$.trim($("#tableBody").html());
				}
				if(n==""){
					$(".find").click();
				}
			});
			function getReceivableUl(data){
				if(!data.initial_flag){
					data.initial_flag="N";
				}
				var color ="";
				if(data.initial_flag=="Y"){
					color="red";
				}
				var ul="<ul class='table-body' style='color:"+color+"'><li style='width: 20%;'>"+ifnull(data.corp_sim_name)+"</li>"+
				"<input id='seeds_id' type='hidden' name='seeds_id' value='"+ifnull(data.seeds_id)+"'>"+
				"<input id='initial_flag' type='hidden' name='initial_flag' value='"+ifnull(data.initial_flag)+"'>"+
				"<li style='width: 10%;'>"+numformat(ifnull(data.oh_sum),2)+"</li>"+
				"<li style='width: 20%;'>"+ifnull(data.settlement_sim_name)+"</li>"+
				"<li style='width: 20%;'>"+ifnull(data.c_memo)+"</li>"+
				"<li style='width: 20%;'>"+ifnull(data.dept_name)+"</li>"+
				"<li class='last' style='width: 10%;'>"+ifnull(data.clerk_name)+"</li></ul>";
				return ul;
			}
			
			function getInitWareUl(data){
				if(!data.initial_flag){
					data.initial_flag="N";
				}
				var color ="";
				if(data.initial_flag=="Y"){
					color="red";
				}
				var ul="" +
				"<ul class='table-body' style='color:"+color+"'>" +
				"<input id='ivt_num_detail' type='hidden' name='ivt_num_detail' value='"+ifnull(data.ivt_num_detail)+"'>"+
				"<input id='initial_flag' type='hidden' name='initial_flag' value='"+ifnull(data.initial_flag)+"'>"+
				"<li style='width: 7%;' title='"+ifnull(data.store_struct_id)+"'>"+ifnull(data.store_struct_id)+"</li>"+
				"<li style='width: 7%;' title='"+ifnull(data.store_struct_name)+"'>"+ifnull(data.store_struct_name)+"</li>"+
				"<li style='width: 7%;' title='"+ifnull(data.item_id)+"'>"+ifnull(data.item_id)+"</li>"+
				"<li style='width: 7%;' title='"+ifnull(data.item_name)+"'>"+ifnull(data.item_name)+"</li>"+
				"<li style='width: 8%;'>"+ifnull(data.item_spec)+"</li>"+
				"<li style='width: 8%;'>"+ifnull(data.item_type)+"</li>"+
				"<li style='width: 8%;'>"+ifnull(data.casing_unit)+"</li>"+
				"<li style='width: 8%;'>"+ifnull(data.item_unit)+"</li>"+
				"<li style='width: 8%;'>"+ifnull(data.i_price)+"</li>"+
				"<li style='width: 8%;'>"+ifnull(data.oh)+"</li>"+
				"<li style='width: 8%;'>"+ifnull(data.i_Amount)+"</li>"+
				"<li style='width: 8%;'>"+ifnull(data.dept_name)+"</li>"+
				"<li class='last' style='width: 8%;'>"+ifnull(data.clerk_name)+"</li>"+
				"</ul>";
				return ul;
			}
		
			function getInitialHandle(data){
				if(!data.initial_flag){
					data.initial_flag="N";
				}
				var color ="";
				if(data.initial_flag=="Y"){
					color="red";
				}
				var ul="<ul class='table-body' style='color:"+color+"'><li style='width: 25%;'>"+ifnull(data.corp_name)+"</li>"+
				"<input id='seeds_id' type='hidden' name='seeds_id' value='"+ifnull(data.seeds_id)+"'>"+
				"<input id='initial_flag' type='hidden' name='initial_flag' value='"+ifnull(data.initial_flag)+"'>"+
				"<li style='width: 25%;'>"+numformat(ifnull(data.beg_sum),2)+"</li>"+
				"<li style='width: 25%;'>"+ifnull(data.dept_name)+"</li>"+
				"<li class='last' style='width: 25%;'>"+ifnull(data.clerk_name)+"</li></ul>";
				return ul;
			}
			
			///期初应收款
			$("#initysk_shenhe").click(function(){
				initKuanxiangShenhe("Y",0,"ysk");
			});
			$("#initysk_qishen").click(function(){
				initKuanxiangShenhe("N",0,"ysk");
			});
			///期初应付款
			$("#inityfk_shenhe").click(function(){
				initKuanxiangShenhe("Y",1,"yfk");
			});
			$("#inityfk_qishen").click(function(){
				initKuanxiangShenhe("N",1,"yfk");
			});
			function initKuanxiangShenhe(type,index,shenheType){
				var name="审核";
				if(type=="N"){
					name="弃审";
				}
				if(shenheType=="initkucun"){
					ivt_num_detail
				}
				var seeds_id=$.trim($(".tabs-content:eq("+index+")").find(".active_table #seeds_id").val());
				if(seeds_id==""){
					pop_up_box.showMsg("请选中一条需要"+name+"的记录!");
					return;
				}
				var initial_flag=$.trim($(".tabs-content:eq("+index+")").find(".active_table #initial_flag").val());
				if(type=="N"&&initial_flag=="N"){
					pop_up_box.showMsg("该记录已经"+name+"或者未审核!");
					return;
				}else if(type=="Y"&&initial_flag=="Y"){
					pop_up_box.showMsg("该记录已经"+name);
					return;
				}
				if (window.confirm("是否"+name+"该条记录?")){
					pop_up_box.postWait();
					$.post("../manager/initKuanxiangShenhe.do",{
						"seeds_id":seeds_id,
						"shenheType":shenheType,
						"initial_flag":type
					},function(data){
						pop_up_box.loadWaitClose();
						if (data.success){
							pop_up_box.toast(name+"成功!",2000);
							$(".tabs-content:eq("+index+")").find(".active_table #initial_flag").val(type);
							console.debug($(".active_table #seeds_id").parents("li"));
							if(type=="Y"){
								$(".tabs-content:eq("+index+")").find(".active_table #seeds_id").parent().css("color","red");
							}else{
								$(".tabs-content:eq("+index+")").find(".active_table #seeds_id").parent().css("color","");
							}
						}else{
							pop_up_box.showMsg(data.msg);
						}
					});
				}
			}
			///期初库存
			$("#initkucun_shenhe").click(function(){
				initKucunShenhe("Y");
			});
			$("#initkucun_qishen").click(function(){
				initKucunShenhe("N");
			});
			function initKucunShenhe(type){
				var name="审核";
				if(type=="N"){
					name="弃审";
				}
				var ivt_num_detail=$.trim($(".tabs-content:eq(2)").find(".active_table #ivt_num_detail").val());
				if(ivt_num_detail==""){
					pop_up_box.showMsg("请选中一条需要"+name+"的记录!");
					return;
				}
				var initial_flag=$.trim($(".tabs-content:eq(2)").find(".active_table #initial_flag").val());
				if(type=="N"&&initial_flag=="N"){
					pop_up_box.showMsg("该记录已经"+name+"或者未审核!");
					return;
				}else if(type=="Y"&&initial_flag=="Y"){
					pop_up_box.showMsg("该记录已经"+name);
					return;
				}
				if (window.confirm("是否"+name+"该条记录?")){
					pop_up_box.postWait();
					$.post("../manager/initKucunShenhe.do",{
						"ivt_num_detail":ivt_num_detail,
						"initial_flag":type
						},function(data){
						pop_up_box.loadWaitClose();
						if (data.success){
							pop_up_box.toast(name+"成功!",2000);
							$(".tabs-content:eq(2)").find(".active_table #initial_flag").val(type);
							if(type=="Y"){
								$(".tabs-content:eq(2)").find(".active_table #ivt_num_detail").parent().css("color","red");
							}else{
								$(".tabs-content:eq(2)").find(".active_table #ivt_num_detail").parent().css("color","");
							}
						}else{
							pop_up_box.showMsg(data.msg);
						}
					});
				}
			}
//			https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxd6d2b1e1898c3ef2&redirect_uri=http://www.pulledup.cn/ds/index.html&response_type=code&scope=snsapi_base&state=001#wechat_redirect
//			https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxd6d2b1e1898c3ef2&redirect_uri=http://www.pulledup.cn/ds/index.html&response_type=code&scope=snsapi_base&state=123#wechat_redirect
			
			
		}
}
