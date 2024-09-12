extends CharacterBody2D

# Variables for movement
var speed = 100
var roll_speed = 210
var roll_duration = 0.5
var is_rolling = false
var roll_timer = 0.0
var is_attacking = false
var attack_duration = 0.5  # Duration of the attack animation

# Reference to the playerSprite node
@onready var sprite = $playerSprite
@onready var hitbox: MyHitBox = $HitBox

func _ready():
	# Correct connection to the animation_finished signal using Callable
	sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	hitbox.disable_hitbox()  # Ensure hitbox is disabled initially

func _process(delta):
	if is_attacking:
		# Handle attacking
		if not sprite.is_playing():
			is_attacking = false
			# If not rolling, set to idle
			if !is_rolling:
				sprite.play("idle")
		else:
			# Ensure that we don't handle movement while attacking
			return
	
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
			# Only play the walk animation if not colliding
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
	
	if Input.is_action_just_pressed("ui_attack") and !is_rolling:
		is_attacking = true
		sprite.play("attack")
		hitbox.enable_hitbox()  # Enable hitbox at the start of the attack

	# Play obstruct animation if there is a collision and not rolling
	if is_colliding() and !is_rolling and !is_attacking:
		sprite.play("obstruct")

# Function to check for collision
func is_colliding() -> bool:
	# Check for collisions after moving
	for i in range(get_slide_collision_count()):
		if get_slide_collision(i):
			return true  # Collision detected
	return false  # No collision detected

# Animation finished callback
func _on_animation_finished() -> void:
	if is_rolling:
		is_rolling = false  # Ensure rolling is set to false when the animation finishes
		sprite.play("walk")  # Return to walk animation after rolling ends
	elif is_attacking:
		is_attacking = false
		hitbox.disable_hitbox()
		# Ensure idle animation plays when attack is done if not rolling
		if !is_rolling:
			sprite.play("idle")
