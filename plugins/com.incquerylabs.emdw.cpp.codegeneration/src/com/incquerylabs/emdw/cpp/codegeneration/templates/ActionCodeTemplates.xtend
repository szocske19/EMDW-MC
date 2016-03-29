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
package com.incquerylabs.emdw.cpp.codegeneration.templates

import com.incquerylabs.emdw.snippettemplate.Snippet
import com.incquerylabs.emdw.snippettemplate.serializer.ReducedAlfSnippetTemplateSerializer
import org.eclipse.incquery.runtime.api.IncQueryEngine

class ActionCodeTemplates extends CPPTemplate {
	extension val ReducedAlfSnippetTemplateSerializer ralfSerializer = new ReducedAlfSnippetTemplateSerializer
	
	new(IncQueryEngine engine) {
		super(engine)
	}
	
	def CharSequence generateActionCode(Snippet snippet) {
		if(snippet!= null){
			return snippet.serialize
		}
	}
}
