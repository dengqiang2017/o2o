$(function(){
	planReport.init();
});

var planReport={
		init:function(){
///初始化日期为当前日期
			var now = new Date();
			var nowStr = now.Format("yyyy-MM-dd"); 
			$(".Wdate").val(nowStr);
			$(".tabs-content:eq(0)>.subtabs-content").find(".Wdate:eq(1)").val("");
			$(".tabs-content:eq(0)>.subtabs-content").find(".Wdate:eq(2)").val(""); 
			function loadExpandfind(){
				return "<div class='folding-btn m-t-b'>" +
				"<button type='button' class='btn btn-primary btn-folding expandfind'>展开搜索</button>" +
				"<button type='button' class='btn btn-danger excel btn-folding'>导出</button></div>";
			}
			$(".subtabs-content").prepend(loadExpandfind());
			$(".expandfind").click(function(){
				var t=$(this).parents(".subtabs-content");
				var form=t.find("form");
				if(form.is(":hidden")){
					form.show();
					$(this).text("隐藏搜索");
				}else{
					$(this).text("展开搜索");
					form.hide();
				}
			}); 
			if($(".folding-btn").css("display")=="none"){
				$("form").show();
			}else{
				$("form").hide();
			}
			$(".find").click(function(){ 
				pop_up_box.loadWait();
				dayProduct();
				 
			});
			$(".excel").click(function(){
				pop_up_box.loadWait();
				dayProductExcel();
			});
			 
			var subtabs0_4={///日计划-分产品
					page:0,
					totalRecord:0,
					totalPage:0
			}
			/**
			 * 日计划-分产品
			 */
			function dayProduct(){
				var subtabs_content=$(".subtabs-content");
				var tbody=subtabs_content.find("table>tbody");
				$.get("../product/dayProduct.do?day=day",getParams(subtabs_content,"日计划"),function(data){
					tbody.html("");
					$.each(data.rows,function(i,n){
						var tr=getTr(4);///多少数据列
						tbody.append(tr);
						tr.find("td:eq(0)").html(n.sort_name);
						tr.find("td:eq(1)").html(n.item_sim_name);
						tr.find("td:eq(2)").html(n.sd_oq); 
						tr.find("td:eq(3)").html(n.sd_oq_View_sdd02020);
					});
					pop_up_box.loadWaitClose();
					subtabs0_4.page=data.page-1;
					subtabs0_4.totalPage=data.totalPage-1;
					subtabs0_4.totalRecord=data.totalRecord;
				});  
			}
			/**
			 * 日计划-分产品导出
			 */
			function dayProductExcel(){
				var subtabs_content=$(".subtabs-content");
				$.get("../product/dayProductExcel.do",getParams(subtabs_content,"日计划"),function(data){
					pop_up_box.loadWaitClose();
					window.location.href=data.msg;
				});
			}
		}
}


function clearDate(){
	var wd=$(this).parents(".subtabs-content").find(".Wdate").index(this);
	if (wd==0) {
		$(this).parents(".subtabs-content").find(".Wdate:eq(1)").val("");
		$(this).parents(".subtabs-content").find(".Wdate:eq(2)").val("");
	}else{
		$(this).parents(".subtabs-content").find(".Wdate:eq(0)").val("");
	}
}
/**
 * 周计划所有产品 参数组合
 */
function getParams(subtabs_content,plantype){
	var atBeginTime=subtabs_content.find(".Wdate:eq(1)").val();
	var atEndnTime=subtabs_content.find(".Wdate:eq(2)").val();
	if (atBeginTime&&$.trim(atBeginTime)!="") {
		 atBeginTime=atBeginTime+" 00:00:00";
	}
	if (atEndnTime&&$.trim(atEndnTime)!="") {
		atEndnTime=atEndnTime+" 23:59:59";
	}
	var param={
			"item_name":subtabs_content.find("#item_name").val(),
			"beginDate":subtabs_content.find(".Wdate:eq(0)").val(),
			"atBeginTime":atBeginTime,
			"atEndTime":atEndnTime,
			"customer_id":$("#customer_id").val(),
			"find":"find",
			"customer_name":subtabs_content.find("#customer_name").val(),
			"sd_order_direct":plantype,
			"type":subtabs_content.find("#type").val(),
			"ver":Math.random()
	};
	return param;
}

function zhuciday(){
	if ($(this).parents(".subtabs-content").find("#type").val()=="周计划") {
		var week=parseInt($dp.cal.getP('W','W'))+1;
		$(this).parents(".subtabs-content").find('#zhuci').show();
		$(this).parents(".subtabs-content").find('#zhuci').html("计划周次为:"+week+"周");
	}else{
		$(this).parents(".subtabs-content").find('#zhuci').hide();
	}
}