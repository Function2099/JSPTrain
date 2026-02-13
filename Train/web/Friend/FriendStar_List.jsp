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
    String starList = "";
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
    
    int PageSize = 12;
    int TTL = 0;
    int Page = 1;
    int TTLPage = 0;
    int sCount = 0;
    boolean isEditing = false;

    // 接收參數
    String Keyword = req("keyword", request);
    String editId = req("editId", request);
    String OP = req("OP", request);
    String dId = req("StarId", request);
    String currentPage = req("p", request);

    // 資料庫連線與動作處理
    Class.forName(DRIVER);
    Connection Conn = DriverManager.getConnection(URL, USER, PWD);
    Statement stmt = Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

    // 刪除
    if ("Del".equals(OP) && !dId.equals("")) {
        sqlDel = "DELETE FROM Friend_Star WHERE S_RecId = "+dId;
        PreparedStatement pstmtDel = Conn.prepareStatement(sqlDel);
        pstmtDel.executeUpdate();
        pstmtDel.close();
        response.sendRedirect("FriendStar_List.jsp");
        return;
    }
    
    // 處理排序移動
    if (("UP".equals(OP) || "DOWN".equals(OP)) && !dId.equals("")) {
        currentSortSql = "SELECT S_Sort FROM Friend_Star WHERE S_RecId = " + dId;
        rsSort = stmt.executeQuery(currentSortSql);
        if (rsSort.next()) {
            mySort = rsSort.getInt("S_Sort");
        }
        
        if ("UP".equals(OP)) {
            findTarget = "SELECT TOP 1 S_RecId, S_Sort FROM Friend_Star WHERE S_Sort < " + mySort + " ORDER BY S_Sort DESC";
        } else {
            findTarget = "SELECT TOP 1 S_RecId, S_Sort FROM Friend_Star WHERE S_Sort > " + mySort + " ORDER BY S_Sort ASC";
        }

        rsTarget = stmt.executeQuery(findTarget);
        if (rsTarget.next()) {
            targetId = rsTarget.getString("S_RecId");
            targetSort = rsTarget.getInt("S_Sort");
            stmt.executeUpdate("UPDATE Friend_Star SET S_Sort = " + targetSort + " WHERE S_RecId = " + dId);
            stmt.executeUpdate("UPDATE Friend_Star SET S_Sort = " + mySort + " WHERE S_RecId = " + targetId);
        }
        rsSort.close();
        rsTarget.close();  
        if (stmt != null) stmt.close();
        if (Conn != null) Conn.close();
        response.sendRedirect("FriendStar_List.jsp");
        return;
    }

    // 更新
    if (isPost(request)) {
        String sId = req("StarId", request);
        String sName = req("StarName", request);
        sqlUpd = "UPDATE Friend_Star SET S_Name = "+ toStr(sName) +" WHERE S_RecId = " + sId;
        PreparedStatement pstmtUpd = Conn.prepareStatement(sqlUpd);
        pstmtUpd.executeUpdate();
        pstmtUpd.close();
        response.sendRedirect("FriendStar_List.jsp");
        return;
    }

    // 執行查詢與分頁邏輯
    sql = "SELECT S_RecId, S_Name, S_Sort FROM Friend_Star ";
    if (!Keyword.trim().equals("")) {
        sql += " WHERE (S_Name LIKE '%" + Keyword + "%')";
    }
    sql += " ORDER BY S_Sort ASC";

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
    while (rs.next() && sCount < PageSize) {
        sCount++;
        currentId = rs.getString("S_RecId");
        currentName = rs.getString("S_Name");
        currentSort = rs.getString("S_Sort");
        isEditing = currentId.equals(editId);

        starList += "<tr>";
        starList += "  <td align='center'>" + ((Page - 1) * PageSize + sCount) + "</td>";
        starList += "  <form method='post' action='FriendStar_List.jsp'>";
        starList += "    <input type='hidden' name='StarId' value='" + currentId + "'>";
        starList += "    <td align='center'>" + (isEditing ? "<input type='text' name='StarName' value='" + currentName + "'>" : currentName) + "</td>";
        starList += "    <td align='center'>" + currentSort + "</td>";
        
        // 功能按鈕
        starList += "    <td align='center'>";
        if (isEditing) {
            starList += "<input type='submit' value='儲存'> <a href='FriendStar_List.jsp'>取消</a>";
        } else {
            starList += "<a href='FriendStar_List.jsp?editId=" + currentId + "'>編輯</a>&nbsp;&nbsp;";
            starList += "<a href='FriendStar_List.jsp?OP=UP&StarId=" + currentId + "'>上移</a>&nbsp;&nbsp;";
            starList += "<a href='FriendStar_List.jsp?OP=DOWN&StarId=" + currentId + "'>下移</a>&nbsp;&nbsp;";
            starList += "<a href='javascript:void(0)' onclick=\"Del('FriendStar_List.jsp?OP=Del&StarId=" + currentId + "')\">刪除</a>";
        }
        starList += "    </td>";
        starList += "  </form>";
        starList += "</tr>";
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
        <title>星座列表</title>

    </head>
    <body>
        <h1>星座列表</h1>
        <form name="Frm" method="post" action="FriendStar_List.jsp">
                <table border="0" width="100%">
                    <tr>
                        <td><a href="Friend_List.jsp">列表</a>&nbsp;&nbsp;&nbsp;<a href="Friend_Edit.jsp">編輯</a></td>
                        <td align="right"><input type="text" name="keyword" placeholder="Keyword" value="<%= Keyword%>">&nbsp;<input type="submit" value="查詢"></td>
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
                <th>星座名稱</th>
                <th>排列順序</th>
                <th>功能</th>
            </tr>
            
            <%= starList %>
        </table>
        <script>
            function Del(URL){
                if (confirm("確定要刪除嗎？")) location.href = URL;
            }
        </script>
    </body>
</html>
