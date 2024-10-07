class_name BTTree extends Node

enum Status { SUCCESS, FAILURE, RUNNING }

var root: BTSelector
var actor: CharacterBody2D

var blackboard: Dictionary = {
	#Hunger 
	"hunger": 0.0,
	"max_hunger": 100,
	"hunger_threshold": 80,
	"eating_rate": 10,
	"hunger_increase_rate": 5,
	"is_eating": false  ,
	
	# Tiredness
	"tiredness": 0.0,
	"max_tiredness": 100,
	"tiredness_threshold": 95,
	"sleeping_rate": 10,
	"tiredness_increase_rate": 4,
	"is_sleeping": false
}

func _ready():
	root = $root
	actor = get_parent()
	blackboard["actor"] = actor

func _process(delta):
	blackboard["delta"] = delta
	
	if root:
		root.tick(blackboard)
	   
	blackboard["hunger"] = min(blackboard["hunger"] + blackboard["hunger_increase_rate"] * delta, blackboard["max_hunger"])
	blackboard["tiredness"] = min(blackboard["tiredness"] + blackboard["tiredness_increase_rate"] * delta, blackboard["max_tiredness"])
		
	print("Hunger: %.2f, Tiredness: %.2f" % [blackboard["hunger"], blackboard["tiredness"]])
