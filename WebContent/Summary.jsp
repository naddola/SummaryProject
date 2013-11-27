<%@page import="kr.co.shineware.nlp.komoran.core.MorphologyAnalyzer"%>
<%@page import="com.wscompany.summarywebapi.WSummary"%>
<%@page import="java.util.ArrayList"%>
<%@page import="de.l3s.boilerpipe.extractors.ArticleExtractor"%>
<%@page import="de.l3s.boilerpipe.document.TextDocument"%>
<%@page import="de.l3s.boilerpipe.sax.BoilerpipeSAXInput"%>
<%@page import="de.l3s.boilerpipe.sax.HTMLFetcher"%>
<%@page import="org.xml.sax.InputSource"%>
<%@page import="java.net.URL"%>
<%@page import="com.wscompany.summarywebapi.JMCrawler"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>요약 결과</title>
</head>
<body>
<%

WSummary.Analyzer = new MorphologyAnalyzer(request.getSession().getServletContext().getRealPath("/WEB-INF")+"/"+"datas/");
	String urlString = request.getParameter("url");
	String lineStr = request.getParameter("line");
	int line = 3;
	
	if(lineStr != null)
		line = Integer.parseInt(lineStr);
	
	if(urlString == ""){
		out.println("url 입력이 안되었습니다.");
	}else{
		
		String str = "";
		
		URL url;
		
		try {
			url = new URL(urlString);
	        final InputSource is = HTMLFetcher.fetch(url).toInputSource();
	        
	        final BoilerpipeSAXInput in = new BoilerpipeSAXInput(is);
	        final TextDocument doc = in.getTextDocument();
	        str=ArticleExtractor.INSTANCE.getText(doc);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	%><pre><%
	
		String[] strArray = str.split("\n");
		
		ArrayList<String> arr = new ArrayList<String>();
		
		// 기사를 문장별로 나누기
		for(int i=0; i<strArray.length; i++){
			if(arr.isEmpty()){
				if(!strArray[i].contains(" 본문"))
					arr.add(strArray[i]);
			}
			if( (strArray[i].length() > 0) && (strArray[i].charAt(strArray[i].length()-1) == '.'))
				arr.add(strArray[i]);
		}
	
		String articleSummary = "";
		
		out.println("<h2>"+arr.get(0)+"</h2>");
		
		// 제목 뺀 기사 내용만
		for(int i=1; i<arr.size(); i++)
			articleSummary += arr.get(i)+"\n";
		
		//out.println(articleSummary);
		
		articleSummary = articleSummary.replaceAll("\n", "");
		
		WSummary.SummaryCheck(articleSummary);
		
		if(WSummary.getResultSize() < line)
			line = WSummary.getResultSize();
		
		if(line == 0){
			out.println("내용이 없습니다.");
		}else{
			out.println(WSummary.getResult(line)+"<br><br>");	
		}
		
	}
%></pre>
</body>
</html>