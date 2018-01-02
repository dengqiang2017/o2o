var id=getQueryString("id");
var now = new Date();
var nowStr = now.Format("yyyy-MM-dd"); 
var onedays=nowStr.split("-");
login_url="../pc/login-yuangong.html?com_id=001";
// $(".Wdate:eq(0)").val(onedays[0]+"-"+onedays[1]+"-01"); 
// $(".Wdate:eq(1)").val(nowStr);
var count=0;
var page=0;
var totalPage=0;
$(".Wdate").val(nowStr);
function loadData(){
$("tbody").html("");
if(totalPage<0){
	totalPage=0;
}
$("#page").html("第"+(page+1)+"页/共"+(totalPage+1)+"页");
$.get("../client/ganzhiRecordPage.do",{
	"id":id,
	"page":page,
	"count":count,
	"rows":10,
	"com_id":getQueryString("com_id"),
	"beginDate":$(".Wdate:eq(0)").val(),
	"endDate":$(".Wdate:eq(1)").val(),
	"searchKey":$("#searchKey").val()
},function(data){
	if(data&&data.rows.length>0){
		var len=$("thead th").length;
		$.each(data.rows,function(xh,n){
			var tr=getTr(len);
			$("tbody").append(tr);
			for (var i = 0; i < len; i++) {
				var th=$($("thead th")[i]);
				var name=$.trim(th.attr("data-name"));
				var show=th.css("display");
				var j=$("thead th").index(th);
				if(show=="none"){
					tr.find("td:eq("+j+")").hide();
				}else{
					if(name=="xuhao"){
						tr.find("td:eq("+j+")").html(xh+1);
					}else if(name=="readTime"){
						var now = new Date(n.readTime);
						var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
						tr.find("td:eq("+j+")").html(nowStr);
					}else if(name=="endTime"){
						if(n.endTime){
							var now = new Date(n.endTime);
							var nowStr = now.Format("yyyy-MM-dd hh:mm:ss");
							tr.find("td:eq("+j+")").html(nowStr);
						}
					}else if(name=="article_name"){//
						if(n.article_id.indexOf("html")>0){
							tr.find("td:eq("+j+")").html("<a target='_blank' href='article_detail.jsp?url="+n.article_id+"'>"+n[name]+"</a>");
						}else{
							tr.find("td:eq("+j+")").html(n[name]);
						}
					}else{
						tr.find("td:eq("+j+")").html(n[name]);
					}
				}
			}
		});
	}
	count=data.totalRecord;
	totalPage=data.totalPage;
	if(totalPage<0){
		totalPage=0;
	}
	$("#page").html("第"+(page+1)+"页/共"+(totalPage+1)+"页");
	pageShow(totalPage);
});
}
loadData();
