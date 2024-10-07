extends BTCondition

func tick(blackboard: Dictionary) -> int:
	# Start sleeping when tiredness is above threshold
	if blackboard["tiredness"] >= blackboard["tiredness_threshold"]:
		blackboard["is_sleeping"] = true
		return SUCCESS
	# Continue sleeping if already sleeping and tiredness is not 0
	elif blackboard["is_sleeping"] and blackboard["tiredness"] > 0:
		return SUCCESS
	
	blackboard["is_sleeping"] = false
	return FAILURE
