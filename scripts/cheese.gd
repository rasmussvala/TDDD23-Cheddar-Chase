extends Area2D

@onready var hud: CanvasLayer = %HUD

func _on_body_entered(_body) -> void:
	hud.add_point()
	queue_free()
