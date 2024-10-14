extends BTCondition

func tick(blackboard: Dictionary) -> int:
	var sprite = blackboard.get("food")
	
	# Food is in the bowl 
	if sprite.texture == preload("res://assets/cat/stuff/plate-food.png"):
		return SUCCESS
	# Bowl is empty
	else:
		return FAILURE
