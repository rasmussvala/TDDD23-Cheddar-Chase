extends Area2D

@onready var player: CharacterBody2D = %player

func _on_body_entered(body) -> void:
	if player.current_health < player.max_health:
		if body.has_method("play_heart_sound"):
			body.play_heart_sound()
		player.current_health += 1
		var hud = player.get_node("hud")
		hud.update_health(player.current_health)
		queue_free()
