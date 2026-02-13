<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="Util_IO.jsp" %>
<%
    String type = req("type", request);
    out.print("type:"+type+"<br>");
    String typeName = "";
    int count = 0;

    if (type.equals("A")) {
        typeName = "台北";
        count = 3;
    } else if (type.equals("B")) {
        typeName = "台中";
        count = 3;
    } else if (type.equals("C")) {
        typeName = "高雄";
        count = 3; 
    }
%>
<script>
    var parentSelect = parent.document.getElementById("subtype");
    parentSelect.options.length = 1;
<% 
    if (!typeName.equals("")) {
        for (int i = 1; i <= count; i++) { 
%> 
    var obj = document.createElement("option");
    obj.value = "<%= type %>-<%= i %>";
    obj.text = "<%= typeName %>-<%= i %>";
    parentSelect.add(obj);
<% 
        } 
    } 
%>
    
</script>