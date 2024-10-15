extends BTCondition

@export var player_key: String = "player"
@export var view_distance: float = 200.0

func tick(blackboard: Dictionary) -> int:
	var actor = blackboard["actor"]
	var player = blackboard.get(player_key)

	# Check if the player exists and is within the view distance
	if player != null and (player.global_position - actor.global_position).length() <= view_distance:
		blackboard["sees_player"] = true
		print("sees the player")
		return SUCCESS
	else:
		blackboard["sees_player"] = false
		return FAILURE
