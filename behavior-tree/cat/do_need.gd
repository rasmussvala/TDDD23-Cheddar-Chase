extends BTAction

@export var need: String
@export var rate: String
@export var action: String

func tick(blackboard: Dictionary) -> int:
	if blackboard[need] > 0:
		blackboard[need] -= blackboard["delta"] * blackboard[rate]
		
		var animated_sprite = blackboard["actor"].get_node("animated_sprite_cat")
		animated_sprite.play(action)
		
		return RUNNING
	else:
		blackboard[action] = false
		return SUCCESS
