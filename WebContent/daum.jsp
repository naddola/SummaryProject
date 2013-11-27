<%@page import="java.util.regex.Matcher"%>
<%@page import="de.l3s.boilerpipe.extractors.ArticleExtractor"%>
<%@page import="de.l3s.boilerpipe.document.TextDocument"%>
<%@page import="de.l3s.boilerpipe.sax.BoilerpipeSAXInput"%>
<%@page import="de.l3s.boilerpipe.sax.HTMLFetcher"%>
<%@page import="org.xml.sax.InputSource"%>
<%@page import="java.net.URL"%>
<%@page import="com.wscompany.summarywebapi.JMCrawler"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ include file="variable.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Daum ��� ���!</title>
</head>
<body>
<%

	// ��� ���� ����
	urlDaumReplyTemp = new ArrayList<String>();
	urlDaumReplyList = new ArrayList<String>();
	articleDaumReplyList = new ArrayList<String>();
	
	htmlSource = JMCrawler.DownloadHtml(urlDaumReply, true);
	urlDaumReplyTemp = JMCrawler.findHref(htmlSource);
	
	// �ּ� ��ȯ
	for(int i=0; i<urlDaumReplyTemp.size(); i++){
		if(urlDaumReplyTemp.get(i).contains(ArticleDaumAddr))
			urlDaumReplyList.add("http://media.daum.net"+urlDaumReplyTemp.get(i));
	}
	
	// ���� �Ƽ� ��� ����
	try {
		for(int i=0; i<10; i++){
			url = new URL(urlDaumReplyList.get(i));
	        final InputSource is = HTMLFetcher.fetch(url).toInputSource();
	        
	        final BoilerpipeSAXInput in = new BoilerpipeSAXInput(is);
	        final TextDocument doc = in.getTextDocument();
	        articleDaumReplyList.add(ArticleExtractor.INSTANCE.getText(doc));
		}
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

	// ��ȣ ���ֱ�
	for(int i=0; i<articleDaumReplyList.size(); i++){
		Pattern pat = Pattern.compile("<[^>]*>");
		Matcher m = pat.matcher(articleDaumReplyList.get(i));
		if(m.find())
			articleDaumReplyList.set(i, m.replaceAll(""));

		pat = Pattern.compile("\\[[^\\]]*\\]");
		m = pat.matcher(articleDaumReplyList.get(i));
		if(m.find())
			articleDaumReplyList.set(i, m.replaceAll(""));
		
		pat = Pattern.compile("\\([^\\)]*\\)");
		m = pat.matcher(articleDaumReplyList.get(i));
		if(m.find())
			articleDaumReplyList.set(i, m.replaceAll(""));
				
	}
	

	// ���� �� ����
	urlDaumPopularTemp = new ArrayList<String>();
	urlDaumPopularList = new ArrayList<String>();
	articleDaumPopularList = new ArrayList<String>();

	htmlSource = JMCrawler.DownloadHtml(urlDaumPopular, true);
	urlDaumPopularTemp = JMCrawler.findHref(htmlSource);

	// �ּ� ��ȯ
	for(int i=0; i<urlDaumPopularTemp.size(); i++){
		if(urlDaumPopularTemp.get(i).contains(ArticleDaumAddr))
			urlDaumPopularList.add("http://media.daum.net"+urlDaumPopularTemp.get(i));
	}
	
	// ���� �Ƽ� ��� ����
	try {
		for(int i=0; i<10; i++){
			url = new URL(urlDaumPopularList.get(i));
	        final InputSource is = HTMLFetcher.fetch(url).toInputSource();
	        
	        final BoilerpipeSAXInput in = new BoilerpipeSAXInput(is);
	        final TextDocument doc = in.getTextDocument();
	        articleDaumPopularList.add(ArticleExtractor.INSTANCE.getText(doc));
		}
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

	// ��ȣ ���ֱ�
	for(int i=0; i<articleDaumPopularList.size(); i++){
		Pattern pat = Pattern.compile("<[^>]*>");
		Matcher m = pat.matcher(articleDaumPopularList.get(i));
		if(m.find())
			articleDaumPopularList.set(i, m.replaceAll(""));

		pat = Pattern.compile("\\[[^\\]]*\\]");
		m = pat.matcher(articleDaumPopularList.get(i));
		if(m.find())
			articleDaumPopularList.set(i, m.replaceAll(""));
		
		pat = Pattern.compile("\\([^\\)]*\\)");
		m = pat.matcher(articleDaumPopularList.get(i));
		if(m.find())
			articleDaumPopularList.set(i, m.replaceAll(""));
				
	}
	

%>
</body>
</html>