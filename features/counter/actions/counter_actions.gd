extends Node

func increment_counter(state: int, action: Dictionary) -> Dictionary:
	return {
		"type": "",
		"payload": {
			"counter": state,
		}
	}

func decrement_counter(state: int, action: Dictionary) -> Dictionary:
	return {
		"type": "",
		"payload": {
			"counter": state,
		}
	}

func reset_counter(state: int, action: Dictionary) -> Dictionary:
	return {
		"type": "",
		"payload": {
			"counter": state,
		}
	}
