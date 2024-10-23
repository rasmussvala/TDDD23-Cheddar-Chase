extends CanvasLayer

@onready var score_label: Label = $score_label
@onready var timer_label: Label = $timer_label
@onready var star_time_label: Label = $star_time_label
@onready var fish_icon: Sprite2D = $anchor_control/fish_icon
@onready var heart_1: Sprite2D = $anchor_control/heart_1
@onready var heart_2: Sprite2D = $anchor_control/heart_2
@onready var heart_3: Sprite2D = $anchor_control/heart_3
@onready var star_1: Sprite2D = $anchor_star/star_1
@onready var star_2: Sprite2D = $anchor_star/star_2
@onready var star_3: Sprite2D = $anchor_star/star_3

var heart_filled: Texture2D = preload("res://assets/heart/heart-filled.png")
var heart_empty: Texture2D = preload("res://assets/heart/heart-empty.png")

var star_filled: Texture2D = preload("res://assets/testlevel/star-hud-filled.png")
var star_empty: Texture2D = preload("res://assets/testlevel/star-hud-empty.png")

func update_timer(time_passed: float, level_star_time: int) -> void:
	var minutes = int(time_passed / 60)
	var seconds = int(time_passed) % 60
	var milliseconds = int((time_passed - int(time_passed)) * 100)
	
	# Format the text as MM:SS.MS
	timer_label.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	
	# Convert level star time to MM:SS format
	var star_minutes = int(level_star_time / 60)
	var star_seconds = level_star_time % 60
	star_time_label.text = "%02d:%02d" % [star_minutes, star_seconds]


func update_stars(stars_earned: int) -> void:
	# Save all star sprites in an array
	var stars = [star_3, star_2, star_1]
	
	# Loop through all stars and update sprites according to earned stars
	for i in range(stars.size()):
		if i < stars_earned:
			stars[i].texture = star_filled
		else:
			# If the star was filled but is now being emptied, call bounce_sprite
			if stars[i].texture != star_empty:
				stars[i].texture = star_empty
				bounce_sprite(stars[i])


func update_score(score, max_score) -> void:
	score_label.text = str(score) + "/" + str(max_score) + " Cheese"

func update_health(new_health) -> void:
	# Save all sprite in array
	var hearts = [heart_3, heart_2, heart_1]
	
	# Loop through all hearts and update sprites according to new_health
	for i in range(hearts.size()):
		if i < new_health:
			hearts[i].texture = heart_filled
			# Bounce the heart when gaining health
			if i == new_health - 1:
				bounce_sprite(hearts[i])
		elif i >= new_health:
			hearts[i].texture = heart_empty
			# Bounce the heart when losing health
			if i == new_health:
				bounce_sprite(hearts[i])

# Give a visual feedback on which heart is being removed
func bounce_sprite(heart: Sprite2D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(heart, "scale", Vector2(10.0, 10.0), 0.15).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(heart, "scale", Vector2(8.0, 8.0), 0.15).set_trans(Tween.TRANS_BOUNCE)

func update_fish_icon(has_fish: bool) -> void:
	if has_fish:
		fish_icon.visible = true
	else:
		fish_icon.visible = false
