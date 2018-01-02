var producarea_id = "";
var producarea_name = "";
var oper_flag = "";//0增加、1修改、2删除

$(function(){
	//初始化
	init();
	$("tbody").html("");
	
	//查找
	$("#find").click(function(){
		init();
		$("tbody").html("");
		pop_up_box.loadWait();
		$.get("../manager/getProducarea.do",{
			"ver":Math.random()
		},function(data){
			pop_up_box.loadWaitClose();
			$.each(data,function(i,n){
				$("tbody").append(getTr(n));
			});
			$("tbody").find("tr").each(function(){
				$(this).attr("onclick","chooseIt(this)");
			});
		});
	});
	$("#find").click();
	
	//增加
	$("#add").click(function(){
		init();
		oper_flag = "0";
		$("#addForm").show();
	});
	
	//增加保存
	$("#save").click(function(){
		var producarea_id = $("#producarea_id").val().trim();
		var producarea_name = $("#producarea_name").val().trim();
		if(producarea_id && producarea_name){
			pop_up_box.loadWait();
			$.get("../manager/addProducarea.do",{
				"producarea_id" : producarea_id,
				"producarea_name" : producarea_name,
				"oper_flag" : oper_flag,
				"ver":Math.random()
			},function(data){
				pop_up_box.loadWaitClose();
				$("#find").click();
			});
		}
	});
	
	//修改
	$("#edit").click(function(){
		if(producarea_id){
			$("#producarea_id").val(producarea_id);
			$("#producarea_name").val(producarea_name);
			$("#producarea_id").attr("disabled",true);
			$("#producarea_name").removeAttr("disabled");
			oper_flag = "1";
			$("#addForm").show();
		}
	});
	
	//删除
	$("#del").click(function(){
		if(producarea_id){
			$("#producarea_id").val(producarea_id);
			$("#producarea_name").val(producarea_name);
			$("#producarea_id").attr("disabled",true);
			$("#producarea_name").attr("disabled",true);
			oper_flag = "2";
			$("#addForm").show();
		}
	});
});

//增加tr
var getTr = function(n){
	var str = "";
	str += "<tr>";
	str += "<td>" + n.producarea_id + "</td>";
	str += "<td>" + n.producarea_name + "</td>";
	str += "</tr>";
	return str;
};

//选择值
var chooseIt = function(data){
	$("tbody").find("tr").each(function(){
		$(this).css('background-color','#FFFFFF');
	});
	$(data).css('background-color','#337AB7');
	producarea_id = $(data).find("td:eq(0)")[0].innerText;
	producarea_name = $(data).find("td:eq(1)")[0].innerText;
};

//初始化值
var init = function(){
	producarea_id = "";
	producarea_name = "";
	oper_flag = "";
	
	$("#producarea_id").val("");
	$("#producarea_name").val("");
	$("#producarea_id").removeAttr("disabled");
	$("#producarea_name").removeAttr("disabled");
	$("#addForm").hide();
};