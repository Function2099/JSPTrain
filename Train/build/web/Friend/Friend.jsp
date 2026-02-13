<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="/Util_IO.jsp" %>
<%@ include file="kernel.jsp" %>
<!doctype html>
<html lang="zh-TW">
  <head>
    <!-- Document metadata goes here -->
  </head>
  <frameset cols="200, *">
    <frame src="Menu.jsp" name="frmMenu"/>
    <frame src="Friend_List.jsp" name="frmBody"/>
  </frameset>
</html>
