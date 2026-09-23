extends CharacterBody2D

@onready var anim : AnimationPlayer = $AnimationPlayer

@export var move_speed : float = 100
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 120
@export var jump_force : float = 200
@export var rotation_speed : float = 5
@export var speed: float = 120.0
var move_input_x : float
var move_input_y : float
var rotation_direction : float
var move_direction : float

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	#if position.y < 0:
		#velocity.y += gravity * delta
	
	# movement maybe ig
	#var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#velocity = direction * move_speed
	#
	#if velocity.length() > 0:
		#var target_angle : float = velocity.angle()
		#rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
		
	if _in_water():
		# new movement poss
		# 1. Handle Smooth Rotation (Left/Right)
		rotation_direction = Input.get_axis("move_left", "move_right")
		rotation += rotation_direction * rotation_speed * delta
		if rotation_direction != 0:
			velocity = Vector2.RIGHT.rotated(rotation) * (speed)

		# 2. Handle Forward Movement
		move_direction = Input.is_action_pressed("move_up")
		
		if move_direction != 0:
			# Vector2.RIGHT rotated by your current rotation points exactly where you are looking
			velocity = Vector2.RIGHT.rotated(rotation) * (move_direction * speed)
		else:
			# Smoothly slide to a halt when no movement keys are pressed
			velocity = velocity.move_toward(Vector2.ZERO, speed * delta * 5)
	else:
		velocity.y += gravity * delta
		if velocity.length() > 0:
			var target_angle : float = velocity.angle()
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

	move_and_slide()
	
func _process(_delta):
	_manage_animation()
	
func _manage_animation():
	if move_direction != 0 || rotation_direction != 0:
		anim.play("move")
	else:
		anim.play("idle")

func _in_water() -> bool:
	return position.y >= 0
