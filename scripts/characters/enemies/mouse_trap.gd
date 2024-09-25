extends Area2D

# Variables for animated sprites
@onready var animated_sprite_2d_trap = $animated_sprite_trap
@onready var animated_sprite_2d_pow = $animated_sprite_pow
@onready var player = %player
var has_activated = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

	# Connect the animation_finished signal of animated_sprite_2d_2
	animated_sprite_2d_pow.connect("animation_finished", Callable(self, "_on_pow_animation_finished"))

func _on_body_entered(body: Node) -> void:
	if has_activated or body.is_flying or not body.has_method("die"):
		return
	
	body.animated_sprite_2d.visible = false
	animated_sprite_2d_pow.play("pow")
	
	if body == player:
		animated_sprite_2d_trap.play("player_trapped")
	else:
		animated_sprite_2d_trap.play("bug_trapped")
	
	body.die()
	has_activated = true

# Function to handle when the "pow" animation finishes
func _on_pow_animation_finished():
	animated_sprite_2d_pow.play("nothing")
