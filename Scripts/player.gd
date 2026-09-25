extends CharacterBody2D

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var HeldBottle: Marker2D = $HeldBottle
@onready var HeldChipBag: Marker2D = $HeldChipBag
@onready var HeldCanRings: Marker2D = $HeldCanRings
@onready var cooldown_timer: Timer = $CooldownTimer

@export var move_speed : float = 100
@export var acceleration : float = 50
@export var braking : float = 20
@export var gravity : float = 120
@export var jump_force : float = 200
@export var rotation_rate : float = 5 #og 5
@export var speed: float = 120
@export var rotation_speed: float = 80
#@export var cooldown_time: float = 0.2
@export var nextLevelPath : String = 'res://Scenes/levels/level_1.tscn'

var move_input_x : float
var move_input_y : float
var rotation_direction : float
var move_direction : float
var held_item : CharacterBody2D = null
var current_area : CharacterBody2D = null
#var can_claw : bool = true
var entering_stage : bool = true

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	#playing enter animation
	anim.play("enter_stage")

func _physics_process(delta: float) -> void:
	if entering_stage:
		return
	
	if _in_water():
		# new movement
		rotation_direction = Input.get_axis("move_left", "move_right")
		rotation += rotation_direction * rotation_rate * delta
		if rotation_direction != 0:
			velocity = Vector2.RIGHT.rotated(rotation) * rotation_speed

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
	
	if Input.is_action_just_pressed("claw"): #&& can_claw:
		if current_area != null && current_area != held_item:
			change_held_item(current_area)
		elif held_item != null:
			drop_held_item()
	
	move_and_slide()
	
func _process(_delta):
	if entering_stage:
		return
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
	#if not can_claw:
		#return
	if held_item == item:
		return
	#can_claw = false
	
	if held_item:
		print('get rid of the current held item ' + held_item.name + ' for the new item ' + item.name)
		await get_rid_of_held_item()
	
	call_deferred('set_item', item)
	
	#cooldown_timer.start(cooldown_time)
	#await cooldown_timer.timeout
	#can_claw = true

func set_item(item: CharacterBody2D):
	held_item = item
	held_item.stop_physics()
	
	var item_name = held_item.name
	if item_name.begins_with('Bottle'):
		held_item.reparent(get('HeldBottle'))
	elif item_name.begins_with('CanRings'):
		held_item.reparent(get('HeldCanRings'))
	elif item_name.begins_with('ChipBag'):
		held_item.reparent(get('HeldChipBag'))
	else:
		held_item.reparent(get('HeldCanRings'))
	
	held_item.position = Vector2.ZERO
	held_item.rotation = 0

func drop_held_item():
	#if not can_claw:
		#return
	#can_claw = false
	
	await get_rid_of_held_item()
	
	#cooldown_timer.start(cooldown_time)
	#await cooldown_timer.timeout
	#can_claw = true

func get_rid_of_held_item():
	held_item.reparent(get_tree().current_scene)
	held_item.start_physics()
	held_item = null
	
func enter_stage():
	entering_stage = false

func exit_stage():
	get_tree().call_deferred("change_scene_to_file", nextLevelPath)

func start_exit():
	entering_stage = true
	anim.play('exit_stage')
