extends Node

func show_increment_counter(state: Array) -> bool:
	var initial_state: Variant = state[0][0]
	var next_state: Variant = state[0][1]
	
	print("A função increment_counter foi executada modificando o estado de: %a para: %b.".replace("%a", str(initial_state)).replace("%b", str(next_state)))
	
	return true

func show_decrement_counter(state: Array) -> bool:
	var initial_state: Variant = state[0][0]
	var next_state: Variant = state[0][1]
	
	print("A função decrement_counter foi executada modificando o estado de: %a para: %b.".replace("%a", str(initial_state)).replace("%b", str(next_state)))
	
	return true

func lock_decrement_counter(state: Array) -> bool:
	var next_state: Variant = state[0][1]
	
	if next_state < 0:
		print("A função decrement_counter foi executada mas sua modificação de estado foi bloqueada por um middleware.")
		
		return false
		
	return true
