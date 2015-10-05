package com.incquerylabs.uml.ralf.snippetcompiler

import com.google.common.base.Preconditions
import com.google.common.collect.Lists
import com.incquerylabs.emdw.valuedescriptor.ValueDescriptor
import com.incquerylabs.uml.ralf.ReducedAlfSystem
import com.incquerylabs.uml.ralf.reducedAlfLanguage.ArithmeticExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.AssignmentExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.AssociationAccessExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.BitStringUnaryExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.BlockStatement
import com.incquerylabs.uml.ralf.reducedAlfLanguage.BooleanLiteralExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.BooleanUnaryExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.CastExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.ClassExtentExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.CollectionLiteralExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.CollectionType
import com.incquerylabs.uml.ralf.reducedAlfLanguage.CollectionVariable
import com.incquerylabs.uml.ralf.reducedAlfLanguage.ConditionalLogicalExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.ConditionalTestExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.DoStatement
import com.incquerylabs.uml.ralf.reducedAlfLanguage.ElementCollectionExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.EqualityExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.Expression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.ExpressionList
import com.incquerylabs.uml.ralf.reducedAlfLanguage.ExpressionStatement
import com.incquerylabs.uml.ralf.reducedAlfLanguage.FeatureInvocationExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.FilterExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.ForStatement
import com.incquerylabs.uml.ralf.reducedAlfLanguage.IfClause
import com.incquerylabs.uml.ralf.reducedAlfLanguage.InstanceCreationExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.InstanceDeletionExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.LinkOperationExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.LiteralExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.LocalNameDeclarationStatement
import com.incquerylabs.uml.ralf.reducedAlfLanguage.LogicalExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.NameExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.NamedExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.NamedTuple
import com.incquerylabs.uml.ralf.reducedAlfLanguage.NaturalLiteralExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.NullExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.NumericUnaryExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.PostfixExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.PrefixExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.RealLiteralExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.RelationalExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.SendSignalStatement
import com.incquerylabs.uml.ralf.reducedAlfLanguage.ShiftExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.SignalDataExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.Statements
import com.incquerylabs.uml.ralf.reducedAlfLanguage.StaticFeatureInvocationExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.StringLiteralExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.SuperInvocationExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.ThisExpression
import com.incquerylabs.uml.ralf.reducedAlfLanguage.Variable
import com.incquerylabs.uml.ralf.reducedAlfLanguage.WhileStatement
import com.incquerylabs.uml.ralf.types.CollectionTypeReference
import java.util.List
import org.apache.log4j.Logger
import org.eclipse.uml2.uml.Class
import org.eclipse.uml2.uml.Operation
import org.eclipse.uml2.uml.Parameter
import org.eclipse.uml2.uml.ParameterDirectionKind
import org.eclipse.uml2.uml.Property
import org.eclipse.uml2.uml.Signal
import org.eclipse.uml2.uml.Type
import org.eclipse.xtend2.lib.StringConcatenation

class ExpressionVisitor {
	extension NavigationVisitor navigationVisitor
	extension SnippetTemplateCompilerUtil util
	extension ReducedAlfSystem typeSystem
	public extension Logger logger = Logger.getLogger(class)
	
	new(SnippetTemplateCompilerUtil util, ReducedAlfSystem typeSystem){
		this.typeSystem = typeSystem
		this.util = util
		this.navigationVisitor = new NavigationVisitor(this, typeSystem, util)
	}
	
	def dispatch String visit(CollectionLiteralExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		if(ex instanceof ElementCollectionExpression){
			val elementType = ex.typeDeclaration.type
			val collectionType = typeSystem.type(ex).value.umlType
			val List<ValueDescriptor> elements = Lists.newArrayList
			
			for(Expression e : ex.elements.expressions){
				val expressionString = e.visit(parent)
				switch(e){
					LiteralExpression: {
						elements.add((descriptorFactory.createLiteralDescriptorBuilder => [
							literal = expressionString
							type = typeSystem.type(e).value.umlType
						]).build)
					}
					default : {
						elements.add(descriptorFactory.getCachedVariableDescriptor(expressionString))
					}
				}
				
			}
						
			val valueDescriptor = (descriptorFactory.createCollectionLiteralBuilder => [
				it.elementType = elementType
				it.collectionType = collectionType
				it.elements = elements
				it.stringBuilder = parent
			]).build
			
			trace('''Finished visiting: Collection Literal Expression: «valueDescriptor.stringRepresentation»''')
			valueDescriptor.stringRepresentation
			
		}else{
			throw new UnsupportedOperationException("Only Element collections are supported")
		}
	}
	
