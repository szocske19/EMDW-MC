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

import com.incquerylabs.emdw.cpp.common.util.XtTypedValueDescriptor
import com.incquerylabs.emdw.valuedescriptor.OperationCallDescriptor
import com.incquerylabs.emdw.valuedescriptor.ValueDescriptor
import org.eclipse.papyrusrt.xtumlrt.common.Operation

interface IOoplOperationCallBuilder extends IValueDescriptorBuilder<OperationCallDescriptor> {
	
	def IOoplOperationCallBuilder setVariable(ValueDescriptor variable)
	
	def IOoplOperationCallBuilder setOperation(Operation operation)
	
	def IOoplOperationCallBuilder setOperationName(String operationName)
	
	def IOoplOperationCallBuilder setCollectionType(String collectionType)
	
	def IOoplOperationCallBuilder setParameters(XtTypedValueDescriptor<? extends ValueDescriptor>... params)
	
}