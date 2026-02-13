<%@ page contentType="text/html;charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%>
<%@ page import="java.sql.*"%>
<html>
<body>
<%
Class.forName("net.sourceforge.jtds.jdbc.Driver").newInstance();
String url="jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";

String user="sa";
String password="root";
Connection Conn= DriverManager.getConnection(url,user,password);
Statement stmt=Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
String sql="";
sql="UPDATE Friend"+
    " SET F_UserName = '劉德華',"+
         "F_UserSex = '0," +
         "F_UserBirthday = 2001-01-01 " +
         "WHERE F_RecId = 5"; 
stmt.executeUpdate(sql);
%>

<%
stmt.close();stmt=null;
Conn.close();Conn=null;
%>
</body>