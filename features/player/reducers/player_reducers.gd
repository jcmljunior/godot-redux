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
	match(action.get("type")):
		PlayerConstants.PLAYER_SET_NAME:
			return PlayerActions.player_set_name(
				PlayerUtils.generate_player_name()
			)
		
		PlayerConstants.PLAYER_SET_AGE:
			return PlayerActions.player_set_age(
				PlayerUtils.generate_player_age()
			)
		
		_:
			return {
				"type": "",
				"payload": {
					"player": state,
				}
			}
