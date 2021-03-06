/*******************************************************************************
 * Copyright (c) 2015-2016, IncQuery Labs Ltd. and Ericsson AB
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   Akos Horvath, Abel Hegedus, Zoltan Ujhelyi, Peter Lunk - initial API and implementation
 *******************************************************************************/
package com.incquerylabs.uml.ralf.tests.parser

import com.incquerylabs.uml.ralf.tests.util.basetests.AbstractParserTest
import java.util.Collection
import org.junit.runners.Parameterized.Parameters

class AffixExpressionParserTest extends AbstractParserTest{
	@Parameters(name = "{0}")
	def static Collection<Object[]> testData() {
		newArrayList(
			#[  "Affix Increment: Integer Literal",
			    '''
				++1''',
			    "PrefixExpression",
			    false
			],
			#[  "Affix Increment: Real Literal",
			    '''
				++1.1''',
			    "PrefixExpression",
			    false
			],
			#[  "Affix Increment: Integer Literal Parentheses",
			    '''
				++(1)''',
			    "PrefixExpression",
			    false
			],
			#[  "Affix Increment: Real Literal Parentheses",
			    '''
				++(1.1)''',
			    "PrefixExpression",
			    false
			],
			#[  "Affix Increment: Boolean Literal",
			    '''
				++true''',
			    "PrefixExpression",
			    false
			],
			#[  "Affix Increment: String Literal",
			    '''
				++"a"''',
			    "PrefixExpression",
			    false
			],
			#[  "Affix Increment: String Literal Parentheses",
			    '''
				++("a")''',
			    "PrefixExpression",
			    false
			],
			#[  "Affix Increment: Numeric Unary Negative",
			    '''
				++-1''',
			    "PrefixExpression",
			    true
			],
			#[  "Affix Increment: Numeric Unary Positive",
			    '''
				+++1''',
			    "PrefixExpression",
			    true
			],
			#[  "Affix Increment: Affix increment",
			    '''
				++++1''',
			    "PrefixExpression",
			    true
			],
			#[  "Affix Increment: Affix Decrement",
			    '''
				++--1''',
			    "PrefixExpression",
			    true
			]
		)
	}	
}
