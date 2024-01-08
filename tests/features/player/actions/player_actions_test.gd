extends GutTest

class TestPlayerActions:
	extends GutTest
	
	var state = {
		"name": "",
		"age": 0,
	}
	
	func test_player_set_name():
		var response = PlayerReducers.get("player_reducer").call(state, PlayerActions.player_set_name(state.get("name")))
		assert_has(response, "name", "O teste falhou porque a chave name não existe.")
		assert_true(state.get("name") != response.get("name"), "O teste falhou porque é esperado uma resposta diferente de %s" % state.get("name"))
	
	func test_player_set_age():
		var response = PlayerReducers.get("player_reducer").call(state, PlayerActions.player_set_age(state.get("age")))
		assert_has(response, "age", "O teste falhou porque a chave age não existe.")
		assert_true(response.get("age") > state.get("age"), "O teste falhou porque é esperado uma resposta maior que 0")
