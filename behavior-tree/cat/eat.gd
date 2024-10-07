extends BTAction

func tick(blackboard: Dictionary) -> int:
	if blackboard["hunger"] > 0:
		blackboard["hunger"] -= blackboard["delta"] * blackboard["eating_rate"]
		
		var animated_sprite = blackboard["actor"].get_node("animated_sprite_cat")
		animated_sprite.play("eating")
		
		return RUNNING
	else:
		blackboard["is_eating"] = false
		return SUCCESS
