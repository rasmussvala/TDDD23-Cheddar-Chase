extends Control
class_name LevelSelect

@onready var current_level: LevelIcon = $level_icon1
@onready var world_select_scene = load("res://scenes/menus/world_select.tscn")
var move_tween: Tween

func _ready() -> void:
	$player_icon.global_position = current_level.global_position

func _input(event: InputEvent) -> void:
	if move_tween and move_tween.is_running():
		return
	
	if event.is_action_pressed("ui_left") and current_level.next_level_left:
		current_level = current_level.next_level_left
		tween_icon()
	
	if event.is_action_pressed("ui_right") and current_level.next_level_right:
		current_level = current_level.next_level_right
		tween_icon()
	
	if event.is_action_pressed("ui_up") and current_level.next_level_up:
		current_level = current_level.next_level_up
		tween_icon()
	
	if event.is_action_pressed("ui_down") and current_level.next_level_down:
		current_level = current_level.next_level_down
		tween_icon()
	
	if event.is_action_pressed("ui_cancel"):
		game_data.reset_level_select_scene()
		get_tree().change_scene_to_packed(world_select_scene)
	
	if event.is_action_pressed("ui_accept"):
		if current_level.next_scene_path:
			game_data.set_current_level(current_level.next_scene_path)
			functions.load_screen_to_scene(current_level.next_scene_path)

func tween_icon():
	move_tween = get_tree().create_tween()
	move_tween.tween_property($player_icon, "global_position", current_level.global_position, 0.5).set_trans(Tween.TRANS_SINE)
