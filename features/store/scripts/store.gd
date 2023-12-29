extends Node

signal changed_state_event_handler(target: String, method: Callable)

var state: Dictionary = {}
var store: Dictionary = {}

# Essa função cria um estado global com base em um redutor de estado.
func create(obj: Dictionary) -> Store:
	assert(obj.has("state"), "Oppss, não foi encontrado o estado inicial.")
	assert(obj.get("state").size() == 1, "Oppss, foram declarados mais de uma chave de estado global.")

	# Obtem a chave de refêrencia ao estado global.
	var key: String = obj.get("state").keys()[0]
	var response: Dictionary;

	assert( not store.has(key), "Oppss, a chave %s já encontra-se em uso." % key)
	assert( not state.has(key), "Oppss, a chave %s já encontra-se em uso." % key)
	store[key] = obj

	# Inicialização de estado.
	response = store.get(key).get("method").call(store.get(key).get("state").get(key), {})

	assert(response.has("payload"), "Oppss, a resposta do redutor não retornou o objeto payload.")
	state[key] = response.get("payload").get(key)

	return self

# Essa função atualiza o estado com base em uma ação.
func dispatch(action: Dictionary) -> void:
	var running = true
	var register_state: Callable
	
	for key in store.keys():

		# Pula para o proxímo indice se a relação entre
		# ação e redutor não for estabelecida.
		if not action.get("payload").has(key):
			continue

		# Bloqueia a execução do redutor se a ação não
		# for um método autorizado.
		if not store.get(key).get("accept_action").has(action.get("type")):
			break

		# Executa o modificador de estado.
		var current_state: Variant = state.get(key)
		var next_state: Variant = store.get(key).get("method").call(current_state, action).get("payload").get(key)

		# Bloqueia o loop for se não houver mudanças de estado.
		if not current_state != next_state:
			break

		# Percorre os dados retornado para saber quais foram modificados.
		var changed_state: Array = [];
		
		if typeof(current_state) == TYPE_STRING \
			or typeof(current_state) == TYPE_INT \
			or typeof(current_state) == TYPE_ARRAY \
			or typeof(current_state) == TYPE_FLOAT:
				changed_state.append([
					current_state,
					next_state,
				])
				
				# Registra as modificações de estado.
				#state[key] = next_state
				
				register_state = func():
					state[key] = next_state
		
		elif typeof(current_state) == TYPE_DICTIONARY:
			for index in next_state.keys():
				if not current_state.has(index):
					continue
					
				changed_state.append([
					current_state.get(index),
					next_state.get(index),
				])
				
				# Registra as modificações de estado.
				register_state = func():
					state[key] = shallow_merge(next_state, current_state)

		# Executa o loop para execução dos observadores.
		var response: bool;
		for middleware in get_middlewares_with_key_value("on", "ready", store.get(key).get("middlewares")):
			if middleware.get("type") != action.get("type"):
				continue

			response = middleware.get("method").call(changed_state)
			
			if not response:
				running = false
				break
		
		# Bloqueia a execução
		if not running:
			break

		register_state.call()

		# Notifica os observadores.
		changed_state_event_handler.emit()
		if store.get(key).has("listeners"):
			for index in range(store.get(key).get("listeners").size()):
				store.get(key).get("listeners")[index].get("method").input_event_handler.emit()

		# Executa o loop para execução dos observadores.
		for middleware in get_middlewares_with_key_value("on", "load", store.get(key).get("middlewares")):
			if middleware.get("type") != action.get("type"):
				continue

			response = middleware.get("method").call(changed_state)
			
			if not response:
				running = false
				break
			
			break

		# Finaliza o loop for.
		break

# Inscrição para ouvir modificações de estado de um único objeto.
func subscribe(key: String, method: Callable, connect_type: ConnectFlags) -> void:
	var method_name: String = str(method).split("::")[1]

	store.get(key).get("listeners").append({
		"name": method_name,
		"method": StoreUtils.new(method, connect_type)
	})

func unsubscribe(key: String, method: Callable) -> void:
	var method_name: String = str(method).split("::")[1]
	var response: Array = [];

	for index in range(store.get(key).get("listeners").size()):
		if store.get(key).get("listeners")[index].get("name") == method_name:
			continue

		response.append(store.get(key).get("listeners")[index])

	store[key]["listeners"] = response


# Esta função classifica os middlewares com base no valor de uma chave específica.
func get_middlewares_with_key_value(key: String, value: String, data: Array) -> Array:
	var response: Array = []

	for index in range(data.size()):
		if data[index].get(key) != value:
			continue

		response.append(data[index])

	return response


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
