package com.incquerylabs.emdw.cpp.bodyconverter.test.multiple

import org.junit.runner.RunWith
import org.junit.runners.Suite
import org.junit.runners.Suite.SuiteClasses

@SuiteClasses(#[
	PhoneXMultipleConversionTest,
	EATFMultipleConversionTest
])
@RunWith(Suite)
class MultipleConversionTestSuite {}