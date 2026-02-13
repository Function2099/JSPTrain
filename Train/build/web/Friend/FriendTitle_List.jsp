<%@ page contentType="text/html;charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %><%@ include file="kernel.jsp" %>
<%
    // 變數宣告與初始化
    String DRIVER = "net.sourceforge.jtds.jdbc.Driver";
    String URL = "jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";
    String USER = "sa";
    String PWD = "root";

    String sql = "";
    String sqlDel = "";
    String sqlUpd = "";
    String titleList = "";
    String SelectPage = "";
    String currentId = "";
    String currentName = "";
    String currentSort = "";

    // 調整排序相關的變數
    String currentSortSql = "";
    String findTarget = "";
    String targetId = "";
    int mySort = 0;
    int targetSort = 0;
    ResultSet rsSort = null;
    ResultSet rsTarget = null;
    
    int PageSize = 10;
    int TTL = 0;
    int Page = 1;
    int TTLPage = 0;
    int tiCount = 0;
    boolean isEditing = false;

    // 接收參數
    String Keyword = req("keyword", request);
    String editId = req("editId", request);
    String OP = req("OP", request);
    String dId = req("TitleId", request);
    String currentPage = req("p", request);

    // 資料庫連線與動作處理 
    Class.forName(DRIVER);
    Connection Conn = DriverManager.getConnection(URL, USER, PWD);
    Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

    // 刪除
    if ("Del".equals(OP) && !dId.equals("")) {
        sqlDel = "DELETE FROM Friend_Title WHERE T_RecId = "+dId;
        PreparedStatement pstmtDel = Conn.prepareStatement(sqlDel);
        pstmtDel.executeUpdate();
        pstmtDel.close();
        if (stmt != null) stmt.close();
        if (Conn != null) Conn.close();
        response.sendRedirect("FriendType_List.jsp");
        return;
    }

    // 處理排序移動
    if (("UP".equals(OP) || "DOWN".equals(OP)) && !dId.equals("")) {
        currentSortSql = "SELECT Ti_Sort FROM Friend_Title WHERE Ti_RecId = " + dId;
        rsSort = stmt.executeQuery(currentSortSql);
        if (rsSort.next()) {
            mySort = rsSort.getInt("Ti_Sort");
        }
        
        
        if ("UP".equals(OP)) {
            findTarget = "SELECT TOP 1 Ti_RecId, Ti_Sort FROM Friend_Title WHERE Ti_Sort < " + mySort + " ORDER BY Ti_Sort DESC";
        } else {
            findTarget = "SELECT TOP 1 Ti_RecId, Ti_Sort FROM Friend_Title WHERE Ti_Sort > " + mySort + " ORDER BY Ti_Sort ASC";
        }

        rsTarget = stmt.executeQuery(findTarget);
        if (rsTarget.next()) {
            targetId = rsTarget.getString("Ti_RecId");
            targetSort = rsTarget.getInt("Ti_Sort");
            stmt.executeUpdate("UPDATE Friend_Title SET Ti_Sort = " + targetSort + " WHERE Ti_RecId = " + dId);
            stmt.executeUpdate("UPDATE Friend_Title SET Ti_Sort = " + mySort + " WHERE Ti_RecId = " + targetId);
        }
        rsSort.close();
        rsTarget.close();  
        if (stmt != null) stmt.close();
        if (Conn != null) Conn.close();
        response.sendRedirect("FriendTitle_List.jsp");
        return;
    }
    
    // 更新
    if (isPost(request)) {
        String tId = req("TitleId", request);
        String tName = req("TitleName", request);
        sqlUpd = "UPDATE Friend_Type SET Ti_Name = " + toStr(tName) + " WHERE Ti_RecId = " + tId;
        PreparedStatement pstmtUpd = Conn.prepareStatement(sqlUpd);
        pstmtUpd.executeUpdate();
        pstmtUpd.close();
        if (stmt != null) stmt.close();
        if (Conn != null) Conn.close();
        response.sendRedirect("FriendTitle_List.jsp");
        return;
    }

    // 執行查詢與分頁邏輯
    sql = "SELECT Ti_RecId, Ti_Name, Ti_Sort FROM Friend_Title ";
    if (!Keyword.trim().equals("")) {
        sql += " WHERE (Ti_Name LIKE '%" + Keyword + "%')";
    }
    sql += " ORDER BY Ti_Sort ASC";
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
    while (rs.next() && tiCount < PageSize) {
        tiCount++;
        currentId = rs.getString("Ti_RecId");
        currentName = rs.getString("Ti_Name");
        currentSort = rs.getString("Ti_Sort");
        isEditing = currentId.equals(editId);

        titleList += "<tr>";
        titleList += "  <td align='center'>" + ((Page - 1) * PageSize + tiCount) + "</td>";
        titleList += "  <form method='post' action='FriendTitle_List.jsp'>";
        titleList += "    <input type='hidden' name='TitleId' value='" + currentId + "'>";
        titleList += "    <td align='center'>" + (isEditing ? "<input type='text' name='TitleName' value='" + currentName + "'>" : currentName) + "</td>";
        titleList += "    <td align='center'>" + currentSort + "</td>";
        titleList += "    <td align='center'>";
        
        // 功能按鈕
        if (isEditing) {
            titleList += "<input type='submit' value='儲存'> <a href='FriendTitle_List.jsp'>取消</a>";
        } else {
            titleList += "<a href='FriendTitle_List.jsp?editId=" + currentId + "'>編輯</a>&nbsp;&nbsp;";
            titleList += "<a href='FriendTitle_List.jsp?OP=UP&TitleId=" + currentId + "'>上移</a>&nbsp;&nbsp;";
            titleList += "<a href='FriendTitle_List.jsp?OP=DOWN&TitleId=" + currentId + "'>下移</a>&nbsp;&nbsp;";
            titleList += "<a href='javascript:void(0)' onclick=\"Del('FriendTitle_List.jsp?OP=Del&TitleId=" + currentId + "')\">刪除</a>";
        }
        titleList += "    </td>";
        titleList += "  </form>";
        titleList += "</tr>";
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

        <form name="Frm" method="post" action="FriendType_List.jsp">
                <table border="0" width="100%">
                    <tr>
                        <td><a href="Friend_List.jsp">列表</a>&nbsp;&nbsp;&nbsp;<a href="titleList_Edit.jsp">新增</a>&nbsp;&nbsp;&nbsp;<a></a></td>
                        <td align="right"><input type="text" name="keyword" id="p" placeholder="Keyword" value="<%= Keyword%>">&nbsp;<input type="submit" value="查詢"></td>
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
                <th>類別名稱</th>
                <th>排列順序</th>
                <th>功能</th>
            </tr>
            <%= titleList %>
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