extends Node

# Exibe uma mensagem no console informando a ação disparada assim como os respectivos valores modificado.
var show_increment_counter = func(current_state: int, next_state: int) -> bool:
	print("A ação %s foi executada alterando o seu valor de estado de %s para %s." % [ CounterConstants.INCREMENT_COUNTER, current_state, next_state ])
	
	return true

var show_decrement_counter = func(current_state: int, next_state: int) -> bool:
	print("A ação %s foi executada alterando o seu valor de estado de %s para %s." % [ CounterConstants.DECREMENT_COUNTER, current_state, next_state ])
	
	return true

var block_counter_when_value_equals_zero = func(current_state: int, next_state: int) -> bool:
	if current_state == 0:
		print("Uma ou mais ações foram  bloqueadas por um middleware.")
		
		return false
	
	return true
