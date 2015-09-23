package com.incquerylabs.emdw.cpp.bodyconverter.test.single

import java.util.Collection
import org.junit.runners.Parameterized.Parameters

class CollectionDescriptorTest extends AbstractSingleConversionTest {
	@Parameters(name = "{0}")
	def static Collection<Object[]> testData() {
		newArrayList(
			#[
				"Set creation with default literal values test",
				"/com.incquerylabs.emdw.cpp.bodyconverter.test/models/PingPongSpecial/model.uml",
				"model::Comp::Pong::sendPing",
				ConversionType.Operation,
				'''
				Set<Integer> p = Set<Integer>{1, 2, 3};
				''',
				'''
				::std::set< long > __ralf__0____std__set = { 1, 2, 3 };
				::std::set< long > __ralf__0__p = __ralf__0____std__set;'''
			],
			#[
				"Set creation with default variable values test",
				"/com.incquerylabs.emdw.cpp.bodyconverter.test/models/PingPongSpecial/model.uml",
				"model::Comp::Pong::sendPing",
				ConversionType.Operation,
				'''
				Integer i = 0;
				Set<Integer> p = Set<Integer>{i};
				''',
				'''
				long __ralf__0__i = 0;
				::std::set< long > __ralf__1____std__set = { __ralf__0__i };
				::std::set< long > __ralf__1__p = __ralf__1____std__set;'''
			],
			#[
				"Set creation with default literal and variable values test",
				"/com.incquerylabs.emdw.cpp.bodyconverter.test/models/PingPongSpecial/model.uml",
				"model::Comp::Pong::sendPing",
				ConversionType.Operation,
				'''
				Integer i = 0;
				Set<Integer> p = Set<Integer>{i, 1, 2, 3};
				''',
				'''
				long __ralf__0__i = 0;
				::std::set< long > __ralf__1____std__set = { 1, 2, 3, __ralf__0__i };
				::std::set< long > __ralf__1__p = __ralf__1____std__set;'''
			],
			#[  "Unlink expression collection test",
				"/com.incquerylabs.emdw.cpp.bodyconverter.test/models/PhoneX/phonex.uml",
				"PhoneX::PhoneX::Implementation::Call::CallStateMachine::DefaultRegion::Terminated",
				ConversionType.StateEntry,
				'''
				Service service = this->'service'.one();
				R6::unlink('service'=>service,'call'=>this);
				''',
				'''
				::PhoneX::PhoneX::Implementation::Service* __ralf__1__Service = ::xtuml::select_any(this->R6_service);
				::PhoneX::PhoneX::Implementation::Service* __ralf__0__service = __ralf__1__Service;
				::std::list< ::PhoneX::PhoneX::Implementation::Call* > __ralf__3____std__list = __ralf__0__service->R6_call;
				__ralf__3____std__list.remove(this);
				this->R6_service = NULL;'''
			],
			#[  "Link expression collection test",
				"/com.incquerylabs.emdw.cpp.bodyconverter.test/models/PhoneX/phonex.uml",
				"PhoneX::PhoneX::Implementation::Call::CallStateMachine::DefaultRegion::Terminated",
				ConversionType.StateEntry,
				'''
				Service service = this->'service'.one();
				R6::link('call'=>this,'service'=>service);
				''',
				'''
				::PhoneX::PhoneX::Implementation::Service* __ralf__1__Service = ::xtuml::select_any(this->R6_service);
				::PhoneX::PhoneX::Implementation::Service* __ralf__0__service = __ralf__1__Service;
				this->R6_service = __ralf__0__service;
				::std::list< ::PhoneX::PhoneX::Implementation::Call* > __ralf__3____std__list = __ralf__0__service->R6_call;
				__ralf__3____std__list.push_back(this);
				bool __ralf__2__bool = true;'''
			]
		)
	}
}