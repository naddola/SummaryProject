<%@page import="com.wscompany.summarywebapi.TwitterClient"%>
<%@page import="twitter4j.auth.AccessToken"%>
<%@page import="twitter4j.auth.RequestToken"%>
<%@ page session="true" language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>

<%
// twitter���� �Ѱ���
String oauth_token = request.getParameter("oauth_token");

// signin.jsp���� ������ �͵�
RequestToken token = (RequestToken)session.getAttribute("requestToken");
TwitterClient tw = (TwitterClient)session.getAttribute("tw");

tw.getAccessToken(oauth_token, token);
tw.update();
tw.printStatuses();	

%>
</body>
</html>
