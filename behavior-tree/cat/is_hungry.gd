extends BTCondition

func tick(blackboard: Dictionary) -> int:
	# Start eating when hunger is above threshold
	if blackboard["hunger"] >= blackboard["hunger_threshold"]:
		blackboard["is_eating"] = true
		return SUCCESS
	# Continue eating if already eating and hunger is not 0
	elif blackboard["is_eating"] and blackboard["hunger"] > 0:
		return SUCCESS
	
	blackboard["is_eating"] = false
	return FAILURE
