package com.incquerylabs.emdw.cpp.transformation.test.mappings

import com.ericsson.xtumlrt.oopl.cppmodel.CPPComponent
import com.ericsson.xtumlrt.oopl.cppmodel.CPPDirectory
import com.ericsson.xtumlrt.oopl.cppmodel.CPPModel
import com.ericsson.xtumlrt.oopl.cppmodel.CPPPort
import com.incquerylabs.emdw.cpp.transformation.test.wrappers.TransformationWrapper
import org.eclipse.papyrusrt.xtumlrt.common.Model
import org.eclipse.papyrusrt.xtumlrt.common.VisibilityKind
import org.eclipse.papyrusrt.xtumlrt.xtuml.XTComponent
import org.eclipse.papyrusrt.xtumlrt.xtuml.XTPackage
import org.eclipse.papyrusrt.xtumlrt.xtuml.XTProtocol
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import static org.junit.Assert.*

import static extension com.incquerylabs.emdw.cpp.transformation.test.TransformationTestUtil.*

@RunWith(Parameterized)
class CPPPortMappingTest extends MappingBaseTest<XTComponent, CPPComponent> {
	CPPDirectory rootDir;
	
	new(TransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}
	
	override protected prepareXtUmlModel(Model model) {
		val pack = model.createXtPackage("RootPackage")
		val component = pack.createXtComponent("Component")
		val protocol = pack.createXtProtocol("Protocol")
		component.createPort(protocol, "Port", VisibilityKind.PUBLIC)
		
		component
	}
		
	override protected prepareCppModel(CPPModel cppModel) {
		val res = cppModel.eResource
		rootDir = res.createCPPDirectory
		val xtmodel = cppModel.commonModel
		val xtPackage = xtmodel.rootPackages.head as XTPackage
		val cppPackage = createCPPPackage(cppModel, xtPackage)
		val xtComponent = xtPackage.entities.head as XTComponent
		val cppComponent = createCPPComponent(cppPackage, xtComponent, null, null, null, null)
		val xtProt = xtPackage.protocols.head as XTProtocol
		createCPPProtocol(cppPackage,xtProt, null)
		
		cppComponent
	}
	
	override protected assertResult(Model input, CPPModel result, XTComponent xtObject, CPPComponent cppObject) {
		val xtPorts = xtObject.ports
		val cppPorts = cppObject.subElements.filter(CPPPort)
		assertEquals(xtPorts.size,cppPorts.size)
		assertEquals(xtPorts.size,rootDir.countCppHeaderFiles)
		assertEquals(xtPorts.size,rootDir.countCppBodyFiles)
		cppPorts.forEach[
			assertNotNull(ooplNameProvider)
			assertNotNull(xtPort)
			assertNotNull(headerFile)
			assertNotNull(bodyFile)
		]
	}
	
	override protected clearXtUmlElement(XTComponent xtObject) {
		xtObject.ports.clear
	}
	
	override protected assertClear(Model input, CPPModel result, XTComponent xtObject, CPPComponent cppObject) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
}
