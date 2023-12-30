extends Node

func increment_counter(state: int) -> Dictionary:
	return {
		"type": CounterConstants.INCREMENT_COUNTER,
		"payload": {
			"counter": state+1,
		}
	}

func decrement_counter(state: int) -> Dictionary:
	return {
		"type": CounterConstants.DECREMENT_COUNTER,
		"payload": {
			"counter": state-1,
		}
	}

func reset_counter(state: int, action: Dictionary) -> Dictionary:
	return {
		"type": CounterConstants.RESET_COUNTER,
		"payload": {
			"counter": state,
		}
	}
