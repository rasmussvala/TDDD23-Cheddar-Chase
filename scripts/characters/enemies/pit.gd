extends Area2D

var bodies_in_pit: Array = []

func _ready():
	# Check if signals are already connected before connecting them
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	if not body_exited.is_connected(_on_body_exited):
		body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("fall_in_pit") and not body in bodies_in_pit:
		bodies_in_pit.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body in bodies_in_pit:
		bodies_in_pit.erase(body)

func _physics_process(_delta: float) -> void:
	for body in bodies_in_pit.duplicate():  # Iterate over a copy of the array
		if body.has_method("fall_in_pit"):
			if not body.is_rolling:
				body.fall_in_pit()
				bodies_in_pit.erase(body)  # Remove the body after it falls
