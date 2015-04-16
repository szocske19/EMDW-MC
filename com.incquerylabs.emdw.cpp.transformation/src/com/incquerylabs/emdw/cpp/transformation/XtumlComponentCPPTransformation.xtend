package com.incquerylabs.emdw.cpp.transformation

import com.google.common.base.Stopwatch
import com.incquerylabs.emdw.cpp.transformation.queries.XtumlQueries
import com.zeligsoft.xtumlrt.common.Model
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.incquery.runtime.api.GenericPatternGroup
import org.eclipse.incquery.runtime.api.IncQueryEngine
import org.eclipse.viatra.emf.runtime.transformation.batch.BatchTransformation

import static com.google.common.base.Preconditions.*
import org.eclipse.incquery.runtime.emf.EMFScope

class XtumlComponentCPPTransformation {

	extension val Logger logger = Logger.getLogger(class)
//	extension RuleProvider ruleProvider
	static val xtUmlQueries = XtumlQueries.instance
	private var initialized = false;

	BatchTransformation transform
	IncQueryEngine engine
	Model xtUmlModel
	

	def initialize(Model xtUmlModel, IncQueryEngine engine) {
		checkArgument(xtUmlModel != null, "XTUML Model cannot be null!")
		checkArgument(engine != null, "Engine cannot be null!")
		if (!initialized) {
			this.xtUmlModel = xtUmlModel
			this.engine = engine

			debug("Preparing queries on engine.")
			var watch = Stopwatch.createStarted
			val queries = GenericPatternGroup.of(xtUmlQueries)
			queries.prepare(engine)
			info('''Prepared queries on engine («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
			
			debug("Preparing transformation rules.")
			transform = BatchTransformation.forScope(engine.scope as EMFScope)
//			ruleProvider = new RuleProvider(engine)
//			initRules
//			transform.addRules
//			transform.create
			info('''Prepared transformation rules («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')

			initialized = true
		}
	}

	def execute() {
			info('''Executing transformation on «xtUmlModel.name»''')
			val watch = Stopwatch.createStarted
			
			info('''Initial execution of transformation rules finished («watch.elapsed(TimeUnit.MILLISECONDS)» ms)''')
	}

	def dispose() {
		transform?.dispose
	}
	
}