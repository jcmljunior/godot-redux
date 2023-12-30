extends Control

@onready var counter_label = $PanelContainer/MarginContainer/TabContainer/Counter/BoxContainer/MarginContainer/BoxContainer/GridContainer/CounterLabel
@onready var player_name_label = $PanelContainer/MarginContainer/TabContainer/Player/BoxContainer/MarginContainer/BoxContainer/GridContainer/GridContainer/PlayerNameLabel
@onready var player_age_label = $PanelContainer/MarginContainer/TabContainer/Player/BoxContainer/MarginContainer/BoxContainer/GridContainer/GridContainer/PlayerAgeLabel

func _ready() -> void:
	Store \
		.create(CounterReducers.initial_setup) \
		.create(PlayerReducers.initial_setup)
	
	Store \
		.subscribe("counter", _on_update_counter, CONNECT_PERSIST) \
		.subscribe("player", _on_update_player, CONNECT_PERSIST)


func _on_update_counter():
	counter_label.text = str(Store.get_entry_on_state("counter"))

func _on_update_player():
	player_name_label.text = str(Store.get_entry_on_state("player").get("name"))
	player_age_label.text = str(Store.get_entry_on_state("player").get("age"))

func _on_increment_button_pressed():
	Store.dispatch(CounterActions.increment_counter(
		Store.get_entry_on_state("counter")
	))


func _on_decrement_button_pressed():
	Store.dispatch(CounterActions.decrement_counter(
		Store.get_entry_on_state("counter")
	))


func _on_generate_player_button_pressed():
	var player: Dictionary = Store.get_entry_on_state("player")
	
	Store.dispatch(PlayerActions.player_set_name(player.get("name")))
	Store.dispatch(PlayerActions.player_set_age(player.get("age")))


func _on_reset_button_pressed():
	print("...")
