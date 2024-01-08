extends GutTest

class TestCounterActions:
	extends GutTest

	var state = 10
	
	func test_increment_counter():
		var response = CounterReducers.get("counter_reducer").call(state, CounterActions.increment_counter(state))
		assert_eq(response, state+1, "O teste falhou porque o resultado esperado era %s" % int(state+1))

	func test_decrement_counter():
		var response = CounterReducers.get("counter_reducer").call(state, CounterActions.decrement_counter(state))
		assert_eq(response, state-1, "O teste falhou porque o resultado esperado era %s" % int(state-1))
