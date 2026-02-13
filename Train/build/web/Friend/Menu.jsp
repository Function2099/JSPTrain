<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="/Util_IO.jsp" %><%@ include file="kernel.jsp" %>
<%
    String DRIVER = "net.sourceforge.jtds.jdbc.Driver";
    String URL = "jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";
    String USER = "sa";
    String PWD = "root";
    Class.forName(DRIVER);
    Connection Conn = DriverManager.getConnection(URL, USER, PWD);
    
    String ScriptStr = "";
    String OrgName = getSession("J_OrgName", session);
    if (OrgName.equals("")) {
        ScriptStr = "<script>top.location.href='Login.jsp';</script>";
    }

    Statement stmtType = Conn.createStatement();
    String sqlType = "SELECT T_RecId, T_Name FROM Friend_Type ORDER BY T_Sort DESC";
    ResultSet rsType = stmtType.executeQuery(sqlType);
    
    String TypeLinks = ""; 

  
    while(rsType.next()){
        String tName = rsType.getString("T_Name");
        String tId = rsType.getString("T_RecId");

        TypeLinks += " <a href='Friend_List.jsp?T=" + tId + "' target='frmBody'>" + tName + "</a><br>";
    }
    
    rsType.close();
    stmtType.close();
    Conn.close(); 
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        歡迎，<%= OrgName %><a href="logout.jsp" target="_top">登出</a>
        <h1>客戶管理</h1>
        <a href="Friend_List.jsp" target="frmBody" >客戶列表</a><br>
        <div class="sub-menu">
            <%= TypeLinks %>
        </div>
        <a href="Friend_Edit.jsp" target="frmBody" >新增客戶</a><br>
        <a href="FriendType_List.jsp" target="frmBody" >類別管理</a><br>
        <a href="FriendStar_List.jsp" target="frmBody" >星座管理</a><br>
        <a href="FriendHobby_List.jsp" target="frmBody" >興趣管理</a><br>
        <a href="FriendTitle_List.jsp" target="frmBody" >職稱管理</a><br>
    </body>
    <%= ScriptStr%>
</html>