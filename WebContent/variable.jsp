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
	ArrayList<String> urlDaumReplyTemp;			// All url. �ܾ���� ��ũ ����
	ArrayList<String> urlDaumReplyList;			// Necessary url. �ʿ��� ��ũ�� ����
	ArrayList<String> articleDaumReplyList;		// Articles ��� ����Ʈ
	
	ArrayList<String> urlDaumPopularTemp;			// All url. �ܾ���� ��ũ ����
	ArrayList<String> urlDaumPopularList;			// Necessary url. �ʿ��� ��ũ�� ����
	ArrayList<String> articleDaumPopularList;		// Articles ��� ����Ʈ
	
	// Downloaded html source
	String htmlSource = "";

	// Pick out url's contents
	URL url;

	// News Tweet
	String title = "����: ";
	String firstSentence = "ù����: ";
	String twtSentence = "";
	String urlReplyString = "";
	String urlPopularString = "";
	
%>