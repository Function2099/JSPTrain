<%-- 
    Document   : sample4
    Created on : 2026年2月3日, 下午1:00:22
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    String dateStr = request.getParameter("myDate");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
        String name = (request.getParameter("UserName") == null) ? "" : request.getParameter("UserName").trim();

        if(name.isEmpty()) {
            out.print("沒填名字");
        }else{
            out.print(name);
        }
        %>
    </body>
</html>
