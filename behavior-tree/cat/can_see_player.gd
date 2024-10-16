extends BTCondition

@export var player_key: String = "player"
var player_dummy
var player_in_sight = false

func tick(blackboard: Dictionary) -> int:
	var player = blackboard.get(player_key)
	
	if blackboard["eating_player"]:
		return SUCCESS
	elif player_in_sight:
		blackboard["sees_player"] = true
		blackboard["player"] = player_dummy
		return SUCCESS
	else:
		blackboard["sees_player"] = false
		return FAILURE

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_dummy = body
		player_in_sight = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_sight = false
