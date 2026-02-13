<%@ page import="java.sql.*" %>
<%@ include file="Util_IO.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String DRIVER = "net.sourceforge.jtds.jdbc.Driver";
    String URL = "jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";
    String USER = "sa";
    String PWD = "root";
    
    Class.forName(DRIVER);
    Connection Conn = DriverManager.getConnection(URL, USER, PWD);
    Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
    
    String ID = "";
    String pwd = "";
    String sql = "";
    String ScriptStr="";
    String OrgId = "";
    String OrgName = "";
    
    if (isPost(request)){
        ID = req("ID", request);
        pwd = req("pwd", request);
        sql = "SELECT * FROM Org WHERE ID = " + toStr(ID) + " AND isEnable = 1 ";
        ResultSet rs = stmt.executeQuery(sql);
        if (rs.next()) {
            
            if (rs.getString("PWD").equals(pwd)) {
                
                OrgId = rs.getString("OrgId");
                OrgName = rs.getString("OrgName");
                
                setSession("J_OrgId", OrgId, session);
                setSession("J_OrgName", OrgName, session);
                response.sendRedirect("/Friend/Friend.jsp");
                return;
            } else {
                ScriptStr = "<script>alert('密碼錯誤');</script>";
            }
        } else {
            ScriptStr = "<script>alert('帳號錯誤或不存在');</script>";
        }
        rs.close();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>用戶登入</h1>
        <form action="Login.jsp" method="post">
            <table>
                <tr>
                    <td>帳號：<input type="text" id="ID" name="ID" required></td>   
                </tr>
                <tr>
                    <td>密碼：<input type="password" id="pwd" name="pwd" required></td>
                </tr>
                <tr>
                    <td><button type="submit">登入</button><td>
                </tr>
            </table>
            <%= ScriptStr %>
        </form>
    </body>
</html>
