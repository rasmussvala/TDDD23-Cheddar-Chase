extends CharacterBody2D

class_name Cat

# Cat's attributes
var hunger: float = 0.0
var tiredness: float = 0.0

# Constants
@export var MAX_HUNGER = 100.0
@export var HUNGER_INCREASE_RATE = 5.0
@export var HUNGER_THRESHOLD = 80
@export	var EATING_RATE = 25 

@export var MAX_TIREDNESS = 100.0
@export var TIREDNESS_INCREASE_RATE = 4.0
@export var TIREDNESS_THRESHOLD = 95 
@export var SLEEPING_RATE = 20

# States
enum State {IDLE, EATING, SLEEPING}
var current_state = State.IDLE

func _process(delta):
	print("hunger: " + str("%.2f" % hunger) 
	+ ", tiredness: " + str("%.2f" % tiredness) 
	+ ", state: " + str(current_state))
	
	# Increase hunger and tiredness over time
	hunger = min(hunger + HUNGER_INCREASE_RATE * delta, MAX_HUNGER)
	tiredness = min(tiredness + TIREDNESS_INCREASE_RATE * delta, MAX_TIREDNESS)
	
	# Perform action based on current state
	match current_state:
		State.IDLE:
			idle_action()
		State.EATING:
			eating_action(delta)
		State.SLEEPING:
			sleeping_action(delta)

func make_decision():
	if hunger >= HUNGER_THRESHOLD:
		current_state = State.EATING
	elif tiredness >= TIREDNESS_THRESHOLD:
		current_state = State.SLEEPING
	else:
		current_state = State.IDLE

func idle_action():
	make_decision()

func eating_action(delta):
	hunger -= EATING_RATE * delta
	if hunger <= 0:
		current_state = State.IDLE
		make_decision()

func sleeping_action(delta):
	tiredness -= SLEEPING_RATE * delta
	if tiredness <= 0:
		current_state = State.IDLE
		make_decision()
