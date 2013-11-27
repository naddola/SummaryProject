package com.wscompany.summarywebapi;

import java.util.ArrayList;
import java.util.Collections;

import kr.co.shineware.nlp.komoran.core.MorphologyAnalyzer;

public class WSummary {

	public static MorphologyAnalyzer Analyzer;
	static int NumberOfAllString;
	static String[] BestNouns;

	static String SummaryString;
	static ArrayList<WString> Strings = new ArrayList<WString>();
	static ArrayList<WNoun> Nouns = new ArrayList<WNoun>();

	public static void init() {
		BestNouns = new String[5];
		SummaryString = "";
		Strings.clear();
		Nouns.clear();
		NumberOfAllString = 0;
	}

	public static String SummaryCheck(String str) {
		// 문장 ?�약
		init();
		SummaryString = str;
		devideStrings();

		calculateWeightAllString();
		// removeUnnecessaryString();
		// combineStrings();
		setBestNouns();

		return SummaryString;
	}

	// 문장 나누기
	public static void devideStrings() {
		ArrayList<String> OldStrings = new ArrayList<String>();
		boolean OldOn = false;
		String[] tempStrings;
		StringBuffer tempStringBuffer = new StringBuffer();
		tempStrings = SummaryString.split("\\.");
		for (int i = 0; i < tempStrings.length; i++) {
			if (tempStrings[i].length() > 0) {

				if (tempStrings[i].charAt(tempStrings[i].length() - 1) >= '가'
						&& tempStrings[i].charAt(tempStrings[i].length() - 1) <= '힣') {
					if (OldOn) {
						ArrayList<WNoun> TempNouns = new ArrayList<WNoun>();
						tempStringBuffer.delete(0, tempStringBuffer.capacity());
						for (int j = 0; j < OldStrings.size(); j++) {
							tempStringBuffer.append(OldStrings.get(j) + ".");
						}
						tempStringBuffer.append(tempStrings[i]);
						if (checkQuotation(tempStringBuffer)) {
							Strings.add(new WString(
									tempStringBuffer.toString(), Analyzer));
							TempNouns = Strings.get(Strings.size() - 1).WNouns;
							insertAllNouns(TempNouns);
							OldOn = false;
							OldStrings.clear();
						} else {
							OldStrings.add(tempStrings[i]);
							OldOn = true;
						}

					} else {
						ArrayList<WNoun> TempNouns = new ArrayList<WNoun>();
						tempStringBuffer.delete(0, tempStringBuffer.capacity());
						tempStringBuffer.append(tempStrings[i]);
						if (checkQuotation(tempStringBuffer)) {
							Strings.add(new WString(
									tempStringBuffer.toString(), Analyzer));
							TempNouns = Strings.get(Strings.size() - 1).WNouns;
							insertAllNouns(TempNouns);
							OldStrings.clear();
							OldOn = false;
						} else {
							OldStrings.add(tempStrings[i]);
							OldOn = true;
						}
					}
				} else {
					OldStrings.add(tempStrings[i]);
					OldOn = true;
				}
			}
		}
		NumberOfAllString = Strings.size();
	}

	public static int getResultSize() {
		return NumberOfAllString;
	}

	// 문장 나눌 때 큰따옴표 체크
	public static boolean checkQuotation(StringBuffer str) {
		int NumberOfQuotation = 0;
		for (int i = 0; i < str.length(); i++) {
			if (str.charAt(i) == '\"') {
				NumberOfQuotation++;
			}
		}
		if (NumberOfQuotation % 2 == 0)
			return true;
		else
			return false;
	}

	// �?문장??�?���?구하�?
	public static void calculateWeight(WString str, int num) {
		double NumberOfNouns = (double) str.WNouns.size();
		double SumNumberOfNouns = 0;
		for (int i = 0; i < str.WNouns.size(); i++) {
			SumNumberOfNouns += getNumberOfNouns(str.WNouns.get(i).Nouns);
		}

		str.WWeight = (SumNumberOfNouns / NumberOfNouns) * Strings.size() / num
				* 1;
	}

	// ?�체 문장 �?���?구하�?
	public static void calculateWeightAllString() {
		for (int i = 0; i < Strings.size(); i++) {
			calculateWeight(Strings.get(i), i + 1);
		}
	}

	// 문장???�어?�을 ?�체 ?�어?�에 ?�력
	public static void insertAllNouns(ArrayList<WNoun> tempList) {
		boolean permission = true;
		for (int i = 0; i < tempList.size(); i++) {
			permission = true;
			for (int j = 0; j < Nouns.size(); j++) {
				if (tempList.get(i).Nouns.equals(Nouns.get(j).Nouns)) {
					Nouns.get(j).Score++;
					permission = false;
				}
			}
			if (permission) {
				Nouns.add(tempList.get(i));
			}
		}
	}

	// ?�정 ?�어??빈도???�기
	public static int getNumberOfNouns(String keyword) {
		for (int i = 0; i < Nouns.size(); i++) {
			if (Nouns.get(i).Nouns.equals(keyword))
				return Nouns.get(i).Score;
		}
		return 0;
	}
	
	public static String getAllInform() {
		StringBuffer str = new StringBuffer();
		for (int i = 0; i < Strings.size(); i++) {
			str.append(i + 1);
			// str.append(Strings.get(i).getAllInform() + "<br><br>");
			str.append(Strings.get(i).getAllInform() + "\n\n");
		}

		str.append("사용 단어 : ");

		for (int i = 0; i < Nouns.size(); i++) {
			str.append(Nouns.get(i).Nouns + "(" + Nouns.get(i).Score + ")"
					+ ", ");
		}

		return str.toString();
	}

	public static String getResult(int number) {
		StringBuffer Result = new StringBuffer();
		ArrayList<Double> InateNumber = new ArrayList<Double>();

		for (int i = 0; i < Strings.size(); i++) {
			InateNumber.add(Strings.get(i).WWeight);
		}
		Collections.sort(InateNumber);
		Collections.reverse(InateNumber);

		double LimitWeight = InateNumber.get(number - 1);
		for (int i = 0; i < Strings.size(); i++) {
			if (Strings.get(i).WWeight < LimitWeight) {
				Strings.remove(i);
				i--;
			}
		}

		for (int i = 0; i < Strings.size(); i++) {
			Result.append("\n");
			Result.append("- ");
			checkResultString(Strings.get(i));
			Result.append(Strings.get(i).WStr + ". ");
		}

		return Result.toString();
	}

	public static void setBestNouns() {
		int max = 0;
		String tempString = "";
		boolean permit = true;
		for (int i = 0; i < BestNouns.length; i++) {
			max = 0;
			permit = true;
			tempString = "";
			for (int j = 0; j < Nouns.size(); j++) {
				if (Nouns.get(j).Score > max) {
					for (int k = 0; k < BestNouns.length; k++) {
						if (BestNouns[k] != null && BestNouns[k].equals(Nouns.get(j).Nouns)) {
							permit = false;
						}
					}
					if (permit) {
						tempString = Nouns.get(j).Nouns;
						max = Nouns.get(j).Score;
					}
					permit = true;
				}
			}
			BestNouns[i] = tempString;
		}
	}
	
	public static String[] getBestNouns(){
		return BestNouns;
	}

	public static void checkResultString(WString wstring) {
		String[] conjunctions = new String[] { "그런데", "그리고", "그리하여", "이리하여" };
		for (int j = 0; j < conjunctions.length; j++) {
			wstring.WStr.replace(conjunctions[j], "");
		}
	}

}
