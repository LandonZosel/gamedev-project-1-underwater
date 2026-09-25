extends Button

@export var filePath : String = 'res://Scenes/levels/level_1.tscn'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressed() -> void:
	print('pressed! Go to level 1!')
	get_tree().change_scene_to_file(filePath)
	
