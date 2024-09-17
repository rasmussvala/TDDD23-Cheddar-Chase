extends Area2D


# Called when a body enters the area.
func _on_body_entered(body: Node2D) -> void:
	
	if body.has_method("fall_in_pit"):
		if !body.is_rolling:
			body.fall_in_pit()
