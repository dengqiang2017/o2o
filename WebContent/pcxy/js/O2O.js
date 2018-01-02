$(function(){
  $(".nav li").removeClass('active');
$(".nav li").click(function(){
  var n = $(".nav li").index(this);
  $(".nav li").removeClass('active');
  $(this).addClass('active');
});

$(function () {
  $('.tree li:has(ul)').addClass('parent_li').find(' > span').attr('title', 'Collapse this branch');
  $('.tree li.parent_li > span').on('click', function (e) {
    var children = $(this).parent('li.parent_li').find(' > ul > li');
    if (children.is(":visible")) {
      children.hide();
      $(this).attr('title', 'Expand this branch').find(' > i').addClass('icon-plus-sign').removeClass('icon-minus-sign');
    } else {
      children.show();
      $(this).attr('title', 'Collapse this branch').find(' > i').addClass('icon-minus-sign').removeClass('icon-plus-sign');
    }
    e.stopPropagation();
  });
});

$(".tree li span").removeClass('activeT');
$(".tree li span").click(function(){
  var n = $(".tree li span").index(this);
  $(".tree li span").removeClass('activeT');
  $(".tree li span:eq("+n+")").addClass('activeT');
});

$("tbody tr").removeClass('activeTable');
$("tbody tr").click(function(){
  $("tbody tr").removeClass('activeTable');
  $(this).addClass('activeTable');
});

$(".img-lg img").hide();
$(".img-lg img:eq(0)").show();
var n = 0;
$(".arrow-left1").click(function() {
  if (n>0) {
    n = n-1
  }
  else{
    n = $(".img-lg img").length-1
  }
  $(".img-lg img").hide();
  $(".img-lg img:eq("+n+")").show();
});

$(".arrow-right1").click(function() {
  if (n< $(".img-lg img").length-1) {
    n = n+1
  }
  else{
    n = 0
  }
  $(".img-lg img").hide();
  $(".img-lg img:eq("+n+")").show();
});

$(".nav-tabs li").removeClass("active");
$(".nav-tabs li:eq(0)").addClass("active");
$(".tabs-content").hide();
$(".tabs-content:eq(0)").show();
$(".nav-tabs li").click(function() {
  var n = $(".nav-tabs li").index(this);
  $(".tabs-content").hide();
  $(".tabs-content:eq("+n+")").show();
});

    $(function(){
        showScroll();
        function showScroll(){
            $(window).scroll( function() {
                var scrollValue=$(window).scrollTop();
                scrollValue > 100 ? $('div[class=back-top]').fadeIn():$('div[class=back-top]').fadeOut();
            } );   
            $('#scroll').click(function(){
                $("html,body").animate({scrollTop:0},200);   
            });   
        }
    })

$(".psearch-item").removeClass("activePI");
$(".psearch-item").click(function() {
  $(".psearch-item").removeClass("activePI");
  $(this).addClass("activePI")
});

$(".pro-img-lg img").hide();
$(".pro-img-lg img:eq(0)").show();
$(".pro-img-xs img").removeClass("activeImg");
$(".pro-img-xs img:eq(0)").addClass("activeImg");
$(".pro-img-xs img").click(function() {
  var n = $(".pro-img-xs img").index(this);
  $(".pro-img-xs img").removeClass("activeImg");
  $(this).addClass("activeImg");
  $(".pro-img-lg img").hide();
  $(".pro-img-lg img:eq("+n+")").show();
});

var timer = setInterval(Auto,4000);
var m = 0;
function Auto(){
  if(m < $(".pro-img-lg img").length-1){
    m = m + 1;
  }
  else{
    m = 0;
  }
  $(".pro-img-lg img").hide();
  $(".pro-img-lg img:eq("+m+")").show();
  $(".pro-img-xs img").removeClass("activeImg");
  $(".pro-img-xs img:eq("+m+")").addClass("activeImg");
};
$(".pro-img-lg img").hover(function() {
  clearTimeout(timer);
}, function() {
  timer = setInterval(Auto,4000);
});

$(".side-cover").hide();
$(".folding-content").hide();
$(".btn-folding").click(function(){
  $(".side-cover").show();
  $(".folding-content").show();
});

$(".side-cover").click(function(){
  $(".side-cover").hide();
  $(".folding-content").hide();
});

$("#account .paycheck-box").removeClass("activeP");
$("#account .paycheck-box").click(function(){
  $("#account .paycheck-box").removeClass("activeP");
  $(this).addClass("activeP");
});

$("#paystyle .paycheck-box").removeClass("activeP");
$("#paystyle .paycheck-box").click(function(){
  $("#paystyle .paycheck-box").removeClass("activeP");
  $(this).addClass("activeP");
});

$(".banner-lg img").hide();
$(".banner-lg img:eq(0)").show();
var Banner = setInterval(Bannertimer,5000);
var n = 0;
function Bannertimer(){
  if (n < $(".banner-lg img").length-1) {
    n = n + 1;
  }
  else{
    n = 0;
  } 
  $(".banner-lg img").hide();
  $(".banner-lg img:eq("+n+")").show();
};

$(".banner-xs img").hide();
$(".banner-xs img:eq(0)").show();
var Banner = setInterval(bannertimer,5000);
var n = 0;
function bannertimer(){
  if (n < $(".banner-xs img").length-1) {
    n = n + 1;
  }
  else{
    n = 0;
  } 
  $(".banner-xs img").hide();
  $(".banner-xs img:eq("+n+")").show();
};

$(".checkbox").removeClass("checkedbox");
$("td>.checkbox").click(function(){
  if ($(this).find("input").prop("checked")) {
    $(this).removeClass("checkedbox");
    $(this).find("input").prop("checked",false);
  }else{
    $(this).addClass("checkedbox");
    $(this).find("input").prop("checked",true);
  }
});

$("th>.checkbox").click(function(){
  $(this).find("input").prop("checked",!$(this).find("input").prop("checked"));
  if ($(this).find("input").prop("checked")) {
    $(".checkbox").removeClass("checkedbox");
  }else{
    $(".checkbox").addClass("checkedbox");
  }
});

$(".p-top .pro-check").click(function(){
  if ($(this).find("input").prop("checked")) {
    $(this).removeClass("pro-checked");
    $(this).find("input").prop("checked",false);
  }else{
    $(this).addClass("pro-checked");
    $(this).find("input").prop("checked",true);
  }
});

$(".left-hide-ctn").hide();
$(".cover").hide();
$("#seekh").click(function(){
  $(".left-hide-ctn").show();
  $(".cover").show();
});

$(".cover").click(function(){
  $(".left-hide-ctn").hide();
  $(".cover").hide();
});

});


 