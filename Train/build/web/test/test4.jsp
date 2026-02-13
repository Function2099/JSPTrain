<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/Util_IO.jsp" %>
<%
    String itemName="",itemCount="",itemMoney="",itemSum="";
    String ttlSum = req("sum", request);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form name="Frm">
            <table  border="1">
                <tr>
                    <td>項次</td>
                    <td>品名</td>
                    <td>金錢</td>
                    <td>數量</td>
                    <td>小記</td>
                </tr>
               
                    <%
                        for(int i = 1 ; i <= 10; i++){
                            itemName = req("item" + i, request);
                            itemMoney = req("money" + i, request);
                            itemCount = req("count" + i, request);
                            itemSum = req("sum" + i, request);
                    %>
                <tr>
                    <td><%=i%></td>
                    <td><input name="item<%=i%>" id="item<%=i%>" value="<%= itemName %>"></td>
                    <td><input onblur="doSum(<%=i%>)" name="money<%=i%>" id="money<%=i%>" value="<%= itemMoney %>"></td>
                    <td><input onblur="doSum(<%=i%>)" name="count<%=i%>" id="count<%=i%>" value="<%= itemCount %>"></td>
                    <td><input name="sum<%=i%>" id="sum<%=i%>" value="<%= itemSum %>"></td>
                </tr>
                    <%
                        }
                    %>
                <tr >
                    <td colspan="4" align="right">加總：</td>
                    <td><input name="sum" id="sum" value="<%= ttlSum %>"></td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input onclick="doTotal()" type="submit" value="計算">
                    </td>
                </tr>
            </table>
        </form>
        <script>
           function doSum(item){
               var money = document.getElementById("money"+item).value;
               var count = document.getElementById("count"+item).value;
               
               if (money != ""&& count != ""){
                   sum = parseInt(money)*parseInt(count);
                   document.getElementById("sum"+item).value=sum;
               }
           }
           
           function doTotal(){
                var total = 0;
                for (var i = 1; i <= 10; i++){
                    var val = document.getElementById("sum"+i).value;
                    if (val !== ""){
                        total += parseInt(val);
                    }
                }
                document.getElementById("sum").value = total;
            }
        </script>
    </body>
</html>
