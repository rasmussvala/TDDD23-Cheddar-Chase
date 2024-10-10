extends Node

# Scene paths
var current_level_path: String = ""
var current_level_icon_name: String = "1"
var current_world_index: int = 0
var current_level_select_scene: PackedScene = null

# Cached references
var main_menu_scene = preload("res://scenes/menus/main_menu.tscn")
var world_select_scene = preload("res://scenes/menus/world_select.tscn")

# Current level management
func set_current_level(path: String) -> void:
	current_level_path = path


func get_current_level() -> String:
	return current_level_path

# Level select scene management
func set_level_select_scene(scene: PackedScene) -> void:
	current_level_select_scene = scene

func get_level_select_scene() -> PackedScene:
	return current_level_select_scene

func reset_level_select_scene() -> void:
	current_level_select_scene = null

# World management
func set_current_world(index: int) -> void:
	current_world_index = index

func get_current_world() -> int:
	return current_world_index

# Scene transition helpers
func transition_to_level(level_path: String) -> void:
	set_current_level(level_path)
	get_tree().change_scene_to_file(level_path)

func transition_to_level_select(world_index: int, level_select: PackedScene) -> void:
	set_current_world(world_index)
	set_level_select_scene(level_select)
	get_tree().change_scene_to_packed(level_select)

func transition_to_world_select() -> void:
	reset_level_select_scene()
	get_tree().change_scene_to_packed(world_select_scene)

func transition_to_main_menu() -> void:
	reset_level_select_scene()
	get_tree().change_scene_to_packed(main_menu_scene)

# Level Icon management
func get_current_level_icon_name() -> String:
	return current_level_icon_name
