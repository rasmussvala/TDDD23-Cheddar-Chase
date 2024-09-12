class_name MyHitBox
extends Area2D

# Export a variable for damage
@export var damage: int = 1

# Reference to the CollisionShape2D node
@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	# Initialize the hitbox as disabled
	collision_layer = 5
	collision_mask = 0
	disable_hitbox()

# Function to enable the hitbox
func enable_hitbox() -> void:
	collision_shape.disabled = false

# Function to disable the hitbox
func disable_hitbox() -> void:
	collision_shape.disabled = true
