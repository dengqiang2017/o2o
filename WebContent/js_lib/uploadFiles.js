	var loadFile={
			filejson:null,
			filestyle:null,
			clearInter:null,//clear timeout
			domElement:null,
			uploadStatus:null,
			uploadUrl:null,
			progressShow:null,
			uploadCallback:null,
            loaddingVal:null,
            loadProStatus:false,
			init:function(dom,style,pro,uploadStatus,url,callback){
				var _this=loadFile;
				_this.filejson=null;
				_this.filestyle=null;
				_this.progressShow=pro||false;// 进度条
				_this.domElement=dom||'';
				_this.filestyle=style||'';	//类型
				_this.uploadStatus=uploadStatus||'';	//1 开发者 2 银联 3 服务机构
				_this.uploadUrl=url;	//1 开发者 2 银联 3 服务机构
                _this.loaddingVal=$(_this.domElement).text();//按钮的文本信息
					_this.formCreat(uploadStatus);
					_this.listView(uploadStatus);
				    
				    _this.uploadCallback=callback;  
			},
			formCreat:function(uploadStatus){
                var versionIE= parseInt($.browser.version);
                if($.browser.msie&&versionIE<10){
                    $("body").css({"overflow":"hidden"});//浏览器不可以滚动阴影后面的内容
                    var USERID="";
                    var USERTOKEN="";
                    $('.filename').remove();
                    $('.progress').remove();
                    $("#maskPage").remove();
                    if(uploadStatus==1){
                            USERID= "D_"+$.cookie("devid");
                            USERTOKEN= $.cookie("token");
                    }else if(uploadStatus==2){
                            USERID= "C_"+$.cookie("cupid");
                            USERTOKEN=  $.cookie("c_token");
                    }else if(uploadStatus==3){
                            USERID= "S_"+$.cookie("s_id");
                            USERTOKEN=  $.cookie("s_token");
                    }
                    var filesubmit=$('<div id="maskPage" class="maskPage"><div class="uploaddiv"><div id="uploadTitle" class="uploadTitle">选择上传文件</div><form id="sb" action="'+
                    		loadFile.uploadUrl+'" class="filename" method="post" enctype="multipart/form-data" onsubmit="return loadFile.checkdata()"><input type="file" id="fileSelect" name="file"><br><div id="ieProgress" class="progress none"><div class="bar"></div ></div><input type="text" id="USERID" name="USERID" class="none" value="'+USERID+'" /><input type="text" id="USERTOKEN" name="USERTOKEN" class="none" value="'+USERTOKEN+'" /><input type="submit" id="uploadSubmit" value="上传" class="resume"/><input type="button" id="narback" value="返回" class="goback"/></form><div id="status"></div></div></div>');
                    $('body').append(filesubmit);
                    var _this=loadFile;
                    $('#sb').removeAttr('onsubmit');
                  //  $('#fileSelect').click();
                    $('#uploadSubmit').click(function(){
                        _this.checkdata();
                        return false;
                    });//inn open filen en
                    $('#narback').click(function(){
                        $("#maskPage").remove();
                        $("body").css({"overflow":"auto"});
                    });

                }else{
                	   var _this=loadFile;
                    $('.filename').remove();
                    $('.progress').remove();
                    var filesubmit=$('<form id="sb" action="'+loadFile.uploadUrl+'" class="filename" method="post" enctype="multipart/form-data" onsubmit="return loadFile.checkdata()"><input type="file" class="none" id="fileSelect" name="file"><input type="submit" class="none"  id="uploadSubmit" value="上传文件"/ display="none"></form>');
                    $('body').append(filesubmit);
                    var testse=$('<div class="progress none"><div class="bar"></div ></div >');
                    _this.domElement.parent().append(testse);
                 
                    var pos=_this.domElement.offset(),//进度条位置的显示
                        elementH=_this.domElement.outerHeight(),
                        elementW=_this.domElement.outerWidth(),
                        posl=pos.left,
                        post=pos.top;
                    $('.progress').css({'top':post+elementH,'left':posl,'width':'72px',"margin-left":"0"});

                    $('#fileSelect').click();//inn open file
                    function isMaxthon(){//搜狗浏览器的判断
                        try{
                            if(window.external && window.external.max_version){
                                if(window.external.max_version.substr(0,1).length>0){
                                    return true;
                                }
                            }
                            return false;
                        }
                        catch (e){
                            return false;
                        }
                    }
                    if($.browser.msie||isMaxthon()==true){
                        setTimeout(function(){
                            var inputVal=$('input[type="file"]').val();
                            if(inputVal!=""){
                                var _this=loadFile;
                                $('#sb input[type="submit"]').click();
                                $('#sb').removeAttr('onsubmit').submit(function(e){
                                    _this.checkdata;
                                    return false;
                                });
                            }
                        },20);
                    }
                    else{
                        $('input[type="file"]').change(function(){
                            var flievalues=$(this).val();
                            if(flievalues!=""){
                                var _this=loadFile;
                                $('#sb input[type="submit"]').click();
                                $('#sb').removeAttr('onsubmit').submit(function(e){
                                    _this.checkdata;
                                    return false;
                                });
                            }

                        });
                    }

                }

			},
			
			checkdata:function(){//对文件类型的判断
				var _this=loadFile,
					fileselect=$('#fileSelect').val().toLowerCase(),
					styleArr=_this.filestyle.split('|'),
						len=styleArr.length,
						i=0;
				var message='';
				for(;i<len;i++){
					var fileval=fileselect.substring(fileselect.length-styleArr[i].length,fileselect.length);
					if(styleArr[i]==fileval){//判断条件成功  c才可以吧submit方法放出来
                      var version=parseInt($.browser.version);
                        if($.browser.msie&&version<10){
                            var uploadSubmit=$("#uploadSubmit"),
                                narback=$("#narback");
                                var options = {
                                    url:_this.uploadUrl,
                                    type:'post',
                                    contentType : 'application/json; charset=utf-8',
                                    dataType:'json',
                                    error : function(XMLHttpRequest, textStatus, errorThrown) {
                                        clearTimeout(loadFile.clearInter);
                                        loadFile.loadProStatus=false;
//                                        alert("上传失败！");
                                        uploadSubmit.val("上传");
                                        uploadSubmit.attr({"disabled":false});
                                        narback.attr({"disabled":false});
                                        $("body").css({"overflow":"auto"});//浏览器不可以滚动阴影后面的内容
                                    },
                                    success : function(returnData) {
                                        clearTimeout(loadFile.clearInter);
                                        loadFile.loadProStatus=false;

                                        if(returnData){
                                            _this.filejson=JSON.stringify(returnData);
                                            _this.uploadCallback(_this.filejson);
                                        }else{
                                            alert("上传失败，请选择正确的包文件！")
                                        }



                                        $("#maskPage").remove();
                                        uploadSubmit.val("上传");
                                        uploadSubmit.attr({"disabled":false});
                                        narback.attr({"disabled":false});
                                        $("body").css({"overflow":"auto"});//浏览器不可以滚动阴影后面的内容
                                    },
                                    beforeSend:function(){
                                        $(".progress").removeClass("none");
                                        var bar = $('.bar');
                                        var percentVal = 10;
                                        if(!loadFile.loadProStatus){
                                            loadFile.loadProStatus=true;
                                            function probar(){
                                                if(percentVal==100){
                                                    percentVal = 0;
                                                }
                                                percentVal = percentVal+5;
                                                bar.width(percentVal+'%');

                                                loadFile.clearInter=setTimeout(function(){ probar();},100);
                                            }
                                            probar();
                                        }
                                    },
                                    complete: function(xhr) {
                                     //   alert(xhr);
                                    }

                                };
                                // 将options传给ajaxSubmit
                                $('#sb').ajaxSubmit(options);
                                uploadSubmit.val("上传中...");//禁用
                                uploadSubmit.attr({"disabled":true});
                                narback.attr({"disabled":true});
                            return false;
                        }else{//非ＩＥ浏览器的去除进度条

                            _this.domElement.text("上传中 . . .");
                            $(_this.domElement).attr({"disabled":true});
                            $('.progress').removeClass('none');
                        }
						return true;
					}else{//上传文件类型不对
						if(message==''){
							message=styleArr[i];
						}else{
							message=message+","+styleArr[i];
						}
						if(i+1==len){
							alert('请选择'+message+'类型文件!');
                            if($.browser.msie==true){
                                _this.filejson=null;
                                return false;
                            }else{
                                $('.filename').remove();
                                $('.progress').remove();
                                _this.filejson=null;
                                return false;
                            }
						}
						
					}
					
				}
				
				//_this.listView();
				if(_this.progressShow!=false){
					$('.progress').removeClass('none'); //remove progress  class none
				}
			
			},
			listView:function(uploadStatus){
				var _this=loadFile;
				var bar = $('.bar');
				var percent = $('.percent');
				var status = $('#status');
				var herder=null;
                var uploadSubmit=$("#uploadSubmit");
                var narback=$("#narback");
				if(uploadStatus==1){
					herder={
			                "USERID" : "D_"+$.cookie("devid"),
			                "USERTOKEN": $.cookie("token")
			            }
				}else if(uploadStatus==2){
					herder={
			                "USERID" : "C_"+$.cookie("cupid"),
			                "USERTOKEN": $.cookie("c_token")
			            }
				}else if(uploadStatus==3){
					herder={
			                "USERID" : "S_"+$.cookie("s_id"),
			                "USERTOKEN": $.cookie("s_token")
			            }
				}
				
				$('form').ajaxForm({
				    beforeSend: function() {
				        status.empty();
				        var percentVal = '0%';
				        bar.width(percentVal);
				        percent.html(percentVal);
				    },
				    uploadProgress: function(event, position, total, percentComplete) {
                        var percentVal = 10;
                        if(!loadFile.loadProStatus){
                            loadFile.loadProStatus=true;
                            function probar(){
                                if(percentVal==100){
                                    percentVal = 0;
                                }
                                percentVal = percentVal+5;
                                bar.width(percentVal+'%');
                                percent.html(percentVal);

                                loadFile.clearInter=setTimeout(function(){ probar();},100);
                            }
                            probar();
                        }

				    },
				    headers : herder,
				    success: function() {
                        clearTimeout(loadFile.clearInter);
                        loadFile.loadProStatus=false;
				        var percentVal = '100%';
				        bar.width(percentVal);
				        percent.html(percentVal);
				    },
                    error : function(XMLHttpRequest, textStatus, errorThrown){
                        clearTimeout(loadFile.clearInter);
                        loadFile.loadProStatus=false;
//                        alert("上传失败！");
                            $('.filename').remove();
                            $('.progress').remove();
                            _this.domElement.text(_this.loaddingVal);
                            $(_this.domElement).attr({"disabled":false});

                    },
					complete: function(xhr) {
						//status.html(xhr.responseText);
                        clearTimeout(loadFile.clearInter);//去掉timer
                        loadFile.loadProStatus=false;
						_this.filejson=xhr.responseText;
                        _this.domElement.text(_this.loaddingVal);
                        $(_this.domElement).attr({"disabled":false});
                        _this.uploadCallback(_this.filejson);
						setTimeout(function(){
                                $('.filename').remove();
                                $('.progress').remove();
						},100);
					}
				}); 
			}
	}

    //针对不支持placeholder浏览器的扩展  IE9-


        ;   (function ($) {
        $.fn.extend({
            placeholder : function () {
                if ("placeholder" in document.createElement("input")) {
                    return this; //如果原生支持placeholder属性，则返回对象本身
                } else {         //如果不支持placeholder属性，处理placeholder
                    return this.each(function () {
                        var _this = $(this);
                        _this.css({"color":"#999"});
                        _this.val(_this.attr("placeholder")).focus(function () {
                            if (_this.val() === _this.attr("placeholder")) {
                                _this.val("");
                                _this.css({"color":"#a9a9a9"});
                            }
                        }).blur(function () {
                                if (_this.val().length === 0) {
                                    _this.val(_this.attr("placeholder"));
                                    _this.css({"color":"#999"});
                                }
                            })
                    })
                }
            }
        })
    })(jQuery);