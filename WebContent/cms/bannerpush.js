var path="cms/banner.json";
var bannerpush={
		tbodytr:"",
		init:function(){
			common.URLFiltering();
			var len=$("th").length;
			$("tbody").html("");
			$.get("../../manager/getJSONArrayByFile.do",{
				"path":path
			},function(data){
				if(data){
					$.each(data,function(i,n){
						var tr=common.getTr(len);
						$("tbody").append(tr);
						tr.find("td:eq(0)").addClass("td1");
						tr.find("td:eq(0)").html('<span class="glyphicon glyphicon-arrow-up" onclick="bannerpush.upimg(this);"></span>'
								+'<span class="glyphicon glyphicon-arrow-down" onclick="bannerpush.downimg(this);"></span>');
						tr.find("td:eq(1)").html("<label><input type='checkbox'>使用</label>");
						tr.find("td:eq(1) input").prop("checked",n.show);
						tr.find("td:eq(2)").html("<img src='"+n.imgurl+"'>");
						if(n.alink){
							tr.find("td:eq(3)").html("<a href='"+n.alink+"' target='_blank'>"+n.alink+"</a>");
						}
						tr.find("td:eq(4)").html('<span class="glyphicon glyphicon-pencil edit" onclick="bannerpush.editimg(this);"></span>'
								+'<span class="glyphicon glyphicon-remove-circle del" onclick="bannerpush.delimg(this);"></span>');
					});
				}
			});
			$(".modal .btn-default,.modal .close").click(function(){
				$(".modal,.modal-cover").hide();
			});
			$('#imgfile').change(function() {
				$('#photoCover').val($(this).val());  
				$(".modal").find("img").attr("src","/ds/images/"+$(this).val());
			});
			$('#photoCover').change(function(){
				if(/\.(gif|jpg|jpeg|png|GIF|JPG|PNG)$/.test($(this).val())){
					$(".modal").find("img").attr("src",$(this).val());
				}
			});
			$("#add").click(function(){
				tbodytr="";
				$(".modal").find("img").attr("src","");
				$(".modal").find("input").val("");
				$(".modal,.modal-cover").show();
			});
			$(".modal .btn-primary").click(function(){
				var imgurl=$(".modal").find("img").attr("src");
				var alink=$(".modal").find("#url").val();
				if(!imgurl){
					pop_up_box.showMsg("请选择图片");
					return;
				}
				if(bannerpush.tbodytr.length>0){//修改
					bannerpush.tbodytr.find("img").attr("src",imgurl);
					bannerpush.tbodytr.find("a").attr("href",alink);
					bannerpush.tbodytr.find("a").html(alink);
				}else{
					var tr=common.getTr(len);
					$("tbody").append(tr);
					tr.find("td:eq(0)").addClass("td1");
					tr.find("td:eq(0)").html('<span class="glyphicon glyphicon-arrow-up" onclick="bannerpush.upimg(this);"></span>'
							+'<span class="glyphicon glyphicon-arrow-down" onclick="bannerpush.downimg(this);"></span>');
					tr.find("td:eq(1)").html("<label><input type='checkbox' checked='checked'>使用</label>");
					tr.find("td:eq(2)").html("<img src='"+imgurl+"'>");
					tr.find("td:eq(3)").html("<a href='"+alink+"' target='_blank'>"+alink+"</a>");
					tr.find("td:eq(4)").html('<span class="glyphicon glyphicon-pencil edit" onclick="bannerpush.editimg(this);"></span>'
							+'<span class="glyphicon glyphicon-remove-circle del" onclick="bannerpush.delimg(this);"></span>');
				}
				$(".modal,.modal-cover").hide();
				bannerpush.saveBanner();
			});
			//////////////////
			if (common.isWeixin()) {
				weixinfileup.init();
				$(".input-append a").unbind("click");
				$(".input-append a").click(function(){
					weixinfileup.chooseImage(this,function(imgurl){
						weixinfileup.uploadImage(imgurl,function(url){
							var imgPath="/@com_id/cms/banner"+common.getbannershuzi()+".jpg";
							$.get("../../weixin/getImageToWeixin.do",{"url":url,"imgPath":imgPath},function(data){
								if (data.success) {
									pop_up_box.toast("上传成功!",500);
									$(".modal").find("img").attr("src",data.msg);
								} else {
									if (data.msg) {
										pop_up_box.showMsg("上传错误!" + data.msg);
									} else {
										pop_up_box.showMsg("上传错误!");
									}
								}
							});
						});
						$(".modal").find("img").attr("src",imgPath);
					});
				});
			}else{ 
				$(".input-append a").click(function(){
					$('#imgfile').click();
				});
			}
		},saveBanner:function(){
			var trs=$("tbody tr");
			if(trs.length>0){
				var list=[];
				for (var i = 0; i < trs.length; i++) {
					var tr=$(trs[i]);
					var imgurl=tr.find("img").attr("src");
					var alink=tr.find("a").html();
					var show=tr.find("input[type='checkbox']").prop("checked");
					list.push(JSON.stringify({"imgurl":imgurl,"alink":alink,"show":show}));
				}
				$.post("../../manager/saveJSONArrayFile.do",{
					"path":path,
					"jsons":"["+list.join(",")+"]"
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
			}else{
				pop_up_box.showMsg("没有数据!");
			}
		
		},editimg:function(t){
			var td=$(t).parent().parent();
			bannerpush.tbodytr=td;
			var imgurl=td.find("img").attr("src");
			var alink=td.find("a").html();
			$(".modal").find("img").attr("src",imgurl);
			$(".modal").find("#photoCover").val(imgurl);
			$(".modal").find("#url").val(alink);
			$(".modal,.modal-cover").show();
		},delimg:function(t){
			if(confirm("删除后将不能恢复,是否继续删除?")){
				var td1=$(t).parent().parent();
				var imgUrl=$.trim(td1.find("img").attr("src"));
				if(!imgUrl||imgUrl==""){
					return;
				}
				$.get("../../upload/removeTemp.do",{
					"imgUrl":imgUrl
					},function(data){
					if (data.success) {
						td1.remove();
						bannerpush.saveBanner();
						pop_up_box.toast("删除成功!",1000);
					} else {
						if (data.msg) {
							pop_up_box.showMsg("删除错误!" + data.msg);
						} else {
							pop_up_box.showMsg("删除错误!");
						}
					}
				});
			}
		},upimg:function(t){
			 var td1=$(t).parent().parent();
			 var td2=$(t).parent().parent().prev();
			 if(td2.length>0){
				$(t).parent().parent().remove();
				td2.before(td1);
			 }
		},downimg:function(t){
			var td1=$(t).parent().parent();
			 var td2=$(t).parent().parent().next();
			 if(td2.length>0){
				 $(t).parent().parent().remove();
				 td2.after(td1);
			 }
		} 
}
function imgUpload(t){
	var imgPath="/@com_id/cms/banner/"+common.getbannershuzi()+".jpg";
	ajaxUploadFile({
		"uploadUrl":"../../upload/uploadImageZs.do?fileName=imgfile&imgPath="+imgPath,
		"msgId":"",
		"fileId":"imgfile",
		"msg":"",
		"fid":"",
		"uploadFileSize":0.5
	},t,function(imgurl){
		pop_up_box.loadWaitClose();
		$(".modal").find("img").attr("src",imgurl);
	});
}
bannerpush.init();