<%@page import="com.wscompany.summarywebapi.ArticleStorage"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.net.URL"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%
	// Daum
	String urlDaumReply = "http://media.daum.net/netizen/bestreply/";
	String urlDaumPopular = "http://media.daum.net/netizen/popular/";
	String ArticleDaumAddr = "/v/";
	String articleSummary = " ";
	
	// ArrayList. You need a initialize
	ArrayList<String> urlDaumReplyTemp;			// All url. 긁어모은 링크 모음
	ArrayList<String> urlDaumReplyList;			// Necessary url. 필요한 링크만 모음
	ArrayList<String> articleDaumReplyList;		// Articles 기사 리스트
	
	ArrayList<String> urlDaumPopularTemp;			// All url. 긁어모은 링크 모음
	ArrayList<String> urlDaumPopularList;			// Necessary url. 필요한 링크만 모음
	ArrayList<String> articleDaumPopularList;		// Articles 기사 리스트
	
	// Downloaded html source
	String htmlSource = "";

	// Pick out url's contents
	URL url;

	// News Tweet
	String title = "제목: ";
	String firstSentence = "첫문장: ";
	String twtSentence = "";
	String urlReplyString = "";
	String urlPopularString = "";
	
%>