<%@ page contentType="text/html;charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %>
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

int totalRows = 0;
for (int i = 1; i <= 1; i++) {
        sql = "INSERT INTO Friend (" +
              " F_UserName, F_UserTel, F_UserSex, F_UserHobby, " +
              " F_UserSchool, F_UserBirthday, F_Star, F_Type, F_UserEmail" +
              ") VALUES (" +
              toStr("陳'大明"+i) + ", " + 
              toStr("0912345678") + ", " + 
              toStr("1")+" , " +           
              toStr("'1, 2'")+", " +      
              toStr("'A'")+" , " +           
              toStr("1982-05-01")+" , " + 
              toStr("10")+" , " +       
              toStr("1")+" ," +  
              toStr("'aab@gmail.com'")+
              " )";
out.print(sql+"<br>");
totalRows += stmt.executeUpdate(sql);}


%>
<%  
    out.print("成功新增 " + totalRows + " 筆資料");%>
<%
stmt.close();stmt=null;
Conn.close();Conn=null;
%>
</body>