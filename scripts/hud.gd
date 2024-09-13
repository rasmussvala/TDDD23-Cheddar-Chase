extends CanvasLayer

@onready var score_label: Label = $ScoreLabel

func update_score(score) -> void:
	score_label.text = str(score) + " Cheese"
