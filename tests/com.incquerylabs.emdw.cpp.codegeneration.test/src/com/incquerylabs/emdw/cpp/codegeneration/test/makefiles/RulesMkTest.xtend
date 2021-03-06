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
package com.incquerylabs.emdw.cpp.codegeneration.test.makefiles

import com.ericsson.xtumlrt.oopl.cppmodel.CPPComponent
import com.ericsson.xtumlrt.oopl.cppmodel.CPPModel
import com.ericsson.xtumlrt.oopl.cppmodel.CPPPackage
import org.eclipse.papyrusrt.xtumlrt.common.State
import org.junit.runner.RunWith
import org.junit.runners.Suite
import org.junit.runners.Suite.SuiteClasses

import static org.junit.Assert.*

@SuiteClasses(#[
	ComponentRulesMkTest,
	PackageRulesMkTest
])
@RunWith(Suite)
class RulesMkTestSuite {}

class ComponentRulesMkTest extends MakeBaseTest<State, CPPModel> {
	
	override protected prepareCppModel(CPPModel cppModel) {
		val xtmodel = cppModel.commonModel
		val xtPackage = xtmodel.createPackage("RootPackage")
		val xtComponent = xtPackage.createXtComponent("Component")
		val xtClass = xtComponent.createXtClass("TEST_CLASS")
		
		val cppPackage = cppModel.createCPPPackage(xtPackage)
		val cppComponent = cppPackage.createCPPComponentWithDirectoriesAndFiles(xtComponent)
		val cppClassHeader = cppComponent.headerDirectory.createCPPHeaderFile
		val cppClassBody = cppComponent.bodyDirectory.createCPPBodyFile
		cppComponent.createCPPClass(xtClass, cppClassHeader, cppClassBody)
		
		cppModel
	}
	
	override protected assertResult(CPPModel result, CPPModel cppObject) {
		val cppPackage = cppObject.subElements.get(0) as CPPPackage
		assertNotNull(cppPackage)
		val cppComponent = cppPackage.subElements.get(0) as CPPComponent
		assertNotNull(cppComponent)
		val headerDir = cppComponent.headerDirectory
		val rules = rules.get(headerDir.makeRulesFile)
		assertNotNull(rules)
		assertTrue(rules.toString.contains("sp	:= $(basename $(sp))"))
		assertFalse(rules.toString.contains("dir := 	$(d)/"))
	}
	
}

class PackageRulesMkTest extends MakeBaseTest<State, CPPModel> {
	
	override protected prepareCppModel(CPPModel cppModel) {
		val xtmodel = cppModel.commonModel
		val xtPackage = xtmodel.createPackage("RootPackage")
		val xtComponent = xtPackage.createXtComponent("Component")
		val xtInnerPackage = xtComponent.createPackage("InnerPack")
		val xtClass = xtInnerPackage.createXtClass("TEST_CLASS")
		
		val cppPackage = cppModel.createCPPPackage(xtPackage)
		val cppComponent = cppPackage.createCPPComponentWithDirectoriesAndFiles(xtComponent)
		val cppPackageHeader = cppComponent.headerDirectory.createCPPHeaderFile
		val cppPackageBody = cppComponent.bodyDirectory.createCPPBodyFile
		val cppInnerPackage = cppComponent.createCPPPackage(xtInnerPackage, cppPackageHeader, cppPackageBody)
		val cppClassHeader = cppInnerPackage.headerDir.createCPPHeaderFile
		val cppClassBody = cppInnerPackage.bodyDir.createCPPBodyFile
		cppInnerPackage.createCPPClass(xtClass, cppClassHeader, cppClassBody)
		
		cppModel
	}
	
	override protected assertResult(CPPModel result, CPPModel cppObject) {
		val cppPackage = cppObject.subElements.get(0) as CPPPackage
		assertNotNull(cppPackage)
		
		val cppComponent = cppPackage.subElements.get(0) as CPPComponent
		assertNotNull(cppComponent)
		
		val headerDir = cppComponent.headerDirectory
		val cppComponentRules = rules.get(headerDir.makeRulesFile)
		assertNotNull(cppComponentRules)
		assertTrue(cppComponentRules.toString.contains("sp	:= $(basename $(sp))"))
		assertTrue(cppComponentRules.toString.contains("dir := 	$(d)/InnerPack"))
		
		val cppInnerPackage = cppComponent.subElements.get(0) as CPPPackage
		val cppInnerPackageheaderDir = cppInnerPackage.headerDir
		val cppInnerPackageRules = rules.get(cppInnerPackageheaderDir.makeRulesFile)
		assertNotNull(cppInnerPackageRules)
		assertTrue(cppInnerPackageRules.toString.contains("sp	:= $(basename $(sp))"))
		assertFalse(cppInnerPackageRules.toString.contains("dir := 	$(d)/"))
	}
	
}