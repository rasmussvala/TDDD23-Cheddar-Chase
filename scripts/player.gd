extends CharacterBody2D

# Variables for movement
var speed = 100
var roll_speed = 210
var roll_duration = 0.5
var is_rolling = false
var roll_timer = 0.0
var is_attacking = false
var attack_duration = 0.5  # Duration of the attack animation

# Health and knockback variables
var max_health = 10
var current_health = 10
var is_dead = false
var knockback_velocity = Vector2.ZERO
var knockback_duration = 0.2
var knockback_timer = 0.0
var knockback_strength = 200

# Reference to the playerSprite node
@onready var sprite = $playerSprite
@onready var hitbox: MyHitBox = $HitBox
@onready var hurtbox = $HurtBox  # Assuming a HurtBox Area2D for collision detection

func _ready():
	# Correct connection to the animation_finished signal using Callable
	sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	hitbox.disable_hitbox()  # Ensure hitbox is disabled initially
	hurtbox.enable_hurtbox()  # Ensure hurtbox is enabled initially
	hurtbox.connect("body_entered", Callable(self, "_on_hurtbox_body_entered"))

func _process(delta):
	if is_dead:
		return
	
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 5 * delta)  # Reduce knockback gradually
	else:
		handle_movement_and_actions(delta)
	
	# Move the character using the set velocity property
	move_and_slide()

func handle_movement_and_actions(delta):
	if is_rolling:
		# Rolling logic
		roll_timer -= delta
		if roll_timer <= 0:
			is_rolling = false  # End roll
			sprite.play("walk")  # Return to walk animation when done
		else:
			# Gradually reduce roll speed to zero as the timer goes down
			velocity = velocity.normalized() * lerp(roll_speed, 0, 1 - (roll_timer / roll_duration))
	
	elif is_attacking:
		# Handle attacking
		if !sprite.is_playing():
			is_attacking = false
			# If not rolling, set to idle
			if !is_rolling:
				sprite.play("idle")
			velocity = Vector2.ZERO  # Stop moving after attack animation
		else:
			# During attack, only stop movement if no input is given
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
				sprite.rotation = velocity.angle()
			else:
				velocity = Vector2.ZERO  # Stop moving if no input

	else:
		# Handle normal movement input if not rolling or attacking
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
		else:
			velocity = Vector2.ZERO  # Stop moving if no input is detected
			if !is_attacking and !is_rolling:
				sprite.play("idle")  # Play idle animation if not attacking or rolling

		# Roll mechanic: Only allow rolling if there is movement input and the roll action is just pressed
		if Input.is_action_just_pressed("ui_shift") and input_vector.length() > 0:  # Shift key
			is_rolling = true
			roll_timer = roll_duration
			velocity = velocity.normalized() * roll_speed  # Fast forward motion
			sprite.play("roll")  # Play roll animation

	if Input.is_action_just_pressed("ui_attack") and !is_rolling:
		is_attacking = true
		sprite.play("attack")
		hitbox.enable_hitbox()  # Enable hitbox at the start of the attack
		hurtbox.disable_hurtbox()	# Disable hurtbox at the start of the attack

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

# Function to handle taking damage
func take_damage(amount: int, attacker_position: Vector2):
	if is_dead:
		return
	
	current_health -= amount
	print("Player took damage! Current health: ", current_health)
	
	if current_health <= 0:
		die()
	else:
		# Calculate knockback direction here
		var direction = (position - attacker_position).normalized()
		knockback_velocity = direction * knockback_strength
		knockback_timer = knockback_duration
		sprite.play("damaged")

func die():
	is_dead = true
	print("Player died! Game will reset.")
	# Reset the game or reload the scene
	get_tree().reload_current_scene()

# Hurtbox body entered callback
func _on_hurtbox_body_entered(body):
	# Assume the body is the attacker's hitbox and it has a position
	if body is MyHitBox:
		var attacker_position = body.global_position
		take_damage(1, attacker_position)  # Pass the damage amount and the attacker’s position

# Animation finished callback
func _on_animation_finished() -> void:
	if is_rolling:
		is_rolling = false  # Ensure rolling is set to false when the animation finishes
		sprite.play("walk")  # Return to walk animation after rolling ends
	elif is_attacking:
		is_attacking = false
		hitbox.disable_hitbox()
		hurtbox.enable_hurtbox()
		# Ensure idle animation plays when attack is done if not rolling
		if !is_rolling:
			sprite.play("idle")
		velocity = Vector2.ZERO  # Stop moving after attack animation
