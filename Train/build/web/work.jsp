<%
    request.setCharacterEncoding("UTF-8");
    String dateStr = request.getParameter("myDate");

    if (dateStr != null && !dateStr.equals("")) {
        int check = dateStr.indexOf("-");
        if (check == -1) {
            out.print("格式不對");
        } else {
            // split 練習：用橫線切開
            String[] data = dateStr.split("-");

            // 直接輸出到網頁上
            out.print("解析成功！<br>");
            out.print("年份是：" + data[0] + "<br>");
            out.print("月份是：" + data[1] + "<br>");
            out.print("日期是：" + data[2] + "<br>");
        }
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>String 方法練習</title>
    </head>
    <body>
        <h2>Email 拆解器 (indexOf & split 練習)</h2>
        
        <form action="email_test.jsp" method="post">
            請輸入日期 (格式如 2026-02-03): 
            <input type="text" name="myDate">
            <input type="submit" value="送出解析">
        </form>
        
        
    </body>
</html>
