package com.incquerylabs.emdw.testing.common.utils

import com.incquerylabs.emdw.cpp.transformation.XtumlCPPTransformationQrt
import com.incquerylabs.emdw.cpp.transformation.XtumlComponentCPPTransformation
import com.incquerylabs.emdw.umlintegration.TransformationQrt
import java.util.Map
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.incquery.runtime.base.api.BaseIndexOptions
import org.eclipse.incquery.runtime.emf.EMFScope
import org.eclipse.incquery.runtime.exception.IncQueryException
import org.eclipse.papyrusrt.xtumlrt.xtuml.XTComponent
import org.eclipse.uml2.uml.Type

class TransformationUtil {

	TransformationQrt xtTrafo
	XtumlCPPTransformationQrt cppTrafo
	XtumlComponentCPPTransformation compTrafo
	AdvancedIncQueryEngine engine
	
	static final val PATHMAP_SCHEME = "pathmap";
	static final val UML_LIBRARIES_AUTHORITY = "UML_LIBRARIES";

	def initializeEngine(ResourceSet set) throws IncQueryException {
		val options = new BaseIndexOptions().withResourceFilterConfiguration([
			val uri = getURI();
			if (uri.toString().contains("RALF")) {
				return false;
			}
			return PATHMAP_SCHEME.equals(uri.scheme()) && !uri.authority().equals(UML_LIBRARIES_AUTHORITY);
		]);
		val scope = new EMFScope(set, options);
		val engine = AdvancedIncQueryEngine.createUnmanagedEngine(scope);
		return engine;
	}


	def initializeAllTransformation(ResourceSet rs) {
		initializeAllTransformation(rs, null)
	}
	
	def initializeAllTransformation(ResourceSet rs, Map<Type, org.eclipse.papyrusrt.xtumlrt.common.Type> primitiveTypeMapping) {
		if(engine==null) {
			engine = initializeEngine(rs)
		}
		xtTrafo = new TransformationQrt
		xtTrafo.externalTypeMap = primitiveTypeMapping
		xtTrafo.initialize(engine)
		cppTrafo = new XtumlCPPTransformationQrt
		cppTrafo.initialize(engine)
		compTrafo = new XtumlComponentCPPTransformation
		compTrafo.initialize(engine)
	}
	
	def initializeXtTransformation(ResourceSet rs, Map<Type, org.eclipse.papyrusrt.xtumlrt.common.Type> primitiveTypeMapping) {
		if(engine==null) {
			engine = initializeEngine(rs)
		}
		xtTrafo = new TransformationQrt
		xtTrafo.externalTypeMap = primitiveTypeMapping
		xtTrafo.initialize(engine)
	}
	
	def initializeCppTransformation(ResourceSet rs) {
		if(engine==null) {
			engine = initializeEngine(rs)
		}
		cppTrafo = new XtumlCPPTransformationQrt
		cppTrafo.initialize(engine)
	}
	
	def initializeCppComponentTransformation(ResourceSet rs) {
		if(engine==null) {
			engine = initializeEngine(rs)
		}
		compTrafo = new XtumlComponentCPPTransformation
		compTrafo.initialize(engine)
	}

	def executeXtTransformation() {
		xtTrafo.execute
	}

	def executeCppTransformation() {
		cppTrafo.execute
	}

	def executeCppComponentTransformation() {
		compTrafo.execute
	}

	def executeCppComponentTransformation(XTComponent component) {
		compTrafo.execute(component)
	}

	def executeAllTransformation() {
		xtTrafo.execute
		cppTrafo.execute
		compTrafo.execute
	}

	def cleanupTransformation() {
		if (xtTrafo != null) {
			xtTrafo.dispose
		}
		if (cppTrafo != null) {
			cppTrafo.dispose
		}
		if (compTrafo != null) {
			compTrafo.dispose
		}
		if (engine != null) {
			engine.dispose
		}
	}

	def getTransformationEngine() {
		return engine
	}

}