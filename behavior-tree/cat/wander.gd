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
		wander_target = actor.global_position + Vector2(randf_range(-100, 100), randf_range(-100, 100))
	
	# Go to target
	if actor.global_position.distance_to(wander_target) > 5:
		actor.velocity = (wander_target - actor.global_position).normalized() * wander_speed
		animated_sprite.play("walk")
		actor.move_and_slide()
		actor.rotation = actor.velocity.angle()
	# Chill at target
	else:
		actor.velocity = Vector2.ZERO
