namespace Test_FSM{
namespace Test_Component{
namespace Test_Package{

class TEST : public ::StatefulClass {

public:

	
	// Constructors
	TEST();
	
	// Destructor
	virtual ~TEST();
	
	void perform_initialization();
	
	// Attributes
	long myInt;
	
	// Associations
	
	// Component reference
	::Test_FSM::Test_Component::CompMain* _comp;
	
	// Operation declarations
	
	enum TEST_state {
		TEST_STATE_TERMINATE,
		TEST_STATE_myState1,
		TEST_STATE_myState2,
		TEST_STATE_myState3,
		TEST_STATE_myState4,
		TEST_STATE_myState5
	};
	
	enum TEST_event {
		TEST_EVENT_mySignal1,
		TEST_EVENT_mySignal2,
		TEST_EVENT_mySignal3
	};
	
	class mySignal1_event : public ::Event {
		public:
			mySignal1_event(bool isInternal);
	};
	class mySignal2_event : public ::Event {
		public:
			mySignal2_event(bool isInternal);
	};
	class mySignal3_event : public ::Event {
		public:
			mySignal3_event(bool isInternal);
	};
	
	
	TEST_state current_state;
	
	virtual void generate_event(const ::Event* e);
	virtual void process();
	
	void process_event(const ::Event* event);

protected:

	// Constructors
	
	// Destructor
	
	// Attributes
	
	// Operation declarations

private:

	// Deny copy of the class using copy constructor
	TEST(const TEST&);
	
	// Deny copy of the class using assignment
	TEST& operator=(const TEST&);
	
	static ::std::list< TEST* > _instances;
	
	static const unsigned short type_id = 1;
	
	virtual unsigned short get_type_id() const {
		return type_id;
	}
	
	// Constructors
	
	// Destructor
	
	// Attributes
	
	// Operation declarations
	
	// myState1 state
	void perform_entry_action_for_myState1_state(const ::Event* event);
	
	void process_event_in_myState1_state(const ::Event* event);
	
	void perform_actions_on_myT13_transition_from_myState1_to_myState3(const ::Event* event);
	// myState2 state
	void perform_entry_action_for_myState2_state(const ::Event* event);
	
	void process_event_in_myState2_state(const ::Event* event);
	
	void perform_actions_on_myT24_transition_from_myState2_to_myState4(const ::Event* event);
	void perform_exit_action_for_myState2_state(const ::Event* event);
	// myState3 state
	
	void process_event_in_myState3_state(const ::Event* event);
	
	void perform_actions_on_myT35_transition_from_myState3_to_myState5(const ::Event* event);
	bool evaluate_guard_on_myT34_transition_from_myState3_to_myState4(const ::Event* event);
	void perform_exit_action_for_myState3_state(const ::Event* event);
	// myState4 state
	
	void process_event_in_myState4_state(const ::Event* event);
	
	// myState5 state
	void perform_entry_action_for_myState5_state(const ::Event* event);
	
	void process_event_in_myState5_state(const ::Event* event);
	
	void perform_actions_on_myT5F_transition_from_myState5_to_TERMINATE(const ::Event* event);
	// State queues
	::std::queue<const ::Event*> _internalEvents, _externalEvents;
}; /* class TEST */
} /* namespace Test_FSM */
} /* namespace Test_Component */
} /* namespace Test_Package */

