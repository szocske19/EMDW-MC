package com.incquerylabs.emdw.cpp.bodyconverter.test.single

import java.util.Collection
import org.junit.runners.Parameterized.Parameters

class StateExitConvertingTest extends AbstractSingleConversionTest{
	@Parameters(name = "{0}")
	def static Collection<Object[]> testData() {
		newArrayList(
			#[  "Send new signal from state exit action",
				"/com.incquerylabs.emdw.cpp.bodyconverter.test/models/PingPongSpecial/model.uml",
				"model::Comp::Ping::Ping_SM::Region1::s1",
				ConversionType.StateExit,
				'''
				send new Pong::ping_s() to this->pong.one();
				''',
				'''
				::model::Comp::Pong::ping_s_event* __ralf__0__ping_s = new ::model::Comp::Pong::ping_s_event();

				::xumlrt::select_any(this->R1_pong)->generate_external_event(__ralf__0__ping_s);'''
			],
			#[  "Re-send sigdata from state exit action",
				"/com.incquerylabs.emdw.cpp.bodyconverter.test/models/PingPongSpecial/model.uml",
				"model::Comp::Ping::Ping_SM::Region1::s1",
				ConversionType.StateExit,
				'''
				send sigdata to this->pong.one();
				''',
				'''
				::model::Comp::Ping::pong_s_event* __ralf__0__pong_s = casted_const_event->clone();
				::xumlrt::select_any(this->R1_pong)->generate_external_event(__ralf__0__pong_s);''' // FIXME: Is __ralf__1__pong_s' type a pointer?
			],
			#[  "Create and initialize new signal",
				"/com.incquerylabs.emdw.cpp.bodyconverter.test/models/ClientServer/clientserver.uml",
				"ClientServer::Component::Client::Behavior::MainRegion::Ready",
				ConversionType.StateExit,
				'''
				ClientServer::Component::Server::RequestAddition request = new ClientServer::Component::Server::RequestAddition(id=>sigdata.id+1, a=>3, b=>9);
				''',
				'''
				::ClientServer::Component::Server::RequestAddition_event* __ralf__0__request = new ::ClientServer::Component::Server::RequestAddition_event();
				__ralf__0__request->id = (casted_const_event->id + 1);
				__ralf__0__request->a = 3;
				__ralf__0__request->b = 9;'''
			]
		)
	}
}

