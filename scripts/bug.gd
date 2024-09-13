extends CharacterBody2D

# Variables for movement
var speed = 25
var chase_speed = 25
var wander_speed = 15
var player_chase = false
var player = null
var wander_target = Vector2.ZERO
var wander_time = 0
var wander_interval = 3
var pause_time = 0
var pause_duration = 2

# Variables for Health
var max_health = 2
var current_health = 2
var is_dead = false

# Variables for Knockback
var knockback_velocity = Vector2.ZERO
var knockback_duration = 0.2
var knockback_timer = 0.0
var knockback_strength = 150

# References to nodes
@onready var sprite: AnimatedSprite2D = $sprite
@onready var ray_cast: RayCast2D = $detectionRay
@onready var detection_area = $detectionArea
@onready var hit_box: HitBox = $HitBox

func _ready():
	hit_box.enable_hitbox()
	
	if not ray_cast:
		ray_cast = RayCast2D.new()
		add_child(ray_cast)
	
	ray_cast.enabled = true
	ray_cast.collision_mask = 1  # Ensure this is set to the layer of the player

func _physics_process(delta):
	if is_dead:
		return
	
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 500 * delta)
	else:
		if player and is_instance_valid(player) and can_see_player():
			chase_player()
			pause_time = 0
		elif pause_time < pause_duration:
			pause(delta)
		else:
			wander(delta)
	
	move_and_slide()
	
	if velocity != Vector2.ZERO:
		sprite.rotation = velocity.angle()

func can_see_player() -> bool:
	if not player or not is_instance_valid(player):
		return false
	
	ray_cast.global_position = global_position
	ray_cast.target_position = player.global_position - global_position
	ray_cast.force_raycast_update()
	
	return not ray_cast.is_colliding()

func chase_player():
	if not player or not is_instance_valid(player):
		return
	
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * chase_speed

func pause(delta):
	pause_time += delta
	velocity = Vector2.ZERO

func wander(delta):
	wander_time += delta
	if wander_time >= wander_interval:
		wander_time = 0
		wander_target = global_position + Vector2(randf_range(-100, 100), randf_range(-100, 100))
	
	if global_position.distance_to(wander_target) > 5:
		velocity = (wander_target - global_position).normalized() * wander_speed
	else:
		velocity = Vector2.ZERO

func _on_detection_area_body_entered(body):
	if body and body.name == "Player":
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body and body.name == "Player":
		player = null
		player_chase = false
		pause_time = 0

func take_damage(amount: int, attacker_position: Vector2):
	if is_dead:
		return
	
	current_health -= amount
	
	if current_health <= 0:
		die()
	else:
		var direction = (global_position - attacker_position).normalized()
		knockback_velocity = direction * knockback_strength
		knockback_timer = knockback_duration
		
		sprite.play("damaged")
		await sprite.animation_finished
		sprite.play("walk")

func die():
	is_dead = true
	sprite.play("death")
	await sprite.animation_finished
	queue_free()
