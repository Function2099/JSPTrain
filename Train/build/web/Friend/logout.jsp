<%@page import="java.lang.annotation.Target"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="/Util_IO.jsp" %><%@ include file="kernel.jsp" %>
<%
    setSession("J_OrgId", "", session);
    setSession("J_OrgName", "", session);
    
    out.print("<script>top.location.href='/Login.jsp';</script>");

%>

