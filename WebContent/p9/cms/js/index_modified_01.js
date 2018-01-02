
$(document).ready(function(){
    $('#lightSlider').lightSlider({
        slideWidth:1270,
        minSlide:1,
        maxSlide:1,
        controls:true,
        useCSS:true,
        currentPagerPosition:'middle',
        auto:false,
        speed:1000
    });
    function toTopHide(){
        $(document).scrollTop()>400?
            $(".to_top").show()
            :$(".to_top").hide();
    }
    $(window).scroll(function(){toTopHide()});
    $('.to_top').click(function(){$('html,body').animate({scrollTop: '0px'}, 1000);return false;});
});

