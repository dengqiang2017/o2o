<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <link rel="stylesheet" href="../pc/css/printerweima.css">
<div class="modal fade" id="mymodal">
    <div class="modal-dialog modal-style">
        <div class="modal-content" style="border-radius: 0">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title">二维码</h4>
            </div>
            <div class="modal-body" style="padding: 0">
                <div id="erweima" style="">
                    <ul>
                        <li>
                            二维码的宽度
                            <div class="pro-num-K">
                                <span class="add">+</span>
                                <span class="sub">-</span>
                                <input type="tel" class="num" data-number="n" value="200" id="wd" placeholder="二维码的宽度" style="text-align:center;height:100%;outline: none;border: none">
                            </div>

                        </li>
                        <li>
                            二维码的高度
                            <div class="pro-num-K">
                                <span class="add">+</span>
                                <span class="sub">-</span>
                                <input type="tel" class="num" data-number="n" value="200" id="hd" placeholder="二维码的高度" style="text-align:center;height:100%;outline: none;border: none">
                            </div>
                        </li>
                        <li>
                            二维码中logo的宽度
                            <div class="pro-num-K">
                                <span class="add">+</span>
                                <span class="sub">-</span>
                                <input type="tel" class="num" data-number="n" value="50" id="imgwd" placeholder="二维码中logo的宽度" style="text-align:center;height:100%;outline: none;border: none">
                            </div>
                        </li>
                        <li>
                            二维码中logo的高度
                            <div class="pro-num-K">
                                <span class="add">+</span>
                                <span class="sub">-</span>
                                <input type="tel" class="num" data-number="n" value="50" id="imghd" placeholder="二维码中logo的高度" style="text-align:center;height:100%;outline: none;border: none">
                            </div>
                        </li>
                        <li>
                            打印页面左边距
                            <div class="pro-num-K">
                                <span class="add">+</span>
                                <span class="sub">-</span>
                                <input type="tel" class="num" data-number="n" value="10" id="imgymwd" placeholder="打印页面高度" style="text-align:center;height:100%;outline: none;border: none">
                            </div>
                        </li>
                        <li>
                            打印页面高度
                            <div class="pro-num-K">
                                <span class="add">+</span>
                                <span class="sub">-</span>
                                <input type="tel" class="num" data-number="n" value="240" id="imgymhd" placeholder="打印页面高度" style="text-align:center;height:100%;outline: none;border: none">
                            </div>
                        </li>
                    </ul>
                    <label style="display: none;">
                    <input type="checkbox" id=snbool>每个产品唯一标识
                    </label>
                    <button class="btn btn-info" id="scewm" type="button" style="margin-left: 10px;margin-top:10px">生成二维码</button>
                    <button class="btn btn-info" id="beginprint" type="button" style="margin-top:10px">开始打印</button>
                    <a class="btn btn-info" id="TJDYJ" type="button" target="_blank" style="margin-top:10px" href="../pc/dyj.html">推荐打印机</a>
                    <div class="printdiv" style="display: none;">
                        <div class="printitem" style="border: 1px solid #ddd;">
                            <div>
                            <span style="font-size: 14px;margin-left: 20px;position: absolute;font-weight: bold;">扫二维码,自助了解该产品</span>
                            <a><img src="" style="margin: 0px;"></a></div>
                            <div style="font-size: 12px;margin-left: 20px;">
                                <span id="item_name"></span>
                                      <span id="item_spec"></span>
                                      <span id="item_type"></span>
                                      <span id="item_color"></span>
                                      <span id="class_card"></span>
                            </div>
                        </div>
                    </div>
                    <div id="page1">
                    </div>
                </div>
            </div>
            <div class="modal-footer" style="display: none">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary">保存</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div>