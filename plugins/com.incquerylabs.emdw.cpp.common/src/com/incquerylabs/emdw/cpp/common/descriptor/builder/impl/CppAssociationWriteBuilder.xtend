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

import com.ericsson.xtumlrt.oopl.OOPLClassReferenceCollection
import com.ericsson.xtumlrt.oopl.cppmodel.CPPQualifiedNamedElement
import com.incquerylabs.emdw.cpp.common.TypeConverter
import com.incquerylabs.emdw.cpp.common.descriptor.builder.IOoplAssociationWriteBuilder
import com.incquerylabs.emdw.cpp.common.mapper.XtumlToOoplMapper
import com.incquerylabs.emdw.valuedescriptor.ValueDescriptor
import com.incquerylabs.emdw.valuedescriptor.ValuedescriptorFactory
import org.apache.log4j.Logger
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.papyrusrt.xtumlrt.xtuml.XTAssociation

class CppAssociationWriteBuilder implements IOoplAssociationWriteBuilder {
	extension Logger logger = Logger.getLogger(class)
	protected static extension ValuedescriptorFactory factory = ValuedescriptorFactory.eINSTANCE
	
	private XtumlToOoplMapper mapper
	private TypeConverter converter
	
	private ValueDescriptor variable
	private XTAssociation association
	private ValueDescriptor newValue
	
	
	new(AdvancedIncQueryEngine engine) {
		mapper = new XtumlToOoplMapper(engine)
		converter = new TypeConverter
	}
	
	
	override build() {
		trace('''Started building''')
		val cppAssociation = mapper.convertAssociation(association)
		if(cppAssociation instanceof CPPQualifiedNamedElement) {
			trace('''Resolved cpp association: «cppAssociation.cppQualifiedName»''')
			val refStorage = cppAssociation.referenceStorage.head
			val type = refStorage.type
			val svd = factory.createPropertyWriteDescriptor => [
				it.baseType = converter.convertToBaseType(type)
				it.fullType = converter.convertToType(type)
				it.stringRepresentation = '''«variable.stringRepresentation»->«cppAssociation.cppName» = «newValue.pointerRepresentation»'''
			]
			if(type instanceof OOPLClassReferenceCollection) {
				svd.templateTypes.add(converter.convertToType(type.ooplClass))
			}
			refStorage.required = true
			trace('''Finished building''')
			return svd
		}
		trace('''No cpp association for «association.name»''')
		throw new IllegalArgumentException('''«association» has no cpp pair.''')
	}
	
	override setVariable(ValueDescriptor variable) {
		this.variable = variable
		return this
	}
	
	override setAssociation(XTAssociation association) {
		this.association = association
		return this
	}
	
	override setNewValue(ValueDescriptor newValue) {
		this.newValue = newValue
		return this
	}
	
}