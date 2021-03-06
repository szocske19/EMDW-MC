/*******************************************************************************
 * Copyright (c) 2015-2016, IncQuery Labs Ltd. and Ericsson AB
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   Akos Horvath, Abel Hegedus, Zoltan Ujhelyi, Daniel Segesdi, Tamas Borbas, Denes Harmath - initial API and implementation
 *******************************************************************************/
package com.incquerylabs.emdw.umlintegration.test

import com.incquerylabs.emdw.toolchain.Toolchain
import com.incquerylabs.emdw.umlintegration.rules.AbstractMapping
import com.incquerylabs.emdw.umlintegration.rules.ActionChainMapping
import com.incquerylabs.emdw.umlintegration.rules.CapsulePartMapping
import com.incquerylabs.emdw.umlintegration.rules.ChoicePointMapping
import com.incquerylabs.emdw.umlintegration.rules.ClassAttributeMapping
import com.incquerylabs.emdw.umlintegration.rules.CompositeStateMapping
import com.incquerylabs.emdw.umlintegration.rules.ConnectorEndMapping
import com.incquerylabs.emdw.umlintegration.rules.ConnectorMapping
import com.incquerylabs.emdw.umlintegration.rules.DeepHistoryMapping
import com.incquerylabs.emdw.umlintegration.rules.EntryPointMapping
import com.incquerylabs.emdw.umlintegration.rules.ExitPointMapping
import com.incquerylabs.emdw.umlintegration.rules.GuardMapping
import com.incquerylabs.emdw.umlintegration.rules.InitialPointMapping
import com.incquerylabs.emdw.umlintegration.rules.JunctionPointMapping
import com.incquerylabs.emdw.umlintegration.rules.OperationMapping
import com.incquerylabs.emdw.umlintegration.rules.ParameterMapping
import com.incquerylabs.emdw.umlintegration.rules.PrimitiveTypeMapping
import com.incquerylabs.emdw.umlintegration.rules.SimpleStateMapping
import com.incquerylabs.emdw.umlintegration.rules.StateMachineMapping
import com.incquerylabs.emdw.umlintegration.rules.StructMemberMapping
import com.incquerylabs.emdw.umlintegration.rules.StructTypeMapping
import com.incquerylabs.emdw.umlintegration.rules.TransitionMapping
import com.incquerylabs.emdw.umlintegration.rules.TypeDefinitionMapping
import com.incquerylabs.emdw.umlintegration.rules.XTAssociationMapping
import com.incquerylabs.emdw.umlintegration.rules.XTClassEventMapping
import com.incquerylabs.emdw.umlintegration.rules.XTClassMapping
import com.incquerylabs.emdw.umlintegration.rules.XTComponentMapping
import com.incquerylabs.emdw.umlintegration.rules.XTEventTriggerMapping
import com.incquerylabs.emdw.umlintegration.rules.XTGeneralizationMapping
import com.incquerylabs.emdw.umlintegration.rules.XTPackageMapping
import com.incquerylabs.emdw.umlintegration.rules.XTPortMapping
import com.incquerylabs.emdw.umlintegration.trace.TraceFactory
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.papyrusrt.xtumlrt.common.CommonFactory
import org.eclipse.uml2.uml.Model
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Suite
import org.junit.runners.Suite.SuiteClasses

import static org.junit.Assert.*

@SuiteClasses(#[
	IntegrationTest
])
@RunWith(Suite)
class IntegrationTestSuite {}

class IntegrationTest {

	static extension val CommonFactory commonFactory = CommonFactory.eINSTANCE
	static extension val TraceFactory traceFactory = TraceFactory.eINSTANCE
	
	@Test
	def gpsWatch() {
		val resourceSet = new ResourceSetImpl
		
		
		val umlResource = resourceSet.createResource(URI.createPlatformPluginURI("/com.incquerylabs.emdw.umlintegration.transformation.test/model/GPSWatch.uml", true)) => [
			load(#{})	
		]
		
		val xtumlrtModel = commonFactory.createModel
		resourceSet.createResource(URI.createURI("dummyXtumlrtUri.xtuml")) => [
			contents += xtumlrtModel
		]
		
		val mapping = createRootMapping => [
			umlRoot = umlResource.contents.filter(Model).head
			xtumlrtRoot = xtumlrtModel
		]
		resourceSet.createResource(URI.createURI("dummyTraceUri.trace")) => [
			contents += mapping
		]
		
		val toolchainBuilder = Toolchain.builder =>[
			it.xumlrtModel = xtumlrtModel
			it.checkNeeded = false
		]
		val toolchain = toolchainBuilder.build
		toolchain.initializeXtTransformation
		toolchain.executeXtTransformation
		
		val rules = getRules(toolchain.engine)
		val umlObjects = rules.map[allUmlObjects].flatten
		umlObjects.forEach[umlObject |
			val trace = mapping.traces.findFirst[umlElements.toSet == #{umlObject}]
			val errorMessage = '''«umlObject» was not transformed'''
			assertNotNull(errorMessage, trace)
			assertFalse(errorMessage, trace.xtumlrtElements.empty)
		]
		
		toolchain.dispose
		toolchain.disposeEngine
		
		val umlRSresources = mapping.eResource.resourceSet.resources
		umlRSresources.forEach[it.unload]
		umlRSresources.clear
	}

	def getRules(AdvancedIncQueryEngine engine) {
		#{
			new XTPackageMapping(engine),
			new XTComponentMapping(engine),
			new XTPortMapping(engine),
			new CapsulePartMapping(engine),
			new ConnectorMapping(engine),
			new ConnectorEndMapping(engine),
			new XTClassMapping(engine),
			new ClassAttributeMapping(engine),
			new OperationMapping(engine),
			new ParameterMapping(engine),
			new XTAssociationMapping(engine),
			new XTGeneralizationMapping(engine),
			new XTClassEventMapping(engine),
// FIXME signal event not correct 
//			new XTSignalEventMapping(engine),
			new TypeDefinitionMapping(engine),
			new PrimitiveTypeMapping(engine),
			new StructTypeMapping(engine),
			new StructMemberMapping(engine),
		
			new StateMachineMapping(engine),
			new InitialPointMapping(engine),
			new ChoicePointMapping(engine),
			new EntryPointMapping(engine),
			new ExitPointMapping(engine),
			new JunctionPointMapping(engine),
			new DeepHistoryMapping(engine),
			new SimpleStateMapping(engine),
			new CompositeStateMapping(engine),
			new TransitionMapping(engine),
			new XTEventTriggerMapping(engine),
			new GuardMapping(engine),
			new ActionChainMapping(engine)
		}
	}

    @BeforeClass
	def static setupRootLogger() {
		Logger.getLogger(AbstractMapping.package.name).level = Level.DEBUG
	}

}