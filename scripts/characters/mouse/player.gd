extends CharacterBody2D

# Variables for movement
var speed = 100
var roll_speed = 210
var roll_duration = 0.5
var is_rolling = false
var roll_timer = 0.0
var is_attacking = false
var attack_duration = 0.5  
var is_falling = false

# Spawn
var spawn_point: Vector2

# Variables for Health
var max_health = 10
var current_health = 10
var is_dead = false

# knockback variables
var knockback_velocity = Vector2.ZERO
var knockback_duration = 0.2
var knockback_timer = 0.0
var knockback_strength = 200

# References to nodes
@onready var animated_sprite_2d: AnimatedSprite2D = $animated_sprite_2d
@onready var hit_box: HitBox = $hit_box
@onready var hurt_box: HurtBox = $hurt_box
@onready var death_timer: Timer = $death_timer

func _ready():
	spawn_point = global_position
	animated_sprite_2d.connect("animation_finished", Callable(self, "_on_animation_finished"))
	hurt_box.connect("body_entered", Callable(self, "_on_hurtbox_body_entered"))
	hit_box.disable_hitbox()  # Ensure hitbox is disabled initially
	hurt_box.enable_hurtbox()  # Ensure hurtbox is enabled initially

func _process(delta):
	if is_dead:
		return
	
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 5 * delta)
	else:
		handle_movement_and_actions(delta)
	
	move_and_slide()

# Function to handle the movement and actions
func handle_movement_and_actions(delta):
	# Rolling logic
	if is_rolling:
		roll_timer -= delta
		
		if roll_timer <= 0:
			is_rolling = false
			animated_sprite_2d.play("walk")
			hurt_box.enable_hurtbox()
		else:
			velocity = velocity.normalized() * lerp(roll_speed, 0, 1 - (roll_timer / roll_duration))
	
	# Attacking logic
	elif is_attacking:
		if !animated_sprite_2d.is_playing():
			is_attacking = false
			
			if !is_rolling:
				animated_sprite_2d.play("idle")
			velocity = Vector2.ZERO
		else:
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
				velocity = input_vector.normalized() * speed
				animated_sprite_2d.rotation = velocity.angle()
			else:
				velocity = Vector2.ZERO
	
	else:
		# Handle normal movement input if not rolling or attacking
		if is_falling:
			velocity = Vector2.ZERO  # Prevent movement while falling
			return  # Exit the function if falling
		
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
			velocity = input_vector.normalized() * speed
			
			if !is_colliding():
				animated_sprite_2d.play("walk")
			animated_sprite_2d.rotation = velocity.angle()
		else:
			velocity = Vector2.ZERO
			
			if !is_attacking and !is_rolling:
				animated_sprite_2d.play("idle")
	
		# Roll mechanic: Only allow rolling if there is movement input and the roll action is just pressed
		if Input.is_action_just_pressed("ui_shift") and input_vector.length() > 0:
			is_rolling = true
			roll_timer = roll_duration
			velocity = velocity.normalized() * roll_speed
			animated_sprite_2d.play("roll")
			hurt_box.disable_hurtbox()
	
	# Play attack animation if attack button is pressed and not rolling
	if Input.is_action_just_pressed("ui_attack") and !is_rolling and !is_falling:
		is_attacking = true
		animated_sprite_2d.play("attack")
		hit_box.enable_hitbox()
		hurt_box.disable_hurtbox()
	
	# Play obstruct animation if there is a collision and not rolling
	if is_colliding() and !is_rolling and !is_attacking and !is_falling:
		animated_sprite_2d.play("obstruct")

# Function to check for collision
func is_colliding() -> bool:
	for i in range(get_slide_collision_count()):
		
		if get_slide_collision(i):
			return true
	return false

# Function to handle taking damage
func take_damage(amount: int, attacker_position: Vector2):
	if is_dead:
		return
	
	current_health -= amount
	
	if current_health <= 0:
		die()
	else:
		# Calculate knockback direction here
		var direction = (position - attacker_position).normalized()
		knockback_velocity = direction * knockback_strength
		knockback_timer = knockback_duration
		animated_sprite_2d.play("damaged")

# Function to handle player death
func die():
	is_dead = true
	animated_sprite_2d.play("death")
	
	Engine.time_scale = 0.5
	death_timer.start()

# Function to check if hurtbox is entered
func _on_hurtbox_body_entered(body):
	if body is HitBox:
		var attacker_position = body.global_position
		take_damage(1, attacker_position)

# Function to handle when animation is finished
func _on_animation_finished() -> void:
	if is_rolling:
		is_rolling = false
		animated_sprite_2d.play("walk")  
	elif is_attacking:
		is_attacking = false
		hit_box.disable_hitbox()
		hurt_box.enable_hurtbox()
		
		if !is_rolling:
			animated_sprite_2d.play("idle")
		velocity = Vector2.ZERO

# Function that handles when the timer is over
func _on_death_timer_timeout() -> void:
	Engine.time_scale = 1
	queue_free()
	get_tree().reload_current_scene()

# Function to reset the player after falling
func reset_player_after_fall():
	global_position = spawn_point
	
	velocity = Vector2.ZERO
	
	if current_health <= 0:
		die()
	else:
		$animated_sprite_2d.scale = Vector2.ONE
		$animated_sprite_2d.modulate = Color(1, 1, 1, 1) 
		$animated_sprite_2d.rotation_degrees = 0 

# Function to handle when the player falls into a pit
func fall_in_pit():
	if is_falling:
		return
	is_falling = true
	
	animated_sprite_2d.play("fall")
	
	current_health -= 1
	
	var tween = get_tree().create_tween()
	tween.tween_property($animated_sprite_2d, "scale", Vector2(), 1)
	tween.parallel().tween_property($animated_sprite_2d, "modulate", Color.BLACK, 0.5)
	tween.parallel().tween_property($animated_sprite_2d, "rotation_degrees", 360.0, 2)
	await tween.finished
	
	reset_player_after_fall()
	
	is_falling = false
