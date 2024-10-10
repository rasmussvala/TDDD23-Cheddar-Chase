extends Node

var score = 0
var max_score = 0
@onready var player: CharacterBody2D = %player
@onready var death_menu: CanvasLayer = %death_menu
@onready var win_menu: CanvasLayer = %win_menu

func _ready() -> void:
	max_score = get_tree().get_node_count_in_group("Cheeses")
	call_deferred("update_initial_hud") 

func update_initial_hud() -> void:
	if player:
		player.hud.update_score(score, max_score)

func add_point() -> void:
	score += 1
	player.hud.update_score(score, max_score)
	
	if score >= max_score: 
		# Get the current level number from game_data
		var current_level = int(game_data.get_current_level().get_basename().trim_prefix("level_"))
		save_manager.save_progress(current_level + 1)
		win()

func _on_player_trigger_death_menu() -> void:
	death_menu.fade_in()

func win() -> void:
	win_menu.fade_in()
