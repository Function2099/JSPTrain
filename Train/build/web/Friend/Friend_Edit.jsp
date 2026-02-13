<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="/Util_IO.jsp" %><%@ include file="kernel.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    String F_RecId = "";
    String userName = "";
    String userTel  = "";
    String userSex  = "";
    String school   = "";
    String userType = "";
    String userStar = "";
    String userTitle = "";
    String memo     = "";
    String hobbyStr = "";

    String sqlSave = "";
    // 連線設定
    String DRIVER = "net.sourceforge.jtds.jdbc.Driver";
    String URL = "jdbc:jtds:sqlserver://127.0.0.1:1433/Friend;SendStringParameterAsUnicode=true";
    String USER = "sa";
    String PWD = "root";
    Class.forName(DRIVER);
    Connection Conn = DriverManager.getConnection(URL, USER, PWD);
//    Connection Conn = DBConfig.getConnection();
//    if (Conn == null) {
//            out.print("資料庫連線失敗");
//            return; // 終止後續執行
//    }
    
    String OP = req("OP", request);
    F_RecId = req("F_RecId", request);
    out.print(OP);
    
    String currentOrgId = getSession("J_OrgId", session);
    
    if (currentOrgId.equals("")) {
            out.print("<script>top.location.href='/Login.jsp';</script>");
            return;
        }
    
    if ("Edit".equals(OP) && !F_RecId.equals("")) {
        String sqlSelect = "SELECT * FROM Friend WHERE F_RecId = ?";
        PreparedStatement pstmt = Conn.prepareStatement(sqlSelect);
        pstmt.setString(1, F_RecId);
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            userName = rs.getString("F_UserName");
            userTel  = rs.getString("F_UserTel");
            userSex  = rs.getString("F_UserSex");
            school   = rs.getString("F_UserSchool");
            userType = rs.getString("F_Type");
            userStar = rs.getString("F_Star");
            userTitle = rs.getString("F_UserTitle");
            memo     = rs.getString("F_UserMemo");
            hobbyStr = rs.getString("F_UserHobby");
        }
        rs.close();
        pstmt.close();
    }

    // 表單欄位
    if (isPost(request)) {
        userName = req("UserName", request);
        userTel  = req("UserTel", request);
        userSex  = req("UserSex", request);
        school   = req("UserSchool", request);
        userType = req("UserType", request);
        userStar = req("UserStar", request);
        userTitle = req("UserTitle", request);
        memo     = req("UserMemo", request);
        hobbyStr = reqValues("Hobby", request);

        Statement stmt = Conn.createStatement();

        if ("Edit".equals(OP) && !F_RecId.equals("")) {
            sqlSave = "UPDATE Friend SET " + 
                      "F_UserName = " + toStr(userName) + ", " +
                      "F_UserTel = "  + toStr(userTel)  + ", " +
                      "F_UserSex = "  + toStr(userSex)  + ", " +
                      "F_UserHobby = "+ toStr(hobbyStr) + ", " +
                      "F_UserSchool = "+ toStr(school)  + ", " +
                      "F_Type = "     + toStr(userType) + ", " +
                      "F_Star = " + toStr(userStar) + ", " +
                      "F_UserTitle = "+ toStr(userTitle) + ", " +
                      "F_UserMemo = " + toStr(memo)     + " " +
                      "WHERE F_RecId = " + F_RecId + " AND F_OrgId = " + toStr(currentOrgId);
        } else {
            sqlSave = "INSERT INTO Friend (F_UserName, F_UserTel, F_UserSex, F_UserHobby, F_UserSchool, F_Type, F_Star, F_UserTitle, F_UserMemo, F_DateTime, F_OrgId) " +
                      "VALUES (" + toStr(userName) + "," + toStr(userTel) + "," + toStr(userSex) + "," + 
                      toStr(hobbyStr) + "," + toStr(school) + "," + toStr(userType) + "," + 
                      toStr(userStar) + "," + toStr(userTitle) + "," + toStr(memo) + ", GETDATE(), " + toStr(currentOrgId) + ")";
        }

        stmt.executeUpdate(sqlSave);
        stmt.close();
        Conn.close();
        response.sendRedirect("Friend_List.jsp");
        return; 
    }
%>
<%
    // 類型列表
    Statement stmtType = Conn.createStatement();
    String sqlType = "SELECT T_RecId, T_Name FROM Friend_Type ORDER BY T_Sort DESC";
    ResultSet rsType = stmtType.executeQuery(sqlType);
    
    String TypeUI = "<select name='UserType' id='UserType'>";
    int T_count = 0;
    String tName = "";
    String tId = "";
    TypeUI += "<option value=''>請選擇</option>";
    while(rsType.next()){
        T_count++;
        tName = rsType.getString("T_Name");
        tId = rsType.getString("T_RecId");
        TypeUI += "<option value='" + tId + "' " +isSelected(userType, tId)+ ">" + tName + "</option>";
        if (T_count % 3 == 0) { 
            TypeUI += "<br>"; 
        }
    }
    TypeUI += "</select>";
    
    rsType.close();
    stmtType.close();
    
%>
<%
    // 抓取星座資料
    Statement stmtStar = Conn.createStatement();
    String sqlStar = "SELECT S_RecId, S_Name FROM Friend_Star ORDER BY S_RecId ASC";
    ResultSet rsStar = stmtStar.executeQuery(sqlStar);
    
    String StarUI = "<select name='UserStar' id='UserStar'>";
    StarUI += "<option value=''>請選擇</option>";
    
    while(rsStar.next()){
        String sId = rsStar.getString("S_RecId");
        String sName = rsStar.getString("S_Name");
        
        StarUI += "<option value='" + sId + "' " + isSelected(userStar, sId) + ">" + sName + "</option>";
    }
    StarUI += "</select>";
    
    rsStar.close();
    stmtStar.close();
