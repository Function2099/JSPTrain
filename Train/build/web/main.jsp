<%--
    Document   : main
    Created on : 2026年2月2日, 下午2:03:20
    Author     : User
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="main.jsp" name="Frm" method="get" onsubmit="return checkData()" target="interFrm">
            <table border="1">
                <tr>
                    <td>姓名</td>
                    <td><input name="UserName" id="UserName"></td>
                </tr>
                <tr>
                    <td>電話</td>
                    <td><input name="UserTel"></td>
                </tr>
                
                <tr>
                    <td>性別</td>
                    <td>
                        <input type="radio" name="UserSex" value="1">
                        男

                        <input type="radio" name="UserSex" value="0">
                        女
                    </td>
                </tr>
                
                <tr>
                    <td>學歷</td>
                    <td>
                        <select name="UserSchool" multiple size="3">
                            <option value="" >請選擇</option>
                            <option value="A">A</option>
                            <option value="B">B</option>
                            <option value="C">C</option>
                            <option value="E">E</option>
                        </select>
                    </td>
                </tr>
                
                <tr>
                    <td>興趣：</td>
                    <td>
                        音樂<input type="checkbox" name="Hobby" value="Music">
                        跳舞<input type="checkbox" name="Hobby" value="Dance">
                        旅行<input type="checkbox" name="Hobby" value="Travel">
                        畫圖<input type="checkbox" name="Hobby" value="Draw">
                    </td>
                </tr>
                
                <tr>
                    <td>備註：</td>
                    <td>
                        <textarea name="UserMemo" rows="5" cols="30" placeholder="請輸入額外說明..."></textarea>
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
