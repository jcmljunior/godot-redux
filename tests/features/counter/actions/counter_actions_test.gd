extends GutTest

class TestCounterActions:
	extends GutTest
	
	var mock_counter := {
		"counter": 10,
	}
	
	func test_increment_counter():
		var response: Dictionary = CounterReducers.counter_reducer(
			mock_counter.get("counter"),
			CounterActions.increment_counter(mock_counter.get("counter")))
		
		# Validações de parametros necessários para execução.
		assert_has(response, "payload")
		assert_has(response, "type")
		assert_has(response.get("payload"), "counter")
		
		# Validação da incrementação do contador.
		assert_eq(response.get("payload").get("counter"), mock_counter.get("counter")+1)

	func test_decrement_counter():
		var response: Dictionary = CounterReducers.counter_reducer(
			mock_counter.get("counter"),
			CounterActions.decrement_counter(mock_counter.get("counter")))
		
		# Validações de parametros necessários para execução.
		assert_has(response, "payload")
		assert_has(response, "type")
		assert_has(response.get("payload"), "counter")
		
		# Validação da incrementação do contador.
		assert_eq(response.get("payload").get("counter"), mock_counter.get("counter")-1)
