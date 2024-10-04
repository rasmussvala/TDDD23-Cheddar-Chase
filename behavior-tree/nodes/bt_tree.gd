class_name BTTree extends Node

enum Status { SUCCESS, FAILURE, RUNNING }

var root: BTSelector
var blackboard: Dictionary = {
	"hunger": 0.0,
	"max_hunger": 100,
	"hunger_threshold": 80,
	"eating_rate": 10,
	"hunger_increase_rate": 5,
	"is_eating": false  
}

func _ready():
	root = $root

func _process(delta):
	blackboard["delta"] = delta
	
	if root:
		root.tick(blackboard)
	   
	blackboard["hunger"] = min(blackboard["hunger"] + blackboard["hunger_increase_rate"] * delta, blackboard["max_hunger"])
	
	print(blackboard["hunger"])
