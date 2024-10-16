extends BTAction

func tick(blackboard: Dictionary) -> int:
	blackboard["food"].texture = load("res://assets/cat/stuff/plate-empty.png")
	return SUCCESS
