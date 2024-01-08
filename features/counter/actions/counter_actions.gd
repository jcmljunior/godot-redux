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

