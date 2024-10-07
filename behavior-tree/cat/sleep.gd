extends BTAction

func tick(blackboard: Dictionary) -> int:
	if blackboard["tiredness"] > 0:
		blackboard["tiredness"] -= blackboard["delta"] * blackboard["sleeping_rate"]
		
		var animated_sprite = blackboard["actor"].get_node("animated_sprite_cat")
		animated_sprite.play("sleep")
		
		return RUNNING
	else:
		blackboard["is_sleeping"] = false
		return SUCCESS
