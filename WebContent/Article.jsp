<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ include file="daum.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<body>
<pre><%

for(int i=0; i<ArticleStorage.PopularWordTop3.size(); i++){
	for(int j=0; j<5; j++){
		out.print(ArticleStorage.PopularWordTop3.get(i)[j]+" ");
	}
	out.println("<br>");
}

%>
</pre>
</body>
</html>