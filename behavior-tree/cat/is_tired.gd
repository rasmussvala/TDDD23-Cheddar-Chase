extends BTCondition

func tick(blackboard: Dictionary) -> int:
	# Is tired and want to sleep
	if blackboard["tiredness"] >= blackboard["tiredness_threshold"]:
		return SUCCESS
		
	# Is already sleeping and want to sleep untill tiredness = 0
	elif blackboard["is_sleeping"] and blackboard["tiredness"] > 0:
		return SUCCESS
	
	blackboard["is_sleeping"] = false
	return FAILURE
