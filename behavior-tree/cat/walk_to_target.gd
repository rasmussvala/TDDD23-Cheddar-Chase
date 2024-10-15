extends BTAction

@export var target: String
@export var action: String
@export var min_distance_to_target: float
@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D

var wander_speed = 100
var wander_target = Vector2.ZERO

func tick(blackboard: Dictionary) -> int:
	
	# Get actor variable 
	var actor = blackboard["actor"]
	var animated_sprite = actor.get_node("animated_sprite_cat")
	
	# Get position of bed
	wander_target = blackboard[target].global_position
	# Make a path to the target 
	# NOTE: This does not need to be calculated every tick  
	nav_agent.target_position = wander_target
	
	# Go to bed if not close enough
	if (wander_target - actor.global_position).length() > min_distance_to_target:
		# Move cat and play walking animation
		var next_position = nav_agent.get_next_path_position()
		var direction = (next_position - actor.global_position).normalized()

		actor.velocity = direction * wander_speed
		animated_sprite.play("walk")
		actor.move_and_slide()
		actor.rotation = actor.velocity.angle()
		return RUNNING
	# At bed, continue to next node
	else: 
		blackboard[action] = true
		return SUCCESS
