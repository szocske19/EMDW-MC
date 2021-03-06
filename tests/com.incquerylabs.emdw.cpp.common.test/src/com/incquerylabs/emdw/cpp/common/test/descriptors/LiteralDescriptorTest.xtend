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
import com.incquerylabs.emdw.cpp.common.test.CachedValueDescriptorBaseTest
import com.incquerylabs.emdw.valuedescriptor.LiteralDescriptor
import org.eclipse.uml2.uml.Model
import org.eclipse.uml2.uml.PrimitiveType
import org.junit.runner.RunWith
import org.junit.runners.Suite
import org.junit.runners.Suite.SuiteClasses

import static org.junit.Assert.*

@SuiteClasses(#[
	LiteralDescriptorForBooleanTest,
	LiteralDescriptorForIntegerTest,
	LiteralDescriptorForRealTest,
	LiteralDescriptorForSimpleStringTest,
	LiteralDescriptorForHeavyStringTest,
	LiteralDescriptorForNumberLiteralCacheTest
])
@RunWith(Suite)
class LiteralDescriptorTestSuite {}

class LiteralDescriptorForBooleanTest extends CachedValueDescriptorBaseTest<PrimitiveType, LiteralDescriptor> {
	private static final String LITERAL = "true"
	
	override protected createUmlObject(Model umlModel) {
		val pT = findPrimitiveType(umlModel, "Boolean")
		return pT
	}
	
	override protected prepareValueDescriptor(IUmlDescriptorFactory factory, PrimitiveType element) {
		val descriptor = (factory.createLiteralDescriptorBuilder => [
			type = element
			literal = LITERAL
		]).build
		return descriptor
	}
	
	override protected assertResult(PrimitiveType object, LiteralDescriptor descriptor) {
		assertTrue("Descriptor's value type should be bool.", descriptor.baseType=="bool")
		assertTrue("Descriptor's string representation should be true.", descriptor.stringRepresentation=="true")
	}
	
	override protected getCachedValueDescriptor(IUmlDescriptorFactory factory, PrimitiveType element) {
		val descriptor = (factory.createLiteralDescriptorBuilder => [
			type = element
			literal = LITERAL
		]).build
		return descriptor
	}
	
	override protected assertResult(LiteralDescriptor originalDescriptor, LiteralDescriptor cachedDescriptor) {
		assertTrue('''Descriptors should be the same but the original is «originalDescriptor» and the cached is «cachedDescriptor».''', 
					originalDescriptor.equals(cachedDescriptor))
	}
	
}

class LiteralDescriptorForIntegerTest extends CachedValueDescriptorBaseTest<PrimitiveType, LiteralDescriptor> {
	private static final String LITERAL = "1"
	
	override protected createUmlObject(Model umlModel) {
		val pT = findPrimitiveType(umlModel, "Integer")
		return pT
	}
	
	override protected prepareValueDescriptor(IUmlDescriptorFactory factory, PrimitiveType element) {
		val descriptor = (factory.createLiteralDescriptorBuilder => [
			type = element
			literal = LITERAL
		]).build
		return descriptor
	}
	
	override protected assertResult(PrimitiveType object, LiteralDescriptor descriptor) {
		assertTrue("Descriptor's value type should be long.", descriptor.baseType=="long")
		assertTrue("Descriptor's string representation should be 1.", descriptor.stringRepresentation=="1")
	}
	
	override protected getCachedValueDescriptor(IUmlDescriptorFactory factory, PrimitiveType element) {
		val descriptor = (factory.createLiteralDescriptorBuilder => [
			type = element
			literal = LITERAL
		]).build
		return descriptor
	}
	
	override protected assertResult(LiteralDescriptor originalDescriptor, LiteralDescriptor cachedDescriptor) {
		assertTrue('''Descriptors should be the same but the original is «originalDescriptor» and the cached is «cachedDescriptor».''', 
					originalDescriptor.equals(cachedDescriptor))
	}
	
}

class LiteralDescriptorForRealTest extends CachedValueDescriptorBaseTest<PrimitiveType, LiteralDescriptor> {
	private static final String LITERAL = "1.1"
	
	override protected createUmlObject(Model umlModel) {
		val pT = findPrimitiveType(umlModel, "Real")
		return pT
	}
	
	override protected prepareValueDescriptor(IUmlDescriptorFactory factory, PrimitiveType element) {
		val descriptor = (factory.createLiteralDescriptorBuilder => [
			type = element
			literal = LITERAL
		]).build
		return descriptor
	}
	
	override protected assertResult(PrimitiveType object, LiteralDescriptor descriptor) {
		assertTrue("Descriptor's value type should be double.", descriptor.baseType=="double")
		assertTrue("Descriptor's string representation should be 1.1.", descriptor.stringRepresentation=="1.1")
	}
	
	override protected getCachedValueDescriptor(IUmlDescriptorFactory factory, PrimitiveType element) {
		val descriptor = (factory.createLiteralDescriptorBuilder => [
			type = element
			literal = LITERAL
		]).build
		return descriptor
	}
	
