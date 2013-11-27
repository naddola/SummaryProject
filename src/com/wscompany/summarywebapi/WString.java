package com.wscompany.summarywebapi;

import java.util.ArrayList;
import java.util.List;

import kr.co.shineware.nlp.komoran.core.MorphologyAnalyzer;
import kr.co.shineware.util.common.model.Pair;

public class WString {
	MorphologyAnalyzer Analyzer;
	String WStr;
	ArrayList<WNoun> WNouns;
	double WWeight;

	public WString(String str, MorphologyAnalyzer analyzer) {
		Analyzer = analyzer; 
		WNouns = new ArrayList<WNoun>();
		WStr = str;

		List<List<Pair<String, String>>> result = Analyzer.analyze(str);

		ArrayList<String> wordList = new ArrayList<String>();

		for (List<Pair<String, String>> eojeolResult : result) {
			for (Pair<String, String> wordMorph : eojeolResult) {
				if (wordMorph.getSecond().equals("NNP")
						|| wordMorph.getSecond().equals("NNG") || wordMorph.getSecond().equals("SN")) {
					WNouns.add(new WNoun(wordMorph.getFirst()));
					//wordList.add(wordMorph.getFirst());
				}
			}
		}

		WWeight = 0;
	}

	public int getWeight() {
		int size = WNouns.size();
		return size;
	}

	public String getAllInform() {
		StringBuffer TempStr = new StringBuffer();
		for (int i = 0; i < WNouns.size(); i++) {
			TempStr.append(WNouns.get(i).getNoun() + ", ");
		}
		String str = "문장 : " + WStr + "    가중치: " + WWeight + "\n" + "단어 : "
				+ TempStr;
		return str;
	}
}
