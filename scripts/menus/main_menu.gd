extends CanvasLayer

const level_select = preload("res://scenes/menus/level_select.tscn") as PackedScene

func _on_start_button_pressed() -> void:
	if level_select:
		get_tree().change_scene_to_packed(level_select)
	else:
		print("Failed to load main menu")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
