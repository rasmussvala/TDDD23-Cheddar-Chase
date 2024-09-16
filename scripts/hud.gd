extends CanvasLayer

@onready var score_label: Label = $score_label

func update_score(score) -> void:
	score_label.text = str(score) + " Cheese"
