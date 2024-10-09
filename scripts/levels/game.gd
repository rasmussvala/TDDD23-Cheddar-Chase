extends Node2D

var parameters: Dictionary

func _ready() -> void:
	var music = load("res://assets/music/Lactose.wav")
	music_manager.change_music(music)
