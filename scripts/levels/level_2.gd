extends Node2D

var parameters: Dictionary
@onready var level_time: Node = %level_time

func _ready() -> void:
	level_time.star_time = 60
