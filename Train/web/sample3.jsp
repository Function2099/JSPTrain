<%-- 
    Document   : sample3
    Created on : 2026年2月3日, 下午12:55:07
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
        String Str = new String("    www.runoob.com    ");
        out.print("原始值 :" );
        out.println(Str);
        out.print("刪除空白:" );
        out.println( Str.trim() );
        %>
    </body>
</html>
