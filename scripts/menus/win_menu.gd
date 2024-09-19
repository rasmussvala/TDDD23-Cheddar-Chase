extends CanvasLayer

@onready var window: ColorRect = $window
@onready var return_button: Button = $window/return_button
@onready var win_label: Label = $window/win_label

@export var fade_in_time = 0.2 

func _ready() -> void:
	var opacity = 0

	window.color.a = opacity
	return_button.modulate.a = opacity
	win_label.modulate.a = opacity
	
	self.visible = false

func fade_in():
	# Ensure the win screen continues to process while the game is paused
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	get_tree().paused = true
	
	self.visible = true
	
	var opacity = 1.0
	
	var tween = create_tween()
	tween.tween_property(window, "color:a", opacity, fade_in_time)
	tween.parallel().tween_property(win_label, "modulate:a", opacity, fade_in_time)
	tween.parallel().tween_property(return_button, "modulate:a", opacity, fade_in_time)

func _on_return_button_pressed() -> void:
	# Unpause the game when pressing the button
	get_tree().paused = false

	var main_menu = load("res://scenes/menus/main_menu.tscn")
	get_tree().change_scene_to_packed(main_menu)
