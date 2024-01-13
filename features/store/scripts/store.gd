extends Node

enum ListenerEventMode {
	ON_READY,
	ON_LOAD,
}

enum ListenerDispatchMode {
	ONE_SHOT,
	PERSIST,
}


var defaults = func(storage: Dictionary) -> Dictionary:
	var state: Dictionary = {}
	var store: Dictionary = {}
	var response: Callable
	var changed_state: Array = []
	
	# Construtor.
	# Necessário para injeção de dependencias.
	if "state" in storage: state = storage.get("state")
	if "store" in storage: store = storage.get("store")
	
	return {
		"changed_state": store,
		
		# A função "register" define em escala global, o acesso as definições dos redutores.
		"register": func(config: Dictionary) -> void:
			# Validações com requisitos minimos para execução da função.
			if not "state" in config:
				printerr("Oppss, o estado inicial não foi encontrado.")
				return
				
			if not "method" in config:
				printerr("Oppss, o redutor não foi encontrado.")
				return
			
			# Define a chave de referência ao state/store.
			var key: String = config.get("name")
			
			# Validação de existencia de chave em state/store.
			if key in state or key in store:
				printerr("Oppss, a chave %s já existe." % key)
				return
			
			# Inicialização de state/store.
			store[key] = config
			state[key] = config.get("method").call(config.get("state"), {}),
		
		# A função "dispatch" interpreta ações do usuário para definir o estado global.
		"dispatch": func(actions: Array[Dictionary]) -> void:
			
			# Bloqueia a continuidade do código se não houver ações a serem percorridas.
			if not actions.size():
				return
			
			# Redefinição de estado modificados.
			# Suporte a combinações de redutores com injeção de dependencias.
			changed_state = []
			
			# Percorre as ações do usuário.
			for action in actions:
				# Percorre os  redutores.
				for key in store.keys():
					# Ignora o indice caso não haja relação com a ação.
					if not "accept_action" in store[key]:
						continue
					
					# Validação da relação entre a ação e o redutor.
					if not action.get("type") in store.get(key).get("accept_action"):
						continue
						
					# Execução do redutor.
					var current_state: Variant = state.get(key)
					var next_state: Variant = store[key].get("method").call(current_state, action)
					
					# Validação das execuções dos modificadores.
					# Importante manter a formatação dos valores retornado como string para evitar problemas com os operadores.
					if str(current_state) == str(next_state):
						continue
					
					
					match action.get("type"):
						
						# Lida com o estado do tipo dicionário.
						TYPE_DICTIONARY:
							
							# Percorre todos os indices para estabelecer quais objetos foram modificados.
							for index in next_state:
								# Ignora os elementos que não receberam mudanças.
								# Importante por causa da mesclagem de objetos.
								if next_state[index] == current_state[index]:
									continue
								
								# Registra quais valores ocorreu modificação.
								changed_state.append_array([
									current_state,
									next_state,
								])
							
							# Define a mudança de estado.
							response = func(): state[key] = StoreCollections.shallow_merge(next_state, current_state)
							
						_:
							changed_state.append_array([
								current_state,
								next_state
							])
							
							# Define a mudança de estado.
							response = func(): state[key] = next_state
			
					# ListenerOnLoadEventHandler
					if not get_instance({
						"store": store,
						"state": state,
					}).get("handle_listener_list").call(key, action, ListenerEventMode.ON_LOAD, changed_state):
						return
					
					# Executa a mudança de estado.
					response.call()
			
					#ListenerOnReadyEventHandler
					if not get_instance({
						"store": store,
						"state": state,
					}).get("handle_listener_list").call(key, action, ListenerEventMode.ON_READY, changed_state):
						return,
			
			"handle_listener_list": func(key: String, action: Dictionary, on: int, changed_state: Array) -> bool:
				if store.get(key).get("listeners").size():
						
						# Percorre a lista de métodos observaveis.
						for index in range(store.get(key).get("listeners").size() -1, -1, -1):
							
							var listener = store.get(key).get("listeners")[index]
							
							# Validação de tipos de ouvintes.
							if not action.get("type") in listener.get("type") or not listener.get("on") != on:
								continue
							
							# Bloqueia a execução da ação se houver resposta negativa.
							if not listener.get("method").callv(changed_state):
								return false
								
							# ListenerDispatchMode
							if listener.get("dispatch_mode") == ListenerDispatchMode.ONE_SHOT:
								store.get(key).get("listeners").remove_at(index)
				
				return true,
			
			"add_listener": func(name: String, type: Array, method: Callable, on: ListenerEventMode = ListenerEventMode.ON_LOAD, dispatch_mode: ListenerDispatchMode = ListenerDispatchMode.PERSIST):
				if not name in store:
					return
				
				store.get(name).get("listeners").append({
					"type": type,
					"method": Callable(method),
					"on": on,
					"dispatch_mode": dispatch_mode,
				}),
				
			"remove_listener": func(name: String, method: Callable):
				for index in range(store.get(name).get("listeners").size() -1, -1, -1):
					if not store.get(name).get("listeners")[index].get("method").get_method() == method.get_method():
						continue
					
					store.get(name).get("listeners").remove_at(index),
	}

func get_instance(storage: Dictionary = {}):
	return defaults.call(storage)

