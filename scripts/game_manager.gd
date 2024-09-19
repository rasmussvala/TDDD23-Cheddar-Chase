extends Node

var score = 0
var max_score = 0

@onready var win_screen: CanvasLayer = %win_screen
@onready var death_screen: CanvasLayer = %death_screen
@onready var player: CharacterBody2D = %player

func _ready() -> void:
	max_score = get_tree().get_node_count_in_group("Cheeses")
	
	# Use call_deffered to wait until player has 
	# been created in order to update the score 
	call_deferred("update_initial_hud") 
	
func update_initial_hud() -> void:
	player.hud.update_score(score, max_score)

# Add a point for collected cheese and update HUD
func add_point() -> void:
	score += 1
	player.hud.update_score(score, max_score)
	
	if score >= max_score: 
		win()

func _on_player_trigger_death_screen() -> void:
	death_screen.fade_in()
	
func win() -> void:
	win_screen.fade_in()
