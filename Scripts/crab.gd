extends Sprite2D

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction

@export var move_direction : Vector2
@export var move_speed : float = 10
@export var trashHeld : bool = true

func _physics_process(delta: float) -> void:
	if not trashHeld:
		return
	
	global_position = global_position.move_toward(target_pos, move_speed * delta)
	if global_position == target_pos:
		if target_pos == start_pos:
			target_pos = start_pos + move_direction
		else:
			target_pos = start_pos

func _process(_delta: float) -> void:
	_manage_animation()

func _manage_animation():
	if not trashHeld:
		anim.play('dance')
	elif move_direction.x != 0:
		anim.play("walk")
	else:
		anim.play("idle")
