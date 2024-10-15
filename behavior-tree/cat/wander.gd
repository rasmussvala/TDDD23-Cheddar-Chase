extends BTAction

var wander_speed = 10
var wander_target = Vector2.ZERO
var wander_time = 0
var wander_interval = 3

func tick(blackboard: Dictionary) -> int:
	wander(blackboard)
	return RUNNING

func wander(blackboard: Dictionary) -> void: 
	var delta = blackboard["delta"]
	var actor = blackboard["actor"]
	var animated_sprite = actor.get_node("animated_sprite_cat")
	
	wander_time += delta
	
	# Update wander direction after a short interval
	if wander_time >= wander_interval:
		wander_time = 0
		
		# Define an angle range for forward movement (in radians)
		var forward_angle = actor.rotation
		var max_turn_angle = deg_to_rad(45)  # Limit turn to within 90 degrees forward
		
		# Generate a random angle within the forward-facing cone
		var random_angle = forward_angle + randf_range(-max_turn_angle, max_turn_angle)
		
		# Calculate the new forward wander direction
		var direction = Vector2(cos(random_angle), sin(random_angle)).normalized()
		
		# Set the new wander target based on the forward-facing direction
		wander_target = actor.global_position + direction * randf_range(50, 100)
	
	# Go to target
	if actor.global_position.distance_to(wander_target) > 5:
		actor.velocity = (wander_target - actor.global_position).normalized() * wander_speed
		animated_sprite.play("walk")
		actor.move_and_slide()
		actor.rotation = actor.velocity.angle()
	# Chill at target
	else:
		actor.velocity = Vector2.ZERO
