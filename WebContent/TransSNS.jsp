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
<title>�׽�Ʈ</title>
<script>
setTimeout("history.go(0);", 1800000); //1000=1�� 60000=60��
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
	
	// ��� ���� ��
	
	// ��� �޾ƿ���
	while(num < 10){
		// ��� �޾ƿ���
		tmpArticle = articleDaumReplyList.get(num).split("\n");
	
		// Ʈ���Ϳ� ���� URL �޾ƿ���
		urlReplyString = urlDaumReplyList.get(num);
	
		arr = new ArrayList<String>();
		
		// ��縦 ���庰�� ������
		for(int i=0; i<tmpArticle.length; i++){
			if(arr.isEmpty()){
				if(!tmpArticle[i].contains(" ����"))
					arr.add(tmpArticle[i]);
			}
			if( (tmpArticle[i].length() > 0) && (tmpArticle[i].charAt(tmpArticle[i].length()-1) == '.'))
				arr.add(tmpArticle[i]);
		}
		
		// �����̶� �ܾ� ���ֱ�
		if(arr.get(0).contains("����")){
			arr.remove(0);
		}
		
		// ���� ����
		title = arr.get(0);
		if(title.length() > 36){
			title = title.substring(0, 36);
			title += "..";
		}
		
		// ù���� ����
		firstSentence = arr.get(1).split("\\.")[0];
		if(firstSentence.length() > 58){
			firstSentence = firstSentence.substring(0, 60);
			firstSentence += "..";
		}
		
		// URL
		urlReplyString = urlDaumReplyList.get(num);
		twtSentence ="["+title+"] "+firstSentence+" "+urlReplyString;

		out.println(twtSentence+"<br><br>");
		
		// ��� ����
		if(!ArticleStorage.ReplyArticleStorage.contains(twtSentence)){
			ArticleStorage.ReplyArticleStorage.add(twtSentence);
			break;
		}

		num++;
	}


	// ���� �� ��� ���븸
	for(int i=1; i<arr.size(); i++)
		articleSummary += arr.get(i)+"\n";
	
	// ������ ����� ���ֱ�
	articleSummary = articleSummary.replaceAll("\n", "");

	// ���
	
	WSummary.SummaryCheck(articleSummary);
		
	String result = title+"\n"+WSummary.getResult(2)+"\n(�ڼ��� ����: "+urlReplyString+")";
	Facebook fb = new Facebook(result);

	// Ʈ����
	tw.update(twtSentence);

	/*
	str = articleDaumReplyList.get(num);
	for(int i=0; i<arr.size(); i++){
		out.println(arr.get(i));
	}
	*/
	
	/********************************************************************************/
	
	out.println(result+"<br><br>");
	
	// �α� ���� ��
	num = 0;
	articleSummary = "";
	
	while(num < 10){
		// ��� �޾ƿ���
		tmpArticle = articleDaumPopularList.get(num).split("\n");
		
		// Ʈ���Ϳ� ���� URL �޾ƿ���
		urlPopularString = urlDaumPopularList.get(num);
	
		arr = new ArrayList<String>();
		
		// ��縦 ���庰�� ������
		for(int i=0; i<tmpArticle.length; i++){
			if(arr.isEmpty()){
				arr.add(tmpArticle[i]);
			}
			if( (tmpArticle[i].length() > 0) && (tmpArticle[i].charAt(tmpArticle[i].length()-1) == '.'))
				arr.add(tmpArticle[i]);
		}
		
		// �����̶� �ܾ� ���ֱ�
		if(arr.get(0).contains("����")){
			arr.remove(0);
		}
		
		//���� ����
		title = arr.get(0);
		if(title.length() > 36){
			title = title.substring(0, 36);
			title += "..";
		}
		
		// ù���� ����
		firstSentence = arr.get(1).split("\\.")[0];
		if(firstSentence.length() > 58){
			firstSentence = firstSentence.substring(0, 60);
			firstSentence += "..";
		}
		
		// URL
		urlPopularString = urlDaumPopularList.get(num);
		twtSentence = "["+title+"] "+firstSentence+" "+urlPopularString;

		out.println(twtSentence+"<br><br>");
		// ��� ����
		if(!ArticleStorage.PopularArticleStorage.contains(twtSentence)){
			
			// ���� �� ��� ���븸
			for(int i=1; i<arr.size(); i++)
				articleSummary += arr.get(i)+"\n";
			
			// ������ ����� ���ֱ�
			articleSummary = articleSummary.replaceAll("\n", "");

			// ���
			WSummary.SummaryCheck(articleSummary);
			
			// ����ġ Top3 �ܾ� �ް�, �ٽ� �� ��
			ArticleStorage.WordTop3 = WSummary.getBestNouns();
			
			boolean wordBtn = false;
			for(int i=0; i<ArticleStorage.PopularWordTop3.size(); i++){
				// ���� �Ǿ��ִ��� �ȵǾ��ִ��� Ȯ��
				int sameWordCount = 0;
				for(int j=0; j<3; j++){
					for(int k=0; k<3; k++){
						if(ArticleStorage.PopularWordTop3.get(i)[j].equals(ArticleStorage.WordTop3[k])){
							sameWordCount++;
							if(sameWordCount == 2){
								// 2�� �̻� ���ԵǾ��ִٸ�
								wordBtn = true;
								break;
							}
						}
					}
				}
			}

			// �� �����Ͱ� ���� �ʰ� ������.
			if(!wordBtn){
				ArticleStorage.PopularArticleStorage.add(twtSentence);
				ArticleStorage.PopularWordTop3.add(ArticleStorage.WordTop3);
				result = title+"\n"+WSummary.getResult(2)+"\n(�ڼ��� ����: "+urlPopularString+")";
				// ���̽� ��
				fb = new Facebook(result);
				// Ʈ����
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