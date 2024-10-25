extends CanvasLayer

@onready var you_sure_screen: ColorRect = %you_sure_screen
@onready var data_deleted_screen: ColorRect = %data_deleted_screen

func _ready() -> void:
	you_sure_screen.visible = false
	data_deleted_screen.visible = false

func _on_reset_progress_button_pressed() -> void:
	you_sure_screen.visible = true

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _on_yes_button_pressed() -> void:
	save_manager.delete_save()
	save_manager.initialize_save()
	game_data.current_level_icon_name = "1"
	
	data_deleted_screen.visible = true


func _on_no_button_pressed() -> void:
	you_sure_screen.visible = false


func _on_ok_button_pressed() -> void:
	data_deleted_screen.visible = false
	you_sure_screen.visible = false
