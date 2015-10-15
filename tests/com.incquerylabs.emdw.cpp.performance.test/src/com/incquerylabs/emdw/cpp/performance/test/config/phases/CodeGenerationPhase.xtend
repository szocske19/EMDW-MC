package com.incquerylabs.emdw.cpp.performance.test.config.phases

import com.ericsson.xtumlrt.oopl.cppmodel.CPPSourceFile
import com.incquerylabs.emdw.cpp.performance.test.config.MCDataToken
import eu.mondo.sam.core.DataToken
import eu.mondo.sam.core.metrics.MemoryMetric
import eu.mondo.sam.core.metrics.TimeMetric
import eu.mondo.sam.core.phases.AtomicPhase
import eu.mondo.sam.core.results.PhaseResult
import com.incquerylabs.emdw.cpp.transformation.queries.XtumlQueries

class CodeGenerationPhase extends AtomicPhase {
	extension XtumlQueries xtumlQueries = XtumlQueries.instance
	
	new(String phaseName) {
		super(phaseName)
	}
	
	override execute(DataToken token, PhaseResult phaseResult) {
		print('''«phaseName»''')
		val mcToken = token as MCDataToken
		val timer = new TimeMetric("Time")
		val memory = new MemoryMetric("Memory")
		
		timer.startMeasure
		
		// WORK START
		mcToken.toolchainManager.initializeCppCodegeneration
		val changeMonitor = mcToken.toolchainManager.xtumlChangeMonitor
		val dirtyComponents = changeMonitor.dirtyXTComponents
		
		val cppComponents = dirtyComponents.map[ xtComponent |
			mcToken.toolchainManager.engine.cppComponents.getAllValuesOfcppComponent(xtComponent).head
		]
		if(mcToken.cppSourceFileContents == null) {
			mcToken.cppSourceFileContents = <CPPSourceFile, CharSequence>newHashMap
		}
		cppComponents.forEach[ cppComponent |
			val cppSourceFileContentsForComponent = mcToken.toolchainManager.executeCppCodeGeneration(cppComponent)
			mcToken.cppSourceFileContents.putAll(cppSourceFileContentsForComponent)
		]
		// WORK END
		
		timer.stopMeasure
		memory.measure
		
		phaseResult.addMetrics(timer)
		phaseResult.addMetrics(memory)
		print(''' | «timer.value»''')
		println(''' | «memory.value»''')
	}
	
	
}