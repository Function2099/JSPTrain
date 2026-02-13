<%@ page import="java.sql.*" %>
<%@ include file="Util_IO.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String Name = (String)application.getAttribute("Name");
    out.print(Name);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
    </body>
</html>
