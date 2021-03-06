/*******************************************************************************
 * Copyright (c) 2015-2016, IncQuery Labs Ltd. and Ericsson AB
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   Akos Horvath, Abel Hegedus, Zoltan Ujhelyi, Daniel Segesdi, Tamas Borbas, Robert Doczi, Peter Lunk, Istvan Papp - initial API and implementation
 *******************************************************************************/
package com.incquerylabs.emdw.cpp.codegeneration.test.mappings

import com.ericsson.xtumlrt.oopl.cppmodel.CPPClass
import com.ericsson.xtumlrt.oopl.cppmodel.CPPModel
import com.incquerylabs.emdw.cpp.codegeneration.test.TransformationTest
import org.eclipse.papyrusrt.xtumlrt.common.State
import org.junit.runner.RunWith
import org.junit.runners.Suite
import org.junit.runners.Suite.SuiteClasses

import static org.junit.Assert.*

@SuiteClasses(#[
	StateMappingTest
])
@RunWith(Suite)
class StateMappingTestSuite {}

class StateMappingTest extends TransformationTest<State, CPPClass> {
	
	override protected prepareCppModel(CPPModel cppModel) {
		
		val xtmodel = cppModel.commonModel
		val xtPackage = xtmodel.createPackage("RootPackage")
		val xtComponent = xtPackage.createXtComponent("Component")
		val xtClass = xtComponent.createXtClass("TEST")
		val topState = xtClass.createStateMachine("SM").createCompositeState("top")
		val classEvent = xtClass.createXtClassEvent("ClassEvent")
		val init = topState.createInitialPoint("init")
		val s1 = topState.createSimpleState("s1")
		topState.createTransition(init, s1, "SAMPLE_CODE")
		val s2 = topState.createSimpleState("s2")
		val t = topState.createTransition(s1,s2,"t2", "C++", "SAMPLE_CODE")
		t.createXTEventTrigger(classEvent, "Trigger")
		
		val cppPackage = cppModel.createCPPPackage(xtPackage)
		val cppComponent = cppPackage.createCPPComponentWithDirectoriesAndFiles(xtComponent)
		val cppClassHeader = cppComponent.headerDirectory.createCPPHeaderFile
		val cppClassBody = cppComponent.bodyDirectory.createCPPBodyFile
		val cppClass = cppComponent.createCPPClass(xtClass, cppClassHeader, cppClassBody)
		cppClass.createCPPEvent(classEvent)
		cppClass.createCPPState(s1)
		cppClass.createCPPState(s2)
		cppClass.createCPPTransition(t)
		
		cppClass
	}
	
	override protected assertResult(CPPModel result, CPPClass cppObject) {
		val files = cppCodeGeneration.generatedCPPSourceFiles
		val classHeader = files.get(cppObject.headerFile).toString
		assertTrue(classHeader.contains("class TEST_state"))
		assertTrue(classHeader.contains("s1"))
		assertTrue(classHeader.contains("s2"))
		
		assertTrue(classHeader.contains("ClassEvent"))
		
		// check state and transition operations in declaration
		assertTrue(classHeader.contains("process_event_in_s1_state"))
		assertTrue(classHeader.contains("perform_actions_on_t2_transition_from_s1_to_s2"))
		assertTrue(classHeader.contains("process_event_in_s2_state"))
		
	}
	
}