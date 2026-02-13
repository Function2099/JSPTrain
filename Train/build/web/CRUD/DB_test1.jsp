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
sql="select * from Friend WHERE F_UserSex = 0 and F_Star >1 and F_Star <6 ORDER BY F_RecId"; 
ResultSet rs=stmt.executeQuery(sql);
while(rs.next()) 
{
%>
data-><%=rs.getString("F_RecId")+":"+rs.getString("F_UserName")+ ":" + rs.getString("F_UserBirthday")%><br>
<%
}    
%>
<%out.print("連接-Conn_OK");%>
<%
rs.close();rs=null;
stmt.close();stmt=null;
Conn.close();Conn=null;
%>
</body>