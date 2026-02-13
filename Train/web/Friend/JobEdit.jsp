<%-- 
    Document   : JobEdit
    Created on : 2026年2月10日, 下午5:45:43
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%><% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.sql.*" %>
<%@ include file="/Util_IO.jsp" %><%@ include file="kernel.jsp" %>
<%
    String subject = "";
    String content = "";
    String JName = "";
    int status = 0;
    
    String DRIVER = "net.sourceforge.jtds.jdbc.Driver";
    String URL = "jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";
    String USER = "sa";
    String PWD = "root";
    String sql = "";
    String sqlEdit = "";
    
    // 接收參數
    String FRecId = req("F_RecId", request);
    String JRecId = req("J_RecId", request);
    String OP = req("OP", request);
    String JStatus = req("J_Status", request);
    
    Class.forName(DRIVER);
    Connection Conn = DriverManager.getConnection(URL, USER, PWD);
    Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE); 

    if (isPost(request)) {

        subject = req("J_Subject", request);
        content = req("J_Content", request);
        JName = req("J_Name", request);
        JStatus = req("J_Status", request);
        
        if ("ADD".equals(OP)) {
            // 新增紀錄
            sql = "INSERT INTO Friend_Job (J_Subject, J_Content, J_FRecId, J_Name, J_Status, J_RecDate) VALUES ("
                  + toStr(subject) + ", " + toStr(content) + ", " + FRecId + ", " + toStr(JName) + ", " + JStatus + ", GETDATE())";
        } else if ("Edit".equals(OP)) {
            // 編輯紀錄
            sql  = "UPDATE Friend_Job SET J_Subject = " + toStr(subject); 
            sql += ", J_Content = " + toStr(content); 
            sql += ", J_Name = " + toStr(JName);
            sql += ", J_Status = " + JStatus;
            sql += ", J_RecDate = GETDATE() WHERE J_RecId = " + JRecId;
        }

        if (!"".equals(sql)) {
            stmt.executeUpdate(sql);
        }

        stmt.close();
        Conn.close();
        response.sendRedirect("FriendJob_List.jsp?F_RecId=" + FRecId);
        return; 
    }
    
    if("Edit".equals(OP) && !JRecId.equals("")){
        sqlEdit = "SELECT J_Subject, J_Content, J_Name, J_Status FROM Friend_Job WHERE J_RecId = " + JRecId;
        ResultSet rs = stmt.executeQuery(sqlEdit);
        if(rs.next()){
            subject = rs.getString("J_Subject");
            content = rs.getString("J_Content");
            JName = rs.getString("J_Name");
            status = rs.getInt("J_Status");
        }
        rs.close();
    }
    stmt.close();
    if(Conn != null) Conn.close();

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>派工紀錄編輯</title>
    </head>
    <body>
        <h2><%= "ADD".equals(OP) ? "新增" : "編輯" %>派工紀錄</h2>
        <hr>
    
    <form action="JobEdit.jsp" method="post" name="JobForm">
            <input type="hidden" name="F_RecId" value="<%= FRecId %>">
            <input type="hidden" name="J_RecId" value="<%= JRecId %>">
            <input type="hidden" name="OP" value="<%= OP %>">

            <table border="0">
                <tr>
                    <td><b>標題：</b></td>
                    <td>
                        <input type="text" name="J_Subject" size="50" value="<%= subject %>" required>
                    </td>
                </tr>
                <tr>
                    <td><b>派工名字：</b></td>
                    <td>
                        <input type="text" name="J_Name" size="50" value="<%= JName %>" required>
                    </td>
                </tr>
                <tr>
                    <td><b>目前狀態：</b></td>
                    <td>
                        <select name="J_Status">
                            <option value="0" <%= status == 0 ? "selected" : "" %>>未處理</option>
                            <option value="1" <%= status == 1 ? "selected" : "" %>>已完成</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td valign="top"><b>詳細內容：</b></td>
                    <td>
                        <textarea name="J_Content" cols="50" rows="10"><%= content %></textarea>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td align="right">
                        <br>
                        <a href="FriendJob_List.jsp?F_RecId=<%= FRecId %>">返回</a>
                        &nbsp;&nbsp;
                        <input type="submit" value="儲存">
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
