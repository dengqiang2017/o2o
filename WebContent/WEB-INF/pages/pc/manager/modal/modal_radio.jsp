<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="modal-cover-first"></div>
<div class="modal-first" style="display:block;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
				<h4 class="modal-title">是否只看自己？</h4>
			</div>
			<div class="modal-body" style="max-height:260px; overflow-y:scroll; padding: 10px;">
				
				<label class="radio-inline">
				  <input type="radio" name="inlineRadioOptions" id="inlineRadio1" value="是"> 是
				</label>
				<label class="radio-inline">
				  <input type="radio" name="inlineRadioOptions" id="inlineRadio2" value="否"> 否
				</label>
				
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default">取消</button>
				<button type="button" class="btn btn-primary">确定</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
		<script type="text/javascript">
		var modal_first={
				mySelf_Info:function(clerk_id,val){
				if("是"==val){
					$(".modal-first").find("input[name='inlineRadioOptions']:eq(0)").prop("checked",true);
				}else{
					$(".modal-first").find("input[name='inlineRadioOptions']:eq(1)").prop("checked",true);
				}
				$(".modal-content").find(".btn-primary").click(function(){
					var inlineRadioOptions=	$(".modal-first").find("input[name='inlineRadioOptions']:checked");
					$.get("updateInfo.do",{
						"clerk_id":clerk_id,
						"mySelf_Info":inlineRadioOptions.val()
					},function(data){
						if(data.success){
					$("tbody").find("td:contains('"+clerk_id+"')").parents("tr").find("td:eq(4)>a").html(inlineRadioOptions.val());
						$(".modal-cover-first,.modal-first").remove();
						pop_up_box.showMsg("提交成功!");
						}else{
						pop_up_box.showMsg("提交失败!");
						}
					});
				});
				$(".modal-content").find(".close,.btn-default").click(function(){
					$(".modal-cover-first,.modal-first").remove();
				});
			}
		}
	</script>
</div><!-- /.modal -->
