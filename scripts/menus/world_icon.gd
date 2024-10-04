@tool
extends Control

@export var world_index: int = 1
@export var level_select_packed: PackedScene = load("res://scenes/menus/level_select_world_1.tscn")
@onready var level_select_scene: LevelSelect = level_select_packed.instantiate()

func _ready() -> void:
	game_data.set_current_world(world_index)
	game_data.set_level_select_scene(level_select_packed)
	$label.text = "World " + str(world_index)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$label.text = "World " + str(world_index)
