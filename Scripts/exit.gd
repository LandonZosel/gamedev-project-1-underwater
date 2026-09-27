extends Area2D

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var player : CharacterBody2D

@export var rotation_speed : float = 5
@export var trashCount : float = 3

var openingExit : bool = false
var exitOpen : bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group('Player')

func _process(_delta: float) -> void:
	_manage_animation()

func _manage_animation():
	if not openingExit:
		anim.play('spin')

func _on_drone_on_trash_deleted() -> void:
	trashCount -= 1
	if trashCount == 0:
		#trigger exit opening cutscene
		openingExit = true
		player.disable_movement()
		anim.play('open_portal')

func open_ext():
	openingExit = false
	exitOpen = true
	player.enable_movement()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group('Player'):
		return
	
	if exitOpen:
		#play player exit animation
		body.start_exit()
