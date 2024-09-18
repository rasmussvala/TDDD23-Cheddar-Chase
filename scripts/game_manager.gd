extends Node

var score = 0

@onready var death_screen: CanvasLayer = %death_screen
@onready var player: CharacterBody2D = %player

# Add a point for collected cheese and update HUD
func add_point() -> void:
	score += 1
	player.hud.update_score(score)

func _on_player_trigger_death_screen() -> void:
	death_screen.fade_in()
