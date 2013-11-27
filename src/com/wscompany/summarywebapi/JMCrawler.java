package com.wscompany.summarywebapi;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class JMCrawler {

		static Pattern HREF;
		private static String source, mAddr;
        private static StringBuffer content;
       
        public static String DownloadHtml(String addr, boolean utf8){
               mAddr = addr;
               content = new StringBuffer();

               try{
                     URL url = new URL(mAddr );
                     InputStream is = url.openStream();
                     InputStreamReader isr = null;
                     if(utf8)
                    	 isr = new InputStreamReader(is, "UTF-8" );
                     else
                    	 isr = new InputStreamReader(is);
                     BufferedReader br = new BufferedReader(isr);

                     String inStr = "";
                      while((inStr = br.readLine()) != null){
                            content.append(inStr + "\n" );
                     }
                     
              } catch(Exception e){
              }
              
               source = new String(content);
               return source ;
       }
       
        public static String htmlDaumBest(String str){
              String source = str;
              String findString = "<ol class=\"list_best\">" ;
               int findNumber = source.indexOf(findString);
              
              source = source.replace(source.substring(0, findNumber), "");
              
              findString = "<li class=\"line_bestnews\">" ;
              findNumber = source.indexOf(findString);

              source = source.replace(source.substring(findNumber, source.length()), "" );
              
              String addDaum = "http://media.daum.net/v/";
              source = source.replace( "/v/", addDaum);
              
               return source;
        }
        
        public static ArrayList<String> findHref(String str){
        	HREF = Pattern.compile("<a[^>]*href=[\"']?([^>\"']+)[\"']?[^>]*>");
        	ArrayList<String> result = new ArrayList<String>();
    		
    		Matcher m = HREF.matcher(str);
    		
    		while(m.find()){
    			result.add(m.group(1));
    		}
    		
    		return result;
    	}
}
