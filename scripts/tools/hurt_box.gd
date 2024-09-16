class_name HurtBox
extends Area2D

# Reference to the CollisionShape2D node
@onready var hurt_box_collision: CollisionShape2D = $hurt_box_collision

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

# Function to enable the hurtbox
func enable_hurtbox() -> void:
	hurt_box_collision.disabled = false

# Function to disable the hurtbox
func disable_hurtbox() -> void:
	hurt_box_collision.disabled = true

# Function to activate take_damage
func _on_area_entered(hit_box: HitBox) -> void:
	if hit_box == null:
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hit_box.damage, hit_box.global_position)
