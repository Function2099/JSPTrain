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
    String sqlDel = "";
    String sqlUpd = "";
    String hobbiesList = "";
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
    int hCount = 0;
    boolean isEditing = false;

    // 接收參數
    String Keyword = req("keyword", request);
    String editId = req("editId", request);
    String OP = req("OP", request);
    String dId = req("HobbyId", request);
    String currentPage = req("p", request);

    // 資料庫連線與動作處理
    Class.forName(DRIVER);
    Connection Conn = DriverManager.getConnection(URL, USER, PWD);
    Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

    // 刪除
    if ("Del".equals(OP) && !dId.equals("")) {
        sqlDel = "DELETE FROM Friend_Hobby WHERE H_RecId = " + dId;
        PreparedStatement pstmtDel = Conn.prepareStatement(sqlDel);
        pstmtDel.executeUpdate();
        pstmtDel.close();
        response.sendRedirect("FriendHobby_List.jsp");
        return;
    }

     
    // 處理排序移動
    if (("UP".equals(OP) || "DOWN".equals(OP)) && !dId.equals("")) {
        currentSortSql = "SELECT H_Sort FROM Friend_Hobby WHERE H_RecId = " + dId;
        rsSort = stmt.executeQuery(currentSortSql);
        if (rsSort.next()) {
            mySort = rsSort.getInt("H_Sort");
        }
        
        if ("UP".equals(OP)) {
            findTarget = "SELECT TOP 1 H_RecId, H_Sort FROM Friend_Hobby WHERE H_Sort < " + mySort + " ORDER BY H_Sort DESC";
        } else {
            findTarget = "SELECT TOP 1 H_RecId, H_Sort FROM Friend_Hobby WHERE H_Sort > " + mySort + " ORDER BY H_Sort ASC";
        }

        rsTarget = stmt.executeQuery(findTarget);
        if (rsTarget.next()) {
            targetId = rsTarget.getString("H_RecId");
            targetSort = rsTarget.getInt("H_Sort");
            stmt.executeUpdate("UPDATE Friend_Hobby SET H_Sort = " + targetSort + " WHERE H_RecId = " + dId);
            stmt.executeUpdate("UPDATE Friend_HObby SET H_Sort = " + mySort + " WHERE H_RecId = " + targetId);
        }
        rsSort.close();
        rsTarget.close();  
        if (stmt != null) stmt.close();
        if (Conn != null) Conn.close();
        response.sendRedirect("FriendHobby_List.jsp");
        return;
    }
    
    // 更新
    if (isPost(request)) {
        String hId = req("HobbyId", request);
        String hName = req("HobbyName", request);
        sqlUpd = "UPDATE Friend_Hobby SET H_Name = "+ toStr(hName) +" WHERE H_RecId = " + hId;
        PreparedStatement pstmtUpd = Conn.prepareStatement(sqlUpd);
        pstmtUpd.executeUpdate();
        pstmtUpd.close();
        response.sendRedirect("FriendHobby_List.jsp");
        return;
    }

    // 執行查詢與分頁邏輯
    sql = "SELECT * FROM Friend_Hobby ";
    if (!Keyword.trim().equals("")) {
        sql += " WHERE (H_Name LIKE '%" + Keyword + "%')";
    }
    sql += " ORDER BY H_Sort ASC";

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
    while (rs.next() && hCount < PageSize) {
        hCount++;
        currentId = rs.getString("H_RecId");
        currentName = rs.getString("H_Name");
        currentSort = rs.getString("H_Sort");
        isEditing = currentId.equals(editId);

        hobbiesList += "<tr>";
        hobbiesList += "  <td align='center'>" + ((Page - 1) * PageSize + hCount) + "</td>";
        hobbiesList += "  <form method='post' action='FriendHobby_List.jsp'>";
        hobbiesList += "    <input type='hidden' name='HobbyId' value='" + currentId + "'>";
        hobbiesList += "    <input type='hidden' name='HobbySort' value='" + currentSort + "'>";
        hobbiesList += "    <td align='center'>" + (isEditing ? "<input type='text' name='HobbyName' value='" + currentName + "'>" : currentName) + "</td>";
        hobbiesList += "    <td align='center'>" + currentSort + "</td>";
        hobbiesList += "    <td align='center'>";
        
        // 功能按鈕
        if (isEditing) {
            hobbiesList += "<input type='submit' value='儲存'> <a href='FriendHobby_List.jsp'>取消</a>";
        } else {
            hobbiesList += "<a href='FriendHobby_List.jsp?editId=" + currentId + "'>編輯</a>&nbsp;&nbsp;";
            hobbiesList += "<a href='FriendHobby_List.jsp?OP=UP&HobbyId=" + currentId + "'>上移</a>&nbsp;&nbsp;";
            hobbiesList += "<a href='FriendHobby_List.jsp?OP=DOWN&HobbyId=" + currentId + "'>下移</a>&nbsp;&nbsp;";
            hobbiesList += "<a href='javascript:void(0)' onclick=\"Del('FriendHobby_List.jsp?OP=Del&HobbyId=" + currentId + "')\">刪除</a>";
        }
        hobbiesList += "    </td>";
        hobbiesList += "  </form>";
        hobbiesList += "</tr>";
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
        <h1>興趣列表</h1>

        <form name="Frm" method="get" action="FriendHobby_List.jsp">
                <table border="0" width="100%">
                    <tr>
                        <td><a href="FriendHobby_List.jsp">列表</a>&nbsp;&nbsp;&nbsp;<a href="HobbyList_Edit.jsp">新增</a></td>
                        <td align="right"><input type="text" id="q" name="keyword" placeholder="Keyword" value="<%= Keyword%>">&nbsp;<input type="submit" value="查詢"></td>
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
                <th>興趣名稱</th>
                <th>排列順序</th>
                <th>功能</th>
            </tr>
            <%=hobbiesList%>
        </table>
        <script>
            function Del(URL){
                if (confirm("確定要刪除嗎？")) location.href =URL;
            }
        </script>
    </body>
</html>



// 我真的不是分隔線