	def dispatch String visit(InstanceDeletionExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val referenceString = ex.reference.visit(parent)
				
		val valueDescriptor = ex.reference.getCachedDescriptor(referenceString)
		
		val descriptor = (descriptorFactory.createDeleteBuilder => [
			variable = valueDescriptor
		]).build
		
		trace('''Finished visiting: Instance Deletion Expression: «descriptor.stringRepresentation»''')	
		descriptor.stringRepresentation
	}
	
		
	def dispatch String visit(CastExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val operandVariable = ex.operand.visit(parent)
		val variableType = typeSystem.type(ex).value.umlType
		
		if(ex.isFlatteningNeeded){
			val operandDescriptor = ex.getCachedDescriptor(operandVariable)
			
			val castDescriptor = (descriptorFactory.createCastDescriptorBuilder => [
				castingType = variableType
				it.descriptor = operandDescriptor
			]).build
			
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «castDescriptor.stringRepresentation»;
			''')
			
			trace('''Finished visiting: Cast Expression: «descriptor.stringRepresentation»''')		
			descriptor.stringRepresentation
		}else{
			val operandDescriptor = ex.getCachedDescriptor(operandVariable)
			val castDescriptor = (descriptorFactory.createCastDescriptorBuilder => [
				castingType = variableType
				it.descriptor = operandDescriptor
			]).build
			
			trace('''Finished visiting: Cast Expression: «castDescriptor.stringRepresentation»''')	
			castDescriptor.stringRepresentation	
		}
	}
	
	def dispatch String visit(NullExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val expr = '''nullptr'''
		trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
		return expr	
	}
	
	def dispatch String visit(InstanceCreationExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')	
		val variableType = typeSystem.type(ex).value.umlType
		
		
		val operationParameters = prepareInstanceCreationTuple(ex, ex.instance, parent)
		val type = ex.instance
		
		val descriptor = (descriptorFactory.createConstructorCallBuilder => [
			type = variableType
			it.operation = operationParameters.key
			it.parameters = operationParameters.value
		]).build
		
		switch(type){
			Signal: {
				var ValueDescriptor variableDescriptor
				
				if(ex.eContainer instanceof LocalNameDeclarationStatement){
					val statement = ex.eContainer as LocalNameDeclarationStatement
					if(statement.variable instanceof CollectionVariable){
						val collection = statement.variable as CollectionVariable
						variableDescriptor = (descriptorFactory.createCollectionVariableDescriptorBuilder => [
							name = collection.name
							collectionType = context.getCollectionType(collection.collectionType)
							elementType = collection.type.type
							isExistingVariable = true
						]).build
					}else{
						variableDescriptor = (descriptorFactory.createSingleVariableDescriptorBuilder => [
							name = statement.variable.name
							type = typeSystem.type(statement.variable).value.umlType
							isExistingVariable = true
						]).build
					}
					
					initiateAttributes(ex, type, parent, variableDescriptor)
					trace('''Finished visiting: Instance Creation Expression: «descriptor.stringRepresentation»''')	
					return descriptor.stringRepresentation
					
				}else{
					variableDescriptor = createNewVariableDescriptor(ex, variableType)
					
					parent.append('''«variableDescriptor.fullType» «variableDescriptor.stringRepresentation» = «descriptor.stringRepresentation»;
					''')
	
					initiateAttributes(ex, type, parent, variableDescriptor)
					parent.append(StringConcatenation.DEFAULT_LINE_DELIMITER)
					trace('''Finished visiting: Instance Creation Expression: «variableDescriptor.stringRepresentation»''')
					return variableDescriptor.stringRepresentation
				}
				

			}
			Class : {
				if(ex.isFlatteningNeeded){
					val variableDescriptor = createNewVariableDescriptor(ex, variableType)
					
					parent.append('''«variableDescriptor.fullType» «variableDescriptor.stringRepresentation» = «descriptor.stringRepresentation»;
					''')
					trace('''Finished visiting: Instance Creation Expression: «variableDescriptor.stringRepresentation»''')
					return variableDescriptor.stringRepresentation
				}else{
					trace('''Finished visiting: Instance Creation Expression: «descriptor.stringRepresentation»''')
					return descriptor.stringRepresentation	
				}
			}
		}
	}
	
	private def initiateAttributes(InstanceCreationExpression ex, Signal cl, StringBuilder builder, ValueDescriptor descriptor){
		val List<ValueDescriptor> descriptors = Lists.newArrayList
		if((ex.parameters instanceof NamedTuple && (ex.parameters as NamedTuple).expressions.size != 0) 
			|| (ex.parameters instanceof ExpressionList && (ex.parameters as ExpressionList).expressions.size != 0)
		){
			if(ex.parameters instanceof NamedTuple){
				val tuple = ex.parameters as NamedTuple
				tuple.expressions.forEach[ exp |
					
					val attribute = getAttribute(cl, exp.name, typeSystem.type(exp.expression).value.umlType)
					if(attribute!=null){
						val rhsString = exp.expression.visit(builder)
						
						val rhsDescriptor = (descriptorFactory.createSingleVariableDescriptorBuilder => [
							it.name = rhsString
							it.type = typeSystem.type(exp.expression).value.umlType
							isExistingVariable = true
						]).build
						
						val assignmentDescriptor =  (descriptorFactory.createPropertyWriteBuilder => [
							variable = descriptor
							property = attribute
							newValue = rhsDescriptor
						]).build
						
						descriptors.add(assignmentDescriptor)
					}
				]
				builder.append('''«FOR descr : descriptors SEPARATOR StringConcatenation.DEFAULT_LINE_DELIMITER»«descr.stringRepresentation»;«ENDFOR»''')
			}else{
				throw new UnsupportedOperationException("Signal creation is only supported with named tuples")
			}
		}
	}
	
	private def getAttribute(Signal cl, String name, Type type) {
		val candidates = cl.members.filter(Property).filter[attr| attr.name.equals(name) && attr.getType.equals(type)]
		if(candidates.size != 0){
			return candidates.head
		}else{
			return null
		}
	}

	def dispatch String visit(ThisExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val expr = getDescriptor(ex).stringRepresentation
		trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
		return expr	
	}
	
	def dispatch String visit(ClassExtentExpression ex, StringBuilder parent){
		ex.visitClassExtent(parent)
	}
	
	def dispatch String visit(FilterExpression ex, StringBuilder parent){
		ex.visitFilter(parent)
	}
	
	def dispatch String visit(SignalDataExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val container = ex.eContainer
		val datatype = typeSystem.type(ex).value.umlType
		if(container instanceof SendSignalStatement){
			val sigdataDescriptor = (descriptorFactory.createSigdataDescriptorBuilder => [
				type = datatype
			]).build
			
			val variableDescriptor = createNewVariableDescriptor(ex, datatype)
			
			val cloneDescriptor = (descriptorFactory.createCopyConstructorCallBuilder => [
				type = datatype
				parameter = sigdataDescriptor
			]).build
			
			parent.append('''«variableDescriptor.fullType» «variableDescriptor.stringRepresentation» = «cloneDescriptor.stringRepresentation»;
			''')
			
			trace('''Finished visiting: Instance Creation Expression: «variableDescriptor.stringRepresentation»''')
			variableDescriptor.stringRepresentation
			
		}else{
			val sigdataDescriptor = (descriptorFactory.createSigdataDescriptorBuilder => [
				type = datatype
			]).build
			trace('''Finished visiting: Instance Creation Expression: «sigdataDescriptor.stringRepresentation»''')
			sigdataDescriptor.stringRepresentation			
		}
	}
	
	def dispatch String visit(StaticFeatureInvocationExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val variableType = typeSystem.type(ex).value.umlType
		val op = ex.operation.reference as Operation
		
		val List<ValueDescriptor> descriptors = ex.prepareTuple(op, parent)
			
		var ValueDescriptor descriptor 
		if(variableType != null && !(ex.eContainer.eContainer instanceof PrefixExpression) && !(ex.eContainer.eContainer instanceof PostfixExpression)&& ex.isFlatteningNeeded){
			descriptor = createNewVariableDescriptor(ex, variableType)
		}	
				
		val invocationDescriptor = (descriptorFactory.createStaticOperationCallBuilder => [
			operation = op
			parameters = descriptors
		]).build
		
		if(variableType != null && !(ex.eContainer.eContainer instanceof PrefixExpression) && !(ex.eContainer.eContainer instanceof PostfixExpression) && ex.isFlatteningNeeded){
	    	parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «invocationDescriptor.stringRepresentation»;
	    	''')
	    	
	    	descriptor.stringRepresentation
	    }else{
	    	invocationDescriptor.stringRepresentation
	    }
	}
	
	def dispatch String visit(SuperInvocationExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		'''***** SUPER invocations not supported yet *****'''
	}
	
	def dispatch String visit(LinkOperationExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val linkOperationDescriptor = ex.descriptor
		return linkOperationDescriptor.stringRepresentation
	}
	
	def dispatch String visit(AssociationAccessExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		Preconditions.checkState(
			!((ex.context instanceof FeatureInvocationExpression) && ((ex.context as FeatureInvocationExpression).feature instanceof Property)),
			"Association access on property values is not allowed (e.g. a.prop->b)"
		)
		
		ex.visitAssociation(parent)
	}
	
	def dispatch String visit(FeatureInvocationExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		if(ex.feature instanceof Property){
			if(ex.context instanceof AssociationAccessExpression){
				return ex.visitAttribute(parent)
			}else{
				ex.visitFeatureInvocationExpression(parent)
			}
		}else if (ex.feature instanceof Operation){
			val op = ex.feature as Operation
			if(op.name.equals("one") && op.ownedParameters.filter[ param| !(param.direction==ParameterDirectionKind.RETURN_LITERAL)].size == 0){
				ex.visitOne(parent)
			}else{
				ex.visitFeatureInvocationExpression(parent)
			}
		}else {
			ex.visitFeatureInvocationExpression(parent)
		}
	}
	
	private def visitFeatureInvocationExpression(FeatureInvocationExpression ex, StringBuilder parent){
		var ValueDescriptor invocationDescriptor
		val contextString = ex.context.visit(parent)
		
		val variableType = typeSystem.type(ex).value.umlType
		
		val descriptor = createNewVariableDescriptor(ex, variableType)
		switch (ex.feature) {
	        Operation: {
	        	val op = ex.feature as Operation
				val List<ValueDescriptor> descriptors = ex.prepareTuple(op, parent)
				
				val contextDescriptor = ex.context.getCachedDescriptor(contextString)					
				invocationDescriptor = (descriptorFactory.createOperationCallBuilder => [
					variable = contextDescriptor
					operation = op
					parameters = descriptors
				]).build
	        }
	        Property: {
	        	val contextDescriptor = ex.context.getCachedDescriptor(contextString)				
	        	invocationDescriptor = (descriptorFactory.createPropertyReadBuilder => [
					variable = contextDescriptor
					property = ex.feature as Property
				]).build
	        }
	        default: throw new UnsupportedOperationException("Invalid feature invocation")
	    }
	    
	    if((typeSystem.type(ex.context).value instanceof CollectionTypeReference)
	    	&& variableType != null
	    	&& invocationDescriptor.hasMultilineRepresentation
	    ) {
	    	val lastLine = invocationDescriptor.cutRepresentationLastLine
			parent.append(	'''
							«invocationDescriptor.stringRepresentation»
							«descriptor.fullType» «descriptor.stringRepresentation» = «lastLine»;
	    					''')
	    	trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
	    	descriptor.stringRepresentation
	    } else if(variableType != null && !(ex.eContainer.eContainer instanceof PrefixExpression) && !(ex.eContainer.eContainer instanceof PostfixExpression) && ex.isFlatteningNeeded && !(ex.feature instanceof Property)){
	    	parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «invocationDescriptor.stringRepresentation»;
	    	''')
	    	trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
	    	descriptor.stringRepresentation
	    }else{
	    	trace('''Finished visiting: «ex.class.simpleName»: «invocationDescriptor.stringRepresentation»''')
	    	invocationDescriptor.stringRepresentation
	    }
	}
	
	def String cutRepresentationLastLine(ValueDescriptor descriptor) {
		var penultimateLineLastCharIndex = descriptor.stringRepresentation.lastIndexOf('\n')
		val original = descriptor.stringRepresentation.toCharArray
		descriptor.stringRepresentation = ""
		var String lastLine = ""
		for(var i = 0 ; i < original.length; i++) {
			if(i < penultimateLineLastCharIndex) {
				descriptor.stringRepresentation = descriptor.stringRepresentation + original.get(i)
			} else if(i > penultimateLineLastCharIndex) {
				if(!original.get(i).equals(';')) {
					lastLine += original.get(i)
				}
			}
		}
		return lastLine
	}
	
	def boolean hasMultilineRepresentation(ValueDescriptor descriptor) {
		return descriptor.stringRepresentation.contains('\n')
	}
	
	def dispatch String visit(AssignmentExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
	   	val variableType = typeSystem.type(ex).value.umlType
	   	if(ex.leftHandSide instanceof FeatureInvocationExpression && (ex.leftHandSide as FeatureInvocationExpression).feature instanceof Property) {
			val propAccess = ex.leftHandSide as FeatureInvocationExpression
			
			val rhsString = ex.rightHandSide.visit(parent)
			val contextString = propAccess.context.visit(parent)
					
			val rhsDescriptor = ex.rightHandSide.getCachedDescriptor(rhsString)
	        val contextDescriptor = propAccess.context.getCachedDescriptor(contextString)
			
			val assignmentDescriptor =  (descriptorFactory.createPropertyWriteBuilder => [
				variable = contextDescriptor
				property = propAccess.feature as Property
				newValue = rhsDescriptor
			]).build
			
			if(ex.isFlatteningNeeded){
				val descriptor = createNewVariableDescriptor(ex, variableType)
				parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = («assignmentDescriptor.stringRepresentation»);
				''')
				trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
				descriptor.stringRepresentation
			}else{
				trace('''Finished visiting: «ex.class.simpleName»: «assignmentDescriptor.stringRepresentation»''')
				assignmentDescriptor.stringRepresentation	
			}
		} else {
			val lhsString = ex.leftHandSide.visit(parent)
		    val rhsString = ex.rightHandSide.visit(parent)
		    
		    val lhsRep = ex.leftHandSide.getProperRepresentation(lhsString)
		    
		    if(ex.isFlatteningNeeded){
		    	val descriptor = createNewVariableDescriptor(ex, variableType)
				parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = («lhsRep» «ex.operator» «rhsString»);
				''')
				trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
				descriptor.stringRepresentation
			}else{
				val expr = '''«lhsRep» «ex.operator» «rhsString»'''	
				trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
				return expr	
			}
		}
	}

	def dispatch String visit(ArithmeticExpression ex, StringBuilder parent) {
		trace('''Started visiting: «ex.class.simpleName»''')
		val operand1Variable = ex.operand1.visit(parent)
		val operand2Variable = ex.operand2.visit(parent)
		
		val operand1Descriptor = ex.operand1.getCachedDescriptor(operand1Variable)
		val operand2Descriptor = ex.operand2.getCachedDescriptor(operand2Variable)
		
		val variableType = typeSystem.type(ex).value.umlType
		
		if(ex.isFlatteningNeeded){
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «operand1Descriptor.valueRepresentation» «ex.operator» «operand2Descriptor.valueRepresentation»;
			''')
			trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
			descriptor.stringRepresentation
		}else{
			val expr = '''«operand1Descriptor.valueRepresentation» «ex.operator» «operand2Descriptor.valueRepresentation»'''
			trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
			return expr	
		}
	}
	
	def dispatch String visit(ShiftExpression ex, StringBuilder parent) {
		trace('''Started visiting: «ex.class.simpleName»''')
		val operand1Variable = ex.operand1.visit(parent)
		val operand2Variable = ex.operand2.visit(parent)
		
		val operand1Descriptor = ex.operand1.getCachedDescriptor(operand1Variable)
		val operand2Descriptor = ex.operand2.getCachedDescriptor(operand2Variable)
		
		val variableType = typeSystem.type(ex).value.umlType
		
		if(ex.isFlatteningNeeded){
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «operand1Descriptor.valueRepresentation» «ex.operator» «operand2Descriptor.valueRepresentation»;
			''')
			trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
			descriptor.stringRepresentation
		}else{
			val expr = '''«operand1Descriptor.valueRepresentation» «ex.operator» «operand2Descriptor.valueRepresentation»'''
			trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
			return expr		
		}
	}
	
	def dispatch String visit(RelationalExpression ex, StringBuilder parent) {
		trace('''Started visiting: «ex.class.simpleName»''')
		val operand1Variable = ex.operand1.visit(parent)
		val operand2Variable = ex.operand2.visit(parent)
		
		val operand1Descriptor = ex.operand1.getCachedDescriptor(operand1Variable)
		val operand2Descriptor = ex.operand2.getCachedDescriptor(operand2Variable)
		
		val variableType = typeSystem.type(ex).value.umlType
		
		if(ex.isFlatteningNeeded){
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «operand1Descriptor.valueRepresentation» «ex.operator» «operand2Descriptor.valueRepresentation»;
			''')
			trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
			descriptor.stringRepresentation
		}else{
			val expr = '''«operand1Descriptor.valueRepresentation» «ex.operator» «operand2Descriptor.valueRepresentation»'''	
			trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
			return expr	
		}
	}
	
	def dispatch String visit(EqualityExpression ex, StringBuilder parent) {
		trace('''Started visiting: «ex.class.simpleName»''')
		val operand1Variable = ex.operand1.visit(parent)
		val operand2Variable = ex.operand2.visit(parent)
		
		val String operand1String = ex.operand1.getProperRepresentation(operand1Variable)			
		val String operand2String = ex.operand2.getProperRepresentation(operand2Variable)
		
		val variableType = typeSystem.type(ex).value.umlType
		
		if(ex.isFlatteningNeeded){
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «operand1String» «ex.operator» «operand2String»;
			''')
			
			trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
			descriptor.stringRepresentation
		}else{
			val expr = '''«operand1String» «ex.operator» «operand2String»'''
			trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
			return expr	
		}
	}
	
	def dispatch String visit(LogicalExpression ex, StringBuilder parent) {
		trace('''Started visiting: «ex.class.simpleName»''')
		val operand1Variable = ex.operand1.visit(parent)
		val operand2Variable = ex.operand2.visit(parent)
		
		val String operand1String = ex.operand1.getCachedDescriptor(operand1Variable).valueRepresentation 
		val String operand2String = ex.operand2.getCachedDescriptor(operand2Variable).valueRepresentation 
		
		val variableType = typeSystem.type(ex).value.umlType
		
		if(ex.isFlatteningNeeded){
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «operand1String» «ex.operator» «operand2String»;
			''')
			
			trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
			descriptor.stringRepresentation
		}else{
			val expr = '''«operand1String» «ex.operator» «operand2String»'''
			trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
			return expr	
		}
	}
	
	def dispatch String visit(ConditionalLogicalExpression ex, StringBuilder parent) {
		trace('''Started visiting: «ex.class.simpleName»''')
		val operand1Variable = ex.operand1.visit(parent)
		val operand2Variable = ex.operand2.visit(parent)
		
		val String operand1String = ex.operand1.getCachedDescriptor(operand1Variable).valueRepresentation 
		val String operand2String = ex.operand2.getCachedDescriptor(operand2Variable).valueRepresentation 
		
		val variableType = typeSystem.type(ex).value.umlType
		
		if(ex.isFlatteningNeeded){
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «operand1String» «ex.operator» «operand2String»;
			''')
			trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
			descriptor.stringRepresentation
		}else{
			val expr = '''«operand1String» «ex.operator» «operand2String»'''	
			trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
			return expr
		}
	}

	def dispatch String visit(PrefixExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val operandVariable = ex.operand.expression.visit(parent)
		
		val String operandString = if(ex.operand.expression instanceof FeatureInvocationExpression) {
			operandVariable
		} else {
			ex.operand.expression.getCachedDescriptor(operandVariable).valueRepresentation
		}  
		
		val variableType = typeSystem.type(ex).value.umlType
		
		if(ex.isFlatteningNeeded){
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «ex.operator.literal»«operandString»;
			''')
			
			trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
			descriptor.stringRepresentation
		}else{
			val expr = '''«ex.operator.literal»«operandString»'''	
			trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
			return expr
		}
	}
	
	def dispatch String visit(PostfixExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val operandVariable = ex.operand.expression.visit(parent)
		
		val String operandString = if(ex.operand.expression instanceof FeatureInvocationExpression) {
			operandVariable
		} else {
			ex.operand.expression.getCachedDescriptor(operandVariable).valueRepresentation
		} 
		
		val variableType = typeSystem.type(ex).value.umlType
		
		if(ex.isFlatteningNeeded){
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «operandString»«ex.operator.literal»;
			''')
			
			trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
			descriptor.stringRepresentation
		}else{
			val expr = '''«operandString»«ex.operator.literal»'''	
			trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
			return expr
		}
	}

	
	def dispatch String visit(ConditionalTestExpression ex, StringBuilder parent) {
		trace('''Started visiting: «ex.class.simpleName»''')
		val operand1Variable = ex.operand1.visit(parent)
		val operand2Variable = ex.operand2.visit(parent)
		val operand3Variable = ex.operand3.visit(parent)
		
		val String operand1String = ex.operand1.getCachedDescriptor(operand1Variable).valueRepresentation
		val String operand2String = ex.operand2.getProperRepresentation(operand2Variable) 
		val String operand3String = ex.operand3.getProperRepresentation(operand3Variable)
		
		val variableType = typeSystem.type(ex).value.umlType
		
		if(ex.isFlatteningNeeded){
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = («operand1String») ? («operand2String») : («operand3String»);
			''')
		
			trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
			descriptor.stringRepresentation
		}else{
			val expr = '''(«operand1String») ? («operand2String») : («operand3String»)'''
			trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
			return expr	
		}
	}

	def dispatch String visit(NameExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		if(ex.reference instanceof Variable){
			val variable = ex.reference as Variable
			if(variable != null){
				val descriptor = getDescriptor(ex)
				trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
				return descriptor.stringRepresentation
			}
		}else if(ex.reference instanceof Parameter){
			val parameter = ex.reference as Parameter
			if(parameter != null){
				val descriptor = getDescriptor(ex)
				if(ex.isValueRepresentationRequired){ //if this is true, the descriptor should never describe a class or signal
					trace('''Finished visiting: «ex.class.simpleName»: «descriptor.valueRepresentation»''')
					return descriptor.valueRepresentation
				}
				trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
				return descriptor.stringRepresentation
			}
		}else{
			throw new UnsupportedOperationException("Only variables and parameters are supported")
		}
	}
	
	
	def dispatch String visit(NumericUnaryExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val operandVariable = ex.operand.visit(parent)
		val variableType = typeSystem.type(ex).value.umlType
		
		val operandString = ex.operand.getCachedDescriptor(operandVariable).valueRepresentation
		
		if(ex.isFlatteningNeeded){
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «ex.operator.literal»«operandString»;
			''')
		
			trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
			descriptor.stringRepresentation
		}else{
			val expr = '''«ex.operator»«operandVariable»'''	
			trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
			return expr		
		}
	}
	
	def dispatch String visit(BitStringUnaryExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val operandVariable = ex.operand.visit(parent)
		val variableType = typeSystem.type(ex).value.umlType
		
		val operandString = ex.operand.getCachedDescriptor(operandVariable).valueRepresentation
		
		if(ex.isFlatteningNeeded){
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «ex.operator»«operandString»;
			''')
		
			trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
			descriptor.stringRepresentation
		}else{
			val expr = '''«ex.operator»«operandVariable»'''	
			trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
			return expr	
		}
	}
	
	def dispatch String visit(BooleanUnaryExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val operandVariable = ex.operand.visit(parent)
		val variableType = typeSystem.type(ex).value.umlType
		
		if(ex.isFlatteningNeeded){
			val descriptor = createNewVariableDescriptor(ex, variableType)
			
			parent.append('''«descriptor.fullType» «descriptor.stringRepresentation» = «ex.operator»«operandVariable»;
			''')
			
			trace('''Finished visiting: «ex.class.simpleName»: «descriptor.stringRepresentation»''')
			descriptor.stringRepresentation
		}else{
			val expr = '''«ex.operator»«operandVariable»'''	
			trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
			return expr
		}
	}
	
	def dispatch String visit(NaturalLiteralExpression ex, StringBuilder parent) {
		trace('''Started visiting: «ex.class.simpleName»''')
		val expr = getDescriptor(ex).stringRepresentation
		trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
		return expr
    }
    
	def dispatch String visit(RealLiteralExpression ex, StringBuilder parent) {
		trace('''Started visiting: «ex.class.simpleName»''')
		val expr = getDescriptor(ex).stringRepresentation
		trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
		return expr
    }
	
	def dispatch String visit(BooleanLiteralExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val expr = getDescriptor(ex).stringRepresentation
		trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
		return expr
	}
	   
	def dispatch String visit(StringLiteralExpression ex, StringBuilder parent){
		trace('''Started visiting: «ex.class.simpleName»''')
		val expr = getDescriptor(ex).stringRepresentation
		trace('''Finished visiting: «ex.class.simpleName»: «expr»''')
		return expr
	}
	
	def boolean isFlatteningNeeded(Expression ex){
		switch(ex.eContainer){
			ExpressionStatement: {
				switch(ex.eContainer.eContainer){
					Statements: return false
					BlockStatement : return false
					ForStatement: {
						if((ex.eContainer.eContainer as ForStatement).update.equals(ex.eContainer)){
							return false	
						}else{
							return true
						}
					}
					default: return true
				}
			}
			LocalNameDeclarationStatement: {
				switch(ex.eContainer.eContainer){
					Statements: return false
					BlockStatement : return false
					default: return true
				}
			}
			AssignmentExpression: {
				return !(ex instanceof FeatureInvocationExpression)
			}
			default: {
				return true
			}
		}
	}
		
	private dispatch def Pair<Operation, ? extends List<Pair<Type, ? extends ValueDescriptor>>> prepareInstanceCreationTuple(InstanceCreationExpression ex, Signal signal, StringBuilder parent){
		return null -> newArrayList
	}
	
	private dispatch def Pair<Operation, ? extends List<Pair<Type, ? extends ValueDescriptor>>> prepareInstanceCreationTuple(InstanceCreationExpression ex, Class c, StringBuilder parent){
		val descriptors = newArrayList	
		
		var Operation op = null
		if(ex.parameters instanceof ExpressionList){
			val parameters = ex.parameters as ExpressionList
			op = getOperation(parameters, c)
			
			if(op !=null){
				parameters.expressions.forEach[ expr |
					val string = expr.visit(parent)
					val descriptor = (descriptorFactory.createSingleVariableDescriptorBuilder => [
						name = string
						type = typeSystem.type(expr).value.umlType
						isExistingVariable = true
					]).build
					descriptors.add(typeSystem.type(expr).value.umlType -> descriptor)				
				]
			}else{
				return op -> descriptors
			}
		}else if(ex.parameters instanceof NamedTuple){
			val parameters = ex.parameters as NamedTuple
			op = getOperation(parameters, c)
			
			if(op !=null){
				val operationParameters = op.ownedParameters

				operationParameters.forEach[operationParameter |
					parameters.expressions.forEach[ namedExpression |
						if(namedExpression.parameterEqualsExpression(operationParameter)){
							val string = namedExpression.expression.visit(parent)
							val descriptor = (descriptorFactory.createSingleVariableDescriptorBuilder => [
								name = string
								type = typeSystem.type(namedExpression.expression).value.umlType
								isExistingVariable = true
							]).build
							descriptors.add(new Pair<Type, ValueDescriptor>(typeSystem.type(namedExpression.expression).value.umlType, descriptor))
						}
					]
				]
			}else{
				return op -> descriptors
			}
			
		}else{
			throw new UnsupportedOperationException("Only expression list and namedTuple based tuples are supported")
		}	
		return op -> descriptors
	}
	
	private dispatch def getOperation(NamedTuple parameters, Class c){
		val candidates = c.ownedOperations.filter[op | op.name.equals(c.name)]
		val List<Operation> operations = Lists.newArrayList
		candidates.forEach[operation | 
			var valid = true
			for(NamedExpression namedExpression : parameters.expressions){
				var expressionFound = false
				for(Parameter parameter : operation.ownedParameters){
					if(namedExpression.parameterEqualsExpression(parameter)){
						expressionFound = true
					}
				}
				if(!expressionFound){
					valid = false
				}
			}
			if(valid){
				operations.add(operation)
			}
		]
		if(operations.size == 0){
			return null
		}else{
			return operations.head
		}
	}
	
	private dispatch def getOperation(ExpressionList parameters, Class c){
		val candidates = c.ownedOperations.filter[op | op.name.equals(c.name)]
		val List<Operation> operations = Lists.newArrayList
		candidates.forEach[operation | 
			var valid = true
			for(Expression expression : parameters.expressions){
				var expressionFound = false
				for(Parameter parameter : operation.ownedParameters){
					if(expression.parameterEqualsExpression(parameter)){
						expressionFound = true
					}
				}
				if(!expressionFound){
					valid = false
				}
			}
			if(valid){
				operations.add(operation)
			}
		]
		if(operations.size == 0){
			return null
		}else{
			return operations.head
		}
	}
	
	private dispatch def prepareTuple(FeatureInvocationExpression ex, Operation op, StringBuilder parent){
		val List<ValueDescriptor> descriptors = Lists.newArrayList
		if(ex.parameters instanceof ExpressionList){
			val parameters = ex.parameters as ExpressionList
			parameters.expressions.forEach[ expr |
				val name = expr.visit(parent)
				descriptors.add(expr.getCachedDescriptor(name))
				
			]
		}else if(ex.parameters instanceof NamedTuple){
			val parameters = ex.parameters as NamedTuple
			val operationParameters = op.ownedParameters

			operationParameters.forEach[operationParameter |
				parameters.expressions.forEach[ namedExpression |
					if(namedExpression.parameterEqualsExpression(operationParameter)){
						val name = namedExpression.expression.visit(parent)
						descriptors.add(namedExpression.expression.getCachedDescriptor(name))
					}
				]
			]
			
		}else{
			throw new UnsupportedOperationException("Only expression list and namedTuple based tuples are supported")
		}	
		return descriptors
	}
	
	private def parameterEqualsExpression(NamedExpression namedExpression, Parameter operationParameter){
		val expType = typeSystem.type(namedExpression.expression).value
		val paramType = typeSystem.type(operationParameter).value
		if(paramType instanceof CollectionTypeReference){
			return (expType instanceof CollectionTypeReference 
				&& paramType.type.equals((expType as CollectionTypeReference).type)
				&& paramType.umlType.equals((expType as CollectionTypeReference).umlType)
				&& namedExpression.name.equals(operationParameter.name)
			)
		}else{
			return(namedExpression.name.equals(operationParameter.name) 
				&& expType.umlType.equals(paramType.umlType)
			)
		}
	}
	
	private def parameterEqualsExpression(Expression expression, Parameter operationParameter){
		val expType = typeSystem.type(expression).value
		val paramType = typeSystem.type(operationParameter).value
		if(paramType instanceof CollectionTypeReference){
			return (expType instanceof CollectionTypeReference 
				&& paramType.type.equals((expType as CollectionTypeReference).type)
				&& paramType.umlType.equals((expType as CollectionTypeReference).umlType)
			)
		}else{
			return expType.umlType.equals(paramType.umlType
			)
		}
	}
	
	private dispatch def prepareTuple(StaticFeatureInvocationExpression ex, Operation op, StringBuilder parent){
		val List<ValueDescriptor> descriptors = Lists.newArrayList
		if(ex.parameters instanceof ExpressionList){
			val parameters = ex.parameters as ExpressionList
			parameters.expressions.forEach[ expr |
				val name = expr.visit(parent)
				descriptors.add(expr.getCachedDescriptor(name))	
			]
		}else if(ex.parameters instanceof NamedTuple){
			val parameters = ex.parameters as NamedTuple
			val operationParameters = op.ownedParameters

			operationParameters.forEach[operationParameter |
				parameters.expressions.forEach[ namedExpression |
					if(namedExpression.parameterEqualsExpression(operationParameter)){
						val name = namedExpression.expression.visit(parent)
						descriptors.add(namedExpression.expression.getCachedDescriptor(name))
					}
				]
			]
			
		}else{
			throw new UnsupportedOperationException("Only expression list and namedTuple based tuples are supported")
		}	
		return descriptors
	}
	
	private def isCollection(Type variableType){
		if(variableType == null){
			return false
		}
		if( variableType.equals(context.getCollectionType(CollectionType.SET)) ||
			variableType.equals(context.getCollectionType(CollectionType.BAG)) ||
			variableType.equals(context.getCollectionType(CollectionType.SEQUENCE))
		){
			return true
		}else{
			return false
		}
		
	}
	
	private def isValueRepresentationRequired(Expression ex) {
		switch(ex.eContainer) {
			LocalNameDeclarationStatement: true
			IfClause : true
			WhileStatement : true
			DoStatement : true
			default : false	
		}
	}
	
	private def createNewVariableDescriptor(Expression ex, Type variableType){
		if(variableType == null){
			return null
		}
		var ValueDescriptor descriptor 
		if(variableType.isCollection){
			descriptor = (descriptorFactory.createCollectionVariableDescriptorBuilder => [
				elementType = (typeSystem.type(ex).value as CollectionTypeReference).valueType.umlType
				collectionType = variableType
				name = null
			]).build
		}else{
			descriptor = (descriptorFactory.createSingleVariableDescriptorBuilder => [
				type = variableType
				name = null
			]).build
		}
	}
	
	def String getProperRepresentation(Expression ex, String name) {
		if(ex instanceof NullExpression) {
			name	
		}			
		else if(typeSystem.type(ex).value.umlType instanceof Class) {
			ex.getCachedDescriptor(name).pointerRepresentation
		} else { 
			ex.getCachedDescriptor(name).valueRepresentation
		}
	}
	
	def ValueDescriptor getCachedDescriptor(Expression ex, String string){
		var ValueDescriptor tempDescriptor
		switch(ex){
			SignalDataExpression: {
				tempDescriptor = (descriptorFactory.createSigdataDescriptorBuilder => [
					type = typeSystem.type(ex).value.umlType
				]).build
			}
			ThisExpression: {
				tempDescriptor = ex.descriptor
			}
			LiteralExpression: {
				tempDescriptor = (descriptorFactory.createLiteralDescriptorBuilder => [
					literal = string
					type = typeSystem.type(ex).value.umlType
				]).build
			}
			default : {
				tempDescriptor = descriptorFactory.getCachedVariableDescriptor(string)
			}
		}
		if(tempDescriptor==null) {
			throw new IllegalArgumentException('''There is no cached descriptor for «string» (expression type: «ex.class.name»)!''')
		}
		return tempDescriptor
	}
}