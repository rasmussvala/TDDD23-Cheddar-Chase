extends BTCondition

func tick(blackboard: Dictionary) -> int:
	if blackboard["hunger"] >= blackboard["hunger_threshold"]:
		return SUCCESS
	return FAILURE
