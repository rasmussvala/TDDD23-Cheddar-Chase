class_name BTTree extends Node

enum Status { SUCCESS, FAILURE, RUNNING }

var root: BTSelector

var blackboard: Dictionary = {
	"hunger": 0.0,
	"max_hunger": 100,
	"hunger_threshold": 80,
	"eating_rate": 10,
	"hunger_increase_rate": 5
}

func _ready():
	root = $behavior

func _process(delta):
	if root:
		root.tick(blackboard)
	
	# Increase hunger and tiredness over time
	blackboard["hunger"] = min(blackboard["hunger"] + blackboard["hunger_increase_rate"] * delta, blackboard["max_hunger"])
	
	print(blackboard["hunger"])
