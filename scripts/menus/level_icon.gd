@tool
extends Control
class_name LevelIcon

@export var level_name: String = "1"
@export_file("*.tscn") var next_scene_path: String 
@export var next_level_up: LevelIcon
@export var next_level_down: LevelIcon
@export var next_level_left: LevelIcon
@export var next_level_right: LevelIcon
var is_locked: bool = true

func _ready() -> void:
	# Add this node to a group for easier access
	add_to_group("level_icons")
	# Only update level state if we're not in the editor
	if not Engine.is_editor_hint():
		update_level_state()
	$label.text = "Level " + str(level_name)

func update_level_state() -> void:
	var highest_level = save_manager.load_progress()
	
	# Convert level_name to integer for proper comparison
	var this_level_number = int(level_name)
	
	# A level is unlocked if its number is less than or equal to the highest_level
	is_locked = this_level_number > highest_level
	
	if is_locked:
		$texture_rect.modulate = Color(0.5, 0.5, 0.5)
	else:
		$texture_rect.modulate = Color(1, 1, 1)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$label.text = "Level " + str(level_name)
