extends Node

@onready var initial_setup: Dictionary = {
	"state": 0,
	"method": counter_reducer,
	"accept_action":
	[
		CounterConstants.INCREMENT_COUNTER,
		CounterConstants.DECREMENT_COUNTER,
	],
	"listeners":
	[
		{
			"type":
			[
				CounterConstants.INCREMENT_COUNTER,
			],
			"method": CounterMiddlewares.show_increment_counter,
			"on": Store.ListenerEventMode.ON_LOAD,
		},
		{
			"type":
			[
				CounterConstants.DECREMENT_COUNTER,
			],
			"method": CounterMiddlewares.lock_decrement_counter,
			"on": Store.ListenerEventMode.ON_READY,
		},
		{
			"type":
			[
				CounterConstants.DECREMENT_COUNTER,
			],
			"method": CounterMiddlewares.show_decrement_counter,
			"on": Store.ListenerEventMode.ON_LOAD,
		},
	],
}


func counter_reducer(state: int, action: Dictionary) -> int:
	match action.get("type"):
		CounterConstants.INCREMENT_COUNTER:
			var response: Dictionary = CounterActions.increment_counter(state)
			return response.get("payload").get("counter")

		CounterConstants.DECREMENT_COUNTER:
			var response: Dictionary = CounterActions.decrement_counter(state)
			return response.get("payload").get("counter")

		_:
			return state
