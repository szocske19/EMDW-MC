package com.incquerylabs.emdw.cpp.codegeneration.test.directory

import com.ericsson.xtumlrt.oopl.cppmodel.CPPModel
import com.incquerylabs.emdw.cpp.codegeneration.test.wrappers.TransformationWrapper
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.papyrusrt.xtumlrt.common.Package
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

@RunWith(Parameterized)
class DirectoryStructureTest extends DirectoryStructureBaseTest<Package, CPPModel> {
	
	new(TransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
	override protected CPPModel prepareCPPModelWithURI(URI modelURI) {
		
		val resSet = new ResourceSetImpl();
		val resource = resSet.getResource(modelURI, true)
		resource.contents.get(0) as CPPModel
	}
	
}