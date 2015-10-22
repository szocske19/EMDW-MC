package com.incquerylabs.emdw.cpp.common.descriptor.builder.impl

import com.incquerylabs.emdw.cpp.common.descriptor.builder.IOoplStaticOperationCallBuilder
import com.incquerylabs.emdw.cpp.common.descriptor.builder.IUmlStaticOperationCallBuilder
import com.incquerylabs.emdw.cpp.common.mapper.UmlToXtumlMapper
import com.incquerylabs.emdw.cpp.common.util.UmlTypedValueDescriptor
import com.incquerylabs.emdw.cpp.common.util.XtTypedValueDescriptor
import com.incquerylabs.emdw.valuedescriptor.ValueDescriptor
import com.incquerylabs.emdw.valuedescriptor.ValuedescriptorFactory
import java.util.List
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.uml2.uml.Operation

class UmlStaticOperationCallBuilder implements IUmlStaticOperationCallBuilder {
	protected static extension ValuedescriptorFactory factory = ValuedescriptorFactory.eINSTANCE
	
	private UmlToXtumlMapper mapper
	private IOoplStaticOperationCallBuilder builder
	
	private Operation operation
	private List<UmlTypedValueDescriptor<? extends ValueDescriptor>> params = #[]
	
	new(AdvancedIncQueryEngine engine) {
		mapper = new UmlToXtumlMapper(engine)
		builder = new CppStaticOperationCallBuilder(engine)
	}
	
	override build() {
		val xtOperation = mapper.convertOperation(operation)
		val xtParams = params.map[new XtTypedValueDescriptor(mapper.convertType(type), descriptor)]
		if(operation.qualifiedName.contains("std::out::println")) {
			return (builder => [
					it.operationName = "println"
					it.parameters = xtParams
				]).build
		}
		if(operation.qualifiedName.contains("std::boolean::toString") ||
			operation.qualifiedName.contains("std::real::toString") ||
			operation.qualifiedName.contains("std::int::toString")
		) {
			return (builder => [
					it.operationName = "toString"
					it.parameters = xtParams
				]).build
		}
		return (builder => [
					it.operation = xtOperation
					it.parameters = xtParams
				]).build
	}
	
	override setOperation(Operation operation) {
		this.operation = operation
		return this
	}
	
	override setParameters(UmlTypedValueDescriptor<? extends ValueDescriptor>... params) {
		this.params = params
		return this
	}
	
}