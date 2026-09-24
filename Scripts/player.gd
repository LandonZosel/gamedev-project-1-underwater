extends CharacterBody2D

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var HeldItem: Marker2D = $HeldItem
@onready var cooldown_timer: Timer = $CooldownTimer

@export var move_speed : float = 100
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 120
@export var jump_force : float = 200
@export var rotation_speed : float = 5
@export var speed: float = 120.0
@export var cooldown_time: float = 0.2
var move_input_x : float
var move_input_y : float
var rotation_direction : float
var move_direction : float
var held_item : CharacterBody2D = null
var current_area : CharacterBody2D = null
var can_claw : bool = true

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	if _in_water():
		# new movement
		rotation_direction = Input.get_axis("move_left", "move_right")
		rotation += rotation_direction * rotation_speed * delta
		if rotation_direction != 0:
			velocity = Vector2.RIGHT.rotated(rotation) * (speed)

		move_direction = Input.is_action_pressed("move_up")
		
		if move_direction != 0:
			velocity = Vector2.RIGHT.rotated(rotation) * (move_direction * speed)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, speed * delta * 5)
	else:
		# not in water, apply gravity with smooth rotation
		velocity.y += gravity * delta
		if velocity.length() > 0:
			var target_angle : float = velocity.angle()
			rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	
	if Input.is_action_pressed("claw") && can_claw:
		print('claw!')
		if current_area != null:
			change_held_item(current_area)
		elif held_item != null:
			drop_held_item()
	
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
	
func change_area(area: CharacterBody2D):
	current_area = area

func change_held_item(item: CharacterBody2D):
	if not can_claw:
		return
	can_claw = false
	
	held_item = item
	held_item.stop_physics()
	held_item.reparent(HeldItem)
	held_item.position = Vector2.ZERO
	held_item.rotation = 0
	
	cooldown_timer.start(cooldown_time)
	await cooldown_timer.timeout
	can_claw = true

func drop_held_item():
	if not can_claw:
		return
	can_claw = false
	
	held_item.reparent(get_tree().current_scene)
	held_item.start_physics()
	held_item = null
	
	cooldown_timer.start(cooldown_time)
	await cooldown_timer.timeout
	can_claw = true
