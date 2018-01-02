//页面全文搜索  直接在页面上进行搜索
(function ($) {
	  jQuery.expr[':'].Contains = function(a,i,m){
	      return (a.textContent || a.innerText || "").toUpperCase().indexOf(m[3].toUpperCase())>=0;
	  };
	}(jQuery));
/**
 * list 数据行所在的div对象
 */
function filterList(list,key){
	if(!key){
		key=".li";
	}
    var input =$("#searchKey");
    input.change( function () {
        var filter = $(this).val();
        if(filter) {
        	//查找包含输入文字的行对象
		  $matches = $(list).find('a:Contains(' + filter + '),span:Contains(' + 
				  filter + '),li:Contains(' + filter + ')').parents(key);
		  //所有行全部隐藏
//		  $(key, list).not($matches).slideUp();
		  $(key).not($matches).slideUp();
		  //只显示出包含文字的行
		  $matches.slideDown(); 
        } else {
        	//没有内容的时候显示所有的行
          $(list).find(key).slideDown();
        }
        return false;
      })
    .keyup( function () {
        //输入实时变化执行
        $(this).change();
    });
}