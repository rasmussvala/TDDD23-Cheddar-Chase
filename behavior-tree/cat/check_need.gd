extends BTCondition

@export var need: String 
@export var threshold: String 
@export var action: String 

func tick(blackboard: Dictionary) -> int:
	# Is needed and want to do action
	if blackboard[need] >= blackboard[threshold]:
		return SUCCESS
		
	# Is already doing the action and want to continue until it hits 0
	elif blackboard[action] and blackboard[need] > 0:
		return SUCCESS
	
	# Need is satisfied and we don't want to do the action
	return FAILURE
