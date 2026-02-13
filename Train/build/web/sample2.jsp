<%-- 
    Document   : sample2
    Created on : 2026年2月3日, 下午12:07:40
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
        String str = "I love Java";
        String[] words = str.split(" ");
        for (String word : words) {
            out.println(word);
        }
        %>
    </body>
</html>
