package com.incquerylabs.uml.ralf.transformation.test

import java.util.Collection
import org.junit.runners.Parameterized.Parameters

class OperationConvertingTest extends AbstractPluginTest{
	@Parameters(name = "{0}")
	def static Collection<Object[]> testData() {
		newArrayList(
			#[  "Plug-In Test: Send signal using the 'this' object",
				//This example test case uses the model of the Ping-Pong example. 
				//It parses the action code describing a ping signal being sent to the "ping" attribute (association end) of the current object.
				"::model::Comp::Pong::sendPing", 
				ConversionType.Operation,
				'''this->ping->generate_event(new model::Comp::Pong::ping_s());'''
			]
		)
	}
}

