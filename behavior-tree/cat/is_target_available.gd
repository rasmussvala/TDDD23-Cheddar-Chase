extends BTCondition

@export var target: String

func tick(blackboard: Dictionary) -> int:
	var sprite = blackboard.get(target)
	
	if sprite != null:
		return SUCCESS
	else:
		return FAILURE
