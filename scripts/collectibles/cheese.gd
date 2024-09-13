extends Area2D

@onready var game_manager = %GameManager

func _on_body_entered(_body) -> void:
	game_manager.add_point()
	queue_free()
