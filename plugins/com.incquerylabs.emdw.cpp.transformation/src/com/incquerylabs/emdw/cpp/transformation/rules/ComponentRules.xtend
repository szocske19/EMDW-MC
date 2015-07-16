package com.incquerylabs.emdw.cpp.transformation.rules

import com.incquerylabs.emdw.cpp.transformation.queries.XtumlQueries
import org.apache.log4j.Logger
import org.eclipse.viatra.emf.runtime.rules.BatchTransformationRuleGroup
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationRuleFactory
import org.eclipse.viatra.emf.runtime.rules.batch.BatchTransformationStatements
import org.eclipse.viatra.emf.runtime.transformation.batch.BatchTransformation
import org.eclipse.xtend.lib.annotations.Accessors

class ComponentRules {
	static extension val XtumlQueries xtUmlQueries = XtumlQueries.instance
	
	extension val Logger logger = Logger.getLogger(class)
	extension BatchTransformationRuleFactory factory = new BatchTransformationRuleFactory
	extension val BatchTransformationStatements statements
	
	val PackageRules packageRules
	val ClassRules classRules
	val AttributeRules attributeRules
	val OperationRules operationRules
	extension val IncludeRules includeRules
	
	new(BatchTransformationStatements statements,
		PackageRules packageRules,
		ClassRules classRules,
		AttributeRules attributeRules,
		OperationRules operationRules,
		IncludeRules includeRules
	) {
		this.statements = statements
		this.packageRules = packageRules
		this.classRules = classRules
		this.attributeRules = attributeRules
		this.operationRules = operationRules
		this.includeRules = includeRules
	}
	
	def addRules(BatchTransformation transformation){
		val rules = new BatchTransformationRuleGroup(
			cleanComponentsRule,
			componentRule
		)
		transformation.addRules(rules)
	}
	
	@Accessors(PUBLIC_GETTER)
	val cleanComponentsRule = createRule.precondition(cppComponents).action[ match |
		val cppComponent = match.cppComponent
		cppComponent.subElements.clear
		val bodyDirectory = cppComponent.bodyDirectory
		if(bodyDirectory != null){
			bodyDirectory.files.clear
			bodyDirectory.subDirectories.clear
		}
		val headerDirectory = cppComponent.headerDirectory
		if(headerDirectory != null){
			headerDirectory.files.clear
			headerDirectory.subDirectories.clear
		}
		if(cppComponent.mainBodyFile != null){
			cppComponent.mainBodyFile.includedHeaders.clear
			bodyDirectory.files += cppComponent.mainBodyFile
		}
		if(cppComponent.mainHeaderFile != null){
			cppComponent.mainHeaderFile.includedHeaders.clear
			headerDirectory.files += cppComponent.mainHeaderFile
		}
		if(cppComponent.declarationHeaderFile != null){
			cppComponent.declarationHeaderFile.includedHeaders.clear
			headerDirectory.files += cppComponent.declarationHeaderFile
		}
		if(cppComponent.definitionHeaderFile != null){
			cppComponent.definitionHeaderFile.includedHeaders.clear
			headerDirectory.files += cppComponent.definitionHeaderFile
		}
		if(cppComponent.headerDirectory.makeRulesFile != null) {
			cppComponent.headerDirectory.files += cppComponent.headerDirectory.makeRulesFile
		}
		if(cppComponent.bodyDirectory != cppComponent.headerDirectory && cppComponent.bodyDirectory.makeRulesFile != null) {
			cppComponent.bodyDirectory.files += cppComponent.bodyDirectory.makeRulesFile
		}
		
		trace('''Cleaned Component «cppComponent.xtComponent.name»''')
	].build
	
	@Accessors(PUBLIC_GETTER)
	val componentRule = createRule.precondition(cppComponents).action[match |
		val cppComponent = match.cppComponent
		cppComponent.addIncludesBetweenOwnFiles
		fireAllCurrent(includeRules.componentRuntimeIncludesRule, [it.cppComponent == cppComponent])
		trace('''Transforming subelements of Component «cppComponent.xtComponent.name»''')
		fireAllCurrent(classRules.classRule, [it.cppComponent == cppComponent])
		fireAllCurrent(attributeRules.entityAttributeRule, [it.cppElement == cppComponent])
		fireAllCurrent(operationRules.entityOperationRule, [it.cppElement == cppComponent])
		fireAllCurrent(packageRules.packageInComponentRule, [it.cppComponent == cppComponent])
	].build
}