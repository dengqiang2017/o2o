var customer_id;
var imgPath;
$.get("../customer/getCustomerInfo.do",function(data){
	customer_id=data.customer_id;
	$("#corp_sim_name").val(data.corp_sim_name);
	$("#clerk_name").html(data.corp_sim_name);
	$("#tel_no").val(data.user_id);
	$("#weixin").val(data.weixin);
	$("#sex").val(data.sex);
	imgPath="001/userpic/"+customer_id+"/Pic_You.png";
	$("#user_logo").attr("src","../"+imgPath+"?ver="+Math.random());
    $("input[type='tel'],input[type='text']").prop('disabled',true);
    $("select").prop('disabled',true);
});
$(function(){
	if (is_weixin()) {//微信端上传图片
		$("#sctx").show();
		$("#upload-btn").hide();
		weixinfileup.init();
		$("#sctx").click(function(){
			weixinfileup.imguploadToWeixin(this, imgPath, $("#user_logo"))
		});
	}else{
		$("#upload-btn").show();
	}
	/////////////////
    $(".myorder_up").click(function(){//注册图片选择框 选择或者取消功能
        var b=$(this).hasClass("myorder_down");
        if (b) {
            $(this).removeClass("myorder_down");
        }else{
            $(this).addClass("myorder_down");
        }
    });
    $('.myorder>.myorder_up').click(function(){
        $('.myorder_list').toggle();
    });
    $('.mymaterial>.myorder_up').click(function(){
        $('.mymaterial_list').toggle();
    });
    $('.mylocation>.myorder_up').click(function(){
        $('.mylocation_list').toggle();
    });
    $('.mydriver>.myorder_up').click(function(){
        $('.mydriver_list').toggle();
    });
    ///////////////
    /**
     * 获取发货地址 返回json字符串
     */
    function getfhdz(li){
		var json={};
		var lxr=li.find("#lxr").val();
		var lxPhone=li.find("#lxPhone").val();
		var fhdz=li.find("#fhdz").val();
		var mr=li.find("#deft>.list04_left_img").hasClass("list03_left_img");
		json.lxr=lxr;
		json.lxPhone=lxPhone;
		json.fhdz=fhdz;
		json.mr=mr;
		return JSON.stringify(json);
    }
    /**
     * 保存发货地址
     */
    function savefhdz(){
    	var lis=$("#fhdzlist").find("li");
		var list="[";
		for (var i = 0; i < lis.length; i++) {
			list+=getfhdz($(lis[i]))+",";
		}
		list=list.substring(0, list.length-1);
		list+="]";
		$.post("../customer/saveFHDZList.do",{
			"fhdzlist":list
		},function(data){
			
		});
    }
    function delfhdz(t){
    	var li=$(t).parents("li");
    	var b=li.find(".list04_left_img").hasClass("list03_left_img");
		li.remove();
		if (b) {//判断删除的是否是默认项,是默认项就将第一列设置为默认项
			var lis=$("#fhdzlist").find("li");
			$(lis[0]).find(".list04_left_img").addClass("list03_left_img");
		}
		savefhdz();
    }
    function editfhdz(t){
    	var li=$(t).parents("li");
    	var lxr=$.trim(li.find("#lxr").val());
		   var lxPhone=$.trim(li.find("#lxPhone").val());
		   var fhdz=$.trim(li.find("#fhdz").val());
			if( $(t).text()=="保存"){
            if(lxr!=""&&lxPhone!=""&&fhdz!=""){
         	   savefhdz();
         	   li.find('input').prop('disabled',true);
         	   li.find('textarea').prop('disabled',true);
         	   $(t).text('编辑');
            }else{
            	pop_up_box.showMsg("请填写完整收货信息!");
            }
        }else{
     	   li.find('input').removeAttr('disabled');
     	   li.find('textarea').removeAttr('disabled');
            $(t).text('保存');
        }
    }
    /**
     * 修改保存个人信息
     */
    $("#editinfo").click(function(){
    	var t=this;
    	if( $(this).text()=="确认"){
    		var corp_sim_name=$("#corp_sim_name").val();
        	var clerk_name=$("#clerk_name").html();
        	var tel_no=$("#tel_no").val();
        	var weixin=$("#weixin").val();
        	var sex=$("#sex").val();
        	$.post("../customer/saveUserInfo.do",{
        		"corp_sim_name":corp_sim_name,
        		"tel_no":tel_no,
        		"weixin":weixin,
        		"sex":sex
        	},function(data){
        		if (data.success) {
    				pop_up_box.showMsg("保存成功!");
    				$('.mymaterial_list').find("input[type='tel'],input[type='text']").prop('disabled',true);
    				$('.mymaterial_list').find("select").prop('disabled',true);
    				$(t).text('修改');
    			} else {
    				if (data.msg) {
    					pop_up_box.showMsg("保存错误!" + data.msg);
    				} else {
    					pop_up_box.showMsg("保存错误!");
    				}
    			}
        	});
        }else{
            $('.mymaterial_list').find("input[type='tel'],input[type='text']").prop('disabled',false);
            $('.mymaterial_list').find("select").prop('disabled',false);
            $(this).text('确认');
        }
    });
	///获取客户的收货地址
	var fhdzitem=$("#fhdzitem");
	$.get("../customer/getFHDZList.do",function(data){
		$("#fhdzlist").html("");
		if(data){
			$.each(data,function(i,n){
				var item=$(fhdzitem.html());
				$("#fhdzlist").append(item);
				item.find("#lxr").val(n.lxr);
				item.find("#lxPhone").val(n.lxPhone);
				item.find("#fhdz").val(n.fhdz);
				if(n.mr){
					item.find("#deft>.list04_left_img").addClass("list03_left_img");
				}
				item.find("#edit").click(function(){
				   editfhdz(this);
				});
				item.find("#del").click(function(){
					delfhdz(this);
				});
			});
		    $("input[type='tel'],input[type='text']").prop('disabled',true);
		    $("textarea").prop('disabled',true);
			$(".list04_left_img").click(function(){//注册图片选择框 选择或者取消功能
				$(".list04_left_img").removeClass("list03_left_img");
				$(this).addClass("list03_left_img");
				savefhdz();
			});
		}
	});
	////新增加发货地址
	$("#addfhdz").unbind("click");
	$("#addfhdz").click(function(){
		var item=$(fhdzitem.html());
		$("#fhdzlist").append(item);
		item.find('input').removeAttr('disabled');
		item.find('textarea').removeAttr('disabled');
		item.find("#edit").text('保存');
		item.find("#edit").click(function(){
			editfhdz(this);
		});
		item.find("#del").click(function(){
			delfhdz(this);
		});
		item.find(".list04_left_img").click(function(){//注册图片选择框 选择或者取消功能
			$(".list04_left_img").removeClass("list03_left_img");
			$(this).addClass("list03_left_img");
			savefhdz();
		});
		initNumInput();
	});
	////获取客户司机信息
	var driveitem=$("#driveitem");
	$.get("../user/getClientDriver.do",function(data){
		$("#drivelist").html("");
		$.each(data,function(i,n){
			var item=$(driveitem.html());
			$("#drivelist").append(item);
			item.find("#corp_sim_name").html(n.corp_sim_name+"("+n.corp_working_lisence+")");
			item.find("#movtel").html(n.movtel);
			item.find("#memo").html(n.memo);
			item.find("#del").click(function(){
				var li=$(this).parents("li");
				
				li.remove();
			});
		});
	});
});
//直接上传图片到正式文件夹
function imgCLientUpload(t){
	pop_up_box.postWait();
	ajaxUploadFile({
		"uploadUrl":"../upload/uploadImageZs.do?fileName=Pic_You&newWidth=500&imgPath="+imgPath,
		"msgId":"msg",
		"fileId":"Pic_You",
		"msg":"图片",
		"fid":"",
		"uploadFileSize":5
	},t,function(imgurl){
		pop_up_box.loadWaitClose(); 
		$("#user_logo").attr("src","../"+imgurl+"?ver="+Math.random());
	});
}