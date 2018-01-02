product={
		init:function(func){
			function getTr(product){
				var tr="<tr><td><input type='hidden' value='"+ifnull(product.item_id)+"'>"+ifnull(product.class_card)+"</td><td>"+ifnull(product.item_sim_name)+"</td>";
				tr+="<td>"+numformat2(ifnull(product.use_oq))+"</td>";
				tr+="<td>"+ifnull(product.item_spec)+"</td>";
				tr+="<td>"+ifnull(product.item_type)+"</td>";
				tr+="<td>"+ifnull(product.item_color)+"</td>";
				tr+="<td>"+numformat2(ifnull(product.item_zeroSell))+"</td>";
				tr+="<td>"+numformat2(ifnull(product.item_Sellprice))+"</td>";
				tr+="<td>"+(ifnull(product.sort_name))+"</td>";
				tr+="<td>"+(ifnull(product.peijian_id))+"</td>";
				tr+="<td>"+ifnull(product.item_id)+"</td></tr>";
				return tr;
			}
			var setto2o=o2otree; 
			$(".modal").find(".tabs-content:eq(1)").show();
			var treePage={
					page:0,
					totalPage:0,
					totalRecord:0
			};
			$(".modal").find("#closeTree,.close").click(function(){
				$(".modal,.modal-cover").hide();
			});
			$(".modal").find("#findtree").unbind("click");
			$(".modal").find("#findtree").click(function(){
				treePage.page=0;
				loadData(0);
			});
			loadData(0);
			function loadData(page){
				pop_up_box.loadWait();
				$.get("../manager/getProductList.do",{
					"searchKey":$("#itemName").val(),
					"page":page,
					"client":"3",
					"totalRecord":treePage.totalRecord,
					"totalPage":treePage.totalPage
				},function(data){
					pop_up_box.loadWaitClose();
					$(".modal").find("tbody").html("");
					$.each(data.rows,function(i,n){
						$(".modal").find("tbody").append(getTr(n));
					});
					treePage.totalPage=data.totalPage;
					treePage.totalRecord=data.totalRecord;
					select_Tree();
					treeSelectId="";
					$("#page").html("当前页:"+page);
					$(".modal").find("tbody>tr").dblclick(function(){
						$(".modal").find("#selectClient").click();
					});
				});
			}
			if($.trim($(".modal").find("tbody").html())==""){
			$(".modal").find("#findtree").click();
			}
			
			$(".modal").find("#selectClient").unbind("click");
 			$(".modal").find("#selectClient").click(function(){
				if(treeSelectId==""){
					alert("请选择一个产品");
				}else{
					if (func) {
						func();
					}
					$(".modal,.modal-cover").hide();
				}
			});
			
// 			treePage.totalPage=${requestScope.pages.totalPage};
			//1.首页
			$(".modal").find("#beginpage").unbind("click");
			$(".modal").find("#beginpage").click(function(){
				treePage.page=0;
				loadData(0);
			});
			//2.尾页
			$(".modal").find("#endpage").unbind("click");
			$(".modal").find("#endpage").click(function(){
				treePage.page=treePage.totalPage;
				loadData(treePage.totalPage);
			});
			$(".modal").find("#uppage").unbind("click");
			$(".modal").find("#uppage").click(function(){
				var page=treePage.page;
				page=parseInt(page)-1;
				if (page>=0) {
					treePage.page=page;
					loadData(page);
				}else{
					pop_up_box.showMsg("已到第一页!");
				}
			});
			$(".modal").find("#nextpage").unbind("click");
			$(".modal").find("#nextpage").click(function(){
				var  totalpage=treePage.totalPage;
				var  page=parseInt(treePage.page)+1;
				if (page<=totalpage) {
					treePage.page=page;
					loadData(page);
				}else{
					pop_up_box.showMsg("已到最后一页!");
				}
			});
	}
}