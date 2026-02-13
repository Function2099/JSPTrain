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
//sql="DELETE FROM Friend WHERE F_RecId = 6";
sql="DELETE FROM Friend WHERE F_RecId > 10";
stmt.executeUpdate(sql);
%>
<%
stmt.close();stmt=null;
Conn.close();Conn=null;
%>
</body>