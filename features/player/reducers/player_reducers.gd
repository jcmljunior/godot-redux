extends Node

@onready var initial_setup: Dictionary = {
	"state": {
		"player": {
			"name": "",
			"age": 0,
		},
	},
	"method": player_reducer,
	"accept_action": [
		PlayerConstants.PLAYER_SET_NAME,
		PlayerConstants.PLAYER_SET_AGE,
	],
	"listeners": [],
	"middlewares": [
		{
			"type": PlayerConstants.PLAYER_SET_NAME,
			"method": PlayerMiddlewares.show_player_set_name,
			"on": "load",
		},
		{
			"type": PlayerConstants.PLAYER_SET_AGE,
			"method": PlayerMiddlewares.show_player_set_age,
			"on": "load",
		},
	],
}

func player_reducer(state: Dictionary, action: Dictionary) -> Dictionary:
	var new_state = Store.shallow_copy(state)
	
	match(action.get("type")):
		PlayerConstants.PLAYER_SET_NAME:
			new_state["name"] = PlayerActions.player_set_name(state.get("name")).get("payload").get("player").get("name")
			return new_state
		
		PlayerConstants.PLAYER_SET_AGE:
			new_state["age"] = PlayerActions.player_set_age(state.get("age")).get("payload").get("player").get("age")
			return new_state
		
		_:
			return state
