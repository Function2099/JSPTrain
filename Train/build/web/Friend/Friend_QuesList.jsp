<%-- 
    Document   : Friend_QuesList
    Created on : 2026年2月10日, 下午2:32:14
    Author     : User
--%>
<%@ page contentType="text/html;charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %><%@ include file="kernel.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    
    // 變數宣告與初始化
    String DRIVER = "net.sourceforge.jtds.jdbc.Driver";
    String URL = "jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";
    String USER = "sa";
    String PWD = "root";

    String sql = "";
    String sqlDel = "";
    String sqlUpd = "";
    String quesList = "";
    String SelectPage = "";
    String currentId = "";
    String currentName = "";
    String currentSort = "";
    
    int PageSize = 6;
    int TTL = 0;
    int Page = 1;
    int TTLPage = 0;
    int qCount = 0;
    boolean isEditing = false;

    // 接收參數
    String Keyword = req("keyword", request);
    String editId = req("editId", request);
    String OP = req("OP", request);
    String dId = req("TitleId", request);
    String currentPage = req("p", request);
    String FRecId = req("F_RecId", request); 

    // 資料庫連線與動作處理 
    Class.forName(DRIVER);
    Connection Conn = DriverManager.getConnection(URL, USER, PWD);
    Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);   
 
       // 刪除
//    if ("Del".equals(OP) && !dId.equals("")) {
//        sqlDel = "DELETE FROM Friend_Ques WHERE Q_RecId = "+dId;
//        PreparedStatement pstmtDel = Conn.prepareStatement(sqlDel);
//        pstmtDel.executeUpdate();
//        pstmtDel.close();
//        if (stmt != null) stmt.close();
//        if (Conn != null) Conn.close();
//        response.sendRedirect("Friend_QuesList.jsp");
//        return;
//    }
    
    // 執行查詢與分頁邏輯
    sql = "SELECT Q_RecId, Q_Subject, Q_Content, Q_RecDate, Q_FRecId FROM Friend_Ques WHERE Q_FRecId = " + FRecId;
    if (!Keyword.trim().equals("")) {
        sql += " AND (Q_Subject LIKE '%" + Keyword + "%' OR Q_Content LIKE '%" + Keyword + "%')";
    }
    sql += " ORDER BY Q_RecDate DESC";
    ResultSet rs = stmt.executeQuery(sql);

    // 取得總筆數
    rs.last();
    TTL = rs.getRow();
    rs.beforeFirst();

    // 分頁計算
    TTLPage = (int) Math.ceil((double) TTL / PageSize);
    Page = (currentPage.equals("") || currentPage.equals("0")) ? 1 : Integer.parseInt(currentPage);
    
    if (TTL > 0) {
        rs.absolute((Page - 1) * PageSize);
    }

    // 封裝列表內容
    while (rs.next() && qCount < PageSize) {
        qCount++;
        currentId = rs.getString("Q_RecId");
        String currentSubject = rs.getString("Q_Subject");
        String currentContent = rs.getString("Q_Content");
        String currentDate = rs.getString("Q_RecDate");

        quesList += "<tr>";
        quesList += "  <td align='center'>" + ((Page - 1) * PageSize + qCount) + "</td>";

        quesList += "  <td align='center'>" + currentSubject + "</td>";
        quesList += "  <td align='center'>" + currentContent + "</td>";
        quesList += "  <td align='center'>" + currentDate + "</td>";

        quesList += "  <td align='center'>";
        quesList += "    <a href='QuesEdit.jsp?OP=Edit&Q_RecId=" + currentId + "&F_RecId=" + FRecId + "'>編輯</a>&nbsp;&nbsp;";
        quesList += "    <a href='javascript:void(0)' onclick=\"Del('Friend_QuesList.jsp?OP=Del&Q_RecId=" + currentId + "&F_RecId=" + FRecId + "')\">刪除</a>";
        quesList += "  </td>";

        quesList += "</tr>";
    }

    // 頁碼下拉選單
    SelectPage = "<select name='p' onchange='document.Frm.submit();'>";
    for (int i = 1; i <= TTLPage; i++) {
        SelectPage += "<option value='" + i + "' " + isSelected(String.valueOf(Page), String.valueOf(i)) + ">第 " + i + " 頁</option>";
    }
    SelectPage += "</select>";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

    </head>
    <body>
        <h1>類型列表</h1>

        <form name="Frm" method="post" action="Friend_QuesList.jsp">
            <input type="hidden" name="F_RecId" value="<%= FRecId %>">
                <table border="0" width="100%">
                    <tr>
                        <td>
                            <a href="Friend_List.jsp">返回通訊錄</a>&nbsp;&nbsp;&nbsp;
                            <a href="QuesEdit.jsp?F_RecId=<%= FRecId %>&OP=ADD">新增問題</a>&nbsp;&nbsp;&nbsp;
                        </td>
                        <td align="right">
                            <input type="text" name="keyword" id="p" placeholder="Keyword" value="<%= Keyword%>">&nbsp;
                            <input type="submit" value="查詢">
                        </td>
                    </tr>
                    <tr>
                        <td>總筆數：<%= TTL%></td>
                        <td align="right">頁數：<%= SelectPage %>&nbsp;/&nbsp;<%= TTLPage%></td>
                    </tr>
                </table>
        </form>
        <table border="1" width="100%">
            <tr>
                <th>項次</th>
                <th>問題標題</th>
                <th>內容</th>
                <th>紀錄時間</th>
                <th>功能</th>
            </tr>
            <%= quesList %>
        </table>
        <script>
            function Del(URL){
                if (confirm("確定要刪除嗎？")) location.href = URL;
            }
        </script>
    </body>
</html>
<%
    // 在頁面渲染結束後，確保最後一個查詢用的 rs 和 stmt 被關閉
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (Conn != null) Conn.close();
%>