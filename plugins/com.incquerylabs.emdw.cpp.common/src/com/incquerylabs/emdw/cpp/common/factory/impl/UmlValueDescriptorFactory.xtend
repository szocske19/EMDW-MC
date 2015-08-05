package com.incquerylabs.emdw.cpp.common.factory.impl

import com.google.common.collect.HashBasedTable
import com.google.common.collect.Table
import com.incquerylabs.emdw.cpp.common.IDescriptorCacheManager
import com.incquerylabs.emdw.cpp.common.builder.impl.UmlSingleValueDescriptorBuilder
import com.incquerylabs.emdw.cpp.common.factory.IUmlDescriptorFactory
import com.incquerylabs.emdw.cpp.common.mapper.UmlToXtumlMapper
import com.incquerylabs.emdw.valuedescriptor.SingleValueDescriptor
import java.util.Map
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.uml2.uml.Element
import org.eclipse.uml2.uml.Type

import static com.google.common.base.Preconditions.*

class UmlValueDescriptorFactory implements IUmlDescriptorFactory, IDescriptorCacheManager{
	private UmlValueDescriptorFactory parent
	private XtumlValueDescriptorFactory factory
	private UmlToXtumlMapper mapper
	private AdvancedIncQueryEngine engine
	private Map<String, SingleValueDescriptor> variableCache
	private Table<String, Element, SingleValueDescriptor> literalCache
	
	/**
	 * @param engine Cannot be null
	 */
	new(AdvancedIncQueryEngine engine) {
		checkArgument(engine!=null, "Engine cannot be null!")
		init(null, engine)
	}
	
	/**
	 * If you use this constructor the factory will use its parent's IncQueryEngine.
	 * 
	 * @param parent Cannot be null
	 */
	new(UmlValueDescriptorFactory parent) {
		checkArgument(parent!=null, "Parent cannot be null!")
		init(parent, parent.engine)
	}
	
	private def init(UmlValueDescriptorFactory parent, AdvancedIncQueryEngine engine) {
		checkArgument(engine!=null)
		this.variableCache = newHashMap()
		this.parent = parent
		this.engine = engine
		if(parent!=null) {
			factory = new XtumlValueDescriptorFactory(parent.factory)
			this.literalCache = parent.literalCache
		} else {
			factory = new XtumlValueDescriptorFactory(engine)
			this.literalCache = HashBasedTable.create
		}
		mapper = new UmlToXtumlMapper(engine)
	}
	
	
	
	/**
	 * Create a new SingleVariableDescriptor which stringRepresentation won't be the same as 
	 * <code>localVariableName</code> because we need to provide a unique name so it will add 
	 * a unique prefix to the <code>localVariableName</code>. This method caches the returned 
	 * SingleValueDescriptor to the <code>localVariableName</code> and you can get it through 
	 * {@link UmlValueDescriptorFactory#prepareSingleValueDescriptorForExistingVariable 
	 * <em>prepareSingleValueDescriptorForExistingVariable</em>} method.
	 * 
	 * @param type Cannot be null
	 * @param localVariableName Cannot be null
	 * 
	 * @return The SingleValueDescriptor with the resolved <code>type</code> based on implementation
	 *         and with unique name based on <code>localVariableName</code>
	 */
	def prepareSingleValueDescriptorForNewLocalVariable(Type type, String localVariableName) {
		val xtumlType = mapper.convertType(type)
		return factory.prepareSingleValueDescriptorForNewLocalVariable(xtumlType, localVariableName).cache(localVariableName)
	}
	
	/**
	 * @return The SingleValueDescriptor with the resolved type based on implementation and 
	 *         with unique name
	 */
	def prepareSingleValueDescriptorForNewLocalVariable(Type type) {
		val xtumlType = mapper.convertType(type)
		return factory.prepareSingleValueDescriptorForNewLocalVariable(xtumlType)
	}
	
	/**
	 * Create a new SingleVariableDescriptor which stringRepresentation is not necessarily the
	 * same as <code>localVariableName</code> because cached new variables are available also 
	 * through this method. If there is no variable in cache to <code>localVariableName</code> 
	 * a new SVD will be returned which <code>stringRepresentation</code> will be the same as 
	 * <code>localVariableName</code>.
	 * 
	 * @param type Only can be null if the required SVD in cache
	 * @param localVariableName Cannot be null
	 * 
	 * @return The SingleValueDescriptor with the resolved <code>type</code> based on implementation 
	 *         and with <code>stringRepresentation</code> which can be a unique name if SVD is a cached 
	 *         variable or the same as <code>localVariableName</code> if it is not
	 */
	def prepareSingleValueDescriptorForExistingVariable(Type type, String localVariableName) {
		val xtumlType = mapper.convertType(type)
		if(variableCache.containsKey(localVariableName)) {
			return variableCache.get(localVariableName)
		}
		return factory.prepareSingleValueDescriptorForExistingVariable(xtumlType, localVariableName).cache(localVariableName)
	}
	
	/**
	 * @param type Cannot be null and must be convertible to an xtUML type
	 * @param literal Cannot be null and must be parsable if it is a number
	 * 
	 * @return The SingleValueDescriptor with the resolved type based on implementation 
	 *         and with <code>stringRepresentation</code> which will contain the converted 
	 *         <code>literal</code>
	 */
	def prepareSingleValueDescriptorForLiteral(Type type, String literal) {
		val xtumlType = mapper.convertType(type)
		if(literalCache.contains(literal, type)) {
			return literalCache.get(literal, type)
		}
		return factory.prepareSingleValueDescriptorForLiteral(xtumlType, literal).cacheLiteral(literal, type)
	}
	
	
	
	private def SingleValueDescriptor cache(SingleValueDescriptor svd, String key) {
		variableCache.put(key, svd)
		return svd
	}
	
	private def SingleValueDescriptor cacheLiteral(SingleValueDescriptor svd, String rowkey, Element columnkey) {
		literalCache.put(rowkey, columnkey, svd)
		return svd
	}
	
	override createSingleValueDescriptorBuilder() {
		return new UmlSingleValueDescriptorBuilder(this)
	}
	
	override createCollectionValueDescriptorBuilder() {
		throw new UnsupportedOperationException("TODO: auto-generated method stub")
	}
	
	override getVariableCache() {
		return variableCache
	}
	
	override getLiteralCache() {
		return literalCache
	}
	
	override createChild() {
		return new UmlValueDescriptorFactory(this)
	}
	
}