<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %><%@ include file="kernel.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    String hName = req("H_Name", request);
    int nextSort = 0; // 預設值

    // 連線設定
    String DRIVER = "net.sourceforge.jtds.jdbc.Driver";
    String URL = "jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";
    String USER = "sa";
    String PWD = "root";
    Class.forName(DRIVER);
    Connection Conn = DriverManager.getConnection(URL, USER, PWD);
%>

<%
    Statement stmtMax = Conn.createStatement();
    String sqlMax="";
    ResultSet rsMax = null;
    String sqlInsert = "";
    
    if (isPost(request)){
 
        sqlMax = "SELECT TOP 1 H_Sort FROM Friend_Hobby ORDER BY H_Sort DESC";
        rsMax = stmtMax.executeQuery(sqlMax);
        if (rsMax.next()) {
            // 拿到目前最大的號碼，然後 +1
            nextSort = rsMax.getInt("H_Sort") + 1;
        }
        
        sqlInsert = "INSERT INTO Friend_Hobby (H_Name, H_Sort) VALUES (" + toStr(hName) +", " + nextSort + ")";
        PreparedStatement pstmt = Conn.prepareStatement(sqlInsert);
        pstmt.executeUpdate();
        
        pstmt.close();
        response.sendRedirect("FriendHobby_List.jsp");
        return;
    }



%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>新增興趣選項</title>
    </head>
    <body>
        <h1>新增興趣選項</h1>
        <form method="post" action="HobbyList_Edit.jsp" name="HobbyAdd">
            <table border="1">
                <tr>
                    <td>興趣名稱：</td>
                    <td><input type="text" name="H_Name" required></td>
                </tr>
                <td colspan="2" align="center">
                    <input type="submit" value="新增" >
                    <input type="button" value="返回" onclick="location.href='FriendHobby_List.jsp';">
                </td>
            </table>
        </form>
    </body>
</html>
