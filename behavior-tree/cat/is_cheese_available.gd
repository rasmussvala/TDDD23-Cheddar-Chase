extends BTCondition

func tick(blackboard: Dictionary) -> int:
	var cheeses: Array = get_tree().get_nodes_in_group("cheeses")
	if cheeses.size() > 0:
		blackboard["cheese"] = cheeses[0]
		return SUCCESS
	return FAILURE
