/*******************************************************************************
 * Copyright (c) 2015-2016 IncQuery Labs Ltd. and Ericsson AB
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     Akos Horvath, Abel Hegedus, Zoltan Ujhelyi, Adam Balogh - initial API and implementation
 *******************************************************************************/
/**
 */
package com.ericsson.executablemodeling.xtuml.profile.xtumlprofile.impl;

import com.ericsson.executablemodeling.xtuml.profile.executablemodelingprofile.impl.XTriggerImpl;

import com.ericsson.executablemodeling.xtuml.profile.xtumlprofile.XtTrigger;

import com.ericsson.executablemodeling.xtuml.profile.xtumlprofile.util.xtUMLProfileValidator;

import com.ericsson.executablemodeling.xtuml.profile.xtumlprofile.xtUMLProfilePackage;

import java.lang.reflect.InvocationTargetException;

import java.util.Map;

import org.eclipse.emf.common.util.BasicDiagnostic;
import org.eclipse.emf.common.util.Diagnostic;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;

import org.eclipse.emf.ecore.plugin.EcorePlugin;

import org.eclipse.emf.ecore.util.EObjectValidator;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Xt Trigger</b></em>'.
 * <!-- end-user-doc -->
 *
 * @generated
 */
public class XtTriggerImpl extends XTriggerImpl implements XtTrigger {
	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected XtTriggerImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return xtUMLProfilePackage.Literals.XT_TRIGGER;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public boolean xtTriggerEvent(DiagnosticChain diagnostics, Map<Object, Object> context) {
		// TODO: implement this method
		// -> specify the condition that violates the invariant
		// -> verify the details of the diagnostic, including severity and message
		// Ensure that you remove @generated or mark it @generated NOT
		if (false) {
			if (diagnostics != null) {
				diagnostics.add
					(new BasicDiagnostic
						(Diagnostic.ERROR,
						 xtUMLProfileValidator.DIAGNOSTIC_SOURCE,
						 xtUMLProfileValidator.XT_TRIGGER__XT_TRIGGER_EVENT,
						 EcorePlugin.INSTANCE.getString("_UI_GenericInvariant_diagnostic", new Object[] { "xtTriggerEvent", EObjectValidator.getObjectLabel(this, context) }),
						 new Object [] { this }));
			}
			return false;
		}
		return true;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	@SuppressWarnings("unchecked")
	public Object eInvoke(int operationID, EList<?> arguments) throws InvocationTargetException {
		switch (operationID) {
			case xtUMLProfilePackage.XT_TRIGGER___XT_TRIGGER_EVENT__DIAGNOSTICCHAIN_MAP:
				return xtTriggerEvent((DiagnosticChain)arguments.get(0), (Map<Object, Object>)arguments.get(1));
		}
		return super.eInvoke(operationID, arguments);
	}

} //XtTriggerImpl
