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
package com.incquerylabs.emdw.cpp.common.descriptor.builder.impl

import com.incquerylabs.emdw.cpp.common.TypeConverter
import com.incquerylabs.emdw.cpp.common.descriptor.builder.IOoplForeachBuilder
import com.incquerylabs.emdw.cpp.common.mapper.XtumlToOoplMapper
import com.incquerylabs.emdw.valuedescriptor.ValueDescriptor
import com.incquerylabs.emdw.valuedescriptor.ValuedescriptorFactory
import org.apache.log4j.Logger
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine

class CppForeachBuilder implements IOoplForeachBuilder {
	extension Logger logger = Logger.getLogger(class)
	protected static extension ValuedescriptorFactory factory = ValuedescriptorFactory.eINSTANCE
	
	private TypeConverter converter
	private XtumlToOoplMapper mapper
	
	private ValueDescriptor collection
	private ValueDescriptor variable
	
	new(AdvancedIncQueryEngine engine) {
		mapper = new XtumlToOoplMapper(engine)
		converter = new TypeConverter
	}
	
	override build() {
		trace('''Started building''')
		val voidTypeString = converter.convertToType(mapper.findBasicType("void"))
		val ocd = factory.createOperationCallDescriptor => [
					it.baseType = voidTypeString
					it.fullType = it.baseType
					it.stringRepresentation = '''for(«variable.fullType» «variable.stringRepresentation» : «collection.stringRepresentation»)'''
				]
		trace('''Finished building''')
		return ocd
	}
	
	override setCollectionDescriptor(ValueDescriptor collection) {
		this.collection = collection
		return this
	}
	
	override setVariableDescriptor(ValueDescriptor variable) {
		this.variable = variable
		return this
	}
	
}