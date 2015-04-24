package com.incquerylabs.emdw.xtumltocpp.test.mappings

import com.ericsson.xtumlrt.oopl.cppmodel.CPPClass
import com.ericsson.xtumlrt.oopl.cppmodel.CPPModel
import com.incquerylabs.emdw.xtumltocpp.test.TransformationTest
import com.incquerylabs.emdw.xtumltocpp.test.wrappers.TransformationWrapper
import org.eclipse.papyrusrt.xtumlrt.common.DirectionKind
import org.eclipse.papyrusrt.xtumlrt.common.Model
import org.eclipse.papyrusrt.xtumlrt.common.VisibilityKind
import org.eclipse.papyrusrt.xtumlrt.xtuml.XTClass
import org.eclipse.papyrusrt.xtumlrt.xtuml.XTComponent
import org.eclipse.papyrusrt.xtumlrt.xtuml.XTPackage
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import static extension com.incquerylabs.emdw.xtumltocpp.test.TransformationTestUtil.*

/**
 * Test case which is responsible for checking if the given transformation method is 
 * capable of creating a cpp structure model which can later be used to determine whether
 * the dynamics of constructor methods work properly.
 * 
 * Creates the following xtuml model and initiates the target CPP model based on it.
 * 
 * - Package
 * 	 - Component
 * 		- Port
 * 		- Class
 * 			- a : Attribute with Primitive Type
 * 			- b : Attribute with User Defined Type
 * 			- TestClass(a,b) : Constructor operation with two attributes
 * 			- SignalEvent based on Signal
 * 			- State Machine
 * 				- Region
 * 					- Init state
 * 					- State1
 * 					- State2
 * 					- Transition1 between init and State1
 * 					- Transition2 between State1 and State2 triggered by SignalEvent		
 * 	 - Primitive Type definition
 * 	 - User defined Type definition
 * 	 - Protocol
 * 		- Signal
 */
@RunWith(Parameterized)
class ClassConstructorTest extends TransformationTest<XTClass, CPPClass> {

	new(TransformationWrapper wrapper, String wrapperType) {
		super(wrapper, wrapperType)
	}

	override protected prepareXtUmlModel(Model xtumlmodel) {
		val pack = xtumlmodel.createXtPackage("RootPackage")
		val component = pack.createXtComponent("Component")
		val xtClass = component.createXtClass("TestClass")

		val typedef = pack.createTypeDefinition("IntDefinition")
		val primitiveType = pack.createPrimitiveType(typedef, "Integer")

		val typedef2 = pack.createTypeDefinition("UserTypeDefinition")
		val userDefinedType = pack.createXTUserDefinedType(typedef2, "UserType")

		xtClass.createSingleAttribute(primitiveType, VisibilityKind.PUBLIC, false, "a")
		xtClass.createSingleAttribute(userDefinedType, VisibilityKind.PUBLIC, false, "b")

		xtClass.createOperation(
			VisibilityKind.PUBLIC,
			false,
			null,
			"TestClass()",
			"CONSTRUCTOR_THAT_SETS_ATTRIBUTES",
			primitiveType.createParameter("a", DirectionKind.IN),
			userDefinedType.createParameter("b", DirectionKind.IN)
		)

		val topState = xtClass.createStateMachine("SM").createCompositeState("top")
		val protocol = pack.createXtProtocol("Protocol")
		val signal = protocol.createSignal("Signal")
		val signalEvent = component.createPort(protocol, "Port", VisibilityKind.PUBLIC).
			createXtSignalEvent(signal, xtClass, "SignalEvent")
		val init = topState.createInitialPoint("init")
		val s1 = topState.createSimpleState("s1")
		val s2 = topState.createSimpleState("s2")
		topState.createTransition(init, s1, "t1")
		topState.createTransition(s1, s2, "t2", "SAMPLE_CODE").createXTEventTrigger(signalEvent, "Trigger")

		xtClass
	}

	override protected prepareCppModel(CPPModel cppModel) {
		val xtmodel = cppModel.commonModel
		val xtPackage = xtmodel.rootPackages.head as XTPackage
		val cppPackage = createCPPPackage(cppModel, xtPackage)
		val xtComponent = xtPackage.entities.head as XTComponent
		val cppComponent = createCPPComponent(cppPackage, xtComponent, null, null, null, null)
		val xtClass = xtComponent.ownedClasses.head as XTClass
		val cppClass = createCPPClass(cppComponent, xtClass, null, null)
		
		cppClass
	}

	override protected assertResult(Model input, CPPModel result, XTClass xtObject, CPPClass cppObject) {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}

}