	override protected assertResult(LiteralDescriptor originalDescriptor, LiteralDescriptor cachedDescriptor) {
		assertTrue('''Descriptors should be the same but the original is «originalDescriptor» and the cached is «cachedDescriptor».''', 
					originalDescriptor.equals(cachedDescriptor))
	}
	
}

class LiteralDescriptorForSimpleStringTest extends CachedValueDescriptorBaseTest<PrimitiveType, LiteralDescriptor> {
	private static final String LITERAL = "simple string"
	
	override protected createUmlObject(Model umlModel) {
		val pT = findPrimitiveType(umlModel, "String")
		return pT
	}
	
	override protected prepareValueDescriptor(IUmlDescriptorFactory factory, PrimitiveType element) {
		val descriptor = (factory.createLiteralDescriptorBuilder => [
			type = element
			literal = LITERAL
		]).build
		return descriptor
	}
	
	override protected assertResult(PrimitiveType object, LiteralDescriptor descriptor) {
		assertTrue("Descriptor's value type should be std::string.", descriptor.baseType=="::std::string")
		assertTrue('''Descriptor's string representation should be "simple string".''', descriptor.stringRepresentation=="simple string")
	}
	
	override protected getCachedValueDescriptor(IUmlDescriptorFactory factory, PrimitiveType element) {
		val descriptor = (factory.createLiteralDescriptorBuilder => [
			type = element
			literal = LITERAL
		]).build
		return descriptor
	}
	
	override protected assertResult(LiteralDescriptor originalDescriptor, LiteralDescriptor cachedDescriptor) {
		assertTrue('''Descriptors should be the same but the original is «originalDescriptor» and the cached is «cachedDescriptor».''', 
					originalDescriptor.equals(cachedDescriptor))
	}
	
}

class LiteralDescriptorForHeavyStringTest extends CachedValueDescriptorBaseTest<PrimitiveType, LiteralDescriptor> {
	private static final String LITERAL = "heavy \" string"
	
	override protected createUmlObject(Model umlModel) {
		val pT = findPrimitiveType(umlModel, "String")
		return pT
	}
	
	override protected prepareValueDescriptor(IUmlDescriptorFactory factory, PrimitiveType element) {
		val descriptor = (factory.createLiteralDescriptorBuilder => [
			type = element
			literal = LITERAL
		]).build
		return descriptor
	}
	
	override protected assertResult(PrimitiveType object, LiteralDescriptor descriptor) {
		assertTrue("Descriptor's value type should be std::string.", descriptor.baseType=="::std::string")
		assertTrue('''Descriptor's string representation should be "heavy \" string".''', descriptor.stringRepresentation=="heavy \" string")
	}
	
	override protected getCachedValueDescriptor(IUmlDescriptorFactory factory, PrimitiveType element) {
		val descriptor = (factory.createLiteralDescriptorBuilder => [
			type = element
			literal = LITERAL
		]).build
		return descriptor
	}
	
	override protected assertResult(LiteralDescriptor originalDescriptor, LiteralDescriptor cachedDescriptor) {
		assertTrue('''Descriptors should be the same but the original is «originalDescriptor» and the cached is «cachedDescriptor».''', 
					originalDescriptor.equals(cachedDescriptor))
	}
	
}

class LiteralDescriptorForNumberLiteralCacheTest extends CachedValueDescriptorBaseTest<PrimitiveType, LiteralDescriptor> {
	private static final String LITERAL = "1"
	private PrimitiveType real
	private LiteralDescriptor realDescriptor
	
	override protected createUmlObject(Model umlModel) {
		val pT = findPrimitiveType(umlModel, "Integer")
		real = findPrimitiveType(umlModel, "Real")
		return pT
	}
	
	override protected prepareValueDescriptor(IUmlDescriptorFactory factory, PrimitiveType element) {
		val svd = (factory.createLiteralDescriptorBuilder => [
			type = element
			literal = LITERAL
		]).build
		realDescriptor = (factory.createLiteralDescriptorBuilder => [
			type = real
			literal = LITERAL
		]).build
		return svd
	}
	
	override protected assertResult(PrimitiveType object, LiteralDescriptor descriptor) {
		assertTrue("Descriptor's value type should be long.", descriptor.baseType=="long")
		assertTrue("Descriptor's string representation should be 1.", descriptor.stringRepresentation=="1")
	}
	
	override protected getCachedValueDescriptor(IUmlDescriptorFactory factory, PrimitiveType element) {
		val descriptor = (factory.createLiteralDescriptorBuilder => [
			type = element
			literal = LITERAL
		]).build
		return descriptor
	}
	
	override protected assertResult(LiteralDescriptor originalDescriptor, LiteralDescriptor cachedDescriptor) {
		assertTrue('''Descriptors should be the same but the original is «originalDescriptor» and the cached is «cachedDescriptor».''', 
					originalDescriptor.equals(cachedDescriptor))
		assertFalse('''Real's descriptor and Integer's descriptor cannot be the same.''', 
					originalDescriptor.equals(realDescriptor))
	}
	
}