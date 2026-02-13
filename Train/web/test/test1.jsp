<%-- 
    Document   : test1
    Created on : 2026年2月2日, 下午4:53:38
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                <tr>
                    <td>1</td>
                    <td><input name="item1" id="item1"></td>
                    <td><input onblur="doSum(1)" name="money1" id="money1"></td>
                    <td><input onblur="doSum(1)" name="count1" id="count1"></td>
                    <td><input name="sum1" id="sum1"></td>
                </tr>
                <tr>
                    <td>2</td>
                    <td><input name="item2" id="item2"></td>
                    <td><input onblur="doSum(2)" name="money2" id="money2"></td>
                    <td><input onblur="doSum(2)" name="count2" id="count2"></td>
                    <td><input name="sum2" id="sum2"></td>
                </tr>
                <tr> 
                    <td>3</td>
                    <td><input name="item3" id="item3"></td>
                    <td><input onblur="doSum(3)" name="money3" id="money3"></td>
                    <td><input onblur="doSum(3)" name="count3" id="count3"></td>
                    <td><input name="sum3" id="sum3"></td>
                </tr>
                <tr> 
                    <td>4</td>
                    <td><input name="item4" id="item4"></td>
                    <td><input onblur="doSum(4)" name="money4" id="money4"></td>
                    <td><input onblur="doSum(4)" name="count4" id="count4"></td>
                    <td><input name="sum4" id="sum4"></td>
                </tr>
                <tr> 
                    <td>5</td>
                    <td><input name="item5" id="item5"></td>
                    <td><input onblur="doSum(5)" name="money5" id="money5"></td>
                    <td><input onblur="doSum(5)" name="count5" id="count5"></td>
                    <td><input name="sum5" id="sum5"></td>
                </tr>
                <tr> 
                    <td>6</td>
                    <td><input name="item6" id="item6"></td>
                    <td><input onblur="doSum(6)" name="money6" id="money6"></td>
                    <td><input onblur="doSum(6)" name="count6" id="count6"></td>
                    <td><input name="sum6" id="sum6"></td>
                </tr>
                <tr> 
                    <td>7</td>
                    <td><input name="item7" id="item7"></td>
                    <td><input onblur="doSum(7)" name="money7" id="money7"></td>
                    <td><input onblur="doSum(7)" name="count7" id="count7"></td>
                    <td><input name="sum7" id="sum7"></td>
                </tr>
                <tr> 
                    <td>8</td>
                    <td><input name="item8" id="item8"></td>
                    <td><input onblur="doSum(8)" name="money8" id="money8"></td>
                    <td><input onblur="doSum(8)" name="count8" id="count8"></td>
                    <td><input name="sum8" id="sum8"></td>
                </tr>
                <tr> 
                    <td>9</td>
                    <td><input name="item9" id="item9"></td>
                    <td><input onblur="doSum(9)" name="money9" id="money9"></td>
                    <td><input onblur="doSum(9)" name="count9" id="count9"></td>
                    <td><input name="sum9" id="sum9"></td>
                </tr>
                <tr> 
                    <td>10</td>
                    <td><input name="item10" id="item10"></td>
                    <td><input onblur="doSum(10)" name="money10" id="money10"></td>
                    <td><input onblur="doSum(10)" name="count10" id="count10"></td>
                    <td><input  name="sum10" id="sum10"></td>
                </tr>
                <tr >
                    <td colspan="4" align="right">加總：</td>
                    <td><input  name="sum" id="sum"></td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input onclick="doTotal()" type="button" value="計算">
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
