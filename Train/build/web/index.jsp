<%-- 
    Document   : index.jsp
    Created on : 2026年2月2日, 上午11:13:59
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
        <h1>Hello World!</h1>
        <img id="car" src="img/test.png">
        <input onclick="showMsg()" type="button" value="按我測試">
        <input onclick="hide()" id="buttonTest" type="button" value="隱藏">
        
        <input onclick="addName()" type="button" value="加入名字aa">
        
        <br>
        
        <div id="div1" style="display: none">測試設</div>
        <span>測試測</span>
        
        
        
        <script>
            let x = true;
            function hide(){             
                if (x){
                    document.getElementById("car").style.display = "none";
                    document.getElementById("buttonTest").value = "顯示";
                    x = false;             
                } else {
                    document.getElementById("car").style.display = "";
                    document.getElementById("buttonTest").value = "隱藏";
                    x = true;
                }
            }
            function showMsg() {
                alert("測試");
            }
            
            function addName(){
                parent.document.Frm.UserName.value = "aaa";
            }
        </script>
    </body>
</html>
