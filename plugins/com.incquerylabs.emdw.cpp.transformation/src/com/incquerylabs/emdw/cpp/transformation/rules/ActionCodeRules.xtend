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
package com.incquerylabs.emdw.cpp.transformation.rules

import com.incquerylabs.emdw.cpp.bodyconverter.scoping.BasicUMLContextProvider
import com.incquerylabs.emdw.cpp.bodyconverter.transformation.impl.BodyConverter
import com.incquerylabs.emdw.cpp.transformation.queries.XtumlQueries
import org.apache.log4j.Logger
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.viatra.emf.runtime.rules.BatchTransformationRuleGroup
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationRuleFactory
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationStatements
import org.eclipse.viatra.emf.runtime.transformation.batch.BatchTransformation
import org.eclipse.xtend.lib.annotations.Accessors

class ActionCodeRules {
	private static val RETHROW_EXCEPTIONS = false
	static extension val XtumlQueries xtUmlQueries = XtumlQueries.instance
	
	extension val Logger logger = Logger.getLogger(class)
	extension val BatchTransformationRuleFactory factory = new BatchTransformationRuleFactory
	extension val BatchTransformationStatements statements
	extension val BodyConverter converter
	val BasicUMLContextProvider context
	
	new(BatchTransformationStatements statements, AdvancedIncQueryEngine engine) {
		this.statements = statements
		this.converter = new BodyConverter
		this.context = new BasicUMLContextProvider(engine)
		converter.initialize(engine, context)
	}
	
	def addRules(BatchTransformation transformation){
		val rules = new BatchTransformationRuleGroup(
			operationActionCodeRule,
			stateEntryActionCodeRule,
			stateExitActionCodeRule,
			transitionActionCodeRule,
			guardActionCodeRule
		)
		transformation.addRules(rules)
	}
	
	@Accessors(PUBLIC_GETTER)
	val operationActionCodeRule = createRule.precondition(cppOperationWithActionCodes).action [ match |
		val cppOperation = match.cppOperation
		val commonOperation = cppOperation.commonOperation
		try{
			cppOperation.compiledBody = commonOperation.convertOperation
			logResult('''Converted Operation «cppOperation.cppName»'s code''')
		} catch (Exception e) {
			e.rethrowOrLogException('''ERROR in Operation «cppOperation.cppName»'s code''')
		}
	].build
	
	@Accessors(PUBLIC_GETTER)
	val stateEntryActionCodeRule = createRule.precondition(cppStateWithEntryActionCodes).action[ match |
		val cppState = match.cppState
		val commonState = cppState.commonState
		try{
			cppState.compiledEntryBody = commonState.convertStateEntry
			logResult('''Converted State «cppState.cppName»'s entry code''')
		} catch (Exception e) {
			e.rethrowOrLogException('''ERROR in State «cppState.cppName»'s entry code''')
		}
	].build
	
	@Accessors(PUBLIC_GETTER)
	val stateExitActionCodeRule = createRule.precondition(cppStateWithExitActionCodes).action[ match |
		val cppState = match.cppState
		val commonState = cppState.commonState
		try{
			cppState.compiledExitBody = commonState.convertStateExit
			logResult('''Converted State «cppState.cppName»'s exit code''')
		} catch (Exception e) {
			e.rethrowOrLogException('''ERROR in State «cppState.cppName»'s exit code''')
		}
	].build
	
	@Accessors(PUBLIC_GETTER)
	val transitionActionCodeRule = createRule.precondition(cppTransitionWithActionCodes).action[ match |
		val cppTransition = match.cppTransition
		val commonTransition = cppTransition.commonTransition
		try{
			cppTransition.compiledEffectBody = commonTransition.convertTransition
			logResult('''Converted Transition «cppTransition.cppName»'s code''')
		} catch (Exception e) {
			e.rethrowOrLogException('''ERROR in Transition «cppTransition.cppName»'s code''')
		}
	].build
	
	@Accessors(PUBLIC_GETTER)
	val guardActionCodeRule = createRule.precondition(cppTransitionWithGuardActionCodes).action[ match |
		val cppTransition = match.cppTransition
		val commonTransition = cppTransition.commonTransition
		try{
			cppTransition.compiledGuardBody = commonTransition.convertTransitionGuard
			logResult('''Converted Transition «cppTransition.cppName»'s guard code''')
		} catch (Exception e) {
			e.rethrowOrLogException('''ERROR in Transition «cppTransition.cppName»'s guard code''')
		}
	].build
	
	private def rethrowOrLogException(Exception e, String errorMessage) {
		if(RETHROW_EXCEPTIONS){
			throw e;
		} else {
			error(errorMessage, e)
		}
	}
	
	private def logResult(String message){
		debug('''«message»''')
	}
}
