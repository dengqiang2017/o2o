URLFiltering();
$(function(){
$('.side-cover').hide();
    var itemhtml=$("#infopage .secition>ul").html();
    $(".header:eq(0) a").attr("href",document.referrer);
    $("#infopage .secition>ul").html("");
    $.get("../customer/getFHDZList.do",function(data){
    	if(data&&data.length>0){
    		$.each(data,function(i,n){
    			var item=$(itemhtml);
    			$("#infopage .secition>ul").append(item);
    			item.find(".name").html(n.lxr);
    			item.find(".cell").html(n.lxPhone);
    			item.find(".site").html(n.fhdz);
    			if(n.mr){
    				item.find(".set").find('span').text('默认地址');
    				item.find(".set").find('i.fa').removeClass('fa-square-o').addClass('fa-check-square');
    			}else{
    				item.find(".set").find('i.fa').removeClass('fa-check-square').addClass('fa-square-o');
    			}
    		});
    		caozuo.init();
    	}
    });
    var caozuo={
    		init:function(){
    			$('#infopage .set').unbind("clikc");
    			$('#infopage .set').click(function(){
        	        $('#infopage .set').find('i').removeClass('fa-check-square').addClass('fa-square-o');
        	        $('#infopage .set').find('span').text('设为默认');
        	       $(this).find('span').text('默认地址');
        	       $(this).find('i').removeClass('fa-square-o').addClass('fa-check-square');
        	       savefhdz();
        	    });
    			$('#infopage .del').unbind("clikc");
        		$('#infopage .del').click(function(){
        	        if(confirm("是否删除!")){
        	        	$(this).parents("li").remove();
        	        	savefhdz();
        	        }
        	    });
        		$('#infopage .eidt>a').unbind("clikc");
        		$("#infopage .eidt>a").click(function(){
        			var item=$(this).parents("li");
    		    	$("#editPage,.header:eq(1)").show();
    		    	$("#infopage,.header:eq(0)").hide();
    		    	$("#editPage input[name='lxr']").val(item.find(".name").html());
    		    	$("#editPage input[name='lxPhone']").val(item.find(".cell").html());
    		    	$("#editPage textarea[name='fhdz']").val(item.find(".site").html());
    		    	var i=item.find(".fa-check-square").length>0;
    		    	if(i>0){
    		    		$("#editPage").find("i.fa").addClass("fa-check-square").removeClass("fa-square-o");
    		    	}else{
    		    		$("#editPage").find("i.fa").removeClass("fa-check-square").addClass("fa-square-o");
    		    	}
    		    	$("#savefhdz").unbind("click");
    		    	$("#savefhdz").click(function(){
    		    		item.find(".name").html($("#editPage input[name='lxr']").val());
    		    		item.find(".cell").html($("#editPage input[name='lxPhone']").val());
    		    		item.find(".site").html($("#editPage textarea[name='fhdz']").val());
    		    		var i=$("#editPage").find(".fa-check-square").length>0;
    		    		if(i>0){
    		    			$("#infopage").find("i.fa").removeClass("fa-check-square").addClass("fa-square-o");
    		    			item.find("i.fa").addClass("fa-check-square").removeClass("fa-square-o");
    		    		}else{
    		    			item.find("i.fa").removeClass("fa-check-square").addClass("fa-square-o");
    		    		}
    		    		$("#editPage,.header:eq(1)").hide();
    		    		$("#infopage,.header:eq(0)").show();
    		    		savefhdz();
    		    	});
        		});
    		}
    }
    
    function savefhdz(){
    	var list=$("#infopage .secition>ul>li");
    	if(list&&list.length>0){
    		var fhdzlist=[];
    		for (var i = 0; i < list.length; i++) {
				var item=$(list[i]);
				var json={};
				json.lxr=item.find(".name").html();
				json.lxPhone=item.find(".cell").html();
				json.fhdz=item.find(".site").html();
				var j=item.find(".fa-check-square").length>0;
				if(j>0){
					json.mr=true;
				}else{
					json.mr=false;
				}
				fhdzlist.push(JSON.stringify(json));
			}
    		if(fhdzlist.length>0){
    			pop_up_box.postWait();
    			$.post("../customer/saveFHDZList.do",{
    				"fhdzlist":"["+fhdzlist.join(",")+"]"
    			},function(data){
    				pop_up_box.loadWaitClose();
    				if (data.success) {
    					pop_up_box.toast("保存成功",1000);
					} else {
						if (data.msg) {
							pop_up_box.showMsg("保存错误!" + data.msg);
						} else {
							pop_up_box.showMsg("保存错误!");
						}
					}
    			});
    		}
    	}
    	
    }
    $("#addfhdz").click(function(){
    	$("#editPage,.header:eq(1)").show();
    	$("#infopage,.header:eq(0)").hide();
    	$("#editPage input[name='lxr']").val("");
    	$("#editPage input[name='lxPhone']").val("");
    	$("#editPage textarea[name='fhdz']").val("");
    	$("#editPage").find(".fa-square-o").removeClass("fa-check-square");
    	$("#savefhdz").unbind("click");
    	$("#savefhdz").click(function(){
    		var item=$(itemhtml);
			$("#infopage .secition>ul").append(item);
    		item.find(".name").html($("#editPage input[name='lxr']").val());
    		item.find(".cell").html($("#editPage input[name='lxPhone']").val());
    		item.find(".site").html($("#editPage textarea[name='fhdz']").val());
    		var i=$("#editPage").find(".fa-check-square").length>0;
    		if(i>0){
    			$("#infopage").find("i.fa").removeClass("fa-check-square").addClass("fa-square-o");
    			item.find("i.fa").addClass("fa-check-square").removeClass("fa-square-o");
    		}else{
    			item.find("i.fa").removeClass("fa-check-square").addClass("fa-square-o");
    		}
    		$("#editPage,.header:eq(1)").hide();
    		$("#infopage,.header:eq(0)").show();
    		caozuo.init();
    		savefhdz();
    	});
    });
    $('#editPage .set').click(function(){
        if($(this).find('i').hasClass('fa-check-square')){
            $(this).find('i').removeClass('fa-check-square').addClass('fa-square-o')
        }
        else{
            $(this).find('i').removeClass('fa-square-o').addClass('fa-check-square')
        }
    });
});