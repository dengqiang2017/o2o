var height=$(".index02_top").position().top;//height是要改变的那个div的滚动条到顶部的距离（只要页面书写完成，这个值是固定的）
var height02=$(".index03_top").position().top-200;//height是要改变的那个div的滚动条到顶部的距离（只要页面书写完成，这个值是固定的）
var height03=$(".index04_top").position().top-250;//height是要改变的那个div的滚动条到顶部的距离（只要页面书写完成，这个值是固定的）
var height04=$(".index05_top").position().top-250;//height是要改变的那个div的滚动条到顶部的距离（只要页面书写完成，这个值是固定的）
var height05=$(".index06_top").position().top-250;//height是要改变的那个div的滚动条到顶部的距离（只要页面书写完成，这个值是固定的）
var height06=$(".index07_top").position().top-230;//height是要改变的那个div的滚动条到顶部的距离（只要页面书写完成，这个值是固定的）
window.onscroll=function(){//页面滚动触发这个方法
    var scrolltop=document.documentElement.scrollTop || document.body.scrollTop;//每一次滚动都获取当前滚动条高度
    if(scrolltop>height){    //当页面滚动到这个div以下时触发执行动作
        $('.index02_top').text('我是谁，为您提供什么服务');
        $('.index02_top').css({position:'fixed',left:'0',top:'90px',right:'0'});
    }
    if(scrolltop>height02){    //当页面滚动到这个div以下时触发执行动作
        $('.index02_top').text('我们与众不同');
    }
    if(scrolltop>height03){    //当页面滚动到这个div以下时触发执行动作
        $('.index02_top').text('我们的服务承诺');
    }
    if(scrolltop>height04){    //当页面滚动到这个div以下时触发执行动作
        $('.index02_top').text('我们的服务方法');
    }
    if(scrolltop>height05){    //当页面滚动到这个div以下时触发执行动作
        $('.index02_top').text('经典成功案例');
    }
    if(scrolltop>height06){    //当页面滚动到这个div以下时触发执行动作
        $('.index02_top').text('企业动态');
    }
    if(scrolltop<height){
        $('.index02_top').css({position:'relative',top:'0'});
    }
};