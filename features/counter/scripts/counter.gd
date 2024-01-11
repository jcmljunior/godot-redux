extends Control

@onready
var counter_label = $PanelContainer/MarginContainer/TabContainer/Contador/BoxContainer/MarginContainer/BoxContainer/GridContainer/CounterLabel
@onready
var people_name_label_2 = $PanelContainer/MarginContainer/TabContainer/Pessoa/MarginContainer/BoxContainer/VBoxContainer/HBoxContainer/PeopleNameLabel2

var setup = Store.get_instance()


func _ready() -> void:
	setup.get("register").call(CounterReducer.initial_setup)
	setup.get("register").call(PeopleReducer.initial_setup)

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

	setup.get("add_listener").call(
		"people", [PeopleConstants.PEOPLE_SET_NAME], _on_update_people, "load"
	)

	#setup.get("remove_listener").call(_on_update_counter)


func _on_update_counter(_current_state: int, next_state: int) -> bool:
	counter_label.text = str(next_state)

	return true


func _on_update_people(current_state, next_state) -> bool:
	people_name_label_2.text = str(next_state.get("name"))

	print(
		(
			"A função people_set_name foi executada modificando o estado de: %s para: %s."
			% [current_state.get("name"), next_state.get("name")]
		)
	)

	return true


func _on_increment_button_pressed() -> void:
	setup.get("dispatch").call(
		[CounterActions.increment_counter(setup.get("get_state").get("counter"))]
	)


func _on_decrement_button_pressed() -> void:
	setup.get("dispatch").call(
		[CounterActions.decrement_counter(setup.get("get_state").get("counter"))]
	)


func _on_people_button_pressed():
	setup.get("dispatch").call(
		[PeopleActions.people_set_name(setup.get("get_state").get("people").get("name"))]
	)
