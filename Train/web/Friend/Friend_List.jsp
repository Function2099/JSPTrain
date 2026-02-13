<%@ page contentType="text/html;charset=UTF-8" %><%request.setCharacterEncoding("UTF-8");%>
<%@ page import="java.sql.*"%><%@ page import="java.util.HashMap, java.util.Map" %>
<%@ include file="/Util_IO.jsp" %><%@ include file="kernel.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

    </head>
    <body>
        <h1>通信錄列表</h1>
<%
String DRIVER = "net.sourceforge.jtds.jdbc.Driver";
String URL = "jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";
String USER = "sa";
String PWD = "root";
Class.forName(DRIVER);
Connection Conn = DriverManager.getConnection(URL, USER, PWD);
Statement stmt=Conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);

String sql="";
int PageSize = 10;
int TTL = 0;
int Page = 0;
int TTLPage = 0;

String OP = req("OP", request);
String F_RecId = req("F_RecId", request);

//out.print(OP+"<br>"+F_RecId+"<br>");

String T = req("T", request);
//out.print(T+"<br>");

// 刪除功能
if ("Del".equals(OP) && !F_RecId.equals("")) {
    String sqlDel = "DELETE FROM Friend WHERE F_RecId = " + F_RecId;

    Statement stmtDel = Conn.createStatement();
    stmtDel.executeUpdate(sqlDel);
    stmtDel.close();

    response.sendRedirect("Friend_List.jsp");
    return;
}

String Keyword = req("keyword", request);

//sql = "SELECT " +
//        "    F_RecId, " +
//        "    F_UserName, " +
//        "    F_UserSex, " +
//        "    F_UserSchool, " +
//        "    2026 - YEAR(F_UserBirthday) AS AGE, " + 
//        "    S_Name AS 星座, " +
//        "    T_Name AS 類型 " +
//        "FROM Friend, Friend_Star, Friend_Type " +
//        "WHERE F_Star = S_RecId " +
//        "  AND F_Type = T_RecId ";

sql = "SELECT " +
      "    F_RecId, F_UserName, F_UserSex, F_UserSchool, F_UserHobby, " +
      "    DATEDIFF(YEAR, ISNULL(F_UserBirthday, GETDATE()), GETDATE()) AS AGE, " + 
      "    S_Name AS 星座, T_Name AS 類型, Ti_Name AS 職稱, Ti_Sort " +
      "FROM Friend " +
      "LEFT JOIN Friend_Star ON F_Star = S_RecId " +
      "LEFT JOIN Friend_Type ON F_Type = T_RecId LEFT JOIN Friend_Title ON F_UserTitle = Ti_RecId WHERE 1=1 AND F_OrgId = " + J_OrgId;

//if (!Keyword.trim().equals("")) {
//        sql = "SELECT " +
//        "    F_RecId, " +
//        "    F_UserName, " +
//        "    F_UserSex, " +
//        "    F_UserSchool, " +
//        "    2026 - YEAR(F_UserBirthday) AS AGE, " + 
//        "    S_Name AS 星座, " +
//        "    T_Name AS 類型 " +
//        "FROM Friend " +
//        "WHERE F_Star = S_RecId " +
//        "  AND F_Type = T_RecId "+
//        "  AND (F_UserName LIKE '%"+ Keyword + "%' or S_Name LIKE '%"+ Keyword + "%' or T_Name LIKE '%"+ Keyword +"%')" ;  
//}
if (!T.trim().equals("")) {
    sql += " AND F_Type = " + T;
}

if (!Keyword.trim().equals("")) {
        sql += " AND (F_UserName LIKE '%" + Keyword + "%' OR S_Name LIKE '%" + Keyword + "%' OR T_Name LIKE '%" + Keyword + "%' OR Ti_Name LIKE '%" + Keyword + "%') ";
    }
//    sql += " ORDER BY Ti_Sort ASC, F_UserName ASC";
    sql += " ORDER BY F_RecId DESC";
//out.print(sql);

ResultSet rs=stmt.executeQuery(sql);

rs.last();
TTL = rs.getRow();
rs.beforeFirst();
//out.print("<br>"+TTL);

TTLPage = TTL / PageSize;
if (TTL % PageSize > 0){
    TTLPage = TTLPage + 1;
}

int TTLPage2 = (((TTL-1)+PageSize)/PageSize);
//out.print("<br>"+"上底+下底頁數："+TTLPage2);
//out.print("<br>"+TTLPage);

String SelectPage = "<select name='p' onchange='Frm.submit();'>";
String currentPage = req("p", request);
if (!currentPage.equals("")) {
    Page = Integer.parseInt(currentPage);
    
} else {
    Page = 1;
}

rs.relative((Page-1)*PageSize);
//out.print("<br>"+Page);
for (int i = 1; i <= TTLPage; i++) {
        SelectPage += "<option value='" + i + "' " + isSelected(currentPage, String.valueOf(i)) + ">第 " + i + " 頁</option>";
    }
