extends BTAction

func tick(blackboard: Dictionary) -> int:
	if blackboard["hunger"] > 0:
		blackboard["hunger"] -= blackboard["delta"] * blackboard["eating_rate"]
		return RUNNING
	else:
		blackboard["is_eating"] = false
		return SUCCESS
