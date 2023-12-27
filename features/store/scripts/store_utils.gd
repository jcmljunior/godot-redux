class_name StoreUtils extends Node

signal input_event_handler()

func _init(method: Callable, connect_type: ConnectFlags):
	input_event_handler.connect(method, connect_type)
