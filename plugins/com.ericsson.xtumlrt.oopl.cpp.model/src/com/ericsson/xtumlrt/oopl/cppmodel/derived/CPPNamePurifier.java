package com.ericsson.xtumlrt.oopl.cppmodel.derived;

import java.util.regex.Pattern;

public class CPPNamePurifier {
	
	/**
	 * \d			A digit: [0-9]
	 * \s			A whitespace character: [ \t\n\x0B\f\r]
	 * \p{Punct}	Punctuation: One of !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
	 * 
	 * See {@link Pattern} for details
	 */
	static String remove_pattern = "^\\d|[\\s\\p{Punct}]"; 

	/**
	 * C++ name conventions: <br>
	 * 
	 *  - invalid characters: ' " ` & ? | \ . , : ; ~ = / * - + < > ( ) [ ] { } ^ % # @ space <br>
	 * 
	 *  - cannot start with a number
	 */
	public static String purifyName(String original) {
		return original.replaceAll(remove_pattern,"_");
	}
	
}