SelectPage+="</select>";

    // 興趣相關
    
    // 初始化變數
    String[] ArrayHobby = null;
    String hobbyIds = "";
    String hobbyNames = "";
    
    // 建立HashMap物件
    // 這個是鍵值對[key:value]容器
    // 需要設定Key為String(ID)，Value為String(名稱)
    Map<String, String> hobbyMap = new HashMap<>();
    
    // 建立獨立的查詢通道給興趣查詢用
    Statement stmtH = Conn.createStatement();
    
    // 接收查詢結果結果為rsH，並執行SQL
    ResultSet rsH = stmtH.executeQuery("SELECT H_RecId, H_Name FROM Friend_Hobby");
    
    // 透過迴圈將資料存到Map裡面，會長這樣:{"1":"音樂", "2":"運動", "3":"閱讀"}
    while (rsH.next()) {
        hobbyMap.put(rsH.getString("H_RecId"), rsH.getString("H_Name"));
    }
    
    // 用完資源要記得釋放close()
    rsH.close();
    stmtH.close();
    
%>

        <form name="Frm" method="get" action="Friend_List.jsp">
            <input type="hidden" name="OP" value="<%= OP%>">
            <input type="hidden" name="F_RecId" value="<%= F_RecId%>">
            <input type="hidden" name="T" value="<%= T%>">
                <table border="0" width="100%">
                    <tr>
                        <td><a href="Friend_List.jsp">列表</a>&nbsp;&nbsp;&nbsp;<a href="Friend_Edit.jsp?OP=Add">新增</a></td>
                        <td align="right"><input type="text" id="q" name="keyword" placeholder="Keyword" value="<%= Keyword%>">&nbsp;<input type="submit" value="查詢"></td>
                    </tr>
                    <tr>
                        <td>總筆數：<%= TTL%></td>
                        <td align="right">頁數：<%= SelectPage %>&nbsp;/&nbsp;<%= TTLPage2%></td>
                    </tr>
                </table>
        </form>
        <table border="1" width="100%">
            <tr>
                <th>項次</th>
                <th>姓名</th>
                <th>性別</th>
                <th>職稱</th>
                <th>興趣</th>
                <th>學歷</th>
                <th>年齡</th>
                <th>星座</th>
                <th>類型</th>
                <th>功能</th>
            </tr>
            
            <% if (rs.next()){
                int startNo = (Page - 1) * PageSize;
                for (int i = 1; i <= PageSize; i++) {
                    // 首先需要從rs取得F_UserHobby的值
                    hobbyIds = rs.getString("F_UserHobby");
                    // 初始化空字串
                    hobbyNames = "";
                    
                    // 檢查抓出來的值是否不為空值，且不只是空的逗號
                    if (!hobbyIds.trim().equals("") && !hobbyIds.equals(",,")) {
                        //如果是，執行以下
                        // 如果字串是",1,2,3,"，就會刪除前後逗號變成"1,2,3"
                        if(hobbyIds.startsWith(",")) hobbyIds = hobbyIds.substring(1);
                        if(hobbyIds.endsWith(",")) hobbyIds = hobbyIds.substring(0, hobbyIds.length()-1);
                        
                        // 清理完畢，將字串按照逗號隔開，存入陣列
                        ArrayHobby = hobbyIds.split(",");
                        
                        // 跑迴圈處理所有陣列的每一個ID
                        for (int j = 0; j < ArrayHobby.length; j++) {
                            if (!ArrayHobby[j].equals("")) {
                                // 【重點】直接從從 hobbyMap 中透過 ID (Key) 抓出對應的中文名稱 (Value)
                                String hName = hobbyMap.get(ArrayHobby[j]);
                                // 將抓到的名稱累加到 hobbyNames
                                hobbyNames += (hobbyNames.equals("") ? "" : ", ") + hName;
                            }
                        }
                    }
            %>
            <tr>
                <td><%= startNo + i %></td>
                <td><%= rs.getString("F_UserName") %></td>
                <td><%= rs.getString("F_UserSex").equals("1") ? "男" : "女" %></td>
                <td><%= rs.getString("職稱")%></td>
                <td><%= hobbyNames %></td>
                <td><%= rs.getString("F_UserSchool") %></td>
                <td><%= rs.getInt("AGE") %></td>
                <td><%= rs.getString("星座") %></td>
                <td><%= rs.getString("類型") %></td>
                <td>
                    <a href="Friend_Edit.jsp?OP=Edit&F_RecId=<%=rs.getString("F_RecId")%>">編輯</a>&nbsp;&nbsp;&nbsp;
                    <a href="javascript:void(0)" onclick="Del('Friend_List.jsp?OP=Del&F_RecId=<%=rs.getString("F_RecId")%>')">刪除</a>&nbsp;&nbsp;&nbsp;
                    <a href="Friend_QuesList.jsp?F_RecId=<%=rs.getString("F_RecId")%>">問題紀錄</a>&nbsp;&nbsp;&nbsp;
                    <a href="FriendJob_List.jsp?F_RecId=<%=rs.getString("F_RecId")%>">派工紀錄</a>
                </td>
            </tr>
            <%      if(!rs.next()) break;
                 }
             }%>
        </table>
        <script>
            function Del(URL){
                if (confirm("您確定要刪除此筆資料嗎？")) location.href =URL;
            }
        </script>
    </body>
</html>
