package com.incquerylabs.emdw.umlintegration.rules

import com.zeligsoft.xtumlrt.common.InitialPoint
import com.incquerylabs.emdw.umlintegration.queries.InitialStateMatch
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.uml2.uml.Pseudostate
import com.zeligsoft.xtumlrt.common.StateMachine
import com.incquerylabs.emdw.umlintegration.queries.ToplevelInitialStateMatch
import com.zeligsoft.xtumlrt.common.CompositeState
import com.incquerylabs.emdw.umlintegration.queries.ChildInitialStateMatch

class InitialStateRules {
	static def getRules(IncQueryEngine engine) {
		#{
			new InitialStateMapping(engine).specification,
			new ToplevelInitialStateMapping(engine).specification,
			new ChildInitialStateMapping(engine).specification
		}
	}
}

class InitialStateMapping extends AbstractObjectRule<InitialStateMatch, Pseudostate, InitialPoint> {

	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getXtumlrtClass() {
		InitialPoint
	}

	override getRulePriority() {
		5
	}

	override getQuerySpecification() {
		initialState
	}

	override getUmlObject(InitialStateMatch match) {
		match.pseudostate
	}

	override createXtumlrtObject(Pseudostate umlObject, InitialStateMatch match) {
		commonFactory.createInitialPoint
	}

	override updateXtumlrtObject(InitialPoint xtumlrtObject, InitialStateMatch match) {
	}

	override protected insertXtumlrtObject(InitialPoint xtumlrtObject, InitialStateMatch match) {
	}
	
}

class ToplevelInitialStateMapping extends AbstractContainmentRule<ToplevelInitialStateMatch, StateMachine, InitialPoint> {

	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getRulePriority() {
		6
	}

	override getQuerySpecification() {
		toplevelInitialState
	}

	override findParent(ToplevelInitialStateMatch match) {
		engine.trace.getAllValuesOfxtumlrtElement(null, null, match.stateMachine).head as StateMachine
	}
	
	override findChild(ToplevelInitialStateMatch match) {
		engine.trace.getAllValuesOfxtumlrtElement(null, null, match.pseudostate).head as InitialPoint
	}
	
	override insertChild(StateMachine parent, InitialPoint child) {
		parent.top.initial = child
	}

}

class ChildInitialStateMapping extends AbstractContainmentRule<ChildInitialStateMatch, CompositeState, InitialPoint> {

	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getRulePriority() {
		6
	}

	override getQuerySpecification() {
		childInitialState
	}

	override findParent(ChildInitialStateMatch match) {
		engine.trace.getAllValuesOfxtumlrtElement(null, null, match.state).head as CompositeState
	}
	
	override findChild(ChildInitialStateMatch match) {
		engine.trace.getAllValuesOfxtumlrtElement(null, null, match.pseudostate).head as InitialPoint
	}
	
	override insertChild(CompositeState parent, InitialPoint child) {
		parent.initial = child
	}

}