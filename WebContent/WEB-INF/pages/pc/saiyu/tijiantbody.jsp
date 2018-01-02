<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<tr>
<td></td>
<td data-name="ivt_oper_listing" style="display: none;"></td>
<td data-name="bx_oper_listing" style="display: none;"></td>
<td data-readonly="work_state">000</td>
<td data-name="position_big">003</td>
<td data-name="position">004</td>
<td data-imge="position_big_img" style="position: relative;"></td>
<td data-imge="itemName_img" style="position: relative;">006img</td>
<td data-name="item_brand">005</td>
<td data-name="item_name">006</td>
<td data-name="item_standard">007</td>
<td data-name="item_num" data-nm="num">008</td>
<td data-imge="light_img" style="position: relative;">010img</td>
<td data-name="item_standard_g">010</td>
<td data-name="item_name_g">009</td>
<td data-name="item_color_g">011</td>
<td data-name="item_num_g"  data-nm="num">012</td>
<td data-name-num="damage_num_g" style="color: red;">013</td>
<c:if test="${requestScope.autr>=10}">
<td data-id="item_id_g_gj1">014</td>
</c:if>
<td data-select="item_name_g_gj1" style="position: relative;">015</td>
<c:if test="${requestScope.autr>=2}">
<td data-name="sd_unit_price_g_gj1" data-nm="num">016</td>
</c:if>
<td data-name="sd_oq_g_gj1"  data-nm="num">017</td>
<c:if test="${requestScope.autr>=10}">
<td data-use="use_oq_g_gj1">18</td>
</c:if>
 
<td data-imge="electrical_img" style="position: relative;">40img</td>
<td data-name="item_name_d">39</td>
<td data-name="item_standard_d">41</td>
<td data-name="item_num_d">42</td>
<td data-name-num="damage_num_d" style="color: red;">43</td>
<%-- <c:if test="${requestScope.autr>=2}"> --%>
<c:if test="${requestScope.autr>=10}"> 
<td data-id="item_id_d_gj1">44</td>
</c:if>
<td data-select="item_name_d_gj1" style="position: relative;">45</td>
<c:if test="${requestScope.autr>=2}">
<td data-name="sd_unit_price_d_gj1">47</td>
</c:if>
<td data-name="sd_oq_d_gj1">48</td>
<c:if test="${requestScope.autr>=10}">
<td data-use="use_oq_d_gj1">49</td>
</c:if>
<td data-client="corp_sim_name" style="position: relative;">002</td>
<%-- <c:if test="${requestScope.autr>=10}"> --%>
<td data-id="customer_id">001</td>
<%-- </c:if> --%>
<%-- <c:if test="${requestScope.autr>=10}"> --%>
<td data-name="sd_order_id"></td>
<%-- </c:if> --%>
<td data-id="seeds_id">id</td>
</tr>