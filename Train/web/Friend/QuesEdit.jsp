<%@page contentType="text/html" pageEncoding="UTF-8"%><% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="java.sql.*" %>
<%@ include file="/Util_IO.jsp" %><%@ include file="kernel.jsp" %>
<%
    String subject = "";
    String content = "";
    
    String DRIVER = "net.sourceforge.jtds.jdbc.Driver";
    String URL = "jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";
    String USER = "sa";
    String PWD = "root";
    String sql = "";
    
    // 接收參數
    String FRecId = req("F_RecId", request);
    String QRecId = req("Q_RecId", request);
    String OP = req("OP", request);
    subject = req("Q_Subject", request);
    content = req("Q_Content", request);
    
    Class.forName(DRIVER);
    Connection Conn = DriverManager.getConnection(URL, USER, PWD);
    Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);   
    
    if (isPost(request)) {

        if ("ADD".equals(OP)) {
            // 新增問題
            sql = "INSERT INTO Friend_Ques (Q_Subject, Q_Content, Q_FRecId, Q_RecDate) VALUES ("+toStr(subject)+" , "+ toStr(content)+", "+FRecId+", GETDATE())";
            PreparedStatement pstmt = Conn.prepareStatement(sql);
            pstmt.executeUpdate();
            pstmt.close();
        } else if ("Edit".equals(OP)) {
            // 編輯問題
            sql = "UPDATE Friend_Ques SET Q_Subject = "+toStr(subject)+", Q_Content = "+toStr(content)+", Q_RecDate = GETDATE() WHERE Q_RecId = " + QRecId;
            PreparedStatement pstmt = Conn.prepareStatement(sql);
            pstmt.executeUpdate();
            pstmt.close();
        }

        // 關閉連線並導回列表
        Conn.close();
        response.sendRedirect("Friend_QuesList.jsp?F_RecId=" + FRecId);
        return; 
    }
    
    if("Edit".equals(OP) && !QRecId.equals("")){
        String findSql = "SELECT Q_Subject, Q_Content FROM Friend_Ques WHERE Q_RecId = " + QRecId;
        ResultSet rs = stmt.executeQuery(findSql);
//        out.print(findSql);
        
        if(rs.next()){
            subject = rs.getString("Q_Subject");
            content = rs.getString("Q_Content");
        }
        rs.close();
        stmt.close();
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>問題紀錄</title>
    </head>
    <body>
        <h2><%= "ADD".equals(OP) ? "新增" : "編輯" %>問題紀錄</h2>
        <hr>
    
        <form action="QuesEdit.jsp" method="post">
            <input type="hidden" name="F_RecId" value="<%= FRecId %>">
            <input type="hidden" name="Q_RecId" value="<%= QRecId %>">
            <input type="hidden" name="OP" value="<%= OP %>">

            <table border="0">
                <tr>
                    <td><b>問題主題：</b></td>
                    <td>
                        <input type="text" name="Q_Subject" size="50" value="<%= subject %>" required>
                    </td>
                </tr>
                <tr>
                    <td valign="top"><b>問題內容：</b></td>
                    <td>
                        <textarea name="Q_Content" cols="50" rows="10"><%= content %></textarea>
                    </td>
                </tr>
                <tr>
                    <td></td>
                    <td align="right">
                        <br>
                        <a href="Friend_QuesList.jsp?F_RecId=<%= FRecId %>">取消</a>
                        &nbsp;&nbsp;
                        <input type="submit" value="確認儲存">
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>
