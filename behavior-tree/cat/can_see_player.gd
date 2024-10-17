extends BTCondition

@onready var detection_ray: RayCast2D = %detection_ray

@export var player_key: String = "player"
var player: CharacterBody2D = null

func tick(blackboard: Dictionary) -> int:
	
	if blackboard["eating_player"]:
		return SUCCESS
	elif player != null:
		blackboard["player"] = player
		
		# Calc direction from cat to player
		var direction = player.global_position - detection_ray.global_position
		
		# Rotate ray in the same direction as the cat because it isn't at the right angle already??? 
		var rotated_direction = direction.rotated(-detection_ray.global_rotation)
		
		# Divide by two because it's two times as big as it should???? 
		detection_ray.target_position = rotated_direction / 2
	
		if not detection_ray.is_colliding():
			return SUCCESS
		return FAILURE
	else:
		blackboard["player"] = null
		return FAILURE

func _on_detection_area_body_entered(body: Node2D) -> void:
	# Assign player to the body detected
	if body.is_in_group("player"):
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	# Remove the player when out of detection
	if body.is_in_group("player"):
		player = null
