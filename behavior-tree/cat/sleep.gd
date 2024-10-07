extends BTAction

func tick(blackboard: Dictionary) -> int:
	if blackboard["tiredness"] > 0:
		blackboard["tiredness"] -= blackboard["delta"] * blackboard["sleeping_rate"]
		return RUNNING
	else:
		blackboard["is_sleeping"] = false
		return SUCCESS
