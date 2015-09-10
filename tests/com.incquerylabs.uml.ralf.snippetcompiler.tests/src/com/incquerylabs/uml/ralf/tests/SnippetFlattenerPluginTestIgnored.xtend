package com.incquerylabs.uml.ralf.tests

import com.incquerylabs.uml.ralf.tests.util.AbstractPluginSnippetTest
import java.util.Collection
import org.junit.Ignore
import org.junit.runners.Parameterized.Parameters

@Ignore("These features are not yet functioning")
class SnippetFlattenerPluginTestIgnored extends AbstractPluginSnippetTest{

	@Parameters(name = "{0}")
	def static Collection<Object[]> testData() {
		newArrayList(
			#[  "Operation call alternative",
			    '''this.doIntegerVoid(parameter => 2);''',
				'''
				this.doIntegerVoid(2);''',
				"model::Comp::Pong::doIntegerVoid"
			],
			#[  "Static operation call",
			    '''
				Pong::staticIntegerOperation();''',
				'''
				PrimitiveTypes::Integer temp0 = this.returnInteger();
				switch (temp0) {
				}''',
				"model::Comp::Pong::doIntegerVoid"
			],
			#[  "Static operation call params",
			    '''
				Pong::staticParametricOperation(1, 2);''',
				'''
				PrimitiveTypes::Integer temp0 = this.returnInteger();
				switch (temp0) {
				}''',
				"model::Comp::Pong::doIntegerVoid"
			],
			#[  "Property access 3",
			    '''
				Ping p = new Ping();
				Integer x = p->pong.integerProperty ;''',
				'''
				model::Comp::Ping p = new model::Comp::Ping();
				model::Comp::Pong temp0 = p->pong;
				PrimitiveTypes::Integer x = temp0->integerProperty;''',
				"model::Comp::Pong::doIntegerVoid"
			],
			#[  "Postfix expression on association",
			    '''
			    Ping x = new Ping();
			    x->pong.integerProperty++;''',
				'''
				model::Comp::Ping x = new model::Comp::Ping();
				model::Comp::Pong temp0 = x->pong;
				temp0->integerProperty++;''',
				"model::Comp::Pong::doIntegerVoid"
			]
		)
	}
}

