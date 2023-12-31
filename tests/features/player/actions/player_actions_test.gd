extends GutTest

class MockPlayer:
	const PLAYER_SET_NAME := "PLAYER_SET_NAME"
	const PLAYER_SET_AGE := "PLAYER_SET_AGE"
	const state: Dictionary = {
		"player": {
			"name": "",
			"age": 0,
		}
	}
	
	func player_set_name(name: String) -> Dictionary:
		return {
			"type": PLAYER_SET_NAME,
			"payload": {
				"player": {
					"name": name,
				}
			}
		}

	func player_set_age(age: int) -> Dictionary:
		return {
			"type": PLAYER_SET_AGE,
			"payload": {
				"player": {
					"age": age,
				}
			}
		}
		
	func reducer(state: Dictionary, action: Dictionary) -> Dictionary:
		match(action.get("type")):
			PLAYER_SET_NAME:
				return player_set_name(action.get("payload").get("player").get("name"))
				
			PLAYER_SET_AGE:
				return player_set_age(action.get("payload").get("player").get("age"))
				
			_:
				return {
					"type": "",
					"payload": state,
				}

class TestPlayerActions:
	extends GutTest
	
	var Mock = MockPlayer.new()
	var player_name := "Amanda"
	var player_age := 18
	
	func test_player_set_name():
		var response = Mock.reducer(Mock.get("state"), Mock.player_set_name(player_name))

		# Validações de parametros necessários para execução.
		assert_has(response, "payload")
		assert_has(response, "type")
		assert_has(response.get("payload"), "player")
		assert_has(response.get("payload").get("player"), "name")
		
		# Validação da resposta.
		assert_typeof(response.get("payload").get("player").get("name"), TYPE_STRING)
		assert_true(response.get("payload").get("player").get("name") == player_name)
		
	
	func test_player_set_age():
		var response = Mock.reducer(Mock.get("state"), Mock.player_set_age(player_age))
		
		## Validações de parametros necessários para execução.
		assert_has(response, "payload")
		assert_has(response, "type")
		assert_has(response.get("payload"), "player")
		assert_has(response.get("payload").get("player"), "age")
		#
		## Validação da resposta.
		assert_typeof(response.get("payload").get("player").get("age"), TYPE_INT)
		assert_true(response.get("payload").get("player").get("age") > Mock.get("state").get("player").get("age"))
