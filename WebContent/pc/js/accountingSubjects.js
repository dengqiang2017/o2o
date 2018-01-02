var expenses_id = "";
var expenses_name = "";
var subject_type_id = "";
var expenses_unitprice = "";
var upper_expenses_id = "";
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
		$.get("../manager/getAccountingSubjects.do",{
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
		var expenses_id = $("#expenses_id").val().trim();
		var expenses_name = $("#expenses_name").val().trim();
		var subject_type_id = $("#subject_type_id").val().trim();
		var expenses_unitprice = $("#expenses_unitprice").val().trim();
		var upper_expenses_id = $("#upper_expenses_id").val().trim();
		if(expenses_id && expenses_name){
			pop_up_box.loadWait();
			$.get("../manager/addAccountingSubjects.do",{
				"expenses_id" : expenses_id,
				"expenses_name" : expenses_name,
				"subject_type_id" : subject_type_id,
				"expenses_unitprice" : expenses_unitprice,
				"upper_expenses_id" : upper_expenses_id,
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
		if(expenses_id){
			$("#expenses_id").val(expenses_id);
			$("#expenses_name").val(expenses_name);
			$("#subject_type_id").val(subject_type_id);
			$("#expenses_unitprice").val(expenses_unitprice);
			$("#upper_expenses_id").val(upper_expenses_id);
			$("#expenses_id").attr("disabled",true);
			$("#expenses_name").removeAttr("disabled");
			$("#subject_type_id").removeAttr("disabled");
			$("#expenses_unitprice").removeAttr("disabled");
			$("#upper_expenses_id").removeAttr("disabled");
			oper_flag = "1";
			$("#addForm").show();
		}
	});
	
	//删除
	$("#del").click(function(){
		if(expenses_id){
			$("#expenses_id").val(expenses_id);
			$("#expenses_name").val(expenses_name);
			$("#subject_type_id").val(subject_type_id);
			$("#expenses_unitprice").val(expenses_unitprice);
			$("#upper_expenses_id").val(upper_expenses_id);
			$("#expenses_id").attr("disabled",true);
			$("#expenses_name").attr("disabled",true);
			$("#subject_type_id").attr("disabled",true);
			$("#expenses_unitprice").attr("disabled",true);
			$("#upper_expenses_id").attr("disabled",true);
			oper_flag = "2";
			$("#addForm").show();
		}
	});
});

//增加tr
var getTr = function(n){
	var str = "";
	str += "<tr>";
	str += "<td>" + n.expenses_id + "</td>";
	str += "<td>" + n.expenses_name + "</td>";
	str += "<td>" + n.subject_type_id + "</td>";
	str += "<td>" + n.expenses_unitprice + "</td>";
	str += "<td style='display:none;'>" + n.upper_expenses_id + "</td>";
	str += "</tr>";
	return str;
};

//选择值
var chooseIt = function(data){
	$("tbody").find("tr").each(function(){
		$(this).css('background-color','#FFFFFF');
	});
	$(data).css('background-color','#337AB7');
	expenses_id = $(data).find("td:eq(0)")[0].innerText;
	expenses_name = $(data).find("td:eq(1)")[0].innerText;
	subject_type_id = $(data).find("td:eq(2)")[0].innerText;
	expenses_unitprice = $(data).find("td:eq(3)")[0].innerText;
	upper_expenses_id = $(data).find("td:eq(4)")[0].innerText;
};

//初始化值
var init = function(){
	expenses_id = "";
	expenses_name = "";
	subject_type_id = "";
	expenses_unitprice = "";
	upper_expenses_id = "";
	
	$("#expenses_id").val("");
	$("#expenses_name").val("");
	$("#subject_type_id").val("");
	$("#expenses_unitprice").val("");
	$("#upper_expenses_id").val("");
	$("#expenses_id").removeAttr("disabled");
	$("#expenses_name").removeAttr("disabled");
	$("#subject_type_id").removeAttr("disabled");
	$("#expenses_unitprice").removeAttr("disabled");
	$("#upper_expenses_id").removeAttr("disabled");
	$("#addForm").hide();
};