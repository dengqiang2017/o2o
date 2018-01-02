	$(function(){
            //当点击跳转链接后，回到页面顶部位置
//            $("#back-to-top").click(function(){
//                $('body,html').animate({scrollTop:0},500);
//                return false;
//            });
            $(".main_content_ctn").html("");
            addItem();
			function addItem(){
				$(".main_content_ctn").append("<div class='product_img_ctn productedit'>"
						+"<a href='product_detail.html' class='panel_head productimg'><img src='images/product_01.png'></a>"
						+"<div class='panel_body'><input type='checkbox' class='checkbox_left'>"
						+"<div class='product_name text_sm productname'><a href='product_detail.html'>软件标题</a></div>"
						+"<div class='product_tips text_xs producttips'><a href='product_detail.html'>软件介绍</a></div>"
						+"<div class='product_price text-lg productprice'>&yen;<a href='product_detail.html'>----</a></div>"
						+"</div></div>");
				try {
					edithtml.init();
				} catch (e) {
				}
			}
    });
	var productList={
			loadWrodList:function(jsonname,img,title,tips,je){
				$(".main_content_ctn").append("<div class='product_img_ctn productedit'>"
						+"<a href='product_detail.html?url="+jsonname+"' class='panel_head productimg'><img src='"+img+"'></a>"
						+"<div class='panel_body'><input type='checkbox' class='checkbox_left'>"
						+"<div class='product_name text_sm productname'><a href='product_detail.html?url="+jsonname+"'>"+title+"</a></div>"
						+"<div class='product_tips text_xs producttips'><a href='product_detail.html?url="+jsonname+"'>"+tips+"</a></div>"
						+"<div class='product_price text-lg productprice'>&yen;<a href='product_detail.html?url="+jsonname+"'>"+je+"</a></div>"
						+"</div></div>"); 
				try {
					edithtml.init();
				} catch (e) {
				}
			}
	}