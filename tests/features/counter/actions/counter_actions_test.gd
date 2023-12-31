extends GutTest

class MockCounter:
	
	const INCREMENT_COUNTER := "INCREMENT_COUNTER"
	const DECREMENT_COUNTER := "DECREMENT_COUNTER"
	
	var state := {
		"counter": 10,
	}

	func increment_counter(state: int) -> Dictionary:
		return {
			"type": INCREMENT_COUNTER,
			"payload": {
				"counter": state,
			}
		}
		
	func decrement_counter(state: int) -> Dictionary:
		return {
			"type": DECREMENT_COUNTER,
			"payload": {
				"counter": state,
			}
		}
	
	func reducer(state: int, action: Dictionary) -> Dictionary:
		match(action.get("type")):
			INCREMENT_COUNTER:
				return increment_counter(state+1)
				
			DECREMENT_COUNTER:
				return decrement_counter(state-1)
			
			_:
				return {
					"type": "",
					"payload": {
						"counter": state,
					}
				}

class TestCounterActions:
	extends GutTest
	
	var Mock = MockCounter.new()
	
	func test_increment_counter():
		var response: Dictionary = Mock.reducer(Mock.get("state").get("counter"),
			Mock.increment_counter(Mock.get("state").get("counter")))
		
		# Validações de parametros necessários para execução.
		assert_has(response, "payload")
		assert_has(response, "type")
		assert_has(response.get("payload"), "counter")
		
		# Validação da incrementação do contador.
		assert_eq(response.get("payload").get("counter"), Mock.get("state").get("counter")+1)

	func test_decrement_counter():
		var response: Dictionary = Mock.reducer(Mock.get("state").get("counter"),
			Mock.decrement_counter(Mock.get("state").get("counter")))
		
		# Validações de parametros necessários para execução.
		assert_has(response, "payload")
		assert_has(response, "type")
		assert_has(response.get("payload"), "counter")
		
		# Validação da incrementação do contador.
		assert_eq(response.get("payload").get("counter"), Mock.get("state").get("counter")-1)
