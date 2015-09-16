package com.incquerylabs.emdw.cpp.common.descriptor.builder.impl

import com.incquerylabs.emdw.valuedescriptor.ValuedescriptorFactory
import com.incquerylabs.emdw.cpp.common.mapper.XtumlToOoplMapper
import com.incquerylabs.emdw.cpp.common.TypeConverter
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import com.ericsson.xtumlrt.oopl.cppmodel.CPPReturnValue
import org.eclipse.papyrusrt.xtumlrt.common.Operation
import com.incquerylabs.emdw.valuedescriptor.ValueDescriptor
import com.ericsson.xtumlrt.oopl.cppmodel.CPPSequence
import com.ericsson.xtumlrt.oopl.cppmodel.CPPOperation
import java.util.List

abstract class AbstractCppOperationCallDescriptorBuilder {
	protected static extension ValuedescriptorFactory factory = ValuedescriptorFactory.eINSTANCE
	
	protected XtumlToOoplMapper mapper
	protected TypeConverter converter
	protected CPPOperation cppOperation
	protected List<ValueDescriptor> params
	
	new(AdvancedIncQueryEngine engine) {
		mapper = new XtumlToOoplMapper(engine)
		converter = new TypeConverter
	}
	
	def prepareOperationCallDescriptor(Operation operation, ValueDescriptor... params) {
		cppOperation = mapper.convertOperation(operation)
		val retType = cppOperation.subElements.filter(CPPReturnValue).head
		var baseType = retType.type
		if(baseType instanceof CPPSequence) {
			baseType = baseType.elementType
		}
		val baseTypeFinal = baseType
		val ocd = factory.createOperationCallDescriptor => [
			it.baseType = converter.convertType(baseTypeFinal)
			it.fullType = converter.convertType(retType)
		]
		return ocd
	}
	
	def getParameterList() '''«IF params!=null»«FOR param : params SEPARATOR ", "»«param.stringRepresentation»«ENDFOR»«ENDIF»'''
}