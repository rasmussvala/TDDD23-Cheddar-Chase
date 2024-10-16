extends BTAction

@export var need: String
@export var rate: String
@export var action: String
@onready var detection_area_polygon: CollisionPolygon2D = %detection_area_polygon

func tick(blackboard: Dictionary) -> int:
	blackboard["eating_player"] = true
	blackboard["hunger_for_player"] -= blackboard["delta"] * blackboard[rate]
	
	# Cat is satisfied with need
	if blackboard[need] < 0:
		blackboard[need] = 0
		blackboard[action] = false
		return SUCCESS
	
	var animated_sprite = blackboard["actor"].get_node("animated_sprite_cat")
	animated_sprite.play("eating_player")
	
	return RUNNING
