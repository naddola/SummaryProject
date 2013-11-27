package com.wscompany.summarywebapi;

import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookClient;
import com.restfb.Parameter;
import com.restfb.types.FacebookType;

public class Facebook {
	public Facebook(String str){
		String MY_ACCESS_TOKEN = "CAAIrb0uZCt2UBAHqdpRs2L5f15iZAAEFgsIBBrKxqZBrMFOKoCM23lKbr1fFtphQNcIsYeB4QoSKnQklMasYBMQEsQOSPC4rXtea95nLyi4i1ZC1kovon1xqq5J97vtsDcJTogfhJ7DuqeulDdCZAsxkY165CHtvrnPeBiq8Q4ZC0AtdskDR7wAOoZBNN4x588ZD";
		String PAGE_ID = "371266863005328";
		FacebookClient facebookClient = new DefaultFacebookClient(MY_ACCESS_TOKEN);
		FacebookType publishMessageResponse = facebookClient.publish(PAGE_ID+"/feed",
				FacebookType.class, Parameter.with("message", str));
		System.out.println("Published message ID: "+ publishMessageResponse.getId());
		
	}
}
