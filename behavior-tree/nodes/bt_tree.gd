class_name BTTree extends Node

enum Status {SUCCESS, FAILURE, RUNNING}

@onready var detection_area_polygon: CollisionPolygon2D = %detection_area_polygon
@onready var cat_mouth_area_polygon: CollisionShape2D = %cat_mouth_area_polygon

var root: BTSelector
var actor: CharacterBody2D
var bed: Sprite2D
var food: Sprite2D


var blackboard: Dictionary = {
	# Chase
	"sees_player": false, # Action
	"chases_player": false, # Action
	"eating_player": false, # Condition
	"hunger_for_player": 100,
	
	# Hunger 
	"hunger": 0.0, # Need
	"max_hunger": 100,
	"hunger_threshold": 80, # Threshold
	"eating_rate": 15, # Rate
	"hunger_increase_rate": 5,
	"eating": false, # Action
	
	# Tiredness
	"tiredness": 0.0, # Need
	"max_tiredness": 100,
	"tiredness_threshold": 95, # Threshold
	"sleeping_rate": 10, # Rate
	"tiredness_increase_rate": 4,
	"sleeping": false # Action
}

func _ready():
	# Init variables 
	root = $root
	actor = get_parent()
	
	# Find things in the scene
	bed = get_tree().get_first_node_in_group("beds")
	food = get_tree().get_first_node_in_group("foods")
	
	# Add things to blackboard
	blackboard["actor"] = actor
	blackboard["bed"] = bed
	blackboard["food"] = food

func _process(delta):
	blackboard["delta"] = delta
	detection_area_polygon.disabled = false
	cat_mouth_area_polygon.disabled = false
	
	if root:
		root.tick(blackboard)

	if not blackboard["eating"]:
		blackboard["hunger"] = min(blackboard["hunger"] + blackboard["hunger_increase_rate"] * delta, blackboard["max_hunger"])

	if not blackboard["sleeping"]:
		blackboard["tiredness"] = min(blackboard["tiredness"] + blackboard["tiredness_increase_rate"] * delta, blackboard["max_tiredness"])
	
	#print("Hunger: %.2f, Tiredness: %.2f" % [blackboard["hunger"], blackboard["tiredness"]])
