extends BTAction

@export var target: String
@export var action: String
@export var min_distance_to_target: float

var wander_speed = 100
var wander_target = Vector2.ZERO

func tick(blackboard: Dictionary) -> int:
	
	# Get actor variable 
	var actor = blackboard["actor"]
	var animated_sprite = actor.get_node("animated_sprite_cat")
	
	# Get position of bed
	wander_target = blackboard[target].global_position
	
	# Go to bed if not close enough
	if (wander_target - actor.global_position).length() > min_distance_to_target:
		# Move cat and play walking animation
		actor.velocity = (wander_target - actor.global_position).normalized() * wander_speed
		animated_sprite.play("walk")
		actor.move_and_slide()
		actor.rotation = actor.velocity.angle()
		return RUNNING
	# At bed, continue to next node
	else: 
		blackboard[action] = true
		return SUCCESS
