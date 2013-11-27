<%@page import="com.restfb.exception.FacebookOAuthException"%>
<%@page import="twitter4j.auth.RequestToken"%>
<%@page import="com.wscompany.summarywebapi.*"%>
<%@page import="kr.co.shineware.util.common.model.Pair"%>
<%@page import="kr.co.shineware.nlp.komoran.core.MorphologyAnalyzer"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ include file="daum.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>테스트</title>
<script>
setTimeout("history.go(0);", 1800000); //1000=1초 60000=60초
</script>
</head>
<body>
<pre><%
	
	WSummary.Analyzer = new MorphologyAnalyzer(request.getSession().getServletContext().getRealPath("/WEB-INF")+"/"+"datas/");
	WSummary.Analyzer.setUserDic(request.getSession().getServletContext().getRealPath("/WEB-INF")+"/"+"datas/userDic.txt");
	String numStr = request.getParameter("num");

	int num = 0;
	if(numStr != null)
		num = Integer.parseInt(numStr);
	
	String[] tmpArticle;
	ArrayList<String> arr = new ArrayList<String>();
	TwtEngine tw = new TwtEngine();
	
	// 댓글 많은 순
	
	// 기사 받아오기
	while(num < 10){
		// 기사 받아오기
		tmpArticle = articleDaumReplyList.get(num).split("\n");
	
		// 트위터에 보낼 URL 받아오기
		urlReplyString = urlDaumReplyList.get(num);
	
		arr = new ArrayList<String>();
		
		// 기사를 문장별로 나누기
		for(int i=0; i<tmpArticle.length; i++){
			if(arr.isEmpty()){
				if(!tmpArticle[i].contains(" 본문"))
					arr.add(tmpArticle[i]);
			}
			if( (tmpArticle[i].length() > 0) && (tmpArticle[i].charAt(tmpArticle[i].length()-1) == '.'))
				arr.add(tmpArticle[i]);
		}
		
		// 본문이란 단어 없애기
		if(arr.get(0).contains("본문")){
			arr.remove(0);
		}
		
		// 제목 설정
		title = arr.get(0);
		if(title.length() > 36){
			title = title.substring(0, 36);
			title += "..";
		}
		
		// 첫문장 설정
		firstSentence = arr.get(1).split("\\.")[0];
		if(firstSentence.length() > 58){
			firstSentence = firstSentence.substring(0, 60);
			firstSentence += "..";
		}
		
		// URL
		urlReplyString = urlDaumReplyList.get(num);
		twtSentence ="["+title+"] "+firstSentence+" "+urlReplyString;

		out.println(twtSentence+"<br><br>");
		
		// 기사 저장
		if(!ArticleStorage.ReplyArticleStorage.contains(twtSentence)){
			ArticleStorage.ReplyArticleStorage.add(twtSentence);
			break;
		}

		num++;
	}


	// 제목 뺀 기사 내용만
	for(int i=1; i<arr.size(); i++)
		articleSummary += arr.get(i)+"\n";
	
	// 과도한 개행시 없애기
	articleSummary = articleSummary.replaceAll("\n", "");

	// 페북
	
	WSummary.SummaryCheck(articleSummary);
		
	String result = title+"\n"+WSummary.getResult(2)+"\n(자세히 보기: "+urlReplyString+")";
	Facebook fb = new Facebook(result);

	// 트위터
	tw.update(twtSentence);

	/*
	str = articleDaumReplyList.get(num);
	for(int i=0; i<arr.size(); i++){
		out.println(arr.get(i));
	}
	*/
	
	/********************************************************************************/
	
	out.println(result+"<br><br>");
	
	// 인기 많은 순
	num = 0;
	articleSummary = "";
	
	while(num < 10){
		// 기사 받아오기
		tmpArticle = articleDaumPopularList.get(num).split("\n");
		
		// 트위터에 보낼 URL 받아오기
		urlPopularString = urlDaumPopularList.get(num);
	
		arr = new ArrayList<String>();
		
		// 기사를 문장별로 나누기
		for(int i=0; i<tmpArticle.length; i++){
			if(arr.isEmpty()){
				arr.add(tmpArticle[i]);
			}
			if( (tmpArticle[i].length() > 0) && (tmpArticle[i].charAt(tmpArticle[i].length()-1) == '.'))
				arr.add(tmpArticle[i]);
		}
		
		// 본문이란 단어 없애기
		if(arr.get(0).contains("본문")){
			arr.remove(0);
		}
		
		//제목 설정
		title = arr.get(0);
		if(title.length() > 36){
			title = title.substring(0, 36);
			title += "..";
		}
		
		// 첫문장 설정
		firstSentence = arr.get(1).split("\\.")[0];
		if(firstSentence.length() > 58){
			firstSentence = firstSentence.substring(0, 60);
			firstSentence += "..";
		}
		
		// URL
		urlPopularString = urlDaumPopularList.get(num);
		twtSentence = "["+title+"] "+firstSentence+" "+urlPopularString;

		out.println(twtSentence+"<br><br>");
		// 기사 저장
		if(!ArticleStorage.PopularArticleStorage.contains(twtSentence)){
			
			// 제목 뺀 기사 내용만
			for(int i=1; i<arr.size(); i++)
				articleSummary += arr.get(i)+"\n";
			
			// 과도한 개행시 없애기
			articleSummary = articleSummary.replaceAll("\n", "");

			// 페북
			WSummary.SummaryCheck(articleSummary);
			
			// 가중치 Top3 단어 받고, 다시 또 비교
			ArticleStorage.WordTop3 = WSummary.getBestNouns();
			
			boolean wordBtn = false;
			for(int i=0; i<ArticleStorage.PopularWordTop3.size(); i++){
				// 포함 되어있는지 안되어있는지 확인
				int sameWordCount = 0;
				for(int j=0; j<3; j++){
					for(int k=0; k<3; k++){
						if(ArticleStorage.PopularWordTop3.get(i)[j].equals(ArticleStorage.WordTop3[k])){
							sameWordCount++;
							if(sameWordCount == 2){
								// 2개 이상 포함되어있다면
								wordBtn = true;
								break;
							}
						}
					}
				}
			}

			// 막 데이터가 들어가지 않게 막아줌.
			if(!wordBtn){
				ArticleStorage.PopularArticleStorage.add(twtSentence);
				ArticleStorage.PopularWordTop3.add(ArticleStorage.WordTop3);
				result = title+"\n"+WSummary.getResult(2)+"\n(자세히 보기: "+urlPopularString+")";
				// 페이스 북
				fb = new Facebook(result);
				// 트위터
				tw.update(twtSentence);
				break;
			}

		}

		num++;
	}

	/*
	str = articleDaumReplyList.get(num);
	for(int i=0; i<arr.size(); i++){
		out.println(arr.get(i));
	}
	*/

	
	/********************************************************************************/
	
	
	out.println(result+"<br><br>");
	
	out.println("heap size : " + Runtime.getRuntime().totalMemory() / (1024*1024) + "MB<br><br>");
	out.println(WSummary.getAllInform());

%></pre>
</body>
</html>