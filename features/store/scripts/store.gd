extends Node

enum ListenerEventMode {
	ON_READY,
	ON_LOAD,
}


var instance: Callable = func() -> Dictionary:
	var state: Dictionary = {}
	var store: Dictionary = {}
	var changed_state: Array = []
	var response: Callable
	
	return {
		"register": func(initial_setup: Dictionary) -> Variant:
			# Validações com requisitos minimos para execução da função.
			if not "state" in initial_setup:
				printerr("Oppss, o estado inicial não foi encontrado.")
				return
				
			if not "method" in initial_setup:
				printerr("Oppss, o redutor não foi encontrado.")
				return
				
			# Captura a nomeclatura do redutor para referência-lo como uma chave state/store.
			@warning_ignore("shadowed_variable_base_class")
			var name: String = initial_setup.get("method").get_method()
			var key: String = name.substr(0, name.rfind("_"))
			
			# Validação de existencia de chave em state/store.
			if key in state or key in store:
				printerr("Oppss, a chave %s já existe." % key)
				return
			
			# Inicialização de state/store.
			store[key] = initial_setup
			state[key] = initial_setup.get("method").call(initial_setup.get("state"), {})
			
			# Retorna a instancia com acesso as funções.
			return self.get_instance(),
		
		"dispatch": func(actions: Array) -> Variant:
			# Redefinição de estado modificados.
			changed_state = []
			
			# Percorre as ações.
			for action: Dictionary in actions:
				# Percorre os redutores.
				for key in store.keys():
					# Ignora o indice caso não haja relação com a ação.
					if not "accept_action" in store[key]:
						continue
					
					var current_state: Variant = state.get(key)
					var next_state: Variant = store[key].get("method").call(current_state, action)
					
					#print(current_state)
					#print(next_state)
					
					# Finaliza o laço segundário caso não haja mudança de estado a ser computada.
					if str(current_state) == str(next_state):
						break
					
					
					if not typeof(next_state) == TYPE_DICTIONARY:
						changed_state.append_array([
							current_state,
							next_state,
						])
						
						response = func(): state[key] = next_state
					
					if typeof(next_state) == TYPE_DICTIONARY:
						for index in next_state:
							if next_state[index] == current_state[index]:
								continue
							
							changed_state.append({
								index: [
									current_state,
									next_state,
								]
							})
					
						response = func(): state[key] = shallow_merge(next_state, current_state)
					
					for listener in store.get(key).get("listeners"):
						if not action.get("type") in listener.get("type") or int(listener.get("on")) == Store.ListenerEventMode.ON_LOAD:
							continue
						
						if not listener.get("method").callv(changed_state):
							return
					
					response.call()
					
					#...
					for listener in store.get(key).get("listeners"):
						if not action.get("type") in listener.get("type") or not int(listener.get("on")) != Store.ListenerEventMode.ON_READY:
							continue

						if not listener.get("method").callv(changed_state):
							return
			
			#print(changed_state)
			
			# Retorna a instancia com acesso as funções.
			return self.get_instance(),
		
		"add_listener": func(key: String, type: Array, method: Callable, on: String) -> void:
			store.get(key).get("listeners").append({
				"type": type,
				"method": method,
				"on": on
			}),
			
		"remove_listener": func(method: Callable) -> void:
			for i in store.keys():
				for ii in range(store.get(i).get("listeners").size()):
					if not store.get(i).get("listeners")[ii].get("method").get_method() == method.get_method():
						continue
					
					store.get(i).get("listeners").remove_at(ii),
		
		"get_instance": func() -> Dictionary:
			return self.instance.call(),
		
		"get_state": state,
	}


func get_instance() -> Dictionary:
	return instance.call()

# Essa função é usada para cópia de dicionários.
func shallow_copy(dict: Dictionary) -> Dictionary:
	return shallow_merge(dict, {})


# Essa função é usada para mesclagem de dicionários.
func shallow_merge(src_dict: Dictionary, dest_dict: Dictionary) -> Dictionary:
	for i in src_dict.keys():
		dest_dict[i] = src_dict[i]
	return dest_dict

