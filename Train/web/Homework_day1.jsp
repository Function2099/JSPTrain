<%-- 
    Document   : DualListBox
    Created on : 2026年2月2日, 下午9:44:41
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dual List Box</title>
        
        <style>
            /* 設定td的寬度 */
            td {
                width: 200px;
                height: 250px;
                text-align: center;   /* 按鈕置中 */
            }

            /* 讓select框撐滿td的寬高 */
            select {
                width: 100%;
                height: 100%;
            }

            /* 讓按鈕寬度一致 */
            button {
                width: 50px;
            }
        </style>
    </head>
    <body>
        <h1>第一天作業實作</h1>
        <!-- 2026/2/2 -->
        <!-- 首先需要建立結構，今天有說到下拉選單的select有multuple屬性，可以列出選項 -->
        <!-- size=10，然後有左右邊，中間是按扭區域，也就是說要分三個區塊，這部分我要在div和table中抉擇 -->
        <!-- 今天學到的基本都是table，所以看看能不能用table實現，考慮要不要加上form -->
        <!-- 根據google查詢，form是用在要傳給伺服器用的，所以可以不設置，但為了練習還是設置一下 -->
        <form>
            <table>
                <!-- 表格分三塊的方式我不確定有哪幾種方法，比較能想到的是用tr分三個td解決 -->
                <tr>
                    <!-- left -->
                    <td>
                        <select id="leftSelect" multiple size="10">
                            <!-- value先設置數字模擬 -->
                            <option value="1">項目一</option>
                            <option value="2">項目二</option>
                            <option value="3">項目三</option>
                            <option value="4">項目四</option>
                            <option value="5">項目五</option>
                            <option value="6">項目六</option>
                            <option value="7">項目七</option>
                            <option value="8">項目八</option>
                            <option value="9">項目九</option>
                            <option value="10">項目十</option>
                        </select>
                    </td>
                    
                    <!-- middle -->
                    <!-- 建立四個按鈕，將四個按鈕都設立點擊事件 -->

                    <td>
                        <button type="button" onclick="moveLeftItems()"> > </button><br><br>
                        <button type="button" onclick="moveLeftAllItems()"> >> </button><br><br>
                        <button type="button" onclick="moveRightItems()"> < </button><br><br>
                        <button type="button" onclick="moveRightAllItems()"> << </button>
                    </td>
                    
                    <!-- right -->
                    <td>
                        <select id="rightSelect" multiple size="10">
                            
                        </select>
                    </td>
                </tr>
            </table>
        </form>
        <script>
            // 先抓元素
            let leftBox = document.getElementById('leftSelect');
            let rightBox = document.getElementById('rightSelect');
            
            function moveLeftItems(){
                // 看是抓到的值是什麼
                // 這個只能抓到一個值，註解紀錄console.log(leftBox.value);
                // 查詢後，抓多個值用陣列，先設置一個空陣列儲存選取的value
                let selectedItems = [];
                // 確認能不能抓到總長度 確認完畢
                console.log(leftBox.options.length);
                // 可以，用for迴圈試試看能不能抓options的值
                for (let i = 0;i < leftBox.options.length;i++){
                    let selectedOptions = leftBox.options[i];
                    
                    if (selectedOptions.selected === true){
                        // 有被選到的索引加入到空陣列
                        selectedItems.push(selectedOptions.value);
                    }
                }
                console.log(selectedItems);
                // 確認完畢
                
                // 已知selectedItems是我選取後要移動的項目
//                for (let i = 0; i < leftBox.options.length; i++) {
//                    let opt = leftBox.options[i];
//                    // 判斷是否被選中
//                    if (opt.selected){
//                       rightBox.appendChild(opt);
//                    }
//                }
                // 出現bug，在selectedItems.length中只有偶數元素(0、2、4)能送過去
                for (let i = 0; i < leftBox.options.length; i++){
                    let opt = leftBox.options[i];
                    if (opt.selected){
                        let sb = sortBox(rightBox, opt.value);
                        rightBox.insertBefore(opt, sb);
                        i--; // 修正bug：搬走第一個後讓迴圈重新循環，保證遞補上來的能被抓到
                    } 
                }
            }
            
            function moveLeftAllItems(){
                // 目標:把所有項目傳過去
                // 也就是說length有多長就傳多長
                while (leftBox.options.length > 0){
                    // 因為會遞補的原因，所以一直搬第一個索引過去
                    let opt = leftBox.options[0];
                    let sb = sortBox(rightBox, opt.value);
                    rightBox.insertBefore(opt, sb);
                }
            }
            
            function moveRightItems(){
                for (let i = 0; i < rightBox.options.length; i++){
                    let opt = rightBox.options[i];
                    if (opt.selected){
                        let sb = sortBox(leftBox, opt.value);
                        leftBox.insertBefore(opt, sb);
                        i--;
                    } 
                }
            }
            
            function moveRightAllItems(){
                while (rightBox.options.length > 0){
                    let opt = rightBox.options[0];
                    let sb = sortBox(leftBox, opt.value);
                    leftBox.insertBefore(opt, sb);
                }
            }
            
            // 排序不直觀，有value可以做排序，寫一個函數用來排序
            function sortBox(box, optionValue){
                for (let j = 0; j < box.options.length; j++){
                    // 找到第一個當前選取項目value值比box.option[j].value小的項目
                    // 回傳給insertBefore(排前面)，否則回傳null(排後面)
                    if (parseInt(optionValue) < parseInt(box.options[j].value)){
                        return box.options[j];
                    }
                }
                return null;
            }
        </script>
    </body>
</html>
