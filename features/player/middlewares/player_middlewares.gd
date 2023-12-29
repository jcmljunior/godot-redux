extends Node

func show_player_set_name(state: Array) -> bool:
	var initial_state: Variant = state[0][0]
	var next_state: Variant = state[0][1]
	
	print("A função player_set_name foi executada modificando o estado de: %a para: %b.".replace("%a", str(initial_state)).replace("%b", str(next_state)))
	
	return true

func show_player_set_age(state: Array) -> bool:
	var initial_state: Variant = state[0][0]
	var next_state: Variant = state[0][1]
	
	print("A função player_set_age foi executada modificando o estado de: %a para: %b.".replace("%a", str(initial_state)).replace("%b", str(next_state)))
	
	return true
