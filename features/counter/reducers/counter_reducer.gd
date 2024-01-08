extends Node

@onready var initial_setup: Dictionary = {
	"state": {
		"counter": 0,
	},
	"method": counter_reducer,
	"accept_action": [
		CounterConstants.INCREMENT_COUNTER,
		CounterConstants.DECREMENT_COUNTER,
	],
	"listeners": [],
	"middlewares": [
		{
			"type": CounterConstants.INCREMENT_COUNTER,
			"method": CounterMiddlewares.show_increment_counter,
			"on": "load",
		},
		{
			"type": CounterConstants.DECREMENT_COUNTER,
			"method": CounterMiddlewares.lock_decrement_counter,
			"on": "ready",
		},
		{
			"type": CounterConstants.DECREMENT_COUNTER,
			"method": CounterMiddlewares.show_decrement_counter,
			"on": "load",
		},
	],
}

func counter_reducer(state: int, action: Dictionary) -> int:
	match (action.get("type")):
		CounterConstants.INCREMENT_COUNTER:
			var response: Dictionary = CounterActions.increment_counter(state)
			return response.get("payload").get("counter")
		
		CounterConstants.DECREMENT_COUNTER:
			var response: Dictionary = CounterActions.decrement_counter(state)
			return response.get("payload").get("counter")
		
		_:
			return state
