 $(function(){
	 var fs=$(".footer a");
	 for (var i = 0; i < fs.length; i++) {
		var f=$(fs[i]);
		var url=f.attr("href");
		if(url&&url!=""&&url.indexOf("?")>0){
			f.attr("href",url+"&ver="+Math.random());
		}else{
			f.attr("href",url+"?ver="+Math.random());
		}
	}
 });