var projectName="p1";
var url="http://www.pulledup.cn";
var prex_url=url+"/"+projectName+"/";// "http://"+projectName+".pulledup.cn/";
function addVer(fs){
	 for (var i = 0; i < fs.length; i++) {
		 var f=$(fs[i]);
		 var url=f.attr("href");
		 if(url&&url!=""&&url.indexOf("?")>0){
			 f.attr("href",url+"&ver="+Math.random());
		 }else{
			 f.attr("href",url+"?ver="+Math.random());
		 }
	 }
}
addVer($(".pull-right a"));
addVer($(".zz a"));