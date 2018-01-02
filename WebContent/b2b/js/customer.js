 $(function(){
	 var fs=$(".footer a");
	 for (var i = 0; i < fs.length; i++) {
		var f=$(fs[i]);
		f.attr("href",f.attr("href")+"?ver="+Math.random());
	}
 });