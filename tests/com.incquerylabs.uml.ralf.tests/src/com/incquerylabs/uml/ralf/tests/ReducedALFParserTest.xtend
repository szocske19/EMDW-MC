package com.incquerylabs.uml.ralf.tests

import com.google.inject.Inject
import com.google.inject.Injector
import com.incquerylabs.uml.ralf.reducedAlfLanguage.Statements
import com.incquerylabs.uml.ralf.validation.ReducedAlfLanguageValidator
import com.incquerylabs.uml.ralf.validation.ReducedAlfSystemValidator
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.junit4.validation.ValidatorTester
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.FixMethodOrder
import org.junit.runners.MethodSorters

@RunWith(typeof(XtextRunner))
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
@InjectWith(typeof(ReducedAlfLanguageCustomInjectorProvider))
class ReducedALFParserTest {

	@Inject
	ParseHelper<Statements> parseHelper

	@Inject
	ReducedAlfSystemValidator validator

	@Inject
	Injector injector

	@Inject
	ValidatorTester<ReducedAlfLanguageValidator> tester
	
	@Inject extension ValidationTestHelper
	
	@Test
	def additionExpression() {
		val model = parseHelper.parse('''1 + 2;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def simpleLocalVariable() {
		val model = parseHelper.parse('''let x : Integer = 1 + 2;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def hexadecimalLiteral() {
		val model = parseHelper.parse('''let x : Integer = 0xAE10;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def underscoreLiteral() {
		val model = parseHelper.parse('''let x : Integer = 123_456;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def multipleAdditions() {
		val model = parseHelper.parse(
		'''
		let x : Integer = 1 + 2;
		let y : Integer = 1 + 2;
		'''
		)
		tester.validate(model).assertOK
	}
	
	@Test
	def chainedAddition() {
		val model = parseHelper.parse('''let x : Integer = 1 + 2 + 3 + 4;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def parenthesedAddition() {
		val model = parseHelper.parse('''let x : Integer = (1 * (2 + 3)) + 4;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def localVariableReference() {
		val model = parseHelper.parse(
		'''
		let x : Integer = 1 + 2;
		let y : Integer = x + 2;
		'''
		)
		tester.validate(model).assertOK
	}
	
	@Test
	def incrementOperation() {
		val model = parseHelper.parse(
		'''
		let x : Integer = 1;
		x++;
		'''
		)
		tester.validate(model).assertOK
	}
	
	@Test
	def incrementOperationPrefix() {
		val model = parseHelper.parse(
		'''
		let x : Integer = 1;
		++x;
		'''
		)
		tester.validate(model).assertOK
	}
	
	@Test
	def decrementOperation() {
		val model = parseHelper.parse(
		'''
		let x : Integer = 1;
		x--;
		'''
		)
		tester.validate(model).assertOK
	}
	
	@Test
	def decrementOperationPrefix() {
		val model = parseHelper.parse(
		'''
		let x : Integer = 1;
		--x;
		'''
		)
		tester.validate(model).assertOK
	}
	
	@Test
	def leftShift() {
		val model = parseHelper.parse(
		'''
        let x : Integer = 1;
        let y : Integer = x << 1;
		'''
		)
		tester.validate(model).assertOK
	}
	
	@Test
	def rightShift() {
		val model = parseHelper.parse(
		'''
        let x : Integer = 1;
        let y : Integer = x >> 1;
		'''
		)
		tester.validate(model).assertOK
	}
	
	@Test
	def shiftPrecedence() {
		val model = parseHelper.parse('''let x : Integer = 1 + (2 >> 3);''')
		tester.validate(model).assertOK
	}
	
	@Test
	def comparisonLesserThan() {
		val model = parseHelper.parse('''let x : Boolean = 1 < 2;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def comparisonLesserOrEquals() {
		val model = parseHelper.parse('''let x : Boolean = 1 <= 2;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def comparisonGreaterThan() {
		val model = parseHelper.parse('''let x : Boolean = 1 > 2;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def comparisonGreaterOrEquals() {
		val model = parseHelper.parse('''let x : Boolean = 1 >= 2;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def equality() {
		val model = parseHelper.parse('''let x : Boolean = 1 == 2;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def inEquality() {
		val model = parseHelper.parse('''let x : Boolean = 1 == 2;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def logicalBitwiseAnd() {
		val model = parseHelper.parse('''let x : Boolean = 1 != 2 & false;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def logicalBitwiseOr() {
		val model = parseHelper.parse('''let x : Boolean = 1 != 2 ^ false;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def logicalNot() {
		val model = parseHelper.parse('''let x : Boolean = 1 != 2 | false;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def logicalAnd() {
		val model = parseHelper.parse('''let x : Boolean = 1 != 2 && true;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def logicalOr() {
		val model = parseHelper.parse('''let x : Boolean = 1 != 2 || true;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def conditionalTestOperation() {
		val model = parseHelper.parse('''let x : String = (1 != 2) ? "test" : "test2";''')
		tester.validate(model).assertOK
	}
	
	@Test
	def assignment() {
		val model = parseHelper.parse(''' y = 2;''')
		tester.validate(model).assertOK
	}
	
	@Test
	def stringConcatenation() {
		val model = parseHelper.parse('''let x : String = "1" + "2";''')
		tester.validate(model).assertOK
	}

}