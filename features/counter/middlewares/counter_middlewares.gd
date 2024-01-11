extends Node


func show_increment_counter(current_state: int, next_state: int) -> bool:
	print(
		(
			"A função %s foi executada modificando o estado de: %s para: %s."
			% ["increment_counter", current_state, next_state]
		)
	)

	return true


func show_decrement_counter(current_state: int, next_state: int) -> bool:
	print(
		(
			"A função %s foi executada modificando o estado de: %s para: %s."
			% ["decrement_counter", current_state, next_state]
		)
	)

	return true


# Bloqueia a subtração do contador se o estado atual for 0.
func lock_decrement_counter(_current_state: int, next_state: int) -> bool:
	if next_state < 0:
		print(
			"A função decrement_counter foi executada mas a sua ação foi bloqueada por um método ouvinte."
		)
		return false

	return true
