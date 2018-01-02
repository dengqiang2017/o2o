$(function(){
	//工序名称
	var gx=$(".gx");
	//派工按钮
	var paigongitem=$("#paigongitem");
	//表格里面显示员工内容模板
	var emplitem=$("#emplitem");
	//待选择员工模板
	var emplinfo=$("#emplinfo");
	setDateNow();
	//生产计划模板
	function getsctr(num,names){
		var td0=$("#td0");
		var td1=$("#td1");
		var td="<td class='zz'><div class='jz'></td></div>";
		var tr="<tr>";
		for (var i = 0; i < num; i++) {
				tr+="<td class='zz'><div class='jz'></td></div>";
		}
		tr+="</tr>";
		tr=$(tr);
		tr.find("td:eq(0)>.jz").html(td0.html());
		tr.find("td:eq(1)>.jz").html(td1.html());
		return tr;;
	}
	var count=0;//总数
	var page=0;//当前页
	var totalPage=0;//总页数
	$("#working_procedure_section option:first").prop("selected", 'selected');
	$("#status option:first").prop("selected", 'selected');
	////////////////
	$("#working_procedure_section").change(function(){//设置工序类别下拉变化事件
		pop_up_box.loadWait();
		$.get("../pPlan/getProductionProcessInfo.do",{
			"working_procedure_section":$(this).val()
		},function(data){
			pop_up_box.loadWaitClose();
			$("thead>tr:eq(1)").html("");
			$("thead>tr:eq(0)>th:eq(6)").attr("colspan",data.length);
			$.each(data,function(i,n){
				var th=$("<th class='gx'><span>"+n.work_name+"</span><span style='display: none;'>"+n.sort_id+"</span></th>")
				$("thead>tr:eq(1)").append(th);
			});
			loadData();
		});
	});
//	pop_up_box.loadWait();
//	$.get("../pPlan/getProductionProcessInfo.do",{
//		"working_procedure_section":$(this).val()
//	},function(data){
//		pop_up_box.loadWaitClose();
//		$("thead>tr:eq(1)").html("");
//		$("thead>tr:eq(0)>th:eq(6)").attr("colspan",data.length);
//		$.each(data,function(i,n){
//			var th=$("<th class='gx'><span>"+n.work_name+"</span><span style='display: none;'>"+n.sort_id+"</span></th>")
//			$("thead>tr:eq(1)").append(th);
//		});
//		loadData();
//	});
	/////////////
	$("#working_procedure_section").change();
	function loadData(){
		pop_up_box.loadWait();
		$("tbody").html("");
		$.get("../pPlan/getProductionTrackingPage.do",{
			"count":count,
			"page":page,
			"searchKey":$.trim($("#searchKey").val()),
			"status":$.trim($("#status").val()),
			"send_date":$("#d4311").val(),
			"plan_end_date":$("#d4312").val(),
			"working_procedure_section":$("#working_procedure_section").val()
		},function(data){
			pop_up_box.loadWaitClose();
			addItem(data);
			totalPage=data.totalPage;
			count=data.totalRecord;
		});
	}
	$(".find").click(function(){
		page=0;
		count=0;
		loadData();
	});
	$(".secition_01 input").change(function(){
		page=0;
		count=0;
		loadData();
	});
	$(".notice").click(function(){
		pop_up_box.postWait();
		var work="";
		for (var i = 0; i < $("tbody tr").length; i++) {
			var tr=$("tbody tr").eq(i);
			if($.trim(tr.find("td").eq(tr.find("td").length-1).html())=="未生产"){
				for (var j = 0; j < $("th.gx").length; j++) {
					var n=$("th").index($("th.gx:eq("+j+")"))-2;
					var clerkid=$.trim(tr.find("td").eq(n).find("#clerkid").html());
					if(clerkid!=""){
						work=work+","+$("th.gx:eq("+j+")>span:eq(1)").html();
						break;
					}
				}
			}
		}
		$.post("../pPlan/noticeProduction.do",{
			"title":"生产派工通知",
			"work":work,
			"work_id":$.trim($("th.gx:eq(0)>span:eq(1)").html()),
			"description":"@comName-@clerkName：你有生产任务需要执行"
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.showMsg("通知成功!",function(){
					page=0;
					loadData();
				});
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
	});
	
	var paigongtr;
	function addItem(data){
		if(data){
			var len=data.rows.length-1;
			var mainthlen=$("thead tr:eq(0)>th").length-1;//左边主表部分长度
			var gxlen=$("thead tr:eq(1)>th").length;//左边主表部分长度
//			var mainthlen=$("th[data-name]").length-1;//左边主表部分长度
			
			$.each(data.rows,function(i,n){
				var names=["PH","corp_name","JHSL","plan_end_date","send_date","item_sim_name","status"];
				var item=getsctr(mainthlen+gxlen,names);
				if(i<len){
					//生成行
					$("tbody").append(item);com_id=$.trim(n.com_id);
					//1.放入主表数据
					for (var i = 0; i < 6; i++) {
						var j=$("th").index($("th[data-name='"+names[i]+"'"));
						if(names[i]=="plan_end_date"){
							var now=new Date(n[names[i]]);
							var nowStr = now.Format("yyyy-MM-dd hh:mm"); 
							item.find("td:eq("+j+")>div").html(nowStr);
						}else if(names[i]=="send_date"){
							var now=new Date(n[names[i]]);
							var nowStr = now.Format("yyyy-MM-dd"); 
							item.find("td:eq("+j+")>div").html(nowStr);
						}else if(names[i]=="item_sim_name"){
							if(n.item_sim_name==""){
								if(n.item_name==""){
									item.find("td:eq("+j+")>div").html("定制产品");
								}else{
									item.find("td:eq("+j+")>div").html(n.item_name);
								}
							}else{
								item.find("td:eq("+j+")>div").html(n.item_sim_name);
							}
							item.find("td:eq("+j+")>div").append('<span style="display: none;">'+$.trim(n.item_id)+$.trim(n.PH)+'</span>')
						}else if(names[i]=="status"){
							if(n[names[i]]=="0"){
								item.find("td").eq(6+$("thead>tr:eq(1)>th").length).html("未生产");
							}else if(n[names[i]]=="1"){
								item.find("td").eq(6+$("thead>tr:eq(1)>th").length).html("生产中");
							}else{
								item.find("td").eq(6+$("thead>tr:eq(1)>th").length).html("已完成");
							}
						}else{
							item.find("td:eq("+j+")>div").html(n[names[i]]);
						}
					}
					var item_id="<span class='item_id' style='display: none;'>"+$.trim(n.item_id)+"</span>";
					var customer_id="<span class='customer_id' style='display: none;'>"+$.trim(n.customer_id)+"</span>";
					var ivt_oper_listing="<span class='ivt_oper_listing' style='display: none;'>"+$.trim(n.ivt_oper_listing)+"</span>";//生产计划编号
					var detailauto_mps_id="<span class='detailauto_mps_id' style='display: none;'>"+$.trim(n.detailauto_mps_id)+"</span>";//销售订单编号
					item.find("td:eq(0)").append(item_id+ivt_oper_listing+detailauto_mps_id+customer_id);
				}else{
					//2.放入右边工序表数据
					var ki=0;
					for (var k = 0; k < len+1; k++) {
						if(n.zuoyelist[ki]!=undefined){
							for (var lk = 0; lk < n.zuoyelist.length; lk++) {
								var thi=$("th").index($("th:contains("+n.zuoyelist[lk].JSGXID+")"))-2;
								var tri=$("tbody tr").index($("tbody tr:contains("+$.trim(n.zuoyelist[lk].item_id)+$.trim(n.zuoyelist[lk].PH)+")"));
//								tri=$("tbody tr").index($("tbody tr:contains('"+$.trim(n.zuoyelist[lk].PH)+"'),tr:contains('"+$.trim(n.zuoyelist[lk].item_id)+"')"));
								var jz=$("tbody tr:eq("+tri+")").find("td:eq("+thi+")>.jz");
								var zuoye=n.zuoyelist[lk];
								var status=parseInt(zuoye.status);
								ki+=1;
								var item=$(emplitem.html());
								jz.append(item);
								item.find("#clerkName").html(zuoye.clerk_name);
								item.find("#num").html(zuoye.PGSL);
								item.find("#clerkid").html(zuoye.clerk_id);
								item.find(".pgdh").html(zuoye.pgdh);
								if(zuoye.plan_end_date){
									var now = new Date(zuoye.plan_end_date);
									var nowStr = now.Format("yyyy-MM-dd hh:mm"); 
									item.find("#plan_end_date").html(nowStr);
								}
								if(zuoye.WGSJ){
									var now = new Date(zuoye.WGSJ);
									var nowStr = now.Format("yyyyMMdd hh:mm"); 
									item.find("#WGSJ").html(nowStr);
								}
								item.find("#wgnum").html("完工"+zuoye.WGSL);
								if(status<0){//未派工
									item.find(".gh_top").addClass("bck01");
									paigongtrclick(jz);
								}else if(status==0){//已派工
									item.find(".gh_top").addClass("bck02");
								}else if(status==1){//生产中
									item.find(".gh_top").addClass("bck02");
								}else if(status==2){//质检中
									item.find(".gh_top").addClass("bck02");
								}else if(status==3){//已完成
									item.find(".gh_top").addClass("bck03");
								}else{
									
								}
							}
							addPaigongbtn(k, gxlen, mainthlen);
						}else{
							//
							addPaigongbtn(k, gxlen, mainthlen);
						}
					}
				}
				if(n.status=="0"){
					item.find("td").eq(6+$("thead>tr:eq(1)>th").length).html("未生产");
				}else if(n.status=="1"){
					item.find("td").eq(6+$("thead>tr:eq(1)>th").length).html("生产中");
				}else if(n.status=="-1"){
					item.find("td").eq(6+$("thead>tr:eq(1)>th").length).html("未派工");
				}else{
					item.find("td").eq(6+$("thead>tr:eq(1)>th").length).html("已完成");
				}
			});
		}
	}
	function addPaigongbtn(k,gxlen,mainthlen){
		var mainthlen=mainthlen-1;
		for (var i = 0; i < gxlen; i++) {
			var tdjz=$("tbody tr:eq("+k+")").find("td:eq("+(mainthlen+i)+")>div");
			if($.trim(tdjz.html())==""){
				var paigong=$(paigongitem.html());
				tdjz.html(paigong);
				var gx=$("th:eq("+(mainthlen+i+2)+")").html();
				var j=$("th").index($("th[data-name='PH'"));
				var ph=$("tbody tr:eq("+k+")").find("td:eq("+j+")>div").html();
				j=$("th").index($("th[data-name='plan_end_date'"));
				var plan_end_date=$("tbody tr:eq("+k+")").find("td:eq("+j+")>div").html();
				j=$("th").index($("th[data-name='JHSL'"));
				var JHSL=$.trim($("tbody tr:eq("+k+")").find("td:eq("+j+")>div").html());
				var item_id=$.trim($("tbody tr:eq("+k+")").find("td:eq(0)>.item_id").html());
				var customer_id=$.trim($("tbody tr:eq("+k+")").find("td:eq(0)>.customer_id").html());
				var ivt_oper_listing=$.trim($("tbody tr:eq("+k+")").find("td:eq(0)>.ivt_oper_listing").html());
				var orderNo=$.trim($("tbody tr:eq("+k+")").find("td:eq(0)>.detailauto_mps_id").html());
				//派工按钮点击事件
				paigong.click({"gx":gx,"PH":ph,"item_id":item_id,
					"ivt_oper_listing":ivt_oper_listing,"customer_id":customer_id,
					"orderNo":orderNo,"plan_end_date":plan_end_date,"pgsl":JHSL
				},function(event){
					$('.tck').show();
					$('.tc').show();
					paigongtr=$(this).parents(".jz");
//					var pgdh=$.trim($("#pgdh").html());///生成派工单号
//					if(pgdh==""){
//						$.get("../pPlan/getOrderNo.do",function(data){
//							$("#pgdh").html($.trim(data));
//						});
//					}
					$(".tc_div01_right:eq(0)").html(event.data.gx);
					$(".tc_div02>#PH").html(event.data.PH);
					$(".tc_div02>#item_id").html(event.data.item_id);
					$(".tc_div02>#customer_id").html(event.data.customer_id);
					$(".tc_div02>#ivt_oper_listing").html(event.data.ivt_oper_listing);
					$(".tc_div02>#orderNo").html(event.data.orderNo);
					$(".tc_div05 #plan_end_date").val(event.data.plan_end_date);
					$(".pgsl").html(event.data.pgsl);
					$(".imgk").html("");
					$(".tc_div03_right>.empl .emplinfo").remove();
					getWorkerList();
				});
			}							
			}
	}
	$(".clerkfind").click(function(){
		//获取该工序下的员工
		$.get("../pm/getWorkerList.do",{
			"work_id":$.trim($(".tc_div01_right:eq(0)").find("span:eq(1)").html()),
			"modal_searchKey":$.trim($("#clerkword").val())
		},function(data){
			$(".tc2>ul").html("");
			$.each(data,function(i,n){
				var workygitem=$($("#workygitem").html());
				$(".tc2>ul").append(workygitem);
				workygitem.find("span[data-name='clerk_name']").html(n.clerk_name);
				workygitem.find("span[data-name='clerk_id']").html(n.clerk_id);
				if($(".tc_div03_right>.empl").html().indexOf(n.clerk_id)>0){
					workygitem.find(".pro-check").addClass("pro-checked");
				}else{
					workygitem.find(".pro-check").removeClass("pro-checked");
				}
				workygitem.find("input[data-num='num']").bind("input propertychange blur",function(){
					var reg = new RegExp("^[0-9]*$");
					var val=$.trim($(this).val());
					if (!reg.test(val)) {
						val=val.substring(0, val.length - 1);
						$(this).val(val);
					}
					var pgsl=parseFloat($.trim($(".pgsl").html())); 
					if(pgsl>0){
						var prs=$(this).parents("ul").find(".pro-checked");
						var fpsl=0;
						for (var i = 0; i < prs.length; i++) {
							var pr=$(prs[i]).parents("li");
							fpsl+=parseFloat($.trim(pr.find("input[data-num='num']").val()));
						}
						if(fpsl>pgsl){
							$(this).val("");
							$(this).parents("li").find(".pro-check").removeClass("pro-checked");
							pop_up_box.showMsg("超出计划数量,请重新分配!");
						}else if(val!=""&&val!="0"){
							$(this).parents("li").find(".pro-check").addClass("pro-checked");
						}
					}
				});
			});
			//注册选择员工事件
			$(".tc2>ul").find('.pro-check').click(function(){
				var b = $(this).hasClass('pro-checked');
				if(b){
					$(this).removeClass('pro-checked');
				}
				else{
					$(this).addClass('pro-checked');
				}
			});
		});
	});
	function getWorkerList(){
		$(".clerkfind:eq(0)").click();
	}
	
	$('.find_position02').click(function(){
		var eminfos=$(this).parent().find(".emplinfo");
		eminfos.find(".pro-check").removeClass("pro-checked");
		for (var i = 0; i < eminfos.length; i++) {
			var em=$(eminfos[i]);
			var clerk_id=em.find("#clerkid").html();
			var ulli=$(".tc2>ul>li:contains("+clerk_id+")");
			if(ulli.length>0){
				ulli.find("input[data-num='num']").val(em.find("#num").html());
				ulli.find(".pro-check").addClass("pro-checked");
			}
		}
		$('.tc2').toggle();
	});
	///选择员工
	$(".clerkqd").click(function(){
		var clerks=$(".tc2>ul").find('.pro-checked');
		$(".tc_div03_right>.empl").html("");
		for (var i = 0; i < clerks.length; i++) {
			var item=$(clerks[i]).parent();
			var clerk_id=item.find("span[data-name='clerk_id']").html();
			var num= parseFloat(item.find("input[data-num='num']").val());
			if(!num||num<=0){
				pop_up_box.showMsg("请为选择的工人输入派工数量",function(){
					item.find("input[data-num='num']").focus().select();
				});
				return;
			}
			if($(".tc_div03_right>.empl").html().indexOf(clerk_id)<0){
				var emplinfoitem=$(emplinfo.html());
				$(".tc_div03_right>.empl").append(emplinfoitem);
				emplinfoitem.find("#name").html(item.find("span[data-name='clerk_name']").html());
				emplinfoitem.find("#num").html(num);
				emplinfoitem.find("#clerkid").html(clerk_id);
			}else{
				var empl=$(".tc_div03_right>.empl>.emplinfo:contains("+clerk_id+")");
				empl.find("#num").html(num);
			}
		}
		$('.tc2').hide();
	});
	function paigongtrclick(paigongbtn){
		paigongbtn.bind("click");
		paigongbtn.click(function(){
			$('.tck').show();
			$('.tc').show();
			paigongtr=$(this);
			var clks=$(this).find(".gh_top");
			$(".tc_div03_right>.empl").html("");
			for (var i = 0; i < clks.length; i++) {
				var clk=$(clks[i]);
				var empl=$(emplinfo.html());
				$(".tc_div03_right>.empl").append(empl);
				empl.find("#name").html(clk.find("#clerkName").html());
				empl.find("#clerkid").html(clk.find("#clerkid").html());
				empl.find("#num").html(clk.find("#num").html());
				empl.find("#pgdhc").html(clk.find(".pgdh").html());
			}
			$(".tc_div02>.pgdh").html(paigongtr.find(".pgdh").html());
			$(".tc_div05 #plan_end_date").val(paigongtr.find("#plan_end_date").html());
			var tr=paigongtr.parents("tr");
			var thi=tr.find("td").index(paigongtr.parents("td"));
			var gx=$("th:eq("+(thi+2)+")").html();//获取工序列数
			$(".tc_div01_right:eq(0)").html(gx);
			var tri=$("tbody tr").index(tr);
			var j=$("th").index($("th[data-name='PH'"));
			var ph=$("tbody tr:eq("+tri+")").find("td:eq("+j+")>div").html();
			j=$("th").index($("th[data-name='JHSL'"));
			var JHSL=$("tbody tr:eq("+tri+")").find("td:eq("+j+")>div").html();
			var JHSL=$.trim($("tbody tr:eq("+tri+")").find("td:eq("+j+")>div").html());
			$(".tc_div02>#PH").html(ph);
			$(".pgsl").html(JHSL);
			var item_id=$.trim($("tbody tr:eq("+tri+")").find("td:eq(0)>.item_id").html());
			var customer_id=$.trim($("tbody tr:eq("+tri+")").find("td:eq(0)>.customer_id").html());
			var ivt_oper_listing=$.trim($("tbody tr:eq("+tri+")").find("td:eq(0)>.ivt_oper_listing").html());
			var orderNo=$.trim($("tbody tr:eq("+tri+")").find("td:eq(0)>.detailauto_mps_id").html());
			$(".tc_div02>#item_id").html(item_id);
			$(".tc_div02>#customer_id").html(customer_id);
			$(".tc_div02>#ivt_oper_listing").html(ivt_oper_listing);
			$(".tc_div02>#orderNo").html(orderNo);
			getWorkerList();
		});
	}
	///保存派工
	$('.tc_div07>button:eq(1)').click(function(){
		var plan_end_date=$(".tc_div05 #plan_end_date").val();
		if(plan_end_date==""){
			pop_up_box.showMsg("请选择要求完工时间!");
			return;
		}else if($(".tc_div03_right>.empl .emplinfo").length<=0){
			pop_up_box.showMsg("请选择工人!");
			return;
		}
		$('.tck').hide();
		$('.tc').hide();
		$('.tc2').hide();
		var JSGR=[];
		var batch_mark="";
		var pgdh=$.trim($(".tc_div02").find(".pgdh").html());
		if(!pgdh){
			pgdh="";
		}
		pop_up_box.postWait();
		for (var i = 0; i < $(".tc_div03_right>.empl .emplinfo").length; i++) {
			var iteminfo=$($(".tc_div03_right>.empl .emplinfo")[i]);
			var clerkid=$.trim(iteminfo.find("#clerkid").html());
			var num=$.trim(iteminfo.find("#num").html());
			var pgdhc=$.trim(iteminfo.find("#pgdhc").html());
			if(clerkid!=""&&num!=""){
				var name=$.trim(iteminfo.find("#name").html());
				var json={"clerkid":clerkid,"PGSL":num,"pgdh":pgdhc};
				JSGR.push(JSON.stringify(json));
				//回显到列表中
				paigongtr.find("button").hide();
				var item=paigongtr.find(".gh:contains("+clerkid+")");
				if(item.length<=0){
					item=$(emplitem.html());
					paigongtr.append(item);
				}
				item.find(".gh_top").addClass("bck01");
				item.find("#clerkName").html(name);
				item.find("#num").html(num);
				item.find(".pgdh").html(pgdh);
				item.find("#clerkid").html(clerkid);
				item.find("#plan_end_date").html(plan_end_date);
				paigongtrclick(paigongtr);
			}
		}
		var imgPath="";
		var imgs=$(".imgk>img");
		for (var i = 0; i < imgs.length; i++) {
			var img=imgs[i];
			imgPath+=replaceAll($(img).attr("src"),"\\.\\.",'');
		}
		$.post("../pPlan/savePaigong.do",{
			"PH":$(".tc_div02").find("#PH").html(),//排产编号
			"pgdh":pgdh,//派工单号
			"working_procedure_section":$("#working_procedure_section").val(),
			"demand_type":"订单式生产",
			"customer_id":$(".tc_div02").find("#customer_id").html(),//订单编号
			"auto_mps_id":$(".tc_div02").find("#orderNo").html(),//订单编号
			"item_id":$(".tc_div02").find("#item_id").html(),//产品编号
			"plan_end_date":plan_end_date,//计划完工时间WGSJ
			"ivt_oper_listing":$(".tc_div02").find("#ivt_oper_listing").html(),//生产计划单号
			"work_id":$(".tc_div01 .gx").find("span:eq(1)").html(),//工序编码JSGXID
			"batch_mark":batch_mark,//批次
//			"WGSJ":$("#WGSJ").val(),//要求完工时间
			"JSGR":"["+JSGR.join(",")+"]",//派工工人
			"status":"-1",
			"imgPath":imgPath,
			"PGSL":$.trim($(".pgsl").html())//派工数量
		},function(data){
			pop_up_box.loadWaitClose();
			if (data.success) {
				pop_up_box.toast("提交成功", 1000);
				paigongtr.find(".pgdh").html($.trim(data.msg));
			} else {
				if (data.msg) {
					pop_up_box.showMsg("保存错误!" + data.msg);
				} else {
					pop_up_box.showMsg("保存错误!");
				}
			}
		});
		$('.tck').hide();
		$('.tc').hide();
		$('.tc2').hide();
	});
	//////////////////////////
	$('.pro-check').click(function(){
		var b = $(this).hasClass('pro-checked');
		if(b){
			$(this).removeClass('pro-checked')
		}
		else{
			$(this).addClass('pro-checked')
		}
	});
	$('.zz>button').eq(0).click(function(){
		$('.tck').show();
		$('.tc').show();
	});
	$('.tck,.tc_div07>button:eq(0)').click(function(){
		$('.tck').hide();
		$('.tc').hide();
		$('.tc2').hide();
	});

	$('.tc2>ul>li>button').click(function(){
		$('.tc2').hide();
	});
	$('.jz').css('marginTop',$('.zz').height()/2-$('.jz').height()/2);
	$('.imgk>img').click(function(){
		$('.zz2').toggle();
	});
	$('.zz2').click(function(){
		$('.zz2').hide();
	});
	
});

function imgUpload(t) {
//	var item_id=t.parents(".tc_div").find("#item_id").html();
//	var work_id=t.parents(".tc_div").find(".gx>span:eq(1)").html();
//	var pgdh=t.parents(".tc_div").find(".pgdh").html();
//	var imgPath="/"+com_id+"/sctz/"+pgdh+"/"+work_id+"/"+item_id+".jpg";
	ajaxUploadFile({
		"uploadUrl" : "../upload/uploadImage.do?fileName=imgFile",
		"msgId" : "msg",
		"fileId" : "imgFile",
		"msg" : "图片",
		"fid" : "",
		"uploadFileSize" : 20
	}, t, function(imgurl) {
//		$("#filePath").val(imgurl);
//		$(".upload-img").find("img").attr("src",
//				"../" + imgurl + "?ver=" + Math.random());
		$(".imgk").append('<img class="img-responsive" src="..'+imgurl+'">');
	});
}