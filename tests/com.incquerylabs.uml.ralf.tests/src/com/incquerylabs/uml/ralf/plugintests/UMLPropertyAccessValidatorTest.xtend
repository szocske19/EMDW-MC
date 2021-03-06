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
package com.incquerylabs.uml.ralf.plugintests

import com.incquerylabs.uml.ralf.ReducedAlfSystem
import com.incquerylabs.uml.ralf.tests.util.basetests.AbstractPluginValidatorTest
import com.incquerylabs.uml.ralf.validation.ReducedAlfLanguageValidator
import java.util.Collection
import org.junit.BeforeClass
import org.junit.runners.Parameterized.Parameters
import org.eclipse.xtext.diagnostics.Diagnostic

class UMLPropertyAccessValidatorTest extends AbstractPluginValidatorTest{
	@BeforeClass
	def static void setup(){
		modelName = "/com.incquerylabs.uml.ralf.tests/model/model.uml"
		init()
	}
	
	@Parameters(name = "{0}")
	def static Collection<Object[]> testData() {
		newArrayList(
			#[  "Property Access: Integer",
			    '''
			    Pong x = new Pong();
			    x.integerProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: Integer_This",
			    '''
			    this.integerProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: String",
			    '''
			    Pong x = new Pong();
			    x.stringProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: Boolean",
			    '''
			    Pong x = new Pong();
			    x.booleanProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: UMLType",
			    '''
			    Pong x = new Pong();
			    x.pongProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: Integer_AssignmentRHS",
			    '''
			    Pong x = new Pong();
			    Integer a;
			    a = x.integerProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: Integer_This_AssignmentRHS",
			    '''
			    Integer a;
			    a = this.integerProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: String_AssignmentRHS",
			    '''
			    Pong x = new Pong();
			    String a;
			    a = x.stringProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: Boolean_AssignmentRHS",
			    '''
			    Pong x = new Pong();
			    Boolean a;
			    a = x.booleanProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: UMLType_AssignmentRHS",
			    '''
			    Pong x = new Pong();
			    Pong a;
			    a = x.pongProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: Integer_AssignmentLHS",
			    '''
			    Pong x = new Pong();
			    Integer a = 1;
			    x.integerProperty = a;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: Integer_This_AssignmentLHS",
			    '''
			    Integer a = 1;
			    this.integerProperty = a;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: String_AssignmentLHS",
			    '''
			    Pong x = new Pong();
			    String a = "123";
			    x.stringProperty = a;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: Boolean_AssignmentLHS",
			    '''
			    Pong x = new Pong();
			    Boolean a = true;
			    x.booleanProperty = a;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: UMLType_AssignmentLHS",
			    '''
			    Pong x = new Pong();
			    Pong a = new Pong();
			    x.pongProperty = a;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Invalid Property Access: InvalidTypeLHS",
			    '''
			    Pong x = new Pong();
			    String a = "1";
			    x.pongProperty = a;''',
				"model::Comp::Pong::TestOperation",
			    #[ReducedAlfSystem.ASSIGNMENTEXPRESSION]
			],
			#[  "Invalid Property Access: InvalidTypeRHS",
			    '''
			    Pong x = new Pong();
			    String a;
			    a = x.pongProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[ReducedAlfSystem.ASSIGNMENTEXPRESSION]
			],
			#[  "Property Access: operation",
			    '''
			    returnPong().integerProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Property Access: association",
			    '''
			    Ping p = new Ping();
			    p->pong.one().integerProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[]
			],
			#[  "Invalid Property Access: no such property",
			    '''
			    Ping x = new Ping();
			    x.stringProperty;''',
				"model::Comp::Pong::TestOperation",
			    #[
			        ReducedAlfSystem.FEATUREINVOCATIONEXPRESSION,
			        Diagnostic.LINKING_DIAGNOSTIC
			    ]
			]
			
		)
	}
}