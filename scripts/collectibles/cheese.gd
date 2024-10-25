extends Area2D

@onready var game_manager: Node = %game_manager

func _on_body_entered(body) -> void:
	if body.has_method("play_cheese_sound"):
		body.play_cheese_sound()

	game_manager.add_point()
	queue_free()
