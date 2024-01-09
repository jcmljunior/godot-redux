extends Node

var state: Dictionary = {}
var store: Dictionary = {}

func get_state() -> Dictionary:
	return state

func register(setup: Dictionary) -> Store:
	# Bloqueia a continuação do código se não existir as chaves necessária para continuar.
	if not "state" in setup or not "method" in setup: return
	
	# Estabelece a relação de chave com base na nomenclatura do redutor.
	var name = setup.get("method").get_method()
	var key = name.substr(0, name.rfind("_"))
	
	# Bloqueia a continuação do código caso a chave informada já exista.
	if key in store or key in state: return
	
	# Inicialização de estado.
	store[key] = setup
	state[key] = store[key].get("method").call(setup.get("state"), {})
	
	return self

func dispatch(actions: Array[Dictionary]) -> void:
	var running: bool = true
	var response: Callable
	var changed_state: Array = []
	
	# Percorre cada indice no store.
	for key in store.keys():
		
		# Bloqueia a continuaçãodo código se a chave accept_action não existir.
		if not "accept_action" in store[key]: return
		
		# Percorre cada indice da ação.
		for action in actions:
			# Bloqueia a continuação do código se não houver relação entre a ação e o redutor.
			if not action.get("type") in store[key].get("accept_action"): continue
			
			# Preparativos para executar a mudança de estado.
			var current_state: Variant = state.get(key)
			var next_state: Variant = store[key].get("method").call(current_state, action)
			
			# Validação de estado.
			if current_state != next_state:
				# Define as modificações de estado.
				match(typeof(next_state)):
					TYPE_DICTIONARY:
						for index in next_state:
							# Ignora os estados mesclados pelo redutor.
							if next_state[index] == current_state[index]:
								continue
							
							changed_state.append({
								index: [
									current_state.get(index),
									next_state.get(index),
								]
							})
						
						# Preparação das alterações de estado.
						response = func():
							state[key] = shallow_merge(next_state, current_state)
					_:
						changed_state.append([
							current_state,
							next_state,
						])
						
						response = func():
							state[key] = next_state
				
				# Execução dos ouvintes tipo 01.
				while running:
					for listener in store[key].get("listeners"):
						if listener.get("on") != "ready": continue
						
						# Finaliza a execução do laço principal.
						if not listener.get("method").call(changed_state):
							return
					
					# Finaliza o laço while caso não haja problema com a execução dos ouvintes.
					break
				
				# Executa a mudança de estado.
				response.call()
				
				# Execução dos ouvintes tipo 02.
				while running:
					for listener in store[key].get("listeners"):
						if listener.get("on") != "load": continue
						
						# Finaliza a execução do laço principal.
						if not listener.get("method").call(changed_state):
							return
					
					# Finaliza o laço while caso não haja problema com a execução dos ouvintes.
					break

# Essa função é usada para cópia de dicionários.
func shallow_copy(dict: Dictionary) -> Dictionary:
	return shallow_merge(dict, {})


# Essa função é usada para mesclagem de dicionários.
func shallow_merge(src_dict: Dictionary, dest_dict: Dictionary) -> Dictionary:
	for i in src_dict.keys():
		dest_dict[i] = src_dict[i]
	return dest_dict
