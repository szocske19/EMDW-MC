package com.incquerylabs.emdw.cpp.common.descriptor.builder.impl

import com.ericsson.xtumlrt.oopl.cppmodel.CPPClass
import com.ericsson.xtumlrt.oopl.cppmodel.CPPClassReferenceStorage
import com.incquerylabs.emdw.cpp.common.TypeConverter
import com.incquerylabs.emdw.cpp.common.descriptor.builder.IOoplInstancesBuilder
import com.incquerylabs.emdw.cpp.common.mapper.XtumlToOoplMapper
import com.incquerylabs.emdw.valuedescriptor.ValuedescriptorFactory
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.papyrusrt.xtumlrt.xtuml.XTClass

class CppInstancesBuilder implements IOoplInstancesBuilder {
	protected static extension ValuedescriptorFactory factory = ValuedescriptorFactory.eINSTANCE
	extension TypeConverter typeConverter
	
	private XtumlToOoplMapper mapper
	
	private XTClass xtClass
	
	new(AdvancedIncQueryEngine engine) {
		mapper = new XtumlToOoplMapper(engine)
		typeConverter = new TypeConverter
	}
	
	override build() {
		val cppClass = mapper.convertType(xtClass) as CPPClass
		val instances = cppClass.referenceStorage.head as CPPClassReferenceStorage
		val cvd = factory.createCollectionVariableDescriptor => [
			it.stringRepresentation = instances.cppQualifiedName
			it.baseType = instances.type.convertToBaseType
			it.fullType = instances.type.convertToType
		]
		return cvd
	}
	
	override setOoplClass(XTClass xtClass) {
		this.xtClass = xtClass
		return this
	}
	
}