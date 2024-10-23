extends CanvasLayer

var is_paused: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # Make sure we can process this scene when paused

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # Escape key
		toggle()

func toggle() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused  # Pause the game
	visible = is_paused   # Show/hide the pause menu

func _on_resume_button_pressed() -> void:
	toggle()

func _on_restart_button_pressed() -> void:
	pass # Replace with function body.

func _on_menu_button_pressed() -> void:
	pass # Replace with function body.
