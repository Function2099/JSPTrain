<%-- 
    Document   : test2
    Created on : 2026年2月3日, 上午10:11:13
    Author     : User
--%>

<%@page language="java" contentType="text/html charset=UTF-8" pageEncoding="UTF-8" %>
<% 
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");

for(int i = 0; i <= 9; i++){
        out.print("<p style=font-size:" + (i*3) + "px>" + i + "</p>"); 
    }
int a = 3+5;
String b = a + "123";
out.print(a);
out.print("<br>"+b);
// 這個是用來請求得到UserName的資料，要測試要
String UserName = request.getParameter("UserName");
out.print("<br>Name:"+UserName);

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <!--<h1>Hello World!</h1>-->
    </body>
</html>
