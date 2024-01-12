extends Node

var increment_counter = func() -> Dictionary:
	return {
		"type": CounterConstants.INCREMENT_COUNTER,
	}

var decrement_counter = func() -> Dictionary:
	return {
		"type": CounterConstants.DECREMENT_COUNTER,
	}
