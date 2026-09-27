extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused

func _on_continue_button_pressed() -> void:
	toggle_pause()

func toggle_pause():
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = not get_tree().paused
	get_tree().change_scene_to_file('res://Scenes/menus/main_menu.tscn')
