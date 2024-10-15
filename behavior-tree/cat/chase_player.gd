extends BTAction

@export var chase_speed: float = 150.0
@export var stop_distance: float = 10.0

func tick(blackboard: Dictionary) -> int:
	var actor = blackboard["actor"]
	var player = blackboard.get("player")

	if player == null or not blackboard["sees_player"]:
		return FAILURE

	var distance_to_player = (player.global_position - actor.global_position).length()

	# Chase player if not close enough
	if distance_to_player > stop_distance:
		var direction = (player.global_position - actor.global_position).normalized()
		
		# Set velocity and move the actor
		actor.velocity = direction * chase_speed
		actor.move_and_slide()

		# Rotate the actor to face the player
		actor.rotation = direction.angle()

		# Play the walking animation
		actor.get_node("animated_sprite_cat").play("walk")
		return RUNNING
	else:
		# Stop the actor and play idle animation
		actor.velocity = Vector2.ZERO
		actor.get_node("animated_sprite_cat").play("idle")
		return SUCCESS
