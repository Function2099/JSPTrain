<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%!
    public String isChecked(String str1, String str2) throws Exception{

        if (str1 == null || str2 == null) {
            return "";
        }else if (str1.equals(str2)){
            return "checked";
        }
        else if(str1.indexOf(str2)>-1){
            return "checked";
        }
        else {
            return "";
        }
    }
%>

<%!
    public String isSelected(String str1, String str2){
        if (str1 != null && str1.equals(str2)){
        return "selected";
        }
        return "";
    }

%>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=UTF-8");

String UserName = request.getParameter("UserName");
String UserTel = request.getParameter("UserTel");
String UserSex = request.getParameter("UserSex");
String UserSchool = request.getParameter("UserSchool");
String[] Hobby = request.getParameterValues("Hobby");
String UserMemo = request.getParameter("UserMemo");

String[] Hobbies = request.getParameterValues("Hobby");
String hobbStr = "";

if (Hobbies != null){
    hobbStr = String.join(",", Hobbies);
}
UserName = "";
UserTel = "";

hobbStr = ","+hobbStr+",";
out.print("<br>名字:");
if (UserName == null){
    out.print("");
}else{
    out.print(UserName);
}

out.print("<br>電話:");
if (UserTel == null){
    out.print("");
}else{
    out.print(UserTel);
}

out.print("<br>性別:");
if (UserSex == null){
    out.print("");
}else{
    out.print(UserSex);
}

out.print("<br>學歷:");
if (UserSchool == null){
    out.print("");
}else{
    out.print(UserSchool);
}

out.print("<br>興趣:");
if (Hobby != null) {
    for (int i = 0; i < Hobby.length; i++) {
        out.print("<br>" + Hobby[i]); 
    }
} else {
    out.print("");
}

out.print("<br>備註:");
if (UserMemo == null){
    out.print("");
}else{
    out.print(UserMemo);
}
%>

<%

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="test3.jsp" name="Frm" method="post" onsubmit="return checkData()">
            <table border="1">
                <tr>
                    <td>姓名</td>
                    <td><input name="UserName" id="UserName" value="<%= UserName == null ? "" : UserName %>"></td>
                </tr>
                <tr>
                    <td>電話</td>
                    <td><input name="UserTel" value="<%= UserTel == null ? "" : UserTel %>"></td>
                </tr>
                
                <tr>
                    <td>性別</td>
                    <td>
                        <input type="radio" name="UserSex" value="1" <%=isChecked(UserSex, "1")%>>
                        男

                        <input type="radio" name="UserSex" value="0" <%=isChecked(UserSex, "0")%>>
                        女
                    </td>
                </tr>
                
                <tr>
                    <td>學歷</td>
                    <td>
                        <select name="UserSchool" size="1">
                            <option value="">請選擇</option>
                            <option value="A" <%=isSelected(UserSchool,"A")%>>A</option>
                            <option value="B" <%=isSelected(UserSchool,"B")%>>B</option>
                            <option value="C" <%=isSelected(UserSchool,"C")%>>C</option>
                            <option value="E" <%=isSelected(UserSchool,"E")%>>E</option>
                        </select>
                    </td>
                </tr>
                
                <tr>
                    <td>興趣：</td>
                    <td>
                        音樂<input type="checkbox" name="Hobby" value="Music" <%=isChecked(hobbStr,",Music,")%>>
                        跳舞<input type="checkbox" name="Hobby" value="Dance" <%=isChecked(hobbStr,",Dance,")%>>
                        旅行<input type="checkbox" name="Hobby" value="Travel" <%=isChecked(hobbStr,",Travel,")%>>
                        畫圖<input type="checkbox" name="Hobby" value="Draw" <%=isChecked(hobbStr,",Draw,")%>>
                    </td>
                </tr>
                
                <tr>
                    <td>備註：</td>
                    <td>
                        <textarea name="UserMemo" rows="5" cols="30" placeholder="請輸入額外說明..." value="<%=UserMemo%>"></textarea>
                    </td>
                </tr>
                
                <tr>
                    <td colspan="2" align="center">
                        <input type="submit" value="送出">    
                    </td>   
                </tr>
                
                <tr>
                    <td colspan="2" align="center">
                        <input onclick="callAddr()" type="button" value="呼叫網址">    
                    </td>
                </tr>
                
                <tr>
                    <td>
                        <iframe src="index.jsp" width="100%" height="300" name="interFrm" id="interFrm"></iframe>
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
                    if (hobbies[j].checked) {
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
