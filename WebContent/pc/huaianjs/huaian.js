var productOrder={
		/**
		 * 产品明细页面中获取数量
		 * @returns  返回换算后的数量
		 */
		detailProductNum:function(){
			var num=parseFloat($.trim($(".num").val()));
			var zsnum=num;
			var index=$('.xs_btn button').index($(".btn-success"));
			var pack_unit=$("#pack_unit").html();
			if (!pack_unit) {
				pack_unit="1";
			}
			if(index==1){
				zsnum=num/pack_unit;
			}
			return zsnum;
		},
		/**
		 * 产品列表中指定块的数量
		 * @param item 指定块的jquery对象
		 * @returns 返回换算后的数量
		 */
		productNum:function(item){
			var num=parseFloat($.trim(item.find(".num").val()));
			var zsnum=num;
			var index=item.find('.xs_btn button').index(item.find(".btn-success"));
			var pack_unit=item.find("#pack_unit").html();
			if (!pack_unit) {
				pack_unit="1";
			}
			if(index==1){
				zsnum=num/pack_unit;
			}
			return zsnum;
		}

}