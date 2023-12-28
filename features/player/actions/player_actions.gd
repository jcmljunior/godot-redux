extends Node

func player_set_name(state: String) -> Dictionary:
	return {
		"type": PlayerConstants.PLAYER_SET_NAME,
		"payload": {
			"player": {
				"name": state,
			}
		}
	}

func player_set_age(state: int) -> Dictionary:
	return {
		"type": PlayerConstants.PLAYER_SET_AGE,
		"payload": {
			"player": {
				"age": state,
			}
		}
	}
