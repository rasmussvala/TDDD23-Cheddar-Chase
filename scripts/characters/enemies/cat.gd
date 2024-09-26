extends CharacterBody2D

class_name Cat

@onready var animated_sprite_cat: AnimatedSprite2D = %animated_sprite_cat

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

@export var MOVEMENT_SPEED = 100

# States
enum State {IDLE, MOVING_TO_FOOD, EATING, MOVING_TO_BED, SLEEPING}
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
		State.MOVING_TO_FOOD:
			move_to_target(Vector2(700.0, 300.0))
		State.EATING:
			eating_action(delta)
		State.MOVING_TO_BED:
			move_to_target(Vector2(400.0, 300.0))
		State.SLEEPING:
			sleeping_action(delta)

func make_decision():
	if hunger >= HUNGER_THRESHOLD:
		current_state = State.MOVING_TO_FOOD
	elif tiredness >= TIREDNESS_THRESHOLD:
		current_state = State.MOVING_TO_BED
	else:
		current_state = State.IDLE

func move_to_target(target: Vector2):
	animated_sprite_cat.play("walk")
	var direction = (target - global_position).normalized()
	velocity = direction * MOVEMENT_SPEED
	animated_sprite_cat.rotation = velocity.angle()
	move_and_slide()
	
	# Check if we've reached the target
	if global_position.distance_to(target) < 1:  # ADJUST LATER
		if current_state == State.MOVING_TO_FOOD:
			current_state = State.EATING
		elif current_state == State.MOVING_TO_BED:
			current_state = State.SLEEPING

func idle_action():
	animated_sprite_cat.play("sit")
	make_decision()

func eating_action(delta):
	hunger -= EATING_RATE * delta
	animated_sprite_cat.play("eating")

	if hunger <= 0:
		current_state = State.IDLE
		make_decision()

func sleeping_action(delta):
	tiredness -= SLEEPING_RATE * delta
	animated_sprite_cat.play("stretch") # CHANGE TO SLEEP WHEN AVAILABLE
	
	if tiredness <= 0:
		current_state = State.IDLE
		make_decision()
