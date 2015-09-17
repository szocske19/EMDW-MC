package com.incquerylabs.uml.ralf.api;

import org.eclipse.uml2.uml.OpaqueBehavior;

import com.incquerylabs.emdw.snippettemplate.Snippet;
import com.incquerylabs.uml.ralf.api.impl.ParsingResults;
import com.incquerylabs.uml.ralf.api.impl.SnippetCompilerException;
import com.incquerylabs.uml.ralf.scoping.IUMLContextProvider;
import com.incquerylabs.uml.ralf.snippetcompiler.ReducedAlfSnippetTemplateCompiler;

public interface IReducedAlfGenerator {
    
    /**
     * Creates a C++ snippet based on the defined rALF code using the provided rALF parser.
     * @param behavior String containing the rALF code
     * @param parser Parser used for parsing the rALF code
     * @return
     */
    Snippet createSnippet(String behavior, IUMLContextProvider contextProvider, IReducedAlfParser parser, ReducedAlfSnippetTemplateCompiler templateCompiler) throws SnippetCompilerException;
    
    /**
     * Creates a C++ snippet based on the the rALF code, which is contained by the specified opaque behavior 
     * using the provided rALF parser.
     * @param behavior Opaque behavior containing the rALF code
     * @param parser Parser used for parsing the rALF code
     * @return
     */
    Snippet createSnippet(OpaqueBehavior behavior, IUMLContextProvider contextProvider, IReducedAlfParser parser, ReducedAlfSnippetTemplateCompiler templateCompiler) throws SnippetCompilerException;
    
    /**
     * Creates a C++ snippet based on a given rALF AST.
     */
    Snippet createSnippet(ParsingResults result, IUMLContextProvider contextProvider, ReducedAlfSnippetTemplateCompiler templateCompiler) throws SnippetCompilerException;
}
