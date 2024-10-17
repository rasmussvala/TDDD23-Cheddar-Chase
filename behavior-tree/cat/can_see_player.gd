extends BTCondition

@export var player_key: String = "player"
var player: CharacterBody2D = null

func tick(blackboard: Dictionary) -> int:
	
	if blackboard["eating_player"]:
		return SUCCESS
	elif player != null:
		blackboard["sees_player"] = true
		blackboard["player"] = player
		return SUCCESS
	else:
		blackboard["sees_player"] = false
		return FAILURE

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
