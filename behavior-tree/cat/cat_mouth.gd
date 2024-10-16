extends Area2D

@onready var animated_sprite_cat: AnimatedSprite2D = %animated_sprite_cat

func _on_body_entered(body: Node) -> void:
	if body.is_flying or not body.has_method("die"):
		return
	
	animated_sprite_cat.play("eating")
	body.animated_sprite_2d.visible = false
	
	body.die()
