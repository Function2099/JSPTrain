<%@page pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    
    String J_OrgId = getSession("J_OrgId", session);
    String J_OrgName = getSession("J_OrgName", session);
    if (J_OrgId.equals("")){
        response.sendRedirect("/Login.jsp");
        return;
    }
%>
