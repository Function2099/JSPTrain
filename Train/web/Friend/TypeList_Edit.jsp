<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %><%@ include file="kernel.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    String tName = req("T_Name", request);
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
 
        sqlMax = "SELECT TOP 1 T_Sort FROM Friend_Type ORDER BY T_Sort DESC";
        rsMax = stmtMax.executeQuery(sqlMax);
        if (rsMax.next()) {
            // 拿到目前最大的號碼，然後 +1
            nextSort = rsMax.getInt("T_Sort") + 1;
        }
    
        sqlInsert = "INSERT INTO Friend_Type (T_Name, T_Sort) VALUES (?, ?)";
        PreparedStatement pstmt = Conn.prepareStatement(sqlInsert);
        pstmt.setString(1, tName);
        pstmt.setInt(2, nextSort);
        
        pstmt.executeUpdate();
        
        pstmt.close();
        response.sendRedirect("FriendType_List.jsp");
        return;
    }



%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>新增類型</title>
    </head>
    <body>
        <h1>新增通訊錄類型</h1>
        <form method="post" action="TypeList_Edit.jsp" name="TypeAdd">
            <table border="1">
                <tr>
                    <td>類型名稱：</td>
                    <td><input type="text" name="T_Name" required placeholder="例如：同事、家人"></td>
                </tr>
                <td colspan="2" align="center">
                    <input type="submit" value="新增" >
                    <input type="button" value="返回" onclick="location.href='FriendType_List.jsp';">
                </td>
            </table>
        </form>
    </body>
</html>
