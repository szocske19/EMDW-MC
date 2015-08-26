package com.incquerylabs.uml.ralf.tests.examples.plugintests

import com.incquerylabs.uml.ralf.tests.example.util.AbstractPluginTest
import java.util.Collection
import org.junit.runners.Parameterized.Parameters

class PluginThisExampleTest extends AbstractPluginTest{
	@Parameters(name = "{0}")
	def static Collection<Object[]> testData() {
		newArrayList(
			#[  "Plug-In Test: Send signal using the 'this' object",
				//This example test case uses the model of the Ping-Pong example. 
				//It parses the action code describing a ping signal being sent to the "ping" attribute (association end) of the current object.
			    '''send new ping_s() to this->ping;''',
				'''this->ping->generate_event(new model::Comp::Pong::ping_s());''',
				//As in this test case there is no editor attached to the UML model, the qualified name of the current operation needs to be specified.
				//Hand the name of the current type to the context provider
				"model::Comp::Pong::doIntegerVoid"
			]
		)
	}
}
