extends Node
class_name SaveManager

const SAVE_FILE_PATH = "user://save_data.json"

func save_progress(highest_level: int, level_stars: Dictionary) -> bool:
	var save_data = {
		"highest_level": highest_level,
		"level_stars": level_stars  # Add the stars for each level
	}
	
	var json_string = JSON.stringify(save_data)
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.close()
		return true
	else:
		push_error("Failed to open save file for writing")
		return false

func load_progress() -> Dictionary:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("Save file not found. Creating new save")
		save_progress(1, {})  # Initialize with empty level_stars dictionary
		return {"highest_level": 1, "level_stars": {}}
		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if not file:
		push_error("Failed to open save file for reading")
		return {"highest_level": 1, "level_stars": {}}
		
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		push_error("Failed to parse save file JSON")
		return {"highest_level": 1, "level_stars": {}}
		
	var save_data = json.get_data()
	if not save_data is Dictionary or not save_data.has("highest_level"):
		push_error("Save data is invalid")
		return {"highest_level": 1, "level_stars": {}}
	
	# Check if level_stars exists, and provide a default empty dictionary if not
	if not save_data.has("level_stars"):
		save_data["level_stars"] = {}
	
	return save_data

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var dir = DirAccess.open("user://")
		if dir:
			dir.remove(SAVE_FILE_PATH)
			save_progress(1, {})
		else:
			push_error("Failed to access user directory")

func initialize_save() -> void:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		save_progress(1, {})
