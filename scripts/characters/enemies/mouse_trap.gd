extends Area2D

# Reference the player's node (update the path if necessary)
@onready var player: CharacterBody2D = %player
@onready var animated_sprite_2d_1 = $animated_sprite_2d_1
@onready var animated_sprite_2d_2 = $animated_sprite_2d_2

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

	# Connect the animation_finished signal of animated_sprite_2d_2
	animated_sprite_2d_2.connect("animation_finished", Callable(self, "_on_pow_animation_finished"))

# Function called when a body enters the trap
func _on_body_entered(body: Node) -> void:
	# Disable player's sprite
	body.animated_sprite_2d.visible = false
	# Play the "pow" animation on animated_sprite_2d_2
	animated_sprite_2d_2.play("pow")
	# Play the "trapped" animation on animated_sprite_2d_1
	animated_sprite_2d_1.play("trapped")
	body.die()

# Function to handle when the "pow" animation finishes
func _on_pow_animation_finished():
	# Switch "pow" back to "nothing" after the animation has finished
	animated_sprite_2d_2.play("nothing")
