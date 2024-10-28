extends Node2D

var parameters: Dictionary
@onready var level_time: Node = %level_time
var level_music = load("res://assets/music/Lactose.wav")

func _ready() -> void:
	level_time.star_time = 60
	music_manager.change_music(level_music)
