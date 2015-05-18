package com.incquerylabs.emdw.cpp.codegeneration.templates

import org.eclipse.papyrusrt.xtumlrt.common.Transition
import org.eclipse.papyrusrt.xtumlrt.common.Trigger
import org.eclipse.papyrusrt.xtumlrt.xtuml.XTEventTrigger
import org.eclipse.incquery.runtime.api.IncQueryEngine
import com.incquerylabs.emdw.cpp.codegeneration.queries.CppCodeGenerationQueries

class TransitionTemplates {
	
	val codeGenQueries = CppCodeGenerationQueries.instance
	
	// TODO @Inject
	val generateTracingCode = CPPTemplates.GENERATE_TRACING_CODE
	val ActionCodeTemplates actionCodeTemplates
	val IncQueryEngine engine
	
	new(IncQueryEngine engine) {
		this.engine = engine
		actionCodeTemplates = new ActionCodeTemplates(engine)
	}
	
	def generatedTransitionCondition(Transition transition, String cppClassName, String stateCppName, String target) {
		var condition = transition.generateEventMatchingCondition(cppClassName)
		val guardCall = '''evaluate_guard_on_«transition.name»_transition_from_«stateCppName»_to_«target»(event_id, event_content)'''
		if(condition.length > 0 && transition.guard != null){
			condition = condition + " && "
		}
		if(transition.guard != null){
			condition = condition + guardCall
		}
		condition
	}
	
	def generateEventMatchingCondition(Transition transition, String cppClassName) {
		val triggers = transition.triggers
		if(triggers.empty) {
			''''''
		} else if(triggers.size == 1){
			'''event_id == «cppClassName»_EVENT_«triggers.head.getEventId»'''
		} else {
			'''
			(«FOR trigger : triggers SEPARATOR " || "»event_id == «trigger.getEventId»«ENDFOR»)'''
		}
	}
	
	def getEventId(Trigger trigger) {
		val xttrigger = trigger as XTEventTrigger
		xttrigger.signal.name
	}
	
}