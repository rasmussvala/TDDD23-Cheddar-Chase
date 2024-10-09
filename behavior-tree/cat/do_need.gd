extends BTAction

@export var need: String
@export var rate: String
@export var action: String

func tick(blackboard: Dictionary) -> int:
	blackboard[need] -= blackboard["delta"] * blackboard[rate]
	
	# Cat is satisfied with need
	if blackboard[need] < 0:
		blackboard[need] = 0
		blackboard[action] = false
		return SUCCESS
	
	var animated_sprite = blackboard["actor"].get_node("animated_sprite_cat")
	animated_sprite.play(action)
	
	return RUNNING
