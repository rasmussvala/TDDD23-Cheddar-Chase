extends BTAction

func tick(blackboard: Dictionary) -> int:
	blackboard["food"].texture = load("res://assets/characters/enemies/cat/plate-empty.png")
	return SUCCESS
