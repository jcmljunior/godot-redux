extends Node

@onready var initial_setup: Dictionary = {
	"state":
	{
		"name": "",
		"age": 0,
	},
	"method": people_reducer,
	"accept_action": [PeopleConstants.PEOPLE_SET_NAME],
	"listeners": []
}


func people_reducer(state: Dictionary, action: Dictionary) -> Dictionary:
	var new_state = Store.shallow_copy(state)

	match action.get("type"):
		PeopleConstants.PEOPLE_SET_NAME:
			new_state["name"] = (
				PeopleActions
				. people_set_name(action.get("payload").get("people").get("name"))
				. get("payload")
				. get("people")
				. get("name")
			)

			return new_state

		_:
			return state
