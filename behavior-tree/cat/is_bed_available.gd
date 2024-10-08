extends BTCondition

func tick(blackboard: Dictionary) -> int:
	var bed_sprite = blackboard.get("bed")
	
	if bed_sprite != null:
		return SUCCESS
	else:
		return FAILURE
