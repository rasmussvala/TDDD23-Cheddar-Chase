class_name BTSequence extends BTCompositeNode

func tick(delta: float) -> int:
	for child in children:
		var response = child.tick(delta)
		if response != Status.SUCCESS:
			return response
	return Status.SUCCESS
