class_name BTSelector extends BTCompositeNode

func tick(delta: float) -> int:
	for child in children:
		var response = child.tick(delta)
		if response != Status.FAILURE:
			return response
	return Status.FAILURE
