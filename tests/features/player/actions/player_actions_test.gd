extends GutTest

class TestPlayerActions:
	extends GutTest
	
	var mock_player_name = {
		"player": {
			"name": "",
		}
	}
	
	var mock_player_age = {
		"player": {
			"age": 0,
		}
	}
	
	func test_player_set_name():
		var response: Dictionary = PlayerReducers.player_reducer(
			mock_player_name,
			PlayerActions.player_set_name(mock_player_name.get("player").get("name")))
		
		# Validações de parametros necessários para execução.
		assert_has(response, "payload")
		assert_has(response, "type")
		assert_has(response.get("payload"), "player")
		assert_has(response.get("payload").get("player"), "name")
		
		# Validação da resposta.
		assert_typeof(response.get("payload").get("player").get("name"), TYPE_STRING)
		assert_true(response.get("payload").get("player").get("name") != "")
		
	
	func test_player_set_age():
		var response: Dictionary = PlayerReducers.player_reducer(
			mock_player_age,
			PlayerActions.player_set_age(mock_player_age.get("player").get("age"))
		)
		
		# Validações de parametros necessários para execução.
		assert_has(response, "payload")
		assert_has(response, "type")
		assert_has(response.get("payload"), "player")
		assert_has(response.get("payload").get("player"), "age")
		
		# Validação da resposta.
		assert_typeof(response.get("payload").get("player").get("age"), TYPE_INT)
