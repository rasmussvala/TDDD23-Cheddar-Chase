extends CanvasLayer

@onready var window: ColorRect = $window
@onready var death_label: Label = $window/death_label
@onready var cheesy_label: Label = $window/cheesy_label
@onready var restart_button: Button = $window/restart_button

@export var fade_in_time = 1.5 

func _ready():
	var opacity = 0.0
	window.color.a = opacity
	death_label.modulate.a = opacity
	cheesy_label.modulate.a = opacity
	restart_button.modulate.a = opacity
	
	self.visible = false

func fade_in():
	self.visible = true
	
	var opacity = 1.0
	
	var tween = create_tween()
	tween.tween_property(window, "color:a", opacity, fade_in_time)
	tween.parallel().tween_property(death_label, "modulate:a", opacity, fade_in_time)
	tween.parallel().tween_property(cheesy_label, "modulate:a", opacity, fade_in_time)
	tween.parallel().tween_property(restart_button, "modulate:a", opacity, fade_in_time)
	
	

func _on_restart_button_pressed() -> void:
	Engine.time_scale = 1.0
	var game_scene = load("res://scenes/levels/game.tscn")  
	get_tree().change_scene_to_packed(game_scene)
