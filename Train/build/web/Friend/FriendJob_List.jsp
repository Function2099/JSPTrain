<%-- 
    Document   : Friend_QuesList
    Created on : 2026年2月10日, 下午2:32:14
    Author     : User
--%>
<%@ page contentType="text/html;charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %>
<%@ include file="kernel.jsp" %>
<%
    
    
    // 變數宣告與初始化
    String DRIVER = "net.sourceforge.jtds.jdbc.Driver";
    String URL = "jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";
    String USER = "sa";
    String PWD = "root";

    String sql = "";
    String jobList = "";
    String SelectPage = "";
    String currentId = "";
    
    // 欄位相關宣告
    String currentSubject = "";
    String currentContent = "";
    String currentName = "";
    String currentDate = "";
    int currentStatus = 0;
    String statusStr = "";
    
    int PageSize = 6;
    int TTL = 0;
    int Page = 1;
    int TTLPage = 0;
    int jCount = 0;

    // 接收參數
    String Keyword = req("keyword", request);
    String OP = req("OP", request);
    String dId = req("J_RecId", request);
    String currentPage = req("p", request);
    String FRecId = req("F_RecId", request);

    // 資料庫連線與動作處理 
    Class.forName(DRIVER);
    Connection Conn = DriverManager.getConnection(URL, USER, PWD);
    Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);   
 
       // 刪除
    if ("Del".equals(OP) && !dId.equals("")) {
        String sqlDel = "DELETE FROM Friend_Job WHERE J_RecId = " + dId;
        stmt.executeUpdate(sqlDel);
        stmt.close();
        Conn.close();
        response.sendRedirect("FriendJob_List.jsp?F_RecId=" + FRecId);
        return;
    }
    
    // 執行查詢與分頁邏輯
    sql = "SELECT J_RecId, J_Subject, J_Content, J_Name, J_RecDate, J_Status FROM Friend_Job WHERE J_FRecId = " + FRecId;
    if (!Keyword.trim().equals("")) {
        sql += " AND (J_Subject LIKE '%" + Keyword + "%' OR J_Content LIKE '%" + Keyword + "%' OR J_Name LIKE '%" + Keyword + "%')";
    }
    sql += " ORDER BY J_RecDate DESC";
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
    while (rs.next() && jCount < PageSize) {
        jCount++;
        currentId = rs.getString("J_RecId");
        currentSubject = rs.getString("J_Subject");
        currentContent = rs.getString("J_Content");
        currentName = rs.getString("J_Name");
        currentDate = rs.getString("J_RecDate");
        currentStatus = rs.getInt("J_Status");

        // 狀態轉換文字輸出
        if(currentStatus == 0) statusStr = "未處理";
        if(currentStatus == 1) statusStr = "已完成";
        
        jobList += "<tr>";
        jobList += "  <td align='center'>" + ((Page - 1) * PageSize + jCount) + "</td>";
        jobList += "  <td align='center'>" + currentSubject + "</td>";
        jobList += "  <td>" + currentContent + "</td>";
        jobList += "  <td align='center'>" + currentName + "</td>";
        jobList += "  <td align='center'>" + statusStr + "</td>";
        jobList += "  <td align='center'>" + currentDate + "</td>";

        jobList += "  <td align='center'>";
        jobList += "    <a href='JobEdit.jsp?OP=Edit&J_RecId=" + currentId + "&F_RecId=" + FRecId + "'>編輯</a>&nbsp;&nbsp;";
        jobList += "    <a href=\"javascript:Del('FriendJob_List.jsp?OP=Del&J_RecId=" + currentId + "&F_RecId=" + FRecId + "')\">刪除</a>";
        jobList += "  </td>";
        jobList += "</tr>";
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
        <title>派工紀錄列表</title>

    </head>
    <body>
        <h1>派工紀錄列表</h1>

        <form name="Frm" method="post" action="FriendJob_List.jsp">
            <input type="hidden" name="F_RecId" value="<%= FRecId %>">
                <table border="0" width="100%">
                    <tr>
                        <td>
                            <a href="Friend_List.jsp">返回通訊錄</a>&nbsp;&nbsp;&nbsp;
                            <a href="JobEdit.jsp?F_RecId=<%= FRecId %>&OP=ADD">新增紀錄</a>&nbsp;&nbsp;&nbsp;
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
                <th>出勤人員</th>
                <th>狀態</th>
                <th>紀錄時間</th>
                <th>功能</th>
            </tr>
            <%= jobList %>
        </table>
        <script>
            function Del(URL){
                if (confirm("確定要刪除嗎？")) location.href = URL;
            }
        </script>
    </body>
</html>
<%
    // 在頁面渲染結束後，確保最後一個查詢用的rs和stmt被關閉
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (Conn != null) Conn.close();
%>
