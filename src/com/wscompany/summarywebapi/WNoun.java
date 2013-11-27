package com.wscompany.summarywebapi;

public class WNoun{
	String Nouns;
	int Score;
	
	public WNoun(String noun){
		Nouns = noun;
		Score = 1;
	}
	
	public String getNoun(){
		return Nouns;
	}
	
	public int getScore(){
		return Score;
	}
}