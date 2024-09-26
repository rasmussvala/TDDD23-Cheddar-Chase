extends CanvasLayer

const LEVEL_PATHS = {
	"Level 1": "res://scenes/levels/demo_level.tscn",
	"Level 2": "res://scenes/levels/game.tscn",
	"Level 3": "res://scenes/levels/level_3.tscn"
}

@onready var item_list = $item_list
@onready var start_button = $start_button
@onready var main_menu = load("res://scenes/menus/main_menu.tscn")
var selected_level = ""

func _ready() -> void:
	for level_name in LEVEL_PATHS.keys():
		item_list.add_item(level_name)
	
	start_button.disabled = true

func _on_ItemList_item_selected(index: int) -> void:
	selected_level = item_list.get_item_text(index)
	start_button.disabled = false

func _on_start_button_pressed() -> void:
	if selected_level != "":
		var level_path = LEVEL_PATHS[selected_level]
		var level_scene = load(level_path)
		if level_scene:
			game_data.set_current_level(level_path)
			get_tree().change_scene_to_packed(level_scene)
		else:
			print("Failed to load selected level")
	else:
		print("No level selected")

func _on_back_button_pressed() -> void:
	if main_menu:
		get_tree().change_scene_to_packed(main_menu)
	else:
		print("Failed to load main menu")
