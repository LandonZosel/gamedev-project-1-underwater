extends Area2D

@onready var anim : AnimationPlayer = $AnimationPlayer

@export var rotation_speed : float = 5
@export var trashCount : float = 3

var openingExit : bool = false
var exitOpen : bool = false

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	_manage_animation()

func _manage_animation():
	if not openingExit:
		anim.play('spin')

func _on_drone_on_trash_deleted() -> void:
	trashCount -= 1
	if trashCount == 0:
		#trigger exit cutscene
		openingExit = true
		anim.play('open_portal')

func open_ext():
	openingExit = false
	exitOpen = true

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group('Player'):
		return
	
	if exitOpen:
		#play exit animation
		body.start_exit()
