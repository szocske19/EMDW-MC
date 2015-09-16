package com.incquerylabs.emdw.cpp.common.descriptor.builder.impl

import com.incquerylabs.emdw.cpp.common.descriptor.builder.IOoplOperationCallBuilder
import com.incquerylabs.emdw.valuedescriptor.ValueDescriptor
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.papyrusrt.xtumlrt.common.Operation

class CppOperationCallBuilder extends AbstractCppOperationCallDescriptorBuilder implements IOoplOperationCallBuilder {
	
	private ValueDescriptor variable
	private Operation operation
	
	
	new(AdvancedIncQueryEngine engine) {
		super(engine)
	}
	
	
	override build() {
		val od = prepareOperationCallDescriptor(operation, params)
		if(mapper.isHiddenByChild(operation)) {
			od.stringRepresentation = '''«variable.stringRepresentation»->«cppOperation.cppQualifiedName»(«parameterList»)'''
		} else {
			od.stringRepresentation = '''«variable.stringRepresentation»->«cppOperation.cppName»(«parameterList»)'''
		}
		return od
	}
	
	override setVariable(ValueDescriptor variable) {
		this.variable = variable
		return this
	}
	
	override setOperation(Operation operation) {
		this.operation = operation
		return this
	}
	
	override setParameters(ValueDescriptor... params) {
		this.params = params
		return this
	}
	
}