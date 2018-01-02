$(function(){
	$.ajax({
		url : "pc/copyright.html?domainName="+domainName,
		cache : true,
		success : function(html) {
			if ($("#copy_bottom").length>0) {
				$("#copy_bottom").append(html);
			}else{
				$("body").append(html);
			}
			pre="";
		},error : function(t) {
			$.get(prexfurl+"/pc/copyright.html?domainName="+domainName, function(html) {
				pre=prexfurl+"/";
				var b=window.location.href.indexOf("saiyu")>0;
				if(!b){
					if ($("#copy_bottom").length>0) {
						$("#copy_bottom").append(html);
					}else{
						$("body").append(html);
					}
				}
			});
		}
	});
});