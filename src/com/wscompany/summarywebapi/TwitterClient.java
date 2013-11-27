package com.wscompany.summarywebapi;

import twitter4j.Paging;
import twitter4j.ResponseList;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.auth.AccessToken;
import twitter4j.auth.RequestToken;

public class TwitterClient {
	public TwitterClient() {
		System.out.println("TwitterClient.TwitterClient");
	}

	Twitter twitter;

	RequestToken requestToken = null;
	AccessToken accessToken = null;

	final String CONSUMER_KEY = "10nFbAV4J1RteLHB6EA";
	final String CONSUMER_SECRET = "v63dLjkjob28sLD2jPmjxsgLKrjMC3SRQdYwedGRc";
	String url = ("OauthTwitter://twitter");
	
	
	public void update() {
		Status status = null;
		try {
			status = twitter.updateStatus("Hello!");
		} catch (TwitterException e) {
		}
	}

	public RequestToken getRequestToken() {

		twitter = new TwitterFactory().getInstance();
		// twitter = new TwitterFactory().(CONSUMER_KEY, CONSUMER_SECRET);
		twitter.setOAuthConsumer(CONSUMER_KEY, CONSUMER_SECRET);

		requestToken = null;
		try {
			requestToken = twitter.getOAuthRequestToken();

		} catch (TwitterException te) {
			te.printStackTrace();
		}
		System.out.print("TwitterClient.getRequestToken: ");
		System.out.print(requestToken.getToken() + " ");
		System.out.println(requestToken.getAuthorizationURL());

		return requestToken;
	}

	// public AccessToken getAccessToken(String oauth_token, RequestToken token)
	public AccessToken getAccessToken(String oauthToken,
			RequestToken requestToken) {
		if (requestToken == null) {
			System.out.print("requestToken == null");
		}
		if (oauthToken == null) {
			System.out.print("oauthToken == null");
		}

		twitter = new TwitterFactory().getInstance();
		twitter.setOAuthConsumer(CONSUMER_KEY, CONSUMER_SECRET);
		System.out.println("TwitterClient.getAccessToken: ");

		if (requestToken.getToken().equals(oauthToken)) {
			try {
				System.out.print("requestToken: ");
				System.out.print(requestToken.getToken() + " ");
				System.out.println(requestToken.getTokenSecret());

				//accessToken = twitter.getOAuthAccessToken(requestToken);
				accessToken = new AccessToken("1899312169-xjg9LCvbfNPlfI4FgFLl1cM0QQXeDusg55uHj5F", "CJgZKNNBN1wUTwmZ1ojEyJKZoG7pN9f3CD3of1zLwGY");

				//accessToken = twitter.getOAuthAccessToken(token.getToken(),
				//token.getTokenSecret());
				twitter.setOAuthAccessToken(accessToken);
				System.out.print("accessToken: ");
				System.out.print(accessToken.getToken() + " ");
				System.out.println(accessToken.getTokenSecret());
			} catch (Exception te) {
				te.printStackTrace();
			}
		} else {
			System.out.println("oauth_token error");
		}
		return accessToken;
	}

	public void printStatuses() {
		ResponseList<Status> statuses;
		Paging page = new Paging();
		page.count(20);
		page.setPage(1);

		try {
			statuses = twitter.getHomeTimeline(page);
			for (Status status : statuses) {
				// status.getId()
				System.out.println(status.getUser().getScreenName() + ":"
						+ status.getText());
				// status.getUser().getScreenName()
				// status.getUser().getURL()
				// status.getText()
				// status.getCreatedAt()
				// status.getUser().getProfileImageURL()
				// status.getSource()
			}
		} catch (TwitterException te) {
			te.printStackTrace();
		}
	}
}
