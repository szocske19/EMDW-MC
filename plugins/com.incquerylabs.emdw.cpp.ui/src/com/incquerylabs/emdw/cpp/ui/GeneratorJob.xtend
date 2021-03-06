/*******************************************************************************
 * Copyright (c) 2015-2016, IncQuery Labs Ltd. and Ericsson AB
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *   Akos Horvath, Abel Hegedus, Zoltan Ujhelyi, Daniel Segesdi, Tamas Borbas, Robert Doczi, Peter Lunk - initial API and implementation
 *******************************************************************************/
package com.incquerylabs.emdw.cpp.ui

import com.incquerylabs.emdw.cpp.codegeneration.fsa.impl.EclipseWorkspaceFileManager
import com.incquerylabs.emdw.cpp.ui.util.EMDWProgressMonitor
import com.incquerylabs.emdw.toolchain.Toolchain
import com.incquerylabs.emdw.toolchain.ToolchainManager
import org.apache.log4j.Level
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Status
import org.eclipse.core.runtime.SubMonitor
import org.eclipse.core.runtime.jobs.Job
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.transaction.RecordingCommand
import org.eclipse.incquery.runtime.api.AdvancedIncQueryEngine
import org.eclipse.papyrus.infra.core.resource.ModelSet
import org.eclipse.papyrusrt.xtumlrt.common.Model
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data

import static com.incquerylabs.emdw.cpp.ui.util.CMUtils.*

class GeneratorJob extends Job {

	static val JOB_NAME = "EMDW Code Generation"
	
	static val CPP_QRT_INIT_WORK = 1
	static val CPP_COMPONENT_INIT_WORK = 1
	static val CPP_INIT_WORK = 1
	static val MAKEFILE_INIT_WORK = 1
	static val CPP_QRT_TRANSFORM_WORK = 1
	static val CPP_CODE_AND_FILEGEN_WORK = 100
	static val CHANGE_MONITOR_INIT_WORK = 1
	static val LOG_WORK = 1
	static val CPPMODEL_SAVE_WORK = 1
	
	
	val ModelSet modelSet
	val Resource xtumlResource
	val Model xtModel
	val AdvancedIncQueryEngine engine
	
	@Accessors boolean transformAllComponents = false
	@Accessors Toolchain toolchain
	
	new(ModelSet modelSet, Resource xtumlResource, Model xtModel, AdvancedIncQueryEngine engine) {
		super(JOB_NAME)
		this.modelSet = modelSet
		this.xtumlResource = xtumlResource
		this.xtModel = xtModel
		this.engine = engine
		
		toolchain = ToolchainManager.getToolchain(engine)
		if(toolchain == null) {
			val targetFolder = GeneratorHelper.getTargetFolder(xtumlResource, false)
			val toolchainBuilder = Toolchain.builder => [
				it.engine = engine
				it.xumlrtModel = xtModel
				it.xtumlChangeMonitor = getChangeMonitor(modelSet)
				it.fileManager = new EclipseWorkspaceFileManager(targetFolder)
			]
			
			toolchain = toolchainBuilder.build()
		}
		toolchain.logLevel = Level.DEBUG
		toolchain.clearMeasuredTimes
	}

	override protected run(IProgressMonitor monitor) {
		val tasks = createGeneratorTasks
		// calculate the sum of the progresses of the tasks
		val fullProgress = tasks.map[progress].fold(0)[$0 + $1]
		val subMonitor = SubMonitor::convert(monitor, JOB_NAME, fullProgress)
		
		try {
			val taskIterator = tasks.iterator
			
			val domain = modelSet.transactionalEditingDomain
			
			val command = new RecordingCommand(domain){
				override protected doExecute() {
					while (taskIterator.hasNext) {
						if (subMonitor.canceled)
							return
						val nextTask = taskIterator.next
						val childMonitor = subMonitor.newChild(nextTask.progress)
						nextTask.run(toolchain, childMonitor)
					}
				}
			}
			domain.commandStack.execute(command)
			if(subMonitor.isCanceled) {
				return Status::CANCEL_STATUS
			}
		} catch (Exception e) {
			// initialize error status since there is no static version of it
			// TODO use proper plugin id and code
			return new Status(Status::ERROR, "unknown", 1, "xUML-RT Code Generation finished with error", e);
		}

		return Status::OK_STATUS
	}
	
	private def createGeneratorTasks() {
		val tasks = newArrayList
		tasks += new GeneratorTask(CPP_QRT_INIT_WORK, "Initializing C++ QRT transformation.") [ toolchain, progressMonitor, progress |
			toolchain.initializeCppQrtTransformation
			progressMonitor.worked(progress)
		]
		tasks += new GeneratorTask(CPP_COMPONENT_INIT_WORK, "Initializing C++ component transformation.") [ toolchain, progressMonitor, progress |
			toolchain.initializeCppComponentTransformation
			progressMonitor.worked(progress)
		]
		tasks += new GeneratorTask(CPP_INIT_WORK, "Initializing C++ codegeneration.") [ toolchain, progressMonitor, progress |
			toolchain.initializeCppCodegeneration
			progressMonitor.worked(progress)
		]
		tasks += new GeneratorTask(MAKEFILE_INIT_WORK, "Initializing makefile generation") [ toolchain, progressMonitor, progress |
			toolchain.initializeMakefileGeneration
			progressMonitor.worked(progress)
		]

		tasks += new GeneratorTask(CPP_QRT_TRANSFORM_WORK, "Executing C++ QRT transformation.") [ toolchain, progressMonitor, progress |
			toolchain.executeCppQrtTransformation
			progressMonitor.worked(progress)
		]
		
		if(transformAllComponents){
			tasks += new GeneratorTask(CPP_CODE_AND_FILEGEN_WORK, "Executing C++ code and file generation.") [ toolchain, progressMonitor, progress |
				toolchain.executeCodeAndFileGenerationForAllComponents(EMDWProgressMonitor::convert(progressMonitor))
			]
		} else {
			tasks += new GeneratorTask(CPP_CODE_AND_FILEGEN_WORK, "Executing C++ code and file generation.") [ toolchain, progressMonitor, progress |
				toolchain.executeDeltaCodeAndFileGeneration(EMDWProgressMonitor::convert(progressMonitor))
			]
		}
		tasks += new GeneratorTask(CHANGE_MONITOR_INIT_WORK, "Starting change monitor.") [ toolchain, progressMonitor, progress |
			toolchain.startChangeMonitor
			progressMonitor.worked(progress)
		]
		tasks += new GeneratorTask(CPPMODEL_SAVE_WORK, "Saving cppmodel.") [ toolchain, progressMonitor, progress |
			val cppModel = toolchain.getOrCreateCPPModel
			cppModel.eResource.save(null)
		]
		tasks += new GeneratorTask(LOG_WORK, "Logging times.") [ toolchain, progressMonitor, progress |
			toolchain.logMeasuredTimes
			progressMonitor.worked(progress)
		]
		return tasks
	}

}

@Data
class GeneratorTask {

	val int progress
	val String taskName
	
	// def void execute(Toolchain tm, SubMonitor sm, Integer i)
	@Accessors(NONE) val (Toolchain, SubMonitor, Integer)=>void task

	def run(Toolchain toolchain, SubMonitor monitor) {
		monitor.taskName = taskName
		task.apply(toolchain, monitor, progress)
	}
}