package com.incquerylabs.emdw.umlintegration.rules

import com.incquerylabs.emdw.umlintegration.queries.OperationMatch
import com.incquerylabs.emdw.umlintegration.util.ModelUtil
import com.incquerylabs.emdw.umlintegration.util.TransformationUtil
import org.eclipse.papyrusrt.xtumlrt.common.Entity
import org.eclipse.papyrusrt.xtumlrt.common.Operation
import org.eclipse.papyrusrt.xtumlrt.common.Type
import java.util.Set
import org.eclipse.incquery.runtime.api.IncQueryEngine
import com.incquerylabs.emdw.umlintegration.TransformationQrt

class OperationRules{
	static def Set<AbstractMapping<?>> getRules(IncQueryEngine engine) {
		#{
			new OperationMapping(engine)
		}
	}
}

/**
 * Transforms Operations which are a Class's or Component's owned operations to the transformed Entity's operations.
 * Transformed fields: body, static, visibility.
 */
class OperationMapping extends AbstractObjectMapping<OperationMatch, org.eclipse.uml2.uml.Operation, Operation> {

	new(IncQueryEngine engine) {
		super(engine)
	}

	override getXtumlrtClass() {
		Operation
	}
	
	public static val PRIORITY = CommonPriorities.TYPE_MAPPING_PRIORITY + 1

	override getRulePriority() {
		PRIORITY
	}

	override getQuerySpecification() {
		operation
	}

	override getUmlObject(OperationMatch match) {
		match.operation
	}

	override createXtumlrtObject() {
		commonFactory.createOperation => [
			body = commonFactory.createActionCode
		]
	}

	override updateXtumlrtObject(Operation xtumlrtObject, OperationMatch match) {
		val umlObject = match.umlObject
		xtumlrtObject.body.source = ModelUtil.getCppCode(umlObject)
		val voidDummyTypeMatcher = structurePatterns.getNamedDataType(engine)
		val voidDummyType = voidDummyTypeMatcher.getAllValuesOfdataType(TransformationQrt.dummyVoidTypeName).head
		
		// Null types in UML are mapped to void types in xtUML!
		// A dummy void type is used to handle this in the trace model.
		var typeToConvert = umlObject.type
		if (typeToConvert == null) {
			 typeToConvert = voidDummyType
		}
		switch xtType : engine.trace.getAllValuesOfxtumlrtElement(null, null, typeToConvert).head {
			Type: xtumlrtObject.returnType = commonFactory.createTypedMultiplicityElement => [
				type = xtType 
			]
		}
		
		xtumlrtObject.static = umlObject.static
		xtumlrtObject.visibility = TransformationUtil.transform(umlObject.visibility)
	}
	
	def getXtumlrtContainer(OperationMatch match) {
		match.umlClass.findXtumlrtObject(Entity)
	}

	override protected insertXtumlrtObject(Operation xtumlrtObject, OperationMatch match) {
		match.xtumlrtContainer.operations += xtumlrtObject
	}

}