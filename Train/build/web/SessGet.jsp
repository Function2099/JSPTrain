<%-- 
    Document   : SessGet
    Created on : 2026年2月11日, 上午9:34:55
    Author     : User
--%>
<%@ page import="java.sql.*" %>
<%@ include file="Util_IO.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String Name = (String)session.getAttribute("Name");
    out.print("Name=>"+Name);


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
