extends Node

var score = 0
var max_score = 0
var time_taken: float = 0.0
var damage_taken: bool = false
var stars_earned: int = 0
var carries_fish: bool = false

@onready var player: CharacterBody2D = %player
@onready var death_menu: CanvasLayer = %death_menu
@onready var win_menu: CanvasLayer = %win_menu
@onready var level_time: Node = %level_time

func _ready() -> void:
	max_score = get_tree().get_node_count_in_group("cheeses")
	time_taken = 0.0
	damage_taken = false
	call_deferred("update_initial_hud")

	# Connect the signal from the player to the game manager
	if player:
		player.connect("player_take_damage", Callable(self, "_on_player_take_damage"))

func _process(delta: float) -> void:
	# Increment time taken
	time_taken += delta
	#print(time_taken)

func update_initial_hud() -> void:
	if player:
		player.hud.update_score(score, max_score)

func mouse_has_fish(value: bool) -> void: 
	carries_fish = value
	print("mouse has fish: %s" % str(carries_fish))
	
	player.hud.update_fish_icon(carries_fish)

func get_value_mouse_has_fish() -> bool:
	return carries_fish

func add_point() -> void:
	score += 1
	player.hud.update_score(score, max_score)
	
	if score >= max_score:
		var progress_data = save_manager.load_progress()
		var level_stars = progress_data["level_stars"]

		# Ensure current_level is handled consistently as a string or integer
		var current_level = str(int(game_data.get_current_level().get_basename().trim_prefix("level_")))

		# Calculate stars earned for the current playthrough
		calculate_stars()  # Make sure this returns the correct stars earned

		# If the level already exists in level_stars, update its value
		if not level_stars.has(current_level):
			# If the level isn't already present, create a new entry
			level_stars[current_level] = stars_earned
		else:
			# If it's present, only update if new stars earned are greater than the existing stars
			if stars_earned > level_stars[current_level]:
				level_stars[current_level] = stars_earned

		# Update the highest level unlocked if necessary
		if progress_data["highest_level"] <= int(current_level):
			progress_data["highest_level"] = int(current_level) + 1

		# Save the updated progress data
		if save_manager.save_progress(progress_data["highest_level"], level_stars):
			print("Stars saved successfully for level: ", current_level, " Stars: ", level_stars[current_level])
		else:
			print("Failed to save stars!")

		# Update all level icons to reflect the new star status
		for level in get_tree().get_nodes_in_group("level_icons"):
			if level is LevelIcon:
				level.update_level_state()  # Refresh the level icons to display the correct stars
		
		win()  # Proceed with the victory/win flow


func calculate_stars() -> void:
	stars_earned = 1  # Always get 1 star for completion
	if time_taken <= level_time.star_time:  # Example threshold for fast completion
		stars_earned += 1
	if not damage_taken:  # No damage taken
		stars_earned += 1

func _on_player_take_damage() -> void:
	damage_taken = true

func _on_player_trigger_death_menu() -> void:
	death_menu.fade_in()

func win() -> void:
	win_menu.fade_in()
