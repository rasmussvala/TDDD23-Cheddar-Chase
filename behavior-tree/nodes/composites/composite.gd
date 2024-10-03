class_name BTCompositeNode extends BTNode

func tick(blackboard: Dictionary) -> int:
	for child in get_children():
		if child is BTNode:
			var status = child.tick(blackboard)
			if status != SUCCESS:
				return status
	return SUCCESS
