package com.incquerylabs.emdw.cpp.transformation.rules

import com.ericsson.xtumlrt.oopl.OoplFactory
import com.ericsson.xtumlrt.oopl.cppmodel.CPPOperation
import com.ericsson.xtumlrt.oopl.cppmodel.CppmodelFactory
import com.incquerylabs.emdw.cpp.transformation.queries.XtumlQueries
import org.apache.log4j.Logger
import org.eclipse.viatra.emf.runtime.rules.BatchTransformationRuleGroup
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationRuleFactory
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationStatements
import org.eclipse.viatra.emf.runtime.transformation.batch.BatchTransformation
import org.eclipse.xtend.lib.annotations.Accessors

class OperationRules {
	static extension val XtumlQueries xtUmlQueries = XtumlQueries.instance
	
	extension val Logger logger = Logger.getLogger(class)
	extension val BatchTransformationRuleFactory factory = new BatchTransformationRuleFactory
	extension val CppmodelFactory cppFactory = CppmodelFactory.eINSTANCE
	extension val OoplFactory ooplFactory = OoplFactory.eINSTANCE
	extension val BatchTransformationStatements statements
	extension val FormalParameterRules formalParameterRules
	
	new(BatchTransformationStatements statements, FormalParameterRules formalParameterRules) {
		this.statements = statements
		this.formalParameterRules = formalParameterRules
	}
	
	def addRules(BatchTransformation transformation){
		val rules = new BatchTransformationRuleGroup(
			entityOperationRule
		)
		transformation.addRules(rules)
	}
	
	@Accessors(PUBLIC_GETTER)
	val entityOperationRule = createRule.precondition(cppEntityOperations).action[ match |
		val cppElement = match.cppElement
		val operation = match.operation
		val cppOperation = createCPPOperation => [
			commonOperation = operation
			ooplNameProvider = createOOPLExistingNameProvider => [ commonNamedElement = operation ]
		]
		cppElement.subElements += cppOperation
		
		trace('''Mapped Operation «operation.name» in entity «match.xtEntity.name» to CPPOperation''')
		transformSubElements(cppOperation)
	].build
	
	def transformSubElements(CPPOperation cppOperation){
		fireAllCurrent(operationParameterRule, [it.cppOperation == cppOperation])
	}
}