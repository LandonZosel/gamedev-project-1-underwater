extends Area2D

@export var rotation_speed : float = 5
@export var trashCount : float = 3

var exitOpen : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_manage_animation(delta)

func _manage_animation(delta: float):
	rotation += rotation_speed * delta

func _on_drone_on_trash_deleted() -> void:
	trashCount -= 1
	print('trash collected! ' + str(trashCount) + ' left')
	if trashCount == 0:
		print('!!! its time to exit')
		
		#pan camera over to exit
		
		#trigger exit cutscene
		
		#activate exit mechanism
		exitOpen = true


func _on_body_entered(body: Node2D) -> void:
	print('something has entered the exit')
	if not body.is_in_group('Player'):
		return
	print('the player has entered the exit')
	
	if exitOpen:
		print('the exit is open !!! change scene!')
		#play exit animation
		body.start_exit()
		
		#transition to next scene
		#get_tree().call_deferred("change_scene_to_file", nextLevelPath)
