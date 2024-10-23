class_name BTSelector extends BTCompositeNode

func tick(blackboard: Dictionary) -> int:
	for child in get_children():
		var status = child.tick(blackboard)
		if status != FAILURE:
			return status
	return FAILURE
