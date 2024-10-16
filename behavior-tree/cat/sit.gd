extends BTAction

func tick(blackboard: Dictionary) -> int:
	var actor = blackboard["actor"]
	var animated_sprite = actor.get_node("animated_sprite_cat")
	animated_sprite.play("sit")
	
	return SUCCESS
