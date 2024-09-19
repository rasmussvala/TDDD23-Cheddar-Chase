class_name HitBox
extends Area2D

# Export a variable for damage
@export var damage: int = 1

# Reference to the CollisionShape2D node
@onready var hit_box_collision: CollisionShape2D = $hit_box_collision

func _ready() -> void:
	disable_hitbox()

# Function to enable the hitbox
func enable_hitbox() -> void:
	hit_box_collision.disabled = false

# Function to disable the hitbox
func disable_hitbox() -> void:
	hit_box_collision.disabled = true
