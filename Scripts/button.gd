extends Button

@export var filePath : String = 'res://Scenes/levels/level_1.tscn'

func _on_pressed() -> void:
	get_tree().change_scene_to_file(filePath)
