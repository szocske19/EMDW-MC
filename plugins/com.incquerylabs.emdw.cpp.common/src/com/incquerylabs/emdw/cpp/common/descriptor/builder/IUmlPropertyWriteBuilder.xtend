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
package com.incquerylabs.emdw.cpp.common.descriptor.builder

import com.incquerylabs.emdw.valuedescriptor.PropertyWriteDescriptor
import com.incquerylabs.emdw.valuedescriptor.ValueDescriptor
import org.eclipse.uml2.uml.Property
import com.incquerylabs.emdw.cpp.common.descriptor.builder.IValueDescriptorBuilder

interface IUmlPropertyWriteBuilder extends IValueDescriptorBuilder<PropertyWriteDescriptor> {
	
	def IUmlPropertyWriteBuilder setVariable(ValueDescriptor variable)
	
	def IUmlPropertyWriteBuilder setProperty(Property property)
	
	def IUmlPropertyWriteBuilder setNewValue(ValueDescriptor newValue)
}