extends Node

var state: Dictionary = {}
var store: Dictionary = {}
var running := true

# Essa função cria um estado global com base em um redutor de estado.
func create(obj: Dictionary) -> Store:
	assert("state" in obj, "Oppss, não foi encontrado o estado inicial.")
	assert(obj.get("state").size() == 1, "Oppss, foram declarados mais de uma chave de estado global.")

	# Obtem a chave de refêrencia ao estado global.
	var key: String = obj.get("state").keys()[0]

	assert(not key in store, "Oppss, a chave %s já encontra-se em uso." % key)
	assert(not key in state, "Oppss, a chave %s já encontra-se em uso." % key)
	
	store[key] = obj

	# Inicialização de estado.
	state[key] = store.get(key).get("method").call(store.get(key).get("state").get(key), {})

	return self

# Essa função atualiza o estado com base em uma ação.
func dispatch(action: Dictionary) -> void:
	# Inicializa a variavel running sempre que uma ação é executada.
	running = true
	
	for key in store.keys():
		# Executa a validação da relação da ação com o redutor.
		if not key in action.get("payload"):
			continue
		
		# Executa a validação da autorização de execução do redutor.
		# Bloqueia a execução do código se as condições necessárias para continuar não for estabelecidas.
		if not action.get("type") in store.get(key).get("accept_action"):
			break
		
		# Executa uma simulação de modificações de estado.
		var current_state: Variant = state.get(key)
		var next_state: Variant = store.get(key).get("method").call(current_state, action)
		
		# Validação de estado passivo a modificação.
		# Bloqueia a execução do código se não houver alterações de estado.
		if not typeof(current_state) == typeof(next_state) \
			and current_state == next_state:
				break
		
		# Memoriza as informações de estados modificado.
		var changed_state: Dictionary = handle_changed_state(key, current_state, next_state)
		
		# Inicialização dos middlewares do tipo "ready".
		if not "middlewares" in store.get(key):
			break
		
		handle_middleware(action, get_middlewares_with_key_value("on", "ready", store.get(key).get("middlewares")), changed_state.values)
		
		# Bloqueia a a continuação do laço se a variavel running for falsa.
		if not running:
			break

		# Se não houver problemas, registra o novo estado.
		changed_state.callback.call()

		# Notifica os observadores.
		if not "listeners" in store.get(key):
			break

		handle_listeners(key)

		# Inicialização dos middlewares do tipo "load".
		handle_middleware(action, get_middlewares_with_key_value("on", "load", store.get(key).get("middlewares")), changed_state.values)
		
		# Bloqueia a a continuação do laço se a variavel running for falsa.
		if not running:
			break
		
		# Finaliza o laço for.
		break

# Inscrição para ouvir modificações de estado.
func subscribe(key: String, method: Callable, connect_type: ConnectFlags) -> Store:
	assert(key in store, "Oppss, a chave %s não foi encontrada." % key)
	assert("listeners" in store.get(key), "Oppss, a chave listeners não foi encontrada.")
	
	store.get(key).get("listeners").append([
		str(method).split("::")[1],
		StoreUtils.new(method, connect_type)
	])
	
	return self

# Remoção da escuta das modificações de estado.
func unsubscribe(key: String, method: Callable) -> Store:
	var method_name := str(method).split("::")[1]
	
	for index in range(store.get(key).get("listeners").size()):
		if store.get(key).get("listeners")[index][0] != method_name:
			continue

		store.get(key).get("listeners").pop_at(index)
		
		# Finaliza o laço.
		break
	
	return self

# Esta função classifica os middlewares com base no valor de uma chave específica.
func get_middlewares_with_key_value(key: String, value: String, data: Array) -> Array:
	var response: Array = []

	for index in range(data.size()):
		if data[index].get(key) != value:
			continue

		response.append(data[index])

	return response

# Inicialização dos middlewares.
func handle_middleware(action: Dictionary, resources: Array, changed_state: Array):
	for middleware in resources:
		if middleware.get("type") != action.get("type"):
			continue
		
		# Executa o middleware e se a resposta não for verdadeira, bloqueia a continuação do código.
		if not middleware.get("method").call(changed_state):
			running = false
			break

# Notifica os observadores relacionados a chave.
func handle_listeners(key: String):
	for index in range(store.get(key).get("listeners").size()):
		store.get(key).get("listeners")[index][1].input_event_handler.emit()


# Memoriza as informações de estados modificado.
func handle_changed_state(key: String, current_state: Variant, next_state: Variant) -> Dictionary:
	var changed_state: Array = []
	var response: Callable
	
	match(typeof(next_state)):
		TYPE_DICTIONARY:
			for index in next_state:
				if not index in current_state and \
					next_state[index] == current_state[index]:
						continue

				changed_state.append([
					current_state[index],
					next_state[index],
				])
			
			# Registra as modificações no estado.
			response = func() -> void:
				state[key] = shallow_merge(next_state, current_state)
		
		_:
			changed_state.append([
				current_state,
				next_state,
			])
			
			response = func() -> void:
				state[key] = next_state
	
	return {
		"values": changed_state,
		"callback": response,
	}

# Esta função recupera um valor associado a uma chave específica no state
func get_entry_on_state(key: String) -> Variant:
	assert(state.has(key), "Oppss, a chave %s não foi encontrada no escopo do objeto state." % key)
	return state.get(key)


# Essa função é usada para cópia de dicionários.
func shallow_copy(dict: Dictionary) -> Dictionary:
	return shallow_merge(dict, {})


# Essa função é usada para mesclagem de dicionários.
func shallow_merge(src_dict: Dictionary, dest_dict: Dictionary) -> Dictionary:
	for i in src_dict.keys():
		dest_dict[i] = src_dict[i]
	return dest_dict
