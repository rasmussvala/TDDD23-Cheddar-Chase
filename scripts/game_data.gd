extends Node

var current_level_path: String = ""

func set_current_level(path: String) -> void:
	current_level_path = path

func get_current_level() -> String:
	return current_level_path
