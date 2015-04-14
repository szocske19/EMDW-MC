package com.incquerylabs.emdw.umlintegration.rules

import com.incquerylabs.emdw.umlintegration.queries.ChildCompositeStateMatch
import com.incquerylabs.emdw.umlintegration.queries.CompositeStateMatch
import com.incquerylabs.emdw.umlintegration.queries.ToplevelCompositeStateMatch
import com.incquerylabs.emdw.umlintegration.util.TransformationUtil
import com.zeligsoft.xtumlrt.common.CompositeState
import com.zeligsoft.xtumlrt.common.State
import com.zeligsoft.xtumlrt.common.StateMachine
import java.util.Set
import org.eclipse.incquery.runtime.api.IncQueryEngine

class CompositeStateRules{
	static def Set<AbstractMapping<?>> getRules(IncQueryEngine engine) {
		#{
			new CompositeStateMapping(engine),
			new ToplevelCompositeStateMapping(engine),
			new ChildCompositeStateMapping(engine)
		}
	}
}

class CompositeStateMapping extends AbstractObjectMapping<CompositeStateMatch, org.eclipse.uml2.uml.State, CompositeState> {

	new(IncQueryEngine engine) {
		super(engine)
	}

	override getXtumlrtClass() {
		CompositeState
	}
	
	override getRulePriority() {
		CommonPriorities.VERTEX_MAPPING_PRIORITY
	}

	override getQuerySpecification() {
		compositeState
	}

	override getUmlObject(CompositeStateMatch match) {
		match.state
	}

	override createXtumlrtObject() {
		commonFactory.createCompositeState
	}

	override updateXtumlrtObject(CompositeState xtumlrtObject, CompositeStateMatch match) {
		TransformationUtil.updateState(xtumlrtObject, match.state)
	}
	
	override insertXtumlrtObject(CompositeState xtumlrtObject, CompositeStateMatch match) {
	}

}


class ToplevelCompositeStateMapping extends AbstractContainmentMapping<ToplevelCompositeStateMatch, StateMachine, State> {

	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getRulePriority() {
		Math.max(StateMachineMapping.PRIORITY, CommonPriorities.VERTEX_MAPPING_PRIORITY) + 1
	}

	override getQuerySpecification() {
		toplevelCompositeState
	}

	override findParent(ToplevelCompositeStateMatch match) {
		match.stateMachine.findXtumlrtObject(StateMachine)
	}
	
	override findChild(ToplevelCompositeStateMatch match) {
		match.state.findXtumlrtObject(State)
	}
	
	override insertChild(StateMachine parent, State child) {
		parent.top.substates += child
	}

}

class ChildCompositeStateMapping extends AbstractContainmentMapping<ChildCompositeStateMatch, CompositeState, State> {

	new(IncQueryEngine engine) {
		super(engine)
	}
	
	override getRulePriority() {
		CommonPriorities.VERTEX_MAPPING_PRIORITY + 1
	}

	override getQuerySpecification() {
		childCompositeState
	}

	override findParent(ChildCompositeStateMatch match) {
		match.parentState.findXtumlrtObject(CompositeState)
	}
	
	override findChild(ChildCompositeStateMatch match) {
		match.state.findXtumlrtObject(State)
	}
	
	override insertChild(CompositeState parent, State child) {
		parent.substates += child
	}

}