package com.wscompany.summarywebapi;

import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.User;
import twitter4j.auth.AccessToken;

public class TwtEngine {
	String comment;
	Twitter twitter;
	AccessToken accessToken = null;
	public TwtEngine(){
		comment = "str";
		String CONSUMER_KEY = "10nFbAV4J1RteLHB6EA";
		String CONSUMER_SECRET = "v63dLjkjob28sLD2jPmjxsgLKrjMC3SRQdYwedGRc";
		accessToken = new AccessToken("1899312169-xjg9LCvbfNPlfI4FgFLl1cM0QQXeDusg55uHj5F", "CJgZKNNBN1wUTwmZ1ojEyJKZoG7pN9f3CD3of1zLwGY");
		twitter = new TwitterFactory().getInstance();
		twitter.setOAuthConsumer(CONSUMER_KEY, CONSUMER_SECRET);
		twitter.setOAuthAccessToken(accessToken);
		User user = null;
		try {
			user = twitter.verifyCredentials();
		} catch (TwitterException e) {
			e.printStackTrace();
		}
		
		
	}
	public void update(String str) {
		Status status = null;
		try {
			status = twitter.updateStatus(str); 
			System.out.println(str);
		} catch (TwitterException e) {
		}
	}
}
