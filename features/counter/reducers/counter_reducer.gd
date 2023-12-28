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
			"method": CounterMiddlewares.show_decrement_counter,
			"on": "load",
		},
	],
}

func counter_reducer(state: int, action: Dictionary) -> Dictionary:
	match (action.get("type")):
		CounterConstants.INCREMENT_COUNTER:
			return CounterActions.increment_counter(state)
		
		CounterConstants.DECREMENT_COUNTER:
			return CounterActions.decrement_counter(state)
		
		_:
			return {
				"type": "",
				"payload": {
					"counter": state,
				}
			}
