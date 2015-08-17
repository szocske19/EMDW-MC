package com.incquerylabs.emdw.cpp.common.test.descriptors

import com.incquerylabs.emdw.cpp.common.descriptor.factory.IUmlDescriptorFactory
import com.incquerylabs.emdw.cpp.common.test.ValueDescriptorBaseTest
import com.incquerylabs.emdw.cpp.common.test.wrappers.TransformationWrapper
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Model
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.junit.runners.Suite
import org.junit.runners.Suite.SuiteClasses

import static org.junit.Assert.*

import static extension com.incquerylabs.emdw.cpp.common.test.CommonTestUtil.*
import com.incquerylabs.emdw.valuedescriptor.SingleVariableDescriptor

@SuiteClasses(#[
	SingleVariableDescriptorForExistingVariableTest
])
@RunWith(Suite)
class SingleVariableDescriptorForExistingVariableTestSuite {}

@RunWith(Parameterized)
class SingleVariableDescriptorForExistingVariableTest extends ValueDescriptorBaseTest<Class, SingleVariableDescriptor> {
	private static final String VARIABLE_NAME = "classVariable"
	
	new(TransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
	override protected createUmlObject(Model umlModel) {
		val comp = umlModel.createComponent("TestComponent")
		val cl = comp.createClass("TestClass")
		return cl
	}
	
	override protected prepareValueDescriptor(IUmlDescriptorFactory factory, Class element) {
		val descriptor = (factory.createSingleVariableDescriptorBuilder => [
			type = element
			isExistingVariable = true
			name = VARIABLE_NAME
		]).build
		return descriptor
	}
	
	override protected assertResult(Class object, SingleVariableDescriptor descriptor) {
		assertTrue('''Descriptor's value type should be ::test::TestComponent::TestClass instead of «descriptor.baseType».''', 
					descriptor.baseType=="::test::TestComponent::TestClass")
		assertTrue('''Descriptor's string representation should be classVariable.''', 
					descriptor.stringRepresentation=="classVariable")
	}
	
	override protected getCachedValueDescriptor(IUmlDescriptorFactory factory, Class element) {
		val chachedDescriptor = (factory.createSingleVariableDescriptorBuilder => [
			type = element
			isExistingVariable = true
			name = VARIABLE_NAME
		]).build
		return chachedDescriptor
	}
	
	override protected assertResult(SingleVariableDescriptor originalDescriptor, SingleVariableDescriptor cachedDescriptor) {
		assertTrue('''Descriptors should be the same but the original is «originalDescriptor» and the cached is «cachedDescriptor».''', 
					originalDescriptor.equals(cachedDescriptor))
	}
	
}