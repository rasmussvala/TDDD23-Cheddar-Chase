extends CharacterBody2D

var speed = 25
var chase_speed = 25
var wander_speed = 15
var playerChase = false
var player = null
var wander_target = Vector2.ZERO
var wander_time = 0
var wander_interval = 3  # Time in seconds before choosing a new wander direction
var pause_time = 0
var pause_duration = 2  # Time in seconds to pause when losing sight of player

@onready var animated_sprite_2d: AnimatedSprite2D = $sprite
@onready var ray_cast: RayCast2D = $detectionRay

func _ready():
	# Ensure the RayCast2D is set up correctly
	if not ray_cast:
		ray_cast = RayCast2D.new()
		add_child(ray_cast)
	ray_cast.enabled = true
	ray_cast.collision_mask = 1  # Adjust this to match your world/obstacle layer

func _physics_process(delta):
	if player and can_see_player():
		chase_player()
		pause_time = 0
	elif pause_time < pause_duration:
		pause(delta)
	else:
		wander(delta)
	
	move_and_slide()
	
	if velocity != Vector2.ZERO:
		animated_sprite_2d.rotation = velocity.angle()

func can_see_player() -> bool:
	if not player:
		return false
	
	ray_cast.global_position = global_position
	ray_cast.target_position = player.global_position - global_position
	ray_cast.force_raycast_update()
	
	return not ray_cast.is_colliding()

func chase_player():
	var direction = (player.position - position).normalized()
	velocity = direction * chase_speed

func pause(delta):
	pause_time += delta
	velocity = Vector2.ZERO

func wander(delta):
	wander_time += delta
	if wander_time >= wander_interval:
		wander_time = 0
		wander_target = position + Vector2(randf_range(-100, 100), randf_range(-100, 100))
	
	if position.distance_to(wander_target) > 5:
		velocity = (wander_target - position).normalized() * wander_speed
	else:
		velocity = Vector2.ZERO

func _on_detection_area_body_entered(body):
	player = body
	playerChase = true

func _on_detection_area_body_exited(_body):
	player = null
	playerChase = false
	pause_time = 0  # Reset pause timer when player exits detection area
