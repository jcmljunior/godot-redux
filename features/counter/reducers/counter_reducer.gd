extends Node

const initial_state: Dictionary = {
	"state": {
		"counter": 0,
	},
	"method": "",
	"accept_action": [],
	"middlewares": [],
}

func counter_reducer(state: int, action: Dictionary) -> Dictionary:
	return {
		"type": "",
		"payload": {
			"counter": state,
		}
	}
