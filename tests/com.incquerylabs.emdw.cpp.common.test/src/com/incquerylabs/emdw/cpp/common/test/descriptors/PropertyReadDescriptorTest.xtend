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
import com.incquerylabs.emdw.valuedescriptor.PropertyReadDescriptor
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Model
import org.eclipse.uml2.uml.Property
import org.junit.runner.RunWith
import org.junit.runners.Suite
import org.junit.runners.Suite.SuiteClasses

import static org.junit.Assert.*

@SuiteClasses(#[
	PropertyReadDescriptorForAttributeTest,
	PropertyReadDescriptorForAssociationTest
])
@RunWith(Suite)
class PropertyReadDescriptorTestSuite {}

class PropertyReadDescriptorForAttributeTest extends ValueDescriptorBaseTest<Property, PropertyReadDescriptor> {
	
	private static final val COMPONENT_NAME = "TestComponent"
	private static final val CLASS_NAME = "TestClass"
	private static final val PROPERTY_NAME = "isOk"
	private static final val PROPERTY_TYPE = "Boolean"
	private static final val VARIABLE_NAME = "classVariable"
	private static final val EXPECTED_TYPE = '''bool'''
	private static final val EXPECTED_REPRESENTATION = '''«VARIABLE_NAME»->«PROPERTY_NAME»'''
	private Class umlClass
	
	override protected createUmlObject(Model umlModel) {
		val comp = umlModel.createComponent(COMPONENT_NAME)
		umlClass = comp.createClass(CLASS_NAME)
		val pT = findPrimitiveType(umlModel, PROPERTY_TYPE)
		val prop = umlClass.createAttribute(pT, PROPERTY_NAME)
		return prop
	}
	
	override protected prepareValueDescriptor(IUmlDescriptorFactory factory, Property object) {
		val classDescriptor = (factory.createSingleVariableDescriptorBuilder => [
			it.isExistingVariable = true
			it.name = VARIABLE_NAME
			it.type = umlClass
		]).build
		val descriptor = (factory.createPropertyReadBuilder => [
			it.property = object
			it.variable = classDescriptor
		]).build
		return descriptor
	}
	
	override protected assertResult(Property object, PropertyReadDescriptor descriptor) {
		assertTrue('''Descriptor's value type should be «EXPECTED_TYPE» instead of «descriptor.fullType».''', 
					descriptor.fullType==EXPECTED_TYPE)
		assertTrue('''Descriptor's string representation should be «EXPECTED_REPRESENTATION» instead of «descriptor.stringRepresentation».''',
					descriptor.stringRepresentation==EXPECTED_REPRESENTATION
		)
	}
}

class PropertyReadDescriptorForAssociationTest extends ValueDescriptorBaseTest<Property, PropertyReadDescriptor> {
	
	private static final val COMPONENT_NAME = "TestComponent"
	private static final val CLASS_NAME = "TestClass"
	private static final val PROPERTY_NAME = "dummy"
	private static final val ASSOCIATION_NAME = "myAssoc"
	private static final val OTHER_CLASS_NAME = "DummyClass"
	private static final val VARIABLE_NAME = "classVariable"
	private static final val EXPECTED_TYPE = '''::test::«COMPONENT_NAME»::«OTHER_CLASS_NAME»*'''
	private static final val EXPECTED_REPRESENTATION = '''«VARIABLE_NAME»->«ASSOCIATION_NAME»_«PROPERTY_NAME»'''
	private Class umlClass
	
	override protected createUmlObject(Model umlModel) {
		val comp = umlModel.createComponent(COMPONENT_NAME)
		umlClass = comp.createClass(CLASS_NAME)
		val dummyClass = comp.createClass(OTHER_CLASS_NAME)
		val prop = comp.createAssociation(umlClass, dummyClass, ASSOCIATION_NAME, PROPERTY_NAME, "test")
		return prop
	}
	
	override protected prepareValueDescriptor(IUmlDescriptorFactory factory, Property object) {
		val classDescriptor = (factory.createSingleVariableDescriptorBuilder => [
			it.isExistingVariable = true
			it.name = VARIABLE_NAME
			it.type = umlClass
		]).build
		val descriptor = (factory.createPropertyReadBuilder => [
			it.property = object
			it.variable = classDescriptor
		]).build
		return descriptor
	}
	
	override protected assertResult(Property object, PropertyReadDescriptor descriptor) {
		assertTrue('''Descriptor's value type should be «EXPECTED_TYPE» instead of «descriptor.fullType».''', 
					descriptor.fullType==EXPECTED_TYPE)
		assertTrue('''Descriptor's string representation should be «EXPECTED_REPRESENTATION» instead of «descriptor.stringRepresentation».''',
					descriptor.stringRepresentation==EXPECTED_REPRESENTATION
		)
	}
}