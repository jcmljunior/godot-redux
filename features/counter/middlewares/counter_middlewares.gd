extends Node

func show_increment_counter(state: Array) -> Callable:
	var initial_state: Variant = state[0][0]
	var next_state: Variant = state[0][1]
	
	print("A função increment_counter foi executada modificando o estado de: %a para: %b.".replace("%a", str(initial_state)).replace("%b", str(next_state)))
	
	return func():
		pass

func show_decrement_counter(state: Array) -> Callable:
	var initial_state: Variant = state[0][0]
	var next_state: Variant = state[0][1]
	
	print("A função decrement_counter foi executada modificando o estado de: %a para: %b.".replace("%a", str(initial_state)).replace("%b", str(next_state)))
	
	return func():
		pass
