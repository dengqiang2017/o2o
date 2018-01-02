function getBannerImg(com_id){
	$.get("/"+com_id+"/banner.json",function(data){
		if(data){
			$('#fade').html("");
			$.each(data,function(i,n){
				if(n.show&&n.imgurl){// data-lightbox="roadtrip"
					var li=$('<li><a><img class="img-responsive"></a></li>');
					$('#fade').append(li);
					li.find("img").attr("src",n.imgurl);
					if(n.alink){
						li.find("a").attr("href",n.alink.replace("amp;", ""));
					}
				}
			});
			$('#fade').lightSlider({
				minSlide: 1,
				maxSlide: 1,
				mode: 'fade'
			});
		}
	});
}
function getBannerImg2(com_id){
	$.get("/"+com_id+"/banner.json",function(data){
		if(data){
			$('.carousel-inner').html("");
			$(".carousel-indicators").html("");
			$.each(data,function(i,n){
				if(n.show&&n.imgurl){
					var li=$('<li data-target="#carousel-example-generic"></li>')
					var item=$("<div class='item'>"+$('.carousel-inner').find(".item:eq(0)")+"</div>");
					$('.carousel-inner').append(item);
					$(".carousel-indicators").append(li);
					li.attr("data-slide-to",i);
					item.find("img").attr("src",n.imgurl);
					if(n.alink){
						item.click({"alink":n.alink.replace("amp;", "")},function(event){
							window.location.href=event.data.alink;
						});
					}
				}
			});
			$('.carousel-inner').find(".item:eq(0)").addClass("active");
			$('.carousel-indicators').find("li:eq(0)").addClass("active");
		}
	});
}