%>
<%
    // 興趣列表
    // 顯示從資料庫查詢，並顯示興趣列表的sql語法和相關設定
    Statement stmtHobby = Conn.createStatement();
    String sqlHobby="";
    ResultSet rsHobby = null;
    
    String checkStr = "";
    String hobbyUI = "";
    int H_count = 0;
    String hName = "";
    sqlHobby = "SELECT H_RecId, H_Name FROM Friend_Hobby ORDER BY H_Sort";
    rsHobby = stmtHobby.executeQuery(sqlHobby);
    
    while(rsHobby.next()){
        H_count++;
        hName = rsHobby.getString("H_Name");
        String hId = rsHobby.getString("H_RecId");

        checkStr = isChecked(hobbyStr, hId); 

        hobbyUI += "<input type='checkbox' name='Hobby' value='" + hId + "' " + checkStr + ">" + hName;
        if (H_count % 3 == 0) hobbyUI += "<br>";
    }
    rsHobby.close();
    stmtHobby.close();

%>
<%

    Statement stmtTitle = Conn.createStatement();
    String sqlTitle = "SELECT Ti_RecId, Ti_Name FROM Friend_Title ORDER BY Ti_RecId ASC";
    ResultSet rsTitle = stmtTitle.executeQuery(sqlTitle);
    String tiId = "";
    String tiName = "";
    

    String TitleUI = "<select name='UserTitle' id='UserTitle'>";
    TitleUI += "<option value=''>請選擇</option>";
    while(rsTitle.next()){
        tiId = rsTitle.getString("Ti_RecId");
        tiName = rsTitle.getString("Ti_Name");
        TitleUI += "<option value='" + tiId + "' " + isSelected(userTitle, tiId) + ">" + tiName + "</option>";
    }
    TitleUI += "</select>";
    rsTitle.close();
    stmtTitle.close();

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>通訊錄編輯介面</title>
    </head>
    <body>
        <form action="Friend_Edit.jsp" name="Frm" method="post" onsubmit="return checkData()">
       
            <input type="hidden" name="OP" value="<%= OP%>">
            <input type="hidden" name="F_RecId" value="<%= F_RecId%>">
            <table border="1">
                <tr>
                    <td>姓名</td>
                    <td><input name="UserName" id="UserName" value="<%=userName%>"></td>
                </tr>
                
                <tr>
                    <td>職稱</td>
                    <td>
                        <%= TitleUI%>
                    </td>
                </tr>
                
                <tr>
                    <td>電話</td>
                    <td><input name="UserTel" value="<%=userTel%>"></td>
                </tr>
                
                <tr>
                    <td>性別</td>
                    <td>
                        <input type="radio" name="UserSex" value="1" <%= isChecked(userSex, "1") %>>
                        男

                        <input type="radio" name="UserSex" value="0" <%= isChecked(userSex, "0") %>>
                        女
                    </td>
                </tr>
                
                <tr>
                    <td>學歷</td>
                    <td>
                        <select name="UserSchool">
                            <option value="">請選擇</option>
                            <option value="A" <%= school.equals("A") ? "selected" : "" %>>國小</option>
                            <option value="B" <%= school.equals("B") ? "selected" : "" %>>國中</option>
                            <option value="C" <%= school.equals("C") ? "selected" : "" %>>高中</option>
                            <option value="E" <%= school.equals("E") ? "selected" : "" %>>大學</option>
                            <option value="F" <%= school.equals("F") ? "selected" : "" %>>研究所</option>
                        </select>
                    </td>
                </tr>
                
                <tr>
                    <td>星座</td>
                    <td>
                        <%= StarUI %>
                    </td>
                </tr>
                
                <tr>
                    <td>類型</td>
                    <td>
                        <%= TypeUI%>
                    </td>
                </tr>
                
                <tr>
                    <td>興趣</td>
                    <td>
                        <%= hobbyUI%>
                    </td>
                </tr>
                
                <tr>
                    <td>備註</td>
                    <td>
                        <textarea name="UserMemo" rows="5" cols="30" placeholder="請輸入額外說明..."></textarea>
                    </td>
                </tr>
                
                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" value="送出">    
                    </td>   
                </tr>
            </table>
        </form>
        
        <script>
            
                
            function checkData(){
                var str =Frm.UserName.value;
                if (str == ""){
                    alert("請填寫姓名");
                    return false;
                }
                
                var tel = Frm.UserTel.value;
                if (tel == "") {
                    alert("請填寫電話");
                    return false;
                }
    
                if (Frm.UserSchool.value == "") {
                    alert("請選擇學歷");
                    return false;
                }
                
                var sex = Frm.UserSex;
                var sexSelected = false;
                
//                我現在要執行迴圈，需要知道radio的長度
//                然後如果有被選擇到，sexSelected就設定為true，並且退出循環
//                如果sexSelected不等於true時，就直接跳出請選擇性別並回傳false
                for (var i = 0; i < sex.length; i++) {
                    if (sex[i].checked) {
                        sexSelected = true;
                        break;
                    }
                }
                if (!sexSelected) {
                    alert("請選擇性別");
                    return false;
                }

                var hobbiesArr = document.getElementsByName("Hobby");
                var hobbyChecked = false;
                for (var j = 0; j < hobbiesArr.length; j++) {
                    if (hobbiesArr[j].checked) {
                        hobbyChecked = true;
                        break;
                    }
                }
                if (!hobbyChecked) {
                    alert("請至少選一個興趣");
                    return false;
                }
                
                return true;
            }
            function callAddr(){
                document.getElementById("interFrm").src= "Menu.jsp";
            }
            
        </script>
        
    </body>
</html>
<%
    if(Conn != null) Conn.close();
%>