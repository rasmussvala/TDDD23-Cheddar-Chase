extends Area2D

# Variables for animated sprites
@onready var animated_sprite_2d_1 = $animated_sprite_trap
@onready var animated_sprite_2d_2 = $animated_sprite_pow
@onready var player = %player
var has_activated = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

	# Connect the animation_finished signal of animated_sprite_2d_2
	animated_sprite_2d_2.connect("animation_finished", Callable(self, "_on_pow_animation_finished"))

# Function called when a body enters the trap
func _on_body_entered(body: Node) -> void:
	if not has_activated:
		if !body.is_flying:
			if body.has_method("die"):
				body.animated_sprite_2d.visible = false
				animated_sprite_2d_2.play("pow")
				if body == player:
					animated_sprite_2d_1.play("player_trapped")
				else:
					animated_sprite_2d_1.play("bug_trapped")
				
				body.die()
				has_activated = true

# Function to handle when the "pow" animation finishes
func _on_pow_animation_finished():
	animated_sprite_2d_2.play("nothing")
