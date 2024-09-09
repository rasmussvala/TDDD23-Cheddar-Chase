extends CharacterBody2D

# Variables for movement
var speed = 100  # Normal movement speed
var roll_speed = 210  # Initial speed for rolling
var roll_duration = 0.5  # Duration of the roll in seconds
var is_rolling = false  # Boolean to check if the player is rolling
var roll_timer = 0.0  # Timer to track roll duration

# Reference to the playerSprite node
@onready var sprite = $playerSprite

func _ready():
	# Correct connection to the animation_finished signal using Callable
	sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _process(delta):
	if is_rolling:
		# Rolling logic
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false  # End roll
			sprite.play("walk")  # Return to walk animation when done
		else:
			# Gradually reduce roll speed to zero as the timer goes down
			velocity = velocity.normalized() * lerp(roll_speed, 0, 1 - (roll_timer / roll_duration))
	else:
		# Handle normal movement input if not rolling
		velocity = Vector2.ZERO
		
		var input_vector = Vector2.ZERO
		if Input.is_action_pressed("ui_right"):
			input_vector.x += 1
		if Input.is_action_pressed("ui_left"):
			input_vector.x -= 1
		if Input.is_action_pressed("ui_down"):
			input_vector.y += 1
		if Input.is_action_pressed("ui_up"):
			input_vector.y -= 1

		if input_vector.length() > 0:
			# Normalize the input_vector to ensure consistent speed in all directions
			velocity = input_vector.normalized() * speed
			# Only play the walk animation if not colliding and not rolling
			if !is_colliding():
				sprite.play("walk")  # Play walking animation
			# Rotate the sprite to face the direction of movement
			sprite.rotation = velocity.angle()

			# Roll mechanic: Only allow rolling if there is movement input and the roll action is just pressed
			if Input.is_action_just_pressed("ui_shift") and input_vector.length() > 0:  # Shift key
				is_rolling = true
				roll_timer = roll_duration
				velocity = velocity.normalized() * roll_speed  # Fast forward motion
				sprite.play("roll")  # Play roll animation
		else:
			# Play idle animation if no movement and not colliding
			if !is_colliding():
				sprite.play("idle")

	# Move the character using the set velocity property
	move_and_slide()

	# Play obstruct animation if there is a collision and not rolling
	if is_colliding() and !is_rolling:
		sprite.play("obstruct")

# Function to check for collision
func is_colliding() -> bool:
	# Check for collisions after moving
	for i in range(get_slide_collision_count()):
		if get_slide_collision(i):
			return true  # Collision detected
	return false  # No collision detected

# Animation finished callback
func _on_animation_finished():
	if is_rolling:
		is_rolling = false  # Ensure rolling is set to false when the animation finishes
		sprite.play("walk")  # Return to walk animation after rolling ends
