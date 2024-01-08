extends Node

func player_set_name(_state: String) -> Dictionary:
	return {
		"type": PlayerConstants.PLAYER_SET_NAME,
		"payload": {
			"player": {
				"name": PlayerUtils.generate_player_name(),
			}
		}
	}

func player_set_age(_state: int) -> Dictionary:
	return {
		"type": PlayerConstants.PLAYER_SET_AGE,
		"payload": {
			"player": {
				"age": PlayerUtils.generate_player_age(),
			}
		}
	}
