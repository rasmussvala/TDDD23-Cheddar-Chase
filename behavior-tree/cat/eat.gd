extends BTAction

func tick(blackboard: Dictionary) -> int:
	if blackboard["hunger"] > 0:
		blackboard["hunger"] = 0
		return RUNNING # Doesn't do anything atm
	return SUCCESS
