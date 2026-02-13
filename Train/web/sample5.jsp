<%-- 
    Document   : sample5
    Created on : 2026年2月3日, 下午1:39:33
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
        <%
        String str = "Hello, World!";
        String sub = str.substring(7);
        String str1 = "Hello, World!";
        String sub1 = str.substring(0, 5);
        
        out.print(sub);
//        out.print(sub1);
        %>
    </body>
</html>
