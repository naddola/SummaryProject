<%@page import="com.wscompany.summarywebapi.ArticleStorage"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ include file="daum.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
<script>
setTimeout("history.go(0);", 5000); //1000=1�� 60000=60��
</script>
</head>
<body>
<%
	// ��� ���� ��
	for(int i=0; i<10; i++){
		if(!ArticleStorage.ReplyUrlStorage.contains(urlDaumReplyList.get(i))){
			ArticleStorage.ReplyUrlStorage.add(urlDaumReplyList.get(i));
			break;
		}
	}
	
	for(int i=0; i<ArticleStorage.ReplyUrlStorage.size(); i++){
		out.println(ArticleStorage.ReplyUrlStorage.get(i)+"<br>");
	}
	
	// �α� ���� ��
	for(int i=0; i<10; i++){
		if(!ArticleStorage.PopularUrlStorage.contains(urlDaumReplyList.get(i))){
			ArticleStorage.PopularUrlStorage.add(urlDaumReplyList.get(i));
			break;
		}
	}
	
	for(int i=0; i<ArticleStorage.PopularUrlStorage.size(); i++){
		out.println(ArticleStorage.PopularUrlStorage.get(i)+"<br>");
	}

	
	out.println("<br>��� ���� ���� top10<br>");
	for(int i=0; i<10; i++){
		out.println(urlDaumReplyList.get(i)+"<br>");
	}

	out.println("<br>���� �� ���� top10<br>");
	for(int i=0; i<10; i++){
		out.println(urlDaumPopularList.get(i)+"<br>");
		
	}
%>
</body>
</html>