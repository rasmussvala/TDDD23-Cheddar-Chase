extends Node

var score = 0

@onready var hud: CanvasLayer = %hud

# Add a point for collected cheese and update HUD
func add_point() -> void:
	score += 1
	hud.update_score(score)
