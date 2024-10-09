extends CanvasLayer

@onready var window: ColorRect = $window
@onready var death_label: Label = $window/death_label
@onready var cheesy_label: Label = $window/cheesy_label
@onready var restart_button: Button = $window/restart_button
@onready var back_button: Button = $window/back_button
@export var fade_in_time = 1.5 

func _ready():
	var opacity = 0.0
	window.color.a = opacity
	death_label.modulate.a = opacity
	cheesy_label.modulate.a = opacity
	restart_button.modulate.a = opacity
	back_button.modulate.a = opacity
	
	self.visible = false

func fade_in():
	self.visible = true
	
	var opacity = 1.0
	
	var tween = create_tween()
	tween.tween_property(window, "color:a", opacity, fade_in_time)
	tween.parallel().tween_property(death_label, "modulate:a", opacity, fade_in_time)
	tween.parallel().tween_property(cheesy_label, "modulate:a", opacity, fade_in_time)
	tween.parallel().tween_property(restart_button, "modulate:a", opacity, fade_in_time)
	tween.parallel().tween_property(back_button, "modulate:a", opacity, fade_in_time)

func _on_restart_button_pressed() -> void:
	Engine.time_scale = 1.0
	var current_level = game_data.get_current_level()
	if current_level != "":
		game_data.transition_to_level(current_level)
	else:
		print("Current level path not set")

func _on_back_button_pressed() -> void:
	Engine.time_scale = 1.0
	var level_select = game_data.get_level_select_scene()
	
	if level_select:
		var music = load("res://assets/music/Cheese_on_the_moon.wav")
		music_manager.change_music(music)
		game_data.transition_to_level_select(game_data.get_current_world(), level_select)
	else:
		print("Failed to load level select menu")
