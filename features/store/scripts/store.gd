extends Node

signal changed_state_event_handler(target: String, method: Callable)

var state: Dictionary = {}
var store: Dictionary = {}

func create(obj: Dictionary) -> Store:
	print(obj)
	
	return self

func dispatch(action: Dictionary) -> void:
	pass

func subscribe(key: String, method: Callable, connect_type: ConnectFlags) -> void:
	pass

func unsubscribe(key: String, method: Callable, connect_type: ConnectFlags) -> void:
	pass

func get_entry_on_store(key: String) -> Dictionary:
	return store.get(key)

func shallow_copy(dict: Dictionary) -> Dictionary:
	return shallow_merge(dict, {})

func shallow_merge(src_dict: Dictionary, dest_dict: Dictionary) -> Dictionary:
	for i in src_dict.keys():
		dest_dict[i] = src_dict[i]
	return dest_dict
