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

import com.ericsson.xtumlrt.oopl.cppmodel.CPPClass
import com.ericsson.xtumlrt.oopl.cppmodel.CPPClassReferenceStorage
import com.incquerylabs.emdw.cpp.common.TypeConverter
import com.incquerylabs.emdw.cpp.common.descriptor.builder.IOoplInstancesBuilder
import com.incquerylabs.emdw.cpp.common.mapper.XtumlToOoplMapper
import com.incquerylabs.emdw.valuedescriptor.ValuedescriptorFactory
import org.apache.log4j.Logger
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.papyrusrt.xtumlrt.xtuml.XTClass

class CppInstancesBuilder implements IOoplInstancesBuilder {
	extension Logger logger = Logger.getLogger(class)
	protected static extension ValuedescriptorFactory factory = ValuedescriptorFactory.eINSTANCE
	extension TypeConverter typeConverter
	
	private XtumlToOoplMapper mapper
	
	private XTClass xtClass
	
	new(AdvancedIncQueryEngine engine) {
		mapper = new XtumlToOoplMapper(engine)
		typeConverter = new TypeConverter
	}
	
	override build() {
		trace('''Started building''')
		val cppClass = mapper.convertType(xtClass) as CPPClass
		trace('''Resolved class: «cppClass.cppQualifiedName»''')
		val instances = cppClass.referenceStorage.head as CPPClassReferenceStorage
		val cvd = factory.createCollectionVariableDescriptor => [
			it.stringRepresentation = instances.cppQualifiedName
			it.baseType = instances.type.convertToBaseType
			it.fullType = instances.type.convertToType
		]
		trace('''Finished building''')
		return cvd
	}
	
	override setOoplClass(XTClass xtClass) {
		this.xtClass = xtClass
		return this
	}
	
}