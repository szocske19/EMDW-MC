package com.incquerylabs.emdw.cpp.common.builder

import com.incquerylabs.emdw.valuedescriptor.AbstractValueDescriptor

interface IUmlValueDescriptorBuilder<ValueDescriptor extends AbstractValueDescriptor> {
	def ValueDescriptor build()
}