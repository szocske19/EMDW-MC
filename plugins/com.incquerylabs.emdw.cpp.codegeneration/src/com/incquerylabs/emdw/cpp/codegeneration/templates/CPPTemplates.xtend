/*******************************************************************************
 * Copyright (c) 2015-2016, IncQuery Labs Ltd. and Ericsson AB
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   Akos Horvath, Abel Hegedus, Zoltan Ujhelyi, Daniel Segesdi, Tamas Borbas, Robert Doczi, Peter Lunk, Istvan Papp - initial API and implementation
 *******************************************************************************/
package com.incquerylabs.emdw.cpp.codegeneration.templates

import com.ericsson.xtumlrt.oopl.cppmodel.CPPClass
import com.ericsson.xtumlrt.oopl.cppmodel.CPPComponent
import com.ericsson.xtumlrt.oopl.cppmodel.CPPPackage
import org.eclipse.incquery.runtime.api.IncQueryEngine
import com.ericsson.xtumlrt.oopl.cppmodel.CPPExternalBridge

class CPPTemplates {
	public static boolean GENERATE_TRACING_CODE = true
	public static boolean USE_CPP11 = true
	
	val NamespaceTemplates namespaceTemplates
	val ClassTemplates classTemplates
	val ComponentTemplates componentTemplates
	val ExternalBridgeTemplates externalBridgeTemplates
	val PackageTemplates packageTemplates
	
	new(IncQueryEngine engine) {
		namespaceTemplates = new NamespaceTemplates
		packageTemplates = new PackageTemplates(engine)
		componentTemplates = new ComponentTemplates(engine)
		classTemplates = new ClassTemplates(engine)
		externalBridgeTemplates = new ExternalBridgeTemplates(engine)
	}
	
	def CharSequence componentDeclHeaderTemplate(CPPComponent cppComponent){
		componentTemplates.componentDeclHeaderTemplate(cppComponent)
	}
	
	def CharSequence componentDefHeaderTemplate(CPPComponent cppComponent){
		componentTemplates.componentDefHeaderTemplate(cppComponent)
	}
	
	def CharSequence componentMainHeaderTemplate(CPPComponent cppComponent){
		componentTemplates.componentMainHeaderTemplate(cppComponent)
	}
	
	def CharSequence componentMainBodyTemplate(CPPComponent cppComponent){
		componentTemplates.componentMainBodyTemplate(cppComponent)
	}
	
	def CharSequence packageMainHeaderTemplate(CPPPackage cppPackage){
		packageTemplates.packageMainHeaderTemplate(cppPackage)
	}
	
	def CharSequence packageMainBodyTemplate(CPPPackage cppPackage){
		packageTemplates.packageMainBodyTemplate(cppPackage)
	}
	
	def classHeaderTemplate(CPPClass cppClass) {
		classTemplates.classHeaderTemplate(cppClass)
	}
	
	def classBodyTemplate(CPPClass cppClass) {
		classTemplates.classBodyTemplate(cppClass)
	}
	
	def externalBridgeHeaderTemplate(CPPExternalBridge externalBridge){
		externalBridgeTemplates.externalBridgeHeaderTemplate(externalBridge)
	}
	
	def externalBridgeBodyTemplate(CPPExternalBridge externalBridge){
		externalBridgeTemplates.externalBridgeBodyTemplate(externalBridge)
	}
	
}
