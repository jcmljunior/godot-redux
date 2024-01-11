extends Control

@onready
var counter_label = $PanelContainer/MarginContainer/TabContainer/Counter/BoxContainer/MarginContainer/BoxContainer/GridContainer/CounterLabel

var setup = preload("res://features/store/scripts/store.gd").new().get_instance()


func _ready() -> void:
	setup.get("register").call(CounterReducer.initial_setup)

	# Chave de armazenamento.
	# Ações onde será executado.
	# Método a ser executado.
	# Quando será executado.
	setup.get("add_listener").call(
		"counter",
		[CounterConstants.INCREMENT_COUNTER, CounterConstants.DECREMENT_COUNTER],
		_on_update_counter,
		"load"
	)

	#setup.get("remove_listener").call(_on_update_counter)


func _on_update_counter(_current_state: int, next_state: int) -> bool:
	counter_label.text = str(next_state)

	return true


func _on_update_player(current_state, next_state) -> bool:
	print(current_state)
	print(next_state)

	return true


func _on_increment_button_pressed() -> void:
	setup.get("dispatch").call(
		[CounterActions.increment_counter(setup.get("get_state").get("counter"))]
	)


func _on_decrement_button_pressed() -> void:
	setup.get("dispatch").call(
		[CounterActions.decrement_counter(setup.get("get_state").get("counter"))]
	)
