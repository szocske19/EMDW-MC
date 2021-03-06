/*******************************************************************************
 * Copyright (c) 2015-2016, IncQuery Labs Ltd. and Ericsson AB
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   Akos Horvath, Abel Hegedus, Zoltan Ujhelyi, Daniel Segesdi, Tamas Borbas, Robert Doczi, Peter Lunk - initial API and implementation
 *******************************************************************************/
package com.incquerylabs.emdw.cpp.common.test.descriptors

import com.incquerylabs.emdw.cpp.common.descriptor.factory.IUmlDescriptorFactory
import com.incquerylabs.emdw.cpp.common.test.ValueDescriptorBaseTest
import com.incquerylabs.emdw.valuedescriptor.OperationCallDescriptor
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Model
import org.eclipse.uml2.uml.Signal
import org.junit.runner.RunWith
import org.junit.runners.Suite
import org.junit.runners.Suite.SuiteClasses

import static org.junit.Assert.*

@SuiteClasses(#[
	SendSignalTest
])
@RunWith(Suite)
class SendSignalTestSuite {}

class SendSignalTest extends ValueDescriptorBaseTest<Signal, OperationCallDescriptor> {
	
	private static final val COMPONENT_NAME = "TestComponent"
	private static final val CLASS_NAME = "TestClass"
	private static final val SIGNAL_NAME = "TestSignal"
	private static final val TARGET_VARIABLE_NAME = "target"
	private static final val SIGNAL_VARIABLE_NAME = "sig"
	private static final val IS_SENT_TO_SELF = false;
	private static final val EXPECTED_TYPE = '''void'''
	private static final val EXPECTED_REPRESENTATION = '''«TARGET_VARIABLE_NAME»->generate_«IF IS_SENT_TO_SELF»internal«ELSE»external«ENDIF»_event(«SIGNAL_VARIABLE_NAME»)'''
	private Class cl
	
	override protected createUmlObject(Model umlModel) {
		val comp = umlModel.createComponent(COMPONENT_NAME)
		cl = comp.createClass(CLASS_NAME)
		val sig = cl.createClassSignal => [
			it.name = SIGNAL_NAME
		]
		umlModel.createSignalEvent(sig)
		return sig
	}
	
	override protected prepareValueDescriptor(IUmlDescriptorFactory factory, Signal signal) {
		val targetDescriptor = (factory.createSingleVariableDescriptorBuilder => [
			it.isExistingVariable = true
			it.name = TARGET_VARIABLE_NAME
			it.type = cl
		]).build
		val signalDescriptor = (factory.createSingleVariableDescriptorBuilder => [
			it.isExistingVariable = true
			it.name = SIGNAL_VARIABLE_NAME
			it.type = signal
		]).build
		val descriptor = (factory.createSendSignalBuilder => [
			it.signal = signalDescriptor
			it.variable = targetDescriptor
			it.isInternal = com.incquerylabs.emdw.cpp.common.test.descriptors.SendSignalTest.IS_SENT_TO_SELF
		]).build
		return descriptor
	}
	
	override protected assertResult(Signal object, OperationCallDescriptor descriptor) {
		assertEquals(EXPECTED_TYPE, descriptor.baseType)
		assertEquals(EXPECTED_REPRESENTATION, descriptor.stringRepresentation)
	}
	
}