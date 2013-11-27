<%@page import="com.wscompany.summarywebapi.ArticleStorage"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
	ArticleStorage.ReplyUrlStorage.clear();
	ArticleStorage.PopularUrlStorage.clear();
	ArticleStorage.ReplySubjectStorage.clear();
	ArticleStorage.PopularSubjectStorage.clear();
	ArticleStorage.ReplyArticleStorage.clear();
	ArticleStorage.PopularArticleStorage.clear();
	ArticleStorage.PopularWordTop3.clear();
	out.println("저장소 초기화");
%>
</body>
</html>