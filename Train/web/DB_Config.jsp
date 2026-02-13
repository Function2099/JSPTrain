<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 資料庫連線資訊集中管理
    String DRIVER = "net.sourceforge.jtds.jdbc.Driver";
    String URL = "jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";
    String USER = "sa";
    String PWD = "root";

    Connection Conn = null; 
    
    try {
        Class.forName(DRIVER);
        Conn = DriverManager.getConnection(URL, USER, PWD);
    } catch (Exception e) {
        out.print("");
    }
%>
