var domainName="http://"+document.location.hostname;
function getQueryString(key,search) {
	/*if(!search){
		search= window.location.search;
	}
	search=replaceAll(window.location.search,"\\|_", "&");*/
    var reg = new RegExp("(^|&)" + key + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) {///decodeURIComponent
    	return unescape(r[2]); 
    }
    return null;
}
