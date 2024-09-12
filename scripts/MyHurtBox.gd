class_name MyHurtBox
extends Area2D

func _ready() -> void:
		collision_layer = 0
		collision_mask = 5
		connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(hitbox: MyHitBox) -> void:
	print("HITBOX ENCOUNTERED")
	
	if hitbox == null:
		return

	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
