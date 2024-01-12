extends Node

@onready var initial_setup: Dictionary = {
	"name": "counter",
	
	"state": 0,
	"method": counter_reducer,
	
	# Quais ações terão acesso ao redutor?
	"accept_action": [
		CounterConstants.INCREMENT_COUNTER,
		CounterConstants.DECREMENT_COUNTER,
	],
	
	# Quais métodos terão acesso as ações do redutor?
	"listeners": [
		{
			"method": CounterMiddlewares.show_increment_counter,
			
			# Em quais ações o método poderá ser executado?
			"type": [
				CounterConstants.INCREMENT_COUNTER,
			],
			
			# O método será executado antes ou após o redutor?
			"on": Store.ListenerEventMode.ON_LOAD,
			
			# Será executado quantas vezes?
			"dispatch_mode": Store.ListenerDispatchMode.PERSIST,
		},
		{
			"method": CounterMiddlewares.show_decrement_counter,
			
			# Em quais ações o método poderá ser executado?
			"type": [
				CounterConstants.DECREMENT_COUNTER,
			],
			
			# O método será executado antes ou após o redutor?
			"on": Store.ListenerEventMode.ON_LOAD,
			
			# Será executado quantas vezes?
			"dispatch_mode": Store.ListenerDispatchMode.PERSIST,
		},
		
		
		
		# Experimental
		{
			"method": func(current_state: int, next_state: int) -> bool:
				print("Executou uma unica vez com a ação %s" % CounterConstants.INCREMENT_COUNTER)
				return true,
			"type": [
				CounterConstants.INCREMENT_COUNTER,
			],
			"on": Store.ListenerEventMode.ON_LOAD,
			"dispatch_mode": Store.ListenerDispatchMode.ONE_SHOT,
		}
	]
}

var counter_reducer = func(state: int, action: Dictionary) -> int:
	
	match action.get("type"):
		CounterConstants.INCREMENT_COUNTER:
			return state+1
			
		CounterConstants.DECREMENT_COUNTER:
			return state-1
		
		_:
			return state
