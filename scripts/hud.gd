extends CanvasLayer

@onready var score_label: Label = $score_label
@onready var heart_1: Sprite2D = $heart_1
@onready var heart_2: Sprite2D = $heart_2
@onready var heart_3: Sprite2D = $heart_3

var heart_filled: Texture2D = preload("res://assets/heart/heart-filled.png")
var heart_empty: Texture2D = preload("res://assets/heart/heart-empty.png")

func update_score(score) -> void:
	score_label.text = str(score) + " Cheese"

func update_health(health) -> void:
	var hearts = [heart_3, heart_2, heart_1]
	
	for i in range(hearts.size()):
		if i < health:
			hearts[i].texture = heart_filled
		else: 
			hearts[i].texture = heart_empty
