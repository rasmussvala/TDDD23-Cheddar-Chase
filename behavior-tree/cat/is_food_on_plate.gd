extends BTCondition

func tick(blackboard: Dictionary) -> int:
	var sprite = blackboard.get("food")
	
	# Food is on the plate 
	if sprite.texture == preload("res://assets/cat/stuff/plate-food.png"):
		return SUCCESS
	# Plate is empty
	else:
		return FAILURE
