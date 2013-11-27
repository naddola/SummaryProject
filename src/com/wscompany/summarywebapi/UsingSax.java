package com.wscompany.summarywebapi;

import java.net.URL;
import java.util.ArrayList;

import org.xml.sax.InputSource;

import de.l3s.boilerpipe.document.TextDocument;
import de.l3s.boilerpipe.extractors.ArticleExtractor;
import de.l3s.boilerpipe.sax.BoilerpipeSAXInput;
import de.l3s.boilerpipe.sax.HTMLFetcher;

public class UsingSax implements Runnable {

	private ArrayList<String> urlList;
	private ArrayList<String> articleList;
	
	public UsingSax(ArrayList<String> url){
		urlList = new ArrayList<String>();
		articleList = new ArrayList<String>();
		urlList = url;
	}

	public ArrayList<String> getArticleList(){
		return articleList;
	}
	public ArrayList<String> getUrlList(){
		return urlList;
	}
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
        URL url;
        try {
            for(int i=0; i<urlList.size(); i++){
				url = new URL(urlList.get(i));
		        final InputSource is = HTMLFetcher.fetch(url).toInputSource();
		        
		        final BoilerpipeSAXInput in = new BoilerpipeSAXInput(is);
		        final TextDocument doc = in.getTextDocument();
		        articleList.add(ArticleExtractor.INSTANCE.getText(doc));
		        
		        Thread.sleep(1000);
            }
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
