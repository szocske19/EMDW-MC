package com.incquerylabs.emdw.cpp.bodyconverter.test.single

import java.util.Collection
import org.junit.runners.Parameterized.Parameters

class TransitionGuardConvertingTest extends AbstractSingleConversionTest{
	@Parameters(name = "{0}")
	def static Collection<Object[]> testData() {
		newArrayList(
			#[  "Single Conversion Test: Test class attribute in transition guard",
				"/com.incquerylabs.emdw.cpp.bodyconverter.test/models/PingPongSpecial/model.uml",
				"model::Comp::Pong::Pong_SM::Region1::e3",
				ConversionType.TransitionGuard,
				'''
				this.'count' < 42;
				''',
				'''
				long __ralf__0__long = this->count;
				__ralf__0__long < 42;'''
			]
		)
	}
}

