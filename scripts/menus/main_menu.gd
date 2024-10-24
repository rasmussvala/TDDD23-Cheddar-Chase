extends CanvasLayer

const level_select = preload("res://scenes/menus/world_select.tscn") as PackedScene
@onready var logo_animation: AnimationPlayer = $logo_animation
@onready var logo: TextureRect = $logo

func _ready() -> void:
	logo_animation.play("logo")

func _on_start_button_pressed() -> void:
	if level_select:
		get_tree().change_scene_to_packed(level_select)
	else:
		print("Failed to load main menu")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
