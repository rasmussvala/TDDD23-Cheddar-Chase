extends Sprite2D

@onready var game_manager: Node = %game_manager
@onready var plate: Sprite2D = $"."

func _on_area_2d_plate_body_entered(body: Node2D) -> void:
	# Player is walking over the plate to drop the fish. 
	if body.name == "player" and game_manager.get_value_mouse_has_fish():
		game_manager.mouse_has_fish(false)
		plate.texture = preload("res://assets/cat/stuff/plate-food.png")
