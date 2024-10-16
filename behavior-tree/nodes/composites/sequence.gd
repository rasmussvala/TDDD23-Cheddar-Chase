class_name BTSequence extends BTCompositeNode

func tick(blackboard: Dictionary) -> int:
	for child in get_children():
		var status = child.tick(blackboard)
		if status != SUCCESS:
			return status
	return SUCCESS
