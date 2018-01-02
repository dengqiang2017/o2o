$(function(){
    function IsPC() {
        var userAgentInfo = navigator.userAgent;
        var Agents = ["Android", "iPhone",
            "SymbianOS", "Windows Phone",
            "iPad", "iPod"];
        var flag = true;
        for (var v = 0; v < Agents.length; v++) {
            if (userAgentInfo.indexOf(Agents[v]) > 0) {
                flag = false;
                break;
            }
        }
		if (flag)
		{
		    $(".col-md-8>img").removeClass();
			return "";
		}else{
			return "phone/";
		}
    }
	if (parent.editstate!=0) {IsPC();
	}  
    function toTopHide(){
        $(document).scrollTop()>400?
            $(".to_top").show()
            :$(".to_top").hide();
    }
    $(window).scroll(function(){toTopHide()});
    $('.to_top').click(function(){$('html,body').animate({scrollTop: '0px'}, 1000);return false;});
});

