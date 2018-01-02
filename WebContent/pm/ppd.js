var ppd={
		open:function(t,s,k){
			if($(t).parents(".form-inline").next().css("display")=="none"){
				$(t).parents(".form-inline").next().show(300);
				if(s){
					$(t).html("收起"+s);
				}else{
					$(t).html("收起工序");
				}
			}else{
				if(!k){
					$(t).parents(".form-inline").next().hide(300);
					if(s){
						$(t).html("展开"+s);
					}else{
						$(t).html("展开工序");
					}
				}
			}
		},
		init:function(){
			var path="productionProcess.json";
			$("input").val("");
			common.initNumInput();
			//增加工段
			$("#addGd").click(function(){
				var item=$($("#gongduanItem").html());
				$(".list").append(item);
				addGx();
				item.find(".gdName").focus();
			});
			function addGx(){
				$(".addGx").unbind("click");
				$(".addGx").click(function(){
					var item=$($("#gongxuItem").html());
					$(this).parents(".gongduan").find(".gongxuList").append(item);
					item.find("input").val("");
					common.initNumInput();
					addNextGx();
					item.find(".gxName").focus();
					ppd.open(this,null,"show");
					$(".gongxuNextList").sortable({axis:"y"});
				});
				addNextGx();
			}
			function addNextGx(){
				$(".addNextGx").unbind("click");
				$(".addNextGx").click(function(){
					var item=$($("#gongxuNextItem").html());
					$(this).parents(".gongxu").find(".gongxuNextList").append(item);
					item.find("input").val("");
					common.initNumInput();
					item.find(".gxName").focus();
					ppd.open(this,"下级","show");
				});
			}
			$('#scroll').click(function() {
				$("html,body").animate({
					scrollTop : 0
				}, 200);
			});
			
			$(".list").html("");
//			$.get("../001/"+path+"?ver="+Math.random(),function(data){
			$.get("../manager/getJSONArrayByFile.do",{"path":path},function(data){
				for (var i = 0; i < data.length; i++) {
					var gd=data[i];
					var item=$($("#gongduanItem").html());
					$(".list").append(item);
					item.find(".gdName").val(gd.gdName);
					item.find(".gdNo").val(gd.gdNo);
					item.find(".use").prop('checked',gd.use);
					if(gd.gongxuItem&&gd.gongxuItem.length>0){
						for (var j = 0; j < gd.gongxuItem.length; j++) {
							var gx=gd.gongxuItem[j];
							var gxItem=$($("#gongxuItem").html());
							item.find(".gongxuList").append(gxItem);
							gxItem.find(".gxName").val(gx.gxName);
							gxItem.find(".gxNo").val(gx.gxNo);
							gxItem.find(".gxPrice").val(gx.gxPrice);
							gxItem.find(".use").prop('checked',gx.use);
							if(gx.nextItem&&gx.nextItem.length>0){
								for (var k = 0; k < gx.nextItem.length; k++) {
									var gxnext=gx.nextItem[k];
									var gxnextitem=$($("#gongxuNextItem").html());
									gxItem.find(".gongxuNextList").append(gxnextitem);
									gxnextitem.find(".gxName").val(gxnext.gxName);
									gxnextitem.find(".gxNo").val(gxnext.gxNo);
									gxnextitem.find(".gxPrice").val(gxnext.gxPrice);
									gxnextitem.find(".use").prop('checked',gxnext.use);
								}
							}
						}
					}
				}
				addGx();
				$(".gongxuList,.gongxuNextList").hide();
				$(".gongxuList").sortable({axis:"y"});
				$(".gongxuNextList").sortable({axis:"y"});
			});
			$("#save").click(function(){
				var list=[];
				var items=$(".list .gongduan");
				for (var i = 0; i < items.length; i++) {
					var item=$(items[i]);
					var gdName=$.trim(item.find(".form-inline .gdName").val());
					var gdNo=$.trim(item.find(".form-inline .gdNo").val());
					var use=item.find(".form-inline .use").prop('checked');
					var gongduanJson={};
					gongduanJson.use=use;
					gongduanJson.gdName=gdName;
					gongduanJson.gdNo=gdNo;
					var gongxuItems=item.find(".gongxu");
					if(gongxuItems&&gongxuItems.length>0){
						gongduanJson.gongxuItem=[];
						for (var j = 0; j < gongxuItems.length; j++) {
							var gongxuItem=$(gongxuItems[j]);
							var gxName=gongxuItem.find(".form-inline .gxName").val();
							var gxNo=gongxuItem.find(".form-inline .gxNo").val();
							var gxPrice=gongxuItem.find(".form-inline .gxPrice").val();
							var use=gongxuItem.find(".form-inline .use").prop('checked');
							var gongxuJson={};
							gongxuJson.use=use;
							gongxuJson.gxName=gxName;
							gongxuJson.gxNo=gxNo;
							gongxuJson.gxPrice=gxPrice;
							var gongxuNextItems=gongxuItem.find(".gongxu-next-item");
							if(gongxuNextItems&&gongxuNextItems.length>0){
								gongxuJson.nextItem=[];
								for (var k = 0; k < gongxuNextItems.length; k++) {
									var gongxuNextItem=$(gongxuNextItems[k]);
									var gxName=gongxuNextItem.find(".gxName").val();
									var gxNo=gongxuNextItem.find(".gxNo").val();
									var gxPrice=gongxuNextItem.find(".gxPrice").val();
									var use=gongxuNextItem.find(".use").prop('checked');
									var gongxuNextJson={};
									gongxuNextJson.use=use;
									gongxuNextJson.gxName=gxName;
									gongxuNextJson.gxNo=gxNo;
									gongxuNextJson.gxPrice=gxPrice;
									gongxuJson.nextItem.push(gongxuNextJson);
								}
							}
							gongduanJson.gongxuItem.push(gongxuJson);
						}
					}
				list.push(JSON.stringify(gongduanJson));
				}
				$.post("../manager/saveJSONArrayFile.do",{
					"jsons":"["+list.join(",")+"]",
					"path":path
				},function(data){
					if (data.success) {
						pop_up_box.showMsg("保存成功!");
					} else {
						if (data.msg) {
							pop_up_box.showMsg("保存错误!" + data.msg);
						} else {
							pop_up_box.showMsg("保存错误!");
						}
					}
				});
			});
		}
}
$(function(){
	ppd.init();
});