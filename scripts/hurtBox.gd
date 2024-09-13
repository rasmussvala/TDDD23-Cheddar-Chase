class_name HurtBox
extends Area2D

# Reference to the CollisionShape2D node
@onready var collision_shape = $CollisionShape2D

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

# Function to enable the hurtbox
func enable_hurtbox() -> void:
	collision_shape.disabled = false

# Function to disable the hurtbox
func disable_hurtbox() -> void:
	collision_shape.disabled = true

# Function to activate take_damage
func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage, hitbox.global_position)
