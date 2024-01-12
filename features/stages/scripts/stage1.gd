extends Node

@onready
var counter_label = $Counter/MarginContainer/TabContainer/Contador/VBoxContainer/CounterLabel

var store = Store.get_instance()


func _ready():
	store.get("register").call(CounterReducer.initial_setup)
	store.get("add_listener").call(
		"counter",
		[CounterConstants.INCREMENT_COUNTER, CounterConstants.DECREMENT_COUNTER],
		_on_update_counter
	)


# Atualiza o contador.
func _on_update_counter(current_state, next_state) -> bool:
	counter_label.text = str(next_state)

	return true


func _on_increment_button_pressed():
	store.get("dispatch").call([CounterActions.increment_counter.call()] as Array[Dictionary])


func _on_decrement_button_pressed():
	store.get("dispatch").call([CounterActions.decrement_counter.call()] as Array[Dictionary])
