extends Node

@onready var music_player: AudioStreamPlayer = $audio_stream

func _ready():
	music_player.play()

# Function to switch the currently playing music
func change_music(new_music: AudioStream):
	if music_player.stream != new_music:
		music_player.stop()
		music_player.stream = new_music 
		music_player.play() 

# This function will restart the music when it finishes
func _on_music_finished():
	music_player.play()
