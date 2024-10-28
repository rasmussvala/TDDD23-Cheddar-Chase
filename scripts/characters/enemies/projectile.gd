extends Area2D

var damage = 1
var speed = 200  # Speed of the projectile
var velocity = Vector2.ZERO  # Variable to store the velocity

@onready var hit_box: HitBox = $hit_box

func _ready():
	$vos_notifier.connect("screen_exited", Callable(self, "_on_screen_exited"))
	hit_box.enable_hitbox()  # Ensure hitbox is enabled initially

func _on_screen_exited():
	queue_free()

# Set the initial velocity of the projectile
func set_velocity(new_velocity: Vector2):
	velocity = new_velocity

func _process(delta):
	# Move the projectile based on its velocity
	position += velocity * delta

	# Rotate the projectile to face the direction it's moving
	if velocity.length() > 0:
		rotation = velocity.angle()
