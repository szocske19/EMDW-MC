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
package com.incquerylabs.emdw.cpp.codegeneration.test.mappings

import com.ericsson.xtumlrt.oopl.SimpleCollectionKind
import com.ericsson.xtumlrt.oopl.cppmodel.CPPClass
import com.ericsson.xtumlrt.oopl.cppmodel.CPPModel
import com.incquerylabs.emdw.cpp.codegeneration.test.TransformationTest
import org.eclipse.papyrusrt.xtumlrt.common.State
import org.junit.runner.RunWith
import org.junit.runners.Suite
import org.junit.runners.Suite.SuiteClasses

import static org.junit.Assert.*

@SuiteClasses(#[
	AssociationMappingTest,
	AssociationCollectionMappingTest
])
@RunWith(Suite)
class AssociationMappingTestSuite {}

class AssociationMappingTest extends TransformationTest<State, CPPClass> {
	
	override protected prepareCppModel(CPPModel cppModel) {
		val xtmodel = cppModel.commonModel
		val xtPackage = xtmodel.createPackage("RootPackage")
		val xtComponent = xtPackage.createXtComponent("Component")
		val xtClass1 = xtComponent.createXtClass("TEST1")
		val xtClass2 = xtComponent.createXtClass("TEST2")
		val xtAssoc1 = xtClass1.createBidirectionalAssociation(xtClass2, "test2", "test1")
		val xtAssoc2 = xtAssoc1.opposite
		
		val cppPackage = createCPPPackage(cppModel, xtPackage)
		val cppComponent = createCPPComponentWithDirectoriesAndFiles(cppPackage, xtComponent)
		val cppClass1Header = createCPPHeaderFile(cppComponent.headerDirectory)
		val cppClass1Body = createCPPBodyFile(cppComponent.bodyDirectory)
		val cppClass1 = createCPPClass(cppComponent, xtClass1, cppClass1Header, cppClass1Body)
		val cppClass2Header = createCPPHeaderFile(cppComponent.headerDirectory)
		val cppClass2Body = createCPPBodyFile(cppComponent.bodyDirectory)
		val cppClass2 = createCPPClass(cppComponent, xtClass2, cppClass2Header, cppClass2Body)
		createCPPRelation(cppClass1, xtAssoc1, 
			createCPPClassReferenceStorage(xtAssoc1, 
				createCPPClassReference(xtAssoc1, cppClass2)
			)
		)
		createCPPRelation(cppClass2, xtAssoc2, 
			createCPPClassReferenceStorage(xtAssoc2, 
				createCPPClassReference(xtAssoc2, cppClass1)
			)
		)
		
		cppClass1
	}
	
	override protected assertResult(CPPModel result, CPPClass cppObject) {
		val files = cppCodeGeneration.generatedCPPSourceFiles
		val classHeader = files.get(cppObject.headerFile).toString
		assertTrue(classHeader.contains("TEST2* test2"))
	}
	
}

class AssociationCollectionMappingTest extends TransformationTest<State, CPPClass> {
	
	override protected prepareCppModel(CPPModel cppModel) {
		val xtmodel = cppModel.commonModel
		val xtPackage = xtmodel.createPackage("RootPackage")
		val xtComponent = xtPackage.createXtComponent("Component")
		val xtClass1 = xtComponent.createXtClass("TEST1")
		val xtClass2 = xtComponent.createXtClass("TEST2")
		val xtAssoc1 = xtClass1.createXtAssociation(xtClass2, "test2s", false, false, 1, 2)
		val xtAssoc2 = xtClass2.createXtAssociation(xtClass1, "test1", false, false, 1, 1)
		xtAssoc1.opposite = xtAssoc2
		xtAssoc2.opposite = xtAssoc1
		
		val cppPackage = cppModel.createCPPPackage(xtPackage)
		val cppComponent = cppPackage.createCPPComponentWithDirectoriesAndFiles(xtComponent)
		val cppClass1Header = cppComponent.headerDirectory.createCPPHeaderFile
		val cppClass1Body = cppComponent.bodyDirectory.createCPPBodyFile
		val cppClass1 = cppComponent.createCPPClass(xtClass1, cppClass1Header, cppClass1Body)
		val cppClass2Header = cppComponent.headerDirectory.createCPPHeaderFile
		val cppClass2Body = cppComponent.bodyDirectory.createCPPBodyFile
		val cppClass2 = cppComponent.createCPPClass(xtClass2, cppClass2Header, cppClass2Body)
		createCPPRelation(cppClass1, xtAssoc1, 
			createCPPClassReferenceStorage(xtAssoc1, 
				createCPPClassRefSimpleCollection(xtAssoc1, cppClass2, SimpleCollectionKind.SIMPLY_LINKED_LIST)
			)
		)
		createCPPRelation(cppClass2, xtAssoc2, 
			createCPPClassReferenceStorage(xtAssoc2, 
				createCPPClassReference(xtAssoc2, cppClass1)
			)
		)
		
		cppClass1
	}
	
	override protected assertResult(CPPModel result, CPPClass cppObject) {
		val files = cppCodeGeneration.generatedCPPSourceFiles
		val classHeader = files.get(cppObject.headerFile).toString
		assertTrue(classHeader.contains('''::std::list< ::«testId»::RootPackage::Component::TEST2* > test2s'''))
	}
